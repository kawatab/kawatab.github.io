`(((tag "Racket" "Debian")
   (lang "ja")
   (title "Debianのテスト版のRacketのバージョンが6.1になった")
   (modify-date 2014 11 20)
   (id "2014112002")
   (contents
    (p "typed-racketがまともに使えるようになったのかな？今は、マイSchemeの開発に集中しているので、あまり手を出せない。")))


  ((tag "Emacs" "Debian")
   (lang "ja")
   (title "M-x is undefined")
   (modify-date 2014 11 20)
   (id "2014112001")
   (contents
    (p "GUIでEmacsを動かした時にM-xが使えなくなっている。テスト版のDebianを使っていて、Emacsのバージョンが比較的最新なのが問題らしい。とりあえず、ターミナルの方では使えるのでそれほど問題ではない。")))


  ((tag "CL" "SBCL" "Debian")
   (lang "en")
   (title "Install Quicklisp")
   (modify-date 2014 10 29)
   (id "2014102902")
   (contents
    (p (a ((href "http://golems.github.io/motion-grammar-kit/install.html"))
	  "http://golems.github.io/motion-grammar-kit/install.html"))
    (blockquote ((cite "http://golems.github.io/motion-grammar-kit/install.html"))
		(p "Quicklisp is a package manager for lisp, similar to CPAN, RubyGems, Python's easy_install, and ELPA. At the time of writing, it is the easiest way to install Lisp packages. You can install Quicklisp from "
		   (a ((href "http://www.quicklisp.org/."))
		      "http://www.quicklisp.org/")
		   ".")

		(p "Alternatively, Debian Wheezy and Ubuntu Precise (or later) contain a package for quicklisp:")

		(pre ((class "command"))
		     (code "$ sudo apt-get install cl-quicklisp"))

		(p "Then, the following command will setup quicklisp for your user account:")

		(pre ((class "command"))
		     (code "$ sbcl --load /usr/share/cl-quicklisp/quicklisp.lisp \\\n"
			   "       --eval '(quicklisp-quickstart:install)'       \\\n"
			   "       --eval '(ql:add-to-init-file)'                \\\n"
			   "       --eval '(quit)'")))))


  ((tag "Emacs" "CL" "SBCL" "Debian")
   (lang "en")
   (title "Installing SBCL")
   (modify-date 2014 10 29)
   (id "2014102901")
   (contents
    (h4 "Installing")
    (pre ((class "command"))
	 (code "# aptitude install sbcl"))

    (h4 "emacs settings")
    (p "Write the following code into " (code "~/.emacs") " or " (code "~/.emacs.d/init.el"))
    (pre ((class "config"))
	 (code "(add-to-list 'load-path \"/usr/share/common-lisp/source/slime\")\n"
	       "(setq inferior-lisp-program \"/usr/bin/sbcl\")\n"
	       "(slime-setup)"))

    (h4 "Start REPL")
    (pre ((class "command"))
	 (code "M-x slime"))

    (h4 "Exit REPL")
    (pre ((class "command"))
	 (code "(sb-ext::quit)"))))


  ((tag "Emacs" "CL" "SBCL" "Debian")
   (lang "ja")
   (title "SBCLのインストール")
   (modify-date 2014 10 29)
   (id "2014102901ja")
   (contents
    (h4 "インストール")
    (pre ((class "command"))
	 (code "# aptitude install sbcl"))

    (h4 "emacsの設定")
    (p (code "~/.emacs") "もしくは~" (code "/.emacs.d/init.el") "に次の内容を書き入れる。")
    (pre ((class "config"))
	 (code "(add-to-list 'load-path \"/usr/share/common-lisp/source/slime\")\n"
	       "(setq inferior-lisp-program \"/usr/bin/sbcl\")\n"
	       "(slime-setup)"))

    (h4 "REPLの開始")
    (pre ((class "command"))
	 (code "M-x slime"))

    (h4 "REPLの終了")
    (pre ((class "command"))
	 (code "(sb-ext::quit)"))))



  ((tag "X11" "Debian")
   (lang "en")
   (title "xkb-data")
   (modify-date 2014 10 28)
   (id "2014102801")
   (contents
   (p "Using arrow keys, Home, End, PgUp, PgDn and Japanese keys with combination of AltGr and alphabets")
    (p (a ((href "https://github.com/kawatab/xkb-data"))
	  "https://github.com/kawatab/xkb-data"))))

  
  ((tag "X11" "Debian")
   (lang "ja")
   (title "xkb-data")
   (modify-date 2014 10 28)
   (id "2014102801ja")
   (contents
    (p "カーソルキーやHome、End、PgUpPgDn日本語キーを右Altキーとアルファベットの組み合わせで打つことができます。")
    (p (a ((href "https://github.com/kawatab/xkb-data"))
	  "https://github.com/kawatab/xkb-data"))))

  
  ((tag "Racket")
   (lang "ja")
   (title "webpage-generator.rktを開発中")
   (modify-date 2014 10 26)
   (id "2014102602")
   (contents
    (p "タグ付けされた記事からタグごとにHTMLファイルを生成するスクリプトを開発中です。日本語、英語、ハンガリー語の3ヶ国語に対応しています。")
    (p "Racketで書かれています。Racketの独自仕様を利用しているため、R5RSやR6RSのSchemeでは動きません。")
    (p (a ((href "https://github.com/kawatab/kawatab.github.io"))
	  "https://github.com/kawatab/kawatab.github.io"))))


  ((tag "Racket" "Emacs")
   (lang "en" "hu" "ja")
   (title "Geiser")
   (modify-date 2014 10 26)
   (id "2014102602")
   (contents
    (p (a ((href "http://docs.racket-lang.org/guide/Emacs.html"))
	  "http://docs.racket-lang.org/guide/Emacs.html"))
    (blockquote ((cite "http://docs.racket-lang.org/guide/Emacs.html"))
		(a ((href "http://www.nongnu.org/geiser/"))
		   "Geiser")
		" provides a programming environment where the editor is tightly integrated with the Racket REPL. Programmers accustomed to environments such as Slime or Squeak should feel at home using Geiser. Geiser requires GNU Emacs 23.2 or better.")))

  ((tag "Racket")
   (lang "ja")
   (title "Typed Racket")
   (modify-date 2014 10 26)
   (id "2014102601")
   (contents
    (p "Racketでは型チェックをするように書くことも可能なようだが、Debianではバージョン5.3.6では仕様が古いため、リファレンスにあるようにしても使えない。以下のようにすると使える。")
    (pre ((class "code"))
	 (code "(: str-list : (Listof String))\n"
	       "(define str-list '(\"abc\" \"def\" \"ghi\"))"))
    (pre ((class "code"))
	 (code "(: func : String -> Number)\n"
	       "(define (func x) (string-length x))"))
    (p "新しいバージョンでは以下のページを参照すること。")
    (p (a ((href "http://docs.racket-lang.org/ts-guide/index.html"))
	  "The Typed Racket Guide"))
    (p (a ((href "http://docs.racket-lang.org/ts-reference/index.html"))
	  "The Typed Racket Reference"))))
  


  ((tag "KDE" "Fcitx")
   (lang "ja")
   (title "fcitxのアイコンをパネルに表示させる")
   (modify-date 2014 10 21)
   (id "2014102101")
   (contents (p "入力方法パネルのウィジェットをパネルに追加する。")))


  ((tag "X11" "C++")
   (lang "en")
   (modify-date 2014 9 28)
   (id "2014092802")
   (title "KeyboardQuery")
   (contents
    (p "This program gets keyboard configuration as "
       (code "setxkb -query")
       ". If you want to know how to get keyboard model or layout by C++ program, this program is helpful for you.")
    (p " If you want to know the further details, you should get the source of "
       (code "setxkbmap.c")
       ".")

    (p (a ((href "https://github.com/kawatab/KeyboardQuery"))
	  "https://github.com/kawatab/KeyboardQuery"))))

  ((tag "X11" "C++")
   (lang "ja")
   (modify-date 2014 9 28)
   (id "2014092802ja")
   (title "KeyboardQuery")
   (contents
    (p "このプログラムはC++のプログラムからキーボードモデルやLayoutを取得するようなプログラムを書くときに参考になるものです。より詳しい情報が必要な場合は、"
       (code "setxkbmap.c")
       "のソースを探してみてください。") 
    (p (a ((href "https://github.com/kawatab/KeyboardQuery"))
	  "https://github.com/kawatab/KeyboardQuery"))))


  ((tag "Mozc" "Fcitx" "Emacs" "Debian" "iBus")
   (lang "ja")
   (modify-date 2014 9 28)
   (id "2014092801")
   (title "月配列2-263式を使えるようにする")
   (contents
    (p "月配列2-263式を使えるようにしたmozcを公開しています。FcitxやiBus、mozc.elを介して使うことができます。"
       (code "ibus-mozc_1.15.1857.102-1_i368.deb")
       "や"
       (code "mozc-data_1.15.1857.102-1_all.deb")
       "、"
       (code "mozc-server_1.15.1857.102-1_i386.deb")
       "の他に、"
       (code "fcitx-mozc_1.15.1857.102-1_i386.deb")
       "や"
       (code "ibus-mozc_1.15.1857.102-1_i386.deb")
       "、"
       (code "emacs-mozc-bin_1.15.1857.102-1_i386.deb")
       "、"
       (code "emacs-mozc_1.15.1857.102-1_i386.deb")
       "をインストールする必要があります。")
    (p "uim-mozcはテストしていませんが、変更はしてあるので、使えるかもしれません")
    (p (a ((href "https://github.com/kawatab/mozc-tsuki"))
	  "https://github.com/kawatab/mozc-tsuki"))))


  ((tag "VLC")
   (lang "en")
   (title "Convert Canon avi file to mp4")
   (modify-date 2014 6 14)
   (id "2014061401")
   (contents 
    (pre ((class "command"))
	 (code "$ a=\"MVI_0995\"; vlc -I dummy -vvv \"$a.AVI\" --sout \"#transcode{vcodec=h264,vb=1200,acodec=mp3,ab=128,channels=1,samplerate=11025}:standard{mux=mp4,dst=\"$a.mp4\",access=file}\" vlc://quit"))))


  ((tag "VLC")
   (lang "hu")
   (title "Konvertálás Canon avi fájlt mp4 fájlba")
   (modify-date 2014 6 14)
   (id "2014061401hu")
   (contents 
    (pre ((class "command"))
	 (code "$ a=\"MVI_0995\"; vlc -I dummy -vvv \"$a.AVI\" --sout \"#transcode{vcodec=h264,vb=1200,acodec=mp3,ab=128,channels=1,samplerate=11025}:standard{mux=mp4,dst=\"$a.mp4\",access=file}\" vlc://quit"))))


  ((tag "VLC")
   (lang "ja")
   (title "Canonのaviからmp4に変換")
   (modify-date 2014 6 14)
   (id "2014061401ja")
   (contents 
    (pre ((class "command"))
	 (code "$ a=\"MVI_0995\"; vlc -I dummy -vvv \"$a.AVI\" --sout \"#transcode{vcodec=h264,vb=1200,acodec=mp3,ab=128,channels=1,samplerate=11025}:standard{mux=mp4,dst=\"$a.mp4\",access=file}\" vlc://quit"))))


  ((tag "SQL")
   (lang "ja")
   (title "Postgresのメモ")
   (modify-date 2014 6 3)
   (id "2014060301")
   (contents 
    (pre ((class "command"))
	 (code "su - postgres\n"
	       "\n"
	       "psql -l\n"
	       "\n"
	       "psql [username]"))
    (section
     (h4 "help")
     (table (tr (td "\\d"))
	    (tr (td "\\q"))
	    (tr (td "\\dt") (td "リレーションの表示"))
	    (tr (td "\\z") (td "アクセス権の表示")))

     (pre ((class "command"))
	  (code "GRANT ALL PRIVILEGES ON sogo_users TO sogo;"))

     (pre ((class "command"))
	  (code "SELECT *FROM sogo_users;")))))


  ((tag "Debian" "Sogo")
   (lang "ja")
   (title "Sogo")
   (modify-date 2014 5 31)
   (id "2014053101")
   (contents
    (section
     (h4 "データベースの準備")
     (p "公式ガイドのp.28に従う。")
     
     (pre ((class "command"))
	  (code "su - postgres\n"
		"createuser --no-superuser --no-createdb --no-createrole "
		"--encrypted --pwprompt sogo"))
     (p "(specify “sogo” as password)")
     (pre ((class "command"))
	  (code "createdb -O sogo sogo")))

    (section
     (h4 "postgreSQLに接続する。")
     (pre ((class "command"))
	  (code "psql sogo"))

     (p "DebianWikiの方法に従う。ただし、" (code "sogo_users") "ではなく" (code "sogo_view") "にする。")

     (pre ((class "config"))
	  (code "CREATE TABLE sogo_view (c_uid VARCHAR(10) PRIMARY KEY, c_name VARCHAR(10), c_password VARCHAR(32), c_cn VARCHAR(128), mail VARCHAR(128));
INSERT INTO sogo_users VALUES ('paul', 'paul', MD5('zxc'), 'Paul Example', 'paul@example.com');")))

    (section
     (h4 "PostgreSQLでの権限追加")
     (pre ((class "command"))
	  (code "GRANT ALL PRIVILEGES ON sogo_users TO sogo"))

     (P "公式ガイドのp.28に従う。")

     (p (code "/var/lib/pgsql/data/pg_hba.conf"))
     (p "Debianの場合は" (code "/etc/postgresql/9.1/main/pg_hba.conf")))

    (setcion
     (h4 "SOGoの設定")

     (p "公式ガイドのp.31の設定。以下の設定を追加し、タイムゾーンなどをいじる。")

     (pre ((class "config"))
	  (code "SOGoUserSources =\n"
		"(\n"
		" {\n"
		"  type = sql;\n"
		"       id = directory;\n"
		"       viewURL = \"postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view\";\n"
		"       canAuthenticate = YES;\n"
		"       isAddressBook = YES;\n"
		"       userPasswordAlgorithm = md5;\n"
		"       }\n"
		" );\"))"))

     (pre ((class "command"))
	  (code "$ cp /usr/share/doc/sogo/apache.conf /etc/apache2/conf.d/SOGo.conf\n"
		"$ sudo vi /etc/apache2/conf.d/SOGo.conf"))
     (p "ipアドレスを書き換え")
     (pre ((class "config"))
	  (code "## adjust the following to your configuration\n"
		"  RequestHeader set \"x-webobjects-server-port\" \"443\"\n"
		"  RequestHeader set \"x-webobjects-server-name\" \"192.168.0.119\"\n"
		"  RequestHeader set \"x-webobjects-server-url\" \"https://192.168.0.119\""))

     (pre ((class "command"))
	  (code "$ sudo service apache2 restart")))

    (section
     (h4 "SSLの設定")
     (p "標準的な方法")

     (pre ((class "config"))
	  (code "<Directory /usr/lib/GNUstep/SOGo>\n"
		"    Require all granted\n"
		"    # Explicitly allow caching of static content to avoid browser specific behavior.\n"
		"    # A resource's URL MUST change in order to have the client load the new version.\n"
		"    <IfModule expires_module>\n"
		"      ExpiresActive On\n"
		"      ExpiresDefault \"access plus 1 year\"\n"
		"    </IfModule>\n"
		"</Directory>")))))


  ((tag "Debian" "KDE")
   (lang "ja")
   (title "Kbackup")
   (modify-date 2014 5 25)
   (id "2014052502")
   (contents (p "シンプルなバックアップソフト")))


  ((tag "Debian" "Network")
   (lang "ja")
   (title "ssh")
   (modify-date 2014 5 25)
   (id "2014052501")
   (contents 
    (section
     (h4 "必要なパッケージ")
     (section
      (h5 "サーバ")
      (p "openssh-server"))

     (section
      (h5 "クライアント")
      (p "openssh-client")))

    (section
     (h4 "サーバの設定")
     (section
      (h5 "/etc/ssh/sshd_config")
      (p (code "/etc/ssh/sshd_config")
	 "に以下の変更を加える。")

      (pre ((class "config"))
	   (code "Port 22                                     # ポート番号は適当に物に書き換える。\n"
		 "PermitRootLogin no                          #rootユーザはログインできないようにする。\n"
		 "AuthorizedKeyFile %h/.ssh/authorized_keys   #コメントを外す。\n"
		 "DenyUsers ALL                               #追加\n"
		 "Allowusers your_name                        #追加"))

      (p "変更したら")
      (pre ((class "command"))
	   (code "# invoke-rc.d ssh restart"))
      (p "を実行する。")))

    (section
     (h4 "キーの作成")
     (pre ((class "command"))
	  "$ ssh-keygen")
     (p "manには次のように書かれているので、オプションは要らない。")
     (blockquote "ssh-keygen generates, manages and converts authentication keys for ssh(1).  ssh-keygen can create RSA keys for use by SSH protocol version 1 and DSA, ECDSA or RSA keys for use by SSH protocol version 2.  The type of key to be generated is specified with the -t option.  If invoked without any arguments, ssh-keygen will generate an RSA key for use in SSH protocol 2 connections.")
     (p "具体的には")

     (pre ((class "command"))
	  (code "$ ssh-keygen"
		"$ cat .ssh/id_rsa.pub > .ssh/authorized_keys"))

     (p "でOK。" (code "ssh-keygen") "の実行時には保存場所の確認とパスワードの入力が必要。公開鍵（id_rsa.pub）は" (code "~/.ssh/authorized_keys") "に書き込む。パーミッションは600。"))

    (section
     (h4 "クライアントの設定")
     (p "秘密鍵（id_rsa）をネットワークを介さない方法でコピーする。")

     (section
      (h5 "Linuxからアクセスする場合")
      (pre ((class "command"))
	   (code "$ ssh -p [ポート番号] -i [秘密鍵] [ユーザ名]@[ipアドレス]"))))))


  ((tag "Debian")
   (lang "ja")
   (title "back in time")
   (modify-date 2014 5 24)
   (id "2014052401")
   (contents 
    (p "スナップショットを作るソフトウェア")
    (p "同じボリューム内にはスナップショットを作れない。 ")))


  ((tag "Debian" "X11")
   (lang "ja")
   (title "AltGrの利用")
   (modify-date 2014 2 2)
   (id "2014020201")
   (contents (ul (li (code "/usr/share/X11/xkb/symbols/pc"))
		 (li (code "/usr/share/X11/xkb/symbols/us")))
	     (p "国際AltGr相当を書き換える。")
	     (p "ひらがな/カタカナトグルは単独ではひらがなキーとして、shiftと同時押しではカタカナキーとなる。 ")))


  ((tag "Debian" "Mozc" "iBus")
   (lang "ja")
   (title "Mozcの書き換え")
   (modify-date 2014 2 1)
   (id "2014020101")
   (contents 
    (section
     (h4 "ソースの取得")
     (pre ((class "command"))
	  (code "$ apt-get source mozc")))

    (section
     (h4 "依存ファイルの取得")
     (pre ((class "command"))
	  (code "$ apt-get build-dep mozc")))

    (section
     (h4 "deb作成")
     (pre ((class "command"))
	  (code "$ dpkg-buildpackage -r -uc -b")))

    (section
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
	  (td "「ゔ」の定義。ひらがなで打っても自動的にカタカナに変換される。"))))

    (section
     (h4 "書き換え手順とインストール")
     (ol
      (li (code "unix/ibus/key_translator.cc") "の" (code "kana_map_US[]") "の初期設定を変更する。")
      (li (code "data/preedit/kana.tsv") "を書き換える。")
      (li "ビルドして、debを作る。")
      (li "インストールする。")
      (li (code "/usr/share/ibux/component/mozc/xml") "の" (code "layout") "を" (code "us") "に書き換える。")
      (li (code "mozc_engine.cc") (code "のis_layout_jp関連"))))))


  ((tag "Debian")
   (lang "ja")
   (title "clamav")
   (modify-date 2013 12 21)
   (id "2013122101")
   (contents 
    (section
     (h4 "コマンド")
     (section
      (h5 "定義ファイルの更新。")
      (pre ((class "command"))
	   (code "$ freshclam")))
     (section
      (h5 "ディレクトリを指定してスキャン。")
      (pre ((class "command"))
	   (code "$ clamscan -r -i directory")))))))
