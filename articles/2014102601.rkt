`(((tag "KDE" "Debian" "Fcitx")
   (lang "ja")
   (title "fcitxのアイコンをパネルに表示させる")
   (modify-date 2014 10 21)
   (id "2014102101")
   (contents (p "入力方法パネルのウィジェットをパネルに追加する。")))


  ((tag "Mozc" "Fcitx" "Emacs" "Debian")
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


  ((tag "Debian" "VLC")
   (lang "ja")
   (title "Canonのaviからmp4に変換")
   (modify-date 2014 6 14)
   (id "2014061401")
   (contents 
    (pre ((class "command"))
	 (code "$ a=\"MVI_0995\"; vlc -I dummy -vvv \"$a.AVI\" --sout \"#transcode{vcodec=h264,vb=1200,acodec=mp3,ab=128,channels=1,samplerate=11025}:standard{mux=mp4,dst=\"$a.mp4\",access=file}\" vlc://quit"))))


  ((tag "Debian")
   (lang "ja")
   (title "Sogo")
   (modify-date 2014 5 31)
   (id "2014053101")
   (contents
    (h4 "データベースの準備")
    (p "公式ガイドのp.28に従う。")

    (pre ((class "command"))
	 (code "su - postgres
createuser --no-superuser --no-createdb --no-createrole \
--encrypted --pwprompt sogo"))
    (p "(specify “sogo” as password)")
    (pre ((class "command"))
	 (code "createdb -O sogo sogo"))


    (h4 "postgreSQLに接続する。")
    (pre ((class "command"))
	 (code "psql sogo"))

    (p "DebianWikiの方法に従う。ただし、" (code "sogo_users") "ではなく" (code "sogo_view") "にする。")

    (pre ((class "config"))
	 (code "CREATE TABLE sogo_view (c_uid VARCHAR(10) PRIMARY KEY, c_name VARCHAR(10), c_password VARCHAR(32), c_cn VARCHAR(128), mail VARCHAR(128));
INSERT INTO sogo_users VALUES ('paul', 'paul', MD5('zxc'), 'Paul Example', 'paul@example.com');"))


    (h4 "PostgreSQLでの権限追加")
    (pre ((class "command"))
	 (code "GRANT ALL PRIVILEGES ON sogo_users TO sogo"))

    (P "公式ガイドのp.28に従う。")

    (p (code "/var/lib/pgsql/data/pg_hba.conf"))
    (p "Debianの場合は" (code "/etc/postgresql/9.1/main/pg_hba.conf"))

    (h4 "SOGoの設定")

    (p "公式ガイドのp.31の設定。以下の設定を追加し、タイムゾーンなどをいじる。")

    (pre ((class "config"))
	 (code "SOGoUserSources =
(
 {
  type = sql;
       id = directory;
       viewURL = \"postgresql://sogo:sogo@127.0.0.1:5432/sogo/sogo_view\";
       canAuthenticate = YES;
       isAddressBook = YES;
       userPasswordAlgorithm = md5;
       }
 );\"))"))

    (pre ((class "command"))
         (code "$ cp /usr/share/doc/sogo/apache.conf /etc/apache2/conf.d/SOGo.conf
$ sudo vi /etc/apache2/conf.d/SOGo.conf"))
    (p "ipアドレスを書き換え")
    (pre ((class "config"))
         (code "## adjust the following to your configuration
  RequestHeader set \"x-webobjects-server-port\" \"443\"
  RequestHeader set \"x-webobjects-server-name\" \"192.168.0.119\"
  RequestHeader set \"x-webobjects-server-url\" \"https://192.168.0.119\""))

    (pre ((class "command"))
         (code "$ sudo service apache2 restart"))

    (h4 "SSLの設定")
    (p "標準的な方法")

    (pre ((class "config"))
         (code "<Directory /usr/lib/GNUstep/SOGo>
    Require all granted
    # Explicitly allow caching of static content to avoid browser specific behavior.
    # A resource's URL MUST change in order to have the client load the new version.
    <IfModule expires_module>
      ExpiresActive On
      ExpiresDefault \"access plus 1 year\"
    </IfModule>
</Directory>"))))


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
    (h4 "必要なパッケージ")
    (h5 "サーバ")
    (p "openssh-server")

    (h5 "クライアント")
    (p "openssh-client")

    (h4 "サーバの設定")
    (h5 "/etc/ssh/sshd_config")
    (p (code "/etc/ssh/sshd_config")
        "に以下の変更を加える。")

    (pre ((class "config"))
         (code "Port 22                                     # ポート番号は適当に物に書き換える。
PermitRootLogin no                          #rootユーザはログインできないようにする。
AuthorizedKeyFile %h/.ssh/authorized_keys   #コメントを外す。
DenyUsers ALL                               #追加
Allowusers your_name                        #追加"))

    (p "変更したら")
    (pre ((class "command"))
          (code "# invoke-rc.d ssh restart"))
    (p "を実行する。")

    (h4 "キーの作成")
    (pre ((class "command"))
         "$ ssh-keygen")
    (p "manには次のように書かれているので、オプションは要らない。")
    (blockquote "ssh-keygen generates, manages and converts authentication keys for ssh(1).  ssh-keygen can create RSA keys for use by SSH protocol version 1 and DSA, ECDSA or RSA keys for use by SSH protocol version 2.  The type of key to be generated is specified with the -t option.  If invoked without any arguments, ssh-keygen will generate an RSA key for use in SSH protocol 2 connections.")
    (p "具体的には")

    (pre ((class "command"))
         (code "$ ssh-keygen
$ cat .ssh/id_rsa.pub > .ssh/authorized_keys"))

    (p "でOK。" (code "ssh-keygen") "の実行時には保存場所の確認とパスワードの入力が必要。公開鍵（id_rsa.pub）は" (code "~/.ssh/authorized_keys") "に書き込む。パーミッションは600。")


    (h4 "クライアントの設定")
    (p "秘密鍵（id_rsa）をネットワークを介さない方法でコピーする。")

    (h5 "Linuxからアクセスする場合")
    (pre ((class "command"))
      (code "$ ssh -p [ポート番号] -i [秘密鍵] [ユーザ名]@[ipアドレス]"))))


  ((tag "Debian")
   (lang "ja")
   (title "back in time")
   (modify-date 2014 5 24)
   (id "2014052401")
   (contents 
    (p "スナップショットを作るソフトウェア")
    (p "同じボリューム内にはスナップショットを作れない。 ")))


  ((tag "Debian")
   (lang "ja")
   (title "AltGrの利用")
   (modify-date 2014 2 2)
   (id "2014020201")
   (contents (ul (li (code "/usr/share/X11/xkb/symbols/pc"))
	         (li (code "/usr/share/X11/xkb/symbols/us")))
	     (p "国際AltGr相当を書き換える。")
	     (p "ひらがな/カタカナトグルは単独ではひらがなキーとして、shiftと同時押しではカタカナキーとなる。 ")))


  ((tag "Debian" "Mozc")
   (lang "ja")
   (title "Mozcの書き換え")
   (modify-date 2014 2 1)
   (id "2014020101")
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


  ((tag "Debian")
   (lang "ja")
   (title "clamav")
   (modify-date 2013 12 21)
   (id "2013122101")
   (contents 
    (h4 "コマンド")
    (h5 "定義ファイルの更新。")
    (pre ((class "command"))
         (code "$ freshclam"))
    (h5 "ディレクトリを指定してスキャン。")
    (pre ((class "command"))
         (code "$ clamscan -r -i directory")))))
