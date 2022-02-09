'use strict';

document.getElementById('search').onclick = function() {
  // 位置情報を取得する。
  navigator.geolocation.getCurrentPosition(successCallback, errorCallback);
};

// 取得に成功したときの処理
function successCallback(position) {
  // 緯度を取得して隠しフィールドに設定する。
  document.getElementById('selected_latitude').setAttribute('value', position.coords.latitude);
  // 経度を取得して隠しフィールドに設定する。
  document.getElementById('selected_longitude').setAttribute('value', position.coords.longitude);
  document.shop_search_form.submit();
};

// 取得に失敗したときの処理
function errorCallback(error) {
  alert("位置情報が取得できませんでした。\nお手持ちの端末にて、位置情報の利用を許可してください。");
};
