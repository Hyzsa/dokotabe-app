'use strict';

// 表示しているページに一致するリンクを有効化する。
$(window).on('turbolinks:load', function() {
  var path = location.pathname

  if (path == "/") {
    $("#home").addClass("active")
  }
  else if (path == "/contact") {
    $("#contact").addClass("active")
  }
  else if (path == "/users/sign_in") {
    $("#login").addClass("active")
  }
  else if ( path.match(/\/favorites\/[\d]*/) ) {
    $("#favorite").addClass("active")
  }
  else if ( path == "/search_history" ||
            path.match(/\/settings/) != null) {
    $("#navbarDropdownMenuLink").addClass("active")
  }
});
