require "rails_helper"

RSpec.describe "User Info Edit", type: :system, js: true do
  describe "バリデーション確認" do
    let(:user) { create(:user) }

    before do
      ActionMailer::Base.deliveries.clear
      log_in_as(user)

      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path
      click_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_selector "h2", text: "ユーザー情報編集"
    end

    example "メールアドレス未入力の場合エラーになること" do
      fill_in "メールアドレス", with: ""

      click_button "変更する"
      expect(page).to have_current_path settings_path
      expect(page).to have_content "メールアドレスを入力してください"
    end

    example "既に存在するメールアドレスの場合エラーになること" do
      user_second = create(:user)
      fill_in "メールアドレス", with: user_second.email

      click_button "変更する"
      expect(page).to have_current_path settings_path
      expect(page).to have_content "メールアドレスはすでに存在します"
    end

    example "「新しいパスワード」と「新しいパスワード（確認用）」が不一致の場合エラーになること" do
      fill_in "新しいパスワード", with: "123456"
      fill_in "新しいパスワード（確認用）", with: "654321"

      click_button "変更する"
      expect(page).to have_current_path settings_path
      expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
    end

    example "パスワードが6文字より短い場合エラーになること" do
      fill_in "新しいパスワード", with: "12345"
      fill_in "新しいパスワード（確認用）", with: "12345"

      click_button "変更する"
      expect(page).to have_current_path settings_path
      expect(page).to have_content "パスワードは6文字以上で入力してください"
    end

    example "現在のパスワードが未入力の場合エラーになること" do
      fill_in "新しいパスワード", with: "123456"
      fill_in "新しいパスワード（確認用）", with: "123456"

      click_button "変更する"
      expect(page).to have_current_path settings_path
      expect(page).to have_content "現在のパスワードを入力してください"
    end

    example "現在のパスワードが間違っている場合エラーになること" do
      fill_in "新しいパスワード", with: "123456"
      fill_in "新しいパスワード（確認用）", with: "123456"
      fill_in "現在のパスワード ※必須", with: "invalid_password"

      click_button "変更する"
      expect(page).to have_current_path settings_path
      expect(page).to have_content "現在のパスワードは不正な値です"
    end
  end

  describe "ユーザー情報変更確認" do
    before { ActionMailer::Base.deliveries.clear }

    example "メールアドレスの変更ができること" do
      user = create(:user)
      log_in_as(user)

      # ユーザー情報編集画面に移動する
      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path
      click_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_selector "h2", text: "ユーザー情報編集"

      # メールアドレスを変更する
      old_info = user
      new_info = build(:user)

      fill_in "メールアドレス", with: new_info.email
      fill_in "現在のパスワード ※必須", with: user.password

      expect { click_button "変更する" }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_current_path root_path
      expect(page).to have_content "アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。"

      # 本人確認前のため、ユーザーのメールアドレスが変更されてないことを確認する
      user = User.find(user.id)
      expect(user.email).to eq old_info.email
      expect(user.unconfirmed_email).to eq new_info.email

      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path
      click_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_selector "h2", text: "ユーザー情報編集"
      expect(page).to have_content "変更確認待ち：#{user.unconfirmed_email}"

      # 本人確認する
      mail = ActionMailer::Base.deliveries.last
      url = extract_url(mail)
      path = url[/\/users.*/] # 相対パスに変換（絶対パスだとvisitに失敗する）
      visit path
      expect(page).to have_current_path root_path
      expect(page).to have_content "メールアドレスが確認できました。"

      # ユーザーのメールアドレスが変更されたことを確認する
      user = User.find(user.id)
      expect(user.email).to eq new_info.email
      expect(user.unconfirmed_email).to eq nil
    end

    example "パスワードの変更ができること" do
      user = create(:user)
      log_in_as(user)

      # ユーザー情報編集画面に移動する
      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path
      click_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_selector "h2", text: "ユーザー情報編集"

      # パスワードを変更する
      fill_in "新しいパスワード", with: "new_password"
      fill_in "新しいパスワード（確認用）", with: "new_password"
      fill_in "現在のパスワード ※必須", with: user.password

      click_button "変更する"
      expect(page).to have_current_path root_path
      expect(page).to have_content "アカウント情報を変更しました。"

      # ユーザーのパスワードが変更されたことを確認する
      click_link "アカウント"
      click_link "ログアウト"

      click_link "ログイン"
      expect(page).to have_current_path new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "new_password"
      click_button "ログイン"

      expect(page).to have_current_path root_path
      expect(page).to have_content "ログインしました。"
    end

    example "ゲストユーザーは編集できないこと" do
      # ゲストユーザーでログインする。
      log_in_as_guest

      click_link "アカウント"
      click_link "設定"
      expect(page).to have_current_path settings_path

      # [ユーザー情報編集]リストを選択する
      click_link "ユーザー情報編集", href: user_info_edit_path
      expect(page).to have_selector "h2", text: "ユーザー情報編集"

      # [変更する]ボタンを選択する。
      click_button "変更する"
      expect(page).to have_current_path root_path
      expect(page).to have_content "ゲストユーザーの更新・削除はできません。"
    end
  end
end
