'use strict';

// ユーザー情報編集へのリンクがクリックされた場合
$("#edit").on("click", function() {
  // activeクラスの設定箇所を変更する。
  $("#edit").addClass("active");
  $("#unsubscribe").removeClass("active");
});

// 退会画面へのリンクがクリックされた場合
$("#unsubscribe").on("click", function() {
  // activeクラスの設定箇所を変更する。
  $("#unsubscribe").addClass("active");
  $("#edit").removeClass("active");
});
