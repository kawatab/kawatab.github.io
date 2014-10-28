#lang typed/racket

;;; config.rkt -- generate web pages from articles with tags
;;
;; The MIT License (MIT)
;;
;; Copyright (c) 2014 Yasuhiro Yamakawa <kawatab@yahoo.co.jp>
;; 
;; Permission is hereby granted, free of charge, to any person obtaining a
;; copy of this software and associated documentation files (the "Software"),
;; to deal in the Software without restriction, including without limitation
;; the rights to use, copy, modify, merge, publish, distribute, sublicense,
;; and/or sell copies of the Software, and to permit persons to whom the
;; Software is furnished to do so, subject to the following conditions:
;; 
;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
;; THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;; DEALINGS IN THE SOFTWARE.


(: language-list : (Listof String))
(define language-list '("en" "hu" "ja"))

(: author : String)
(define author "Yasuhiro Yamakawa")

(: email-address : String)
(define email-address "kawatab@yahoo.co.jp")

(: articles-directory : String)
(define articles-directory "articles")

(: stylesheet-filename : String)
(define stylesheet-filename "base-style.css")

(: get-title : String -> String)
(define (get-title lang)
  (cond [(eq? "en" lang) "Kawatab's tips"]
	[(eq? "hu" lang) "Kawatab tippek"]
	[else "Kawatabの技術メモ"]))

(: get-description : String -> String)
(define (get-description lang)
  (cond [(eq? lang "en")
	 "This is my tips for using and setting up Computer, mainly Linux."]
	[(eq? lang "hu")
	 "Ez a tippek számítógép használathóz és konfigurációhóz."]
	[else
	 "主にLinuxを中心としたコンピュータ関連の技術情報を公開しています。"]))

(: get-license-text : String -> (values String String String String))
(define (get-license-text lang)
  (cond [(eq? lang "en")
	 (values "This work is licensed under a "
		 "Creative Commons Attribution 4.0 International License."
		 ""
		 "Creative Commons License")]
	[(eq? lang "hu")
	 (values "Ez a Mű a "
		 "Creative Commons Nevezd meg! 4.0 Nemzetközi Licenc"
		 " feltételeinek megfelelően felhasználható."
		 "Creative Commons Licenc")]
	[else
	 (values "この作品は"
		 "クリエイティブ・コモンズ 表示 4.0 国際 ライセンス"
		 "の下に提供されています。"
		 "クリエイティブ・コモンズ・ライセンス")]))

(: get-expression-of-number : Number String -> String)
(define (get-expression-of-number num lang)
  (cond [(eq? lang "en")
	 (cond [(zero? num) "No articles"]
	       [(= num 1) "1 article"]
	       [else (format "~a articles" num)])]
	[(eq? lang "hu")
	 (if (zero? num)
	     "Nincs cikk"
	     (format "~a cikk" num))]
	[else
	 (if (zero? num)
	     "記事はありません"
	     (format "~a個の記事" num))]))

(provide language-list
	 author
	 email-address
	 articles-directory
	 stylesheet-filename
	 get-title
	 get-description
	 get-license-text
	 get-expression-of-number)
