require "rails_helper"

RSpec.describe "Home Pages", type: :system do
  example "検索範囲セレクターに設定されている項目が正しいこと"

  context "ページ遷移直後に[検索]ボタンを押下したとき" do
    example "初期値がparamsで送信できていること"
  end

  context "プルダウンで条件選択後に[検索]ボタンを押下したとき" do
    example "プルダウンで選択した項目が、paramsで送信できていること"
  end
end
