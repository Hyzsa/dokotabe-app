function setHeight() {
  let vh = window.innerHeight * 0.01;
  document.documentElement.style.setProperty("--vh", `${vh}px`);
};

setHeight();
// ブラウザのウィンドウサイズが変更されたときに再計算する。
window.addEventListener("resize", setHeight);
