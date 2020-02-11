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
  
  //クリックしたら選択したタブの項目が表示
  $(function(){
    $(".tab").click(function(){
      $(".is-active").removeClass("is-active");
      $(this).addClass("is-active");
      $(".is-show").removeClass("is-show");
      //クリックしたタブからインデックス番号を取得
      const index = $(this).index();
      //クリックしたタブと同じインデックス番号をもつコンテンツを表示
      $(".panel").eq(index).addClass("is-show");
    });
  });

  //フォームの追加
  $(function(){
    $(".add-form").click(function(){
      //対象のクラス内にあるコードを全部コピーして変数内に代入
      var clonecode = $(".formbox:last").clone(true);
      
      //clonecode内にあるdata-formnoの数字をコピー
      var cloneno = clonecode.attr("data-formno");

      //parseIntは数字をstringからintegerに変換してくれる
      var cloneno2 = parseInt(cloneno) + 1;
      
      //attrはelementのみの指定であれば値を取得するが
      //valueを取得すると該当するelementの中身をvalueに書き換える
      clonecode.attr("data-formno",cloneno2);
      
      //formbox-noをcloneno2に書換え
      clonecode.find(".formbox-no").html(cloneno2);
      
      //inputフォームのナンバーを＋１する
      clonecode.find("input.hidden-number").attr("value", cloneno2);
      
      //テキストエリアのidを変更
      clonecode.find("textarea").attr('id', 'textarea' + cloneno2);
      //テキストエリアを空にする
      clonecode.find("textarea").html("")
      
      //procedure-showの内容を空にする
      clonecode.find(".procedure-show").html("")
      //porocedure-showのname="number[?]"を書き換える
      var procedure_number = clonecode.find("div.procedure-show").attr("name");
      procedure_number = procedure_number.replace(/number\[[0-9]{1,2}/g,"number[" + cloneno2);
      clonecode.find("div.procedure-show").attr("name", procedure_number);
      
      //formbox:lastに書き換えたコードを挿入
      clonecode.insertAfter($(".formbox:last"));
    });
  });

  //フォームの削除
  $(function(){
    $('.delete-formbox').click(function(){
      var count = $(".formbox").length;
      if (count > 1){
        $(this).parents(".formbox").remove();

        //番号振り直し
        $('.formbox').each(function(index){
          var number = index + 1;
          //data属性の数字
          $(this).attr('data-formno', number);

          $(".formbox-no",this).html(number);
          $("input.hidden-number",this).attr("value", number);
          $("textarea",this).attr('id', 'textarea' + number);
          var procedure_number = $("div.procedure-show",this).attr("name");
          procedure_number = procedure_number.replace(/number\[[0-9]{1,2}/g,"number[" + number);
          $("div.procedure-show",this).attr("name", procedure_number);
        });
      } else {
        $('.formbox').find("textarea").html("")
      }
    });
  });
});