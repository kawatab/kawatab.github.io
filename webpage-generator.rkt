#lang racket

;;; webpage-generator.rkt -- generate web pages from articles with tags
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


;; The values defined in `config.rkt' are as follows:
;;   language-list       : (Listof String)
;;   author              : String
;;   email-address       : String
;;   articles-directory  : String
;;   stylesheet-filename : String
;;   get-title           : -> String String
;;   get-description     : -> String String
;;   get-license-text    : -> String (values String String String String)

(require xml
	 racket/date
	 (file "config.rkt"))


(define add-tags-to-list
  ;; This is a closure. The closure has list of tags, and expects an argument
  ;; as list of tags. List is sorted with order by alphabet without any
  ;; duplicated tags. The return value is the list of tags in the closure.
  ;; If the argument is '(), the function return the list of tags without
  ;; any action.
  ;; (-> String (Listof String))
  (let ([tags '()])
    (lambda (arg)
      (for-each (lambda (a-tag)
		  (if (null? tags)
		      (set! tags (list a-tag))
		      (let iter ([temp (car tags)]
				 [compared '()]
				 [rest (cdr tags)])
			(unless (string-ci=? a-tag temp)
			  (if (string-ci<? a-tag temp)
			      (set! tags
				    (foldl cons
					   `(,a-tag ,temp ,@rest)
					   compared))
			      (if (null? rest)
				  (set! tags `(,@tags ,a-tag))
				  (iter (car rest)
					(cons temp compared)
					(cdr rest))))))))
		arg)
      tags)))

(define (read-all-articles filename)
  ;; This function reads a file that name matches `filename', and modifies
  ;; articles. While in this process, the function adds new tags to
  ;; `add-tags-to-list'. The return values is list of all articles in the
  ;; file named `filename'. If any articles do not have any pairs of
  ;; 'modify-date, this function makes pairs from modify-date of file system.
  ;; -> (Listof Any)
  ;; filename : Path
  (let* ([a-path (build-path articles-directory filename)]
	 [articles (eval (call-with-input-file a-path
			   (lambda (in) (read in)))
			 (make-base-namespace))])
    (map (lambda (an-article)
	   (add-tags-to-list (cdr (assq 'tag an-article)))
	   `((modify-date
	      ,(let ([modify-date (assq 'modify-date an-article)])
		 (if modify-date
		     (find-seconds 0
				   0
				   0
				   (cadddr modify-date)
				   (caddr modify-date)
				   (cadr modify-date)
				   #f)
		     (file-or-directory-modify-seconds a-path))))
	     ,@an-article))
	 articles)))

(define find-articles
  ;; This is a closure. The closure has list of articles, and expects two
  ;; argument as string. The location of articles is set to
  ;; `articles-directory'. The return values is list of articles that match
  ;; with the tag and the language given as arguments. The list of articles
  ;; are sorted with order by date.
  ;; (-> String String (Listof Any))
  (let ([all-articles
	 (apply append
		(map read-all-articles
		     (filter (lambda (filename)
			       (not
				(memq (string-ref (path->string filename) 0)
				      '(#\# #\~ #\.))))
			     (directory-list articles-directory))))])
    (lambda (a-tag lang)
      (filter-map (lambda (an-article)
		    (let ([tags (assq 'tag an-article)]
			  [langs (assq 'lang an-article)])
		      (and tags (member a-tag (cdr tags))
			   langs (member lang (cdr langs))
			   an-article)))
		  (sort-articles-with-order-by-date all-articles)))))

(define (sort-articles-with-order-by-date articles)
  ;; This function sorts articles with order by date.
  ;; -> (Listof Any)
  ;; articles : (Listof Any)
  (sort articles
	(lambda (x y)
	  (> (cadr (assq 'modify-date x))
	     (cadr (assq 'modify-date y))))))

(define (get-latest-update articles)
  ;; This function gets latest update among articles.
  ;; -> String or (Listof Any)
  ;; articles : (Listof Any)
  (let ([date-list (map (lambda (an-article)
			  (cond [(assq 'modify-date an-article) => cadr]
				[else 0]))
			articles)])
    (if (null? date-list)
	""
	(format-date (apply max date-list)))))


(define (make-tag-html/ul current-page-tag tags lang)
  ;; -> (Listof String)
  ;; current-page-tag : String
  ;; tags : (Listof String)
  ;; lang : String
  `(ul ((class "tags"))
       ,@(map (lambda (a-tag)
	       (if (eq? a-tag current-page-tag)
		   `(li ((class "current-page"))
			,a-tag)
		   `(li (a ((href ,(append-html-suffix a-tag lang)))
			   ,a-tag))))
	     tags)))

(define (format-date seconds)
  ;; The return value is included HTML elements. `seconds' is time in
  ;; seconds since midnight UTC, January 1, 1970.
  ;; -> (Listof Any)
  ;; seconds : Real
  (let* ([date (seconds->date seconds)]
	 [year (date-year date)]
	 [month (~r (date-month date) #:min-width 2 #:pad-string "0")]
	 [day (~r (date-day date) #:min-width 2 #:pad-string "0")])
    `(time ((datetime ,(format "~a-~a-~a" year month day)))
	   ,(format "~a-~a-~a" year month day))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for multilingual                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (append-html-suffix name lang)
  ;; This function appends suffix, ".html", "-hu.html" or "-ja.html". The
  ;; applied suffix depends on `lang'. `name' is converted to down case.
  ;; -> String
  ;; name : String
  ;; lang : String
  (string-append (make-safe-name name)
		 (cond [(eq? "en" lang) ".html"]
		       [(eq? "hu" lang) "-hu.html"]
		       [else "-ja.html"])))

(define (make-language-selector page-name lang)
  ;; This function makes data for a selector of languages. The first letter
  ;; of selectors is space for using in <p>.
  ;; -> (Listof Any)
  ;; page-name : String
  ;; lang : String
  `(" ("
    ,(if (eq? lang "en")
	 "English"
	 `(a ((href ,(string-append page-name ".html")))
	     "English"))
    " | "
    ,(if (eq? lang "hu")
	 "Magyar"
	 `(a ((href ,(string-append page-name "-hu.html")))
	     "Magyar"))
    " | "
    ,(if (eq? lang "ja")
	 "日本語"
	 `(a ((href ,(string-append page-name "-ja.html")))
	     "日本語"))
    ")"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for making all pages                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-head title lang)
  ;; The author name is set to `author', and the author's e-mail address is
  ;; set to `email-address'. The file name of CSS that is applied is set to
  ;; `stylesheet-filename'.
  ;; -> (Listof Any)
  ;; title : String
  ;; lang : String
  `(head (meta ((HTTP-EQUIV "Content-Type")
		(CONTENT "text/html; CHARSET=utf-8")))
	 (meta ((name "Author")
		(content ,author)))
	 (title ,title)
	 (link ((rev "made")
		(href ,(string-append "mailto:" email-address))))
	 (link ((rel "stylesheet")
		(href ,stylesheet-filename)
		(type "text/css")))))

(define (make-safe-name name)
  (regexp-replaces (string-downcase name)
		    '((#rx" " "_")
		      (#rx"~" "tilde")
		      (#rx"!" "excl")
		      (#rx"@" "atmark")
		      (#rx"#" "hash")
		      (#rx"%" "percentage")
		      (#rx"&" "amp")
		      (#rx"=" "equal")
		      (#rx";" "semicolon")
		      (#rx":" "colon")
		      (#rx"," "comma")
		      (#rx"/" "slash")
		      (#rx"<" "lt")
		      (#rx">" "gt")
		      (#rx"\\$" "dollar")
		      (#rx"\\'" "quot")
		      (#rx"\\(" "lparen")
		      (#rx"\\)" "rparen")
		      (#rx"\\*" "asterisk")
		      (#rx"\\+" "plus")
		      (#rx"\\?" "question")
		      (#rx"\\[" "lbracket")
		      (#rx"\\]" "rbracket")
		      (#rx"\\{" "lbrace")
		      (#rx"\\}" "rbrace")
		      (#rx"\\." "dot")
		      (#rx"\\^" "hat")
		      (#rx"\\|" "bar"))))

(define (make-header title lang)
  ;; This function makes data for applying all pages commonly. The selector of
  ;; language requires the page name. Page names are converted to down case.
  ;; -> (Listof Any)
  ;; title : String
  ;; lang : String
  `(header (h1 ,(get-title lang))
	   (p ,(get-description lang)
	      ,@(make-language-selector (make-safe-name title) lang))))

(define (make-footer lang)
  ;; This function makes data for CC License displaying at footer.
  ;; -> (Listof Any)
  ;; lang : String
  (let-values (((text1 text2 text3 alt) (get-license-text lang)))
    `(footer (a ((rel "license")
		 (href "http://creativecommons.org/licenses/by/4.0/"))
		(img ((alt ,alt)
		      (style "border-width:0")
		      (src "https://i.creativecommons.org/l/by/4.0/88x31.png"))))
	     (address (a ((href ,(string-append "mailto:" email-address)))
			 ,(string-append author " <" email-address ">")))
	     (p ,text1
		(a ((rel "license")
		    (href "http://creativecommons.org/licenses/by/4.0/"))
		   ,text2)
		,text3)
	     (p "This page is generated by "
		(a ((href "https://github.com/kawatab/kawatab.github.io"))
		   "webpage-generator.rkt")
		", using "
		(a ((href "http://racket-lang.org/"))
		   "the Racket language")
		"."))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for making main pages                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-mainpage-contents lang)
  ;; -> (Listof Any)
  ;; lang : String
  (map (lambda (a-tag) 
	 (let ([articles (find-articles a-tag lang)])
	   `(section ((class "index"))
		     (h2 (a ((href ,(append-html-suffix a-tag lang)))
			    ,a-tag))
		     (p ((class "number-of-articles"))
			,(get-expression-of-number (length articles) lang))
		     (p ((class "modify-date"))
			,(get-latest-update articles)))))
       (add-tags-to-list '())))

(define (make-mainpage lang)
  ;; -> (Listof Any)
  ;; lang : String
  (string-append
   "<!DOCTYPE html>"
   (xexpr->string `(html ((lang ,lang))
			 ,(make-head (get-title lang) lang)
			 ,(make-header "index" lang)
			 ,@(make-mainpage-contents lang)
			 ,(make-footer lang)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for making sub pages                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-subpage-contents a-tag lang)
  ;; -> (Listof Any)
  ;; a-tag : String
  ;; lang : String
  `((section (h2 ,a-tag)
	     (nav ,(make-tag-html/ul a-tag (add-tags-to-list '()) lang)))
    ,@(map (lambda (an-article)
	     `(article
	       (header
		(h3 ,@(let ([id (assq 'id an-article)])
		       (if id
			   `(((id ,@(cdr id))))
			   '()))
		    ,@(cdr (assq 'title an-article)))
		(p ((class "modify-date"))
		   ,(format-date (cadr (assq 'modify-date an-article)))))
	       ,@(cdr (assq 'contents an-article))
	       (nav
		,(make-tag-html/ul a-tag
				   (sort (cdr (assq 'tag an-article))
					 string-ci<?)
				   lang))))
	   (find-articles a-tag lang))))

(define (make-subpage a-tag lang)
  ;; -> (Listof Any)
  ;; a-tag : String
  ;; lang : String
  (string-append
   "<!DOCTYPE html>"
   (xexpr->string `(html ((lang ,lang))
			 ,(make-head (string-append (get-title lang)
						    "/"
						    a-tag)
				     lang)
			 ,(make-header a-tag lang)
			 ,@(make-subpage-contents a-tag lang)
			 ,(make-footer lang)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generate all main pages                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(for-each (lambda (lang)
	    (call-with-output-file (append-html-suffix "index" lang)
		(lambda (out)
		  (display (make-mainpage lang) out))
		#:exists 'replace))
	  language-list)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generate all subpages                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(for-each (lambda (a-tag)
	    (for-each (lambda (lang)
			(call-with-output-file (append-html-suffix a-tag lang)
			  (lambda (out)
			    (display (make-subpage a-tag lang) out))
			  #:exists 'replace))
		      language-list))
	  (add-tags-to-list '()))
