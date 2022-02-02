require "rails_helper"

RSpec.describe "Registrations", type: :system do
  before do
    visit new_user_registration_path
  end

  context "入力値が有効な場合" do
    example "レコードが1つ増えること" do
      user_count = User.all.size
      expect do
        fill_in "メールアドレス", with: "tester@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        click_button "アカウントを作成"
        user_count = User.all.size
      end.to change { user_count }.by(1)
    end

    describe "UI" do
      before do
        fill_in "メールアドレス", with: "tester@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        click_button "アカウントを作成"
      end

      example "ホーム画面に遷移すること" do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      example "本人確認を促すflashメッセージが表示されること" do
        expect(page).to have_selector(".alert-success", text: "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。")
      end

      example "リロードでflashメッセージが消えること" do
        visit root_path
        expect(page).to_not have_selector(".alert-success", text: "本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。")
      end
    end
  end

  describe "入力値が無効" do
    context "メールアドレスが未入力の場合" do
      example "レコードが増えないこと" do
        user_count = User.all.size
        expect do
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "アカウントを作成"
          user_count = User.all.size
        end.to change { user_count }.by(0)
      end

      describe "UI" do
        before do
          fill_in "メールアドレス", with: ""
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "password"
          click_button "アカウントを作成"
        end

        example "新規登録画面から遷移しないこと" do
          expect(page).to have_current_path users_path, ignore_query: true
        end

        example "バリデーションエラーのメッセージが表示されること" do
          expect(page).to have_selector(".text-danger", text: "メールアドレスを入力してください")
        end

        example "リロードでバリデーションエラーのメッセージが消えること" do
          visit users_path
          expect(page).to_not have_selector(".text-danger", text: "メールアドレスを入力してください")
        end
      end
    end

    context "パスワードが未入力の場合" do
      example "レコードが増えないこと" do
        user_count = User.all.size
        expect do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: ""
          fill_in "パスワード（確認用）", with: "password"
          click_button "アカウントを作成"
          user_count = User.all.size
        end.to change { user_count }.by(0)
      end

      describe "UI" do
        before do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: ""
          fill_in "パスワード（確認用）", with: "password"
          click_button "アカウントを作成"
        end

        example "新規登録画面から遷移しないこと" do
          expect(page).to have_current_path users_path, ignore_query: true
        end

        example "バリデーションエラーのメッセージが表示されること" do
          expect(page).to have_selector(".text-danger", text: "パスワードを入力してください")
        end

        example "リロードでバリデーションエラーのメッセージが消えること" do
          visit users_path
          expect(page).to_not have_selector(".text-danger", text: "パスワードを入力してください")
        end
      end
    end

    context "パスワード確認が未入力の場合" do
      example "レコードが増えないこと" do
        user_count = User.all.size
        expect do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: ""
          click_button "アカウントを作成"
          user_count = User.all.size
        end.to change { user_count }.by(0)
      end

      describe "UI" do
        before do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: ""
          click_button "アカウントを作成"
        end

        example "新規登録画面から遷移しないこと" do
          expect(page).to have_current_path users_path, ignore_query: true
        end

        example "バリデーションエラーのメッセージが表示されること" do
          expect(page).to have_selector(".text-danger", text: "パスワード（確認用）とパスワードの入力が一致しません")
        end

        example "リロードでバリデーションエラーのメッセージが消えること" do
          visit users_path
          expect(page).to_not have_selector(".text-danger", text: "パスワード（確認用）とパスワードの入力が一致しません")
        end
      end
    end

    context "パスワードが不一致の場合" do
      example "レコードが増えないこと" do
        user_count = User.all.size
        expect do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "pass"
          click_button "アカウントを作成"
          user_count = User.all.size
        end.to change { user_count }.by(0)
      end

      describe "UI" do
        before do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: "password"
          fill_in "パスワード（確認用）", with: "pass"
          click_button "アカウントを作成"
        end

        example "新規登録画面から遷移しないこと" do
          expect(page).to have_current_path users_path, ignore_query: true
        end

        example "バリデーションエラーのメッセージが表示されること" do
          expect(page).to have_selector(".text-danger", text: "パスワード（確認用）とパスワードの入力が一致しません")
        end

        example "リロードでバリデーションエラーのメッセージが消えること" do
          visit users_path
          expect(page).to_not have_selector(".text-danger", text: "パスワード（確認用）とパスワードの入力が一致しません")
        end
      end
    end

    context "パスワードが6文字より短い場合" do
      example "レコードが増えないこと" do
        user_count = User.all.size
        expect do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: "pass"
          fill_in "パスワード（確認用）", with: "pass"
          click_button "アカウントを作成"
          user_count = User.all.size
        end.to change { user_count }.by(0)
      end

      describe "UI" do
        before do
          fill_in "メールアドレス", with: "tester@example.com"
          fill_in "パスワード", with: "pass"
          fill_in "パスワード（確認用）", with: "pass"
          click_button "アカウントを作成"
        end

        example "新規登録画面から遷移しないこと" do
          expect(page).to have_current_path users_path, ignore_query: true
        end

        example "バリデーションエラーのメッセージが表示されること" do
          expect(page).to have_selector(".text-danger", text: "パスワードは6文字以上で入力してください")
        end

        example "リロードでバリデーションエラーのメッセージが消えること" do
          visit users_path
          expect(page).to_not have_selector(".text-danger", text: "パスワードは6文字以上で入力してください")
        end
      end
    end
  end
end
