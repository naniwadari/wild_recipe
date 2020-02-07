// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require turbolinks
//= require_tree ./main

//JS未起動対策 Turbolinksをページ移動した際にリロードする
//処理はこの間に書くこと
$(document).on('turbolinks:load', function(){
  
  //アコーディオン
  $(function(){
    $(".hiddenform dt").on("click", function(){
      $(this).next().slideToggle();
    });
  });
  
  $(function(){
    $(".profile-tab").click(function(){
      $(".is-active").removeClass("is-active");
      $(this).addClass("is-active");
      $(".is-show").removeClass("is-show");
      //クリックしたタブからインデックス番号を取得
      const index = $(this).index();
      //クリックしたタブと同じインデックス番号をもつコンテンツを表示
      $(".panel").eq(index).addClass("is-show");
    });
  });
});