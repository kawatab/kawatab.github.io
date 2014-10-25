`((tag "Debian" "Network")
  (lang "ja")
  (title "ssh")
  (modify-date 2014 5 25)
  (contents 
   (h4 "必要なパッケージ")
   (h5 "サーバ")
   (p "openssh-server")

   (h5 "クライアント")
   (P "openssh-client")

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
   (P "manには次のように書かれているので、オプションは要らない。")
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
