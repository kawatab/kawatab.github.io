`((tag "Debian")
  (lang "ja")
  (title "Sogo")
  (modify-date 2014 5 31)
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

