module StaticPagesHelper
  def range_option
    [
      ["検索範囲：300m", "1"], ["検索範囲：500m", "2"], ["検索範囲：1000m", "3"], ["検索範囲：2000m", "4"], ["検索範囲：3000m", "5"]
    ]
  end

  def genre_option
    [
      ["お店のジャンル：すべて", ""], ["居酒屋", "G001"], ["ダイニングバー・バル", "G002"], ["創作料理", "G003"], ["和食", "G004"], ["洋食", "G005"], ["イタリアン・フレンチ", "G006"], ["中華", "G007"], ["焼肉・ホルモン", "G008"], ["韓国料理", "G017"], ["アジア・エスニック料理", "G009"], ["各国料理", "G010"], ["カラオケ・パーティ", "G011"], ["バー・カクテル", "G012"], ["ラーメン", "G013"], ["お好み焼き・もんじゃ", "G016"], ["カフェ・スイーツ", "G014"], ["その他グルメ", "G015"]
    ]
  end

  def budget_option
    [
      ["料金：こだわらない", ""], ["～500円", "B009"], ["501～1000円", "B010"], ["1001～1500円", "B011"], ["1501～2000円", "B001"], ["2001～3000円", "B002"], ["3001～4000円", "B003"], ["4001～5000円", "B008"], ["5001～7000円", "B004"], ["7001～10000円", "B005"], ["10001～15000円", "B006"], ["15001～20000円", "B012"], ["20001～30000円", "B013"], ["30001円～", "B014"]
    ]
  end
end
