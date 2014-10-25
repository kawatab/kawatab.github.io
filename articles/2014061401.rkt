`((tag "Debian" "VLC")
  (lang "ja")
  (title "Canonのaviからmp4に変換")
  (modify-date 2014 6 14)
  (contents 
   (pre ((class "command"))
	(code "$ a=\"MVI_0995\"; vlc -I dummy -vvv \"$a.AVI\" --sout \"#transcode{vcodec=h264,vb=1200,acodec=mp3,ab=128,channels=1,samplerate=11025}:standard{mux=mp4,dst=\"$a.mp4\",access=file}\" vlc://quit"))))
