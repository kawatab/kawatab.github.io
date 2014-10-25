`((tag "Debian" "Mozc")
  (lang "ja")
  (title "Mozcの書き換え")
  (modify-date 2014 2 1)
  (contents 
   (h4 "ソースの取得")
   (pre ((class "command"))
	(code "$ apt-get source mozc"))

   (h4 "依存ファイルの取得")
   (pre ((class "command"))
	(code "$ apt-get build-dep mozc"))

   (h4 "deb作成")
   (pre ((class "command"))
	(code "$ dpkg-buildpackage -r -uc -b"))

   (h4 "mozcかな入力設定関連ファイル")
   (table
    (tr (td (code "data/preedit/kana.tsv"))
	(td "濁音・半濁音テーブル"))

    (tr (td (code "composer/table.cc"))
	(td "濁点・半濁点テーブルの位置を示す。"))

    (tr (td (code "composer/internal/char-chunk.cc"))
	(td "未入力文字の処理"))

    (tr (td (code "unix/ibus/key-translator.cc"))
	(td "iBus用のレイアウト"))

    (tr (td (code "data/preedit/normalize_voiced_sound.tsv"))
	(td "「ゔ」の定義。ひらがなで打っても自動的にカタカナに変換される。")))

   (h4 "書き換え手順とインストール")
   (ol
    (li (code "unix/ibus/key_translator.cc") "の" (code "kana_map_US[]") "の初期設定を変更する。")
    (li (code "data/preedit/kana.tsv") "を書き換える。")
    (li "ビルドして、debを作る。")
    (li "インストールする。")
    (li (code "/usr/share/ibux/component/mozc/xml") "の" (code "layout") "を" (code "us") "に書き換える。")
    (li (code "mozc_engine.cc") (code "のis_layout_jp関連")))))
