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
  (let ([tags '()])
    (lambda (arg)
      (for-each (lambda (a-tag)
		  (if (null? tags)
		      (set! tags (list a-tag))
		      (let iter ([temp (car tags)]
				 [compared '()]
				 [rest (cdr tags)])
			(unless (string=? a-tag temp)
			  (if (string<? a-tag temp)
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

(define find-articles
  ;; This is a closure. The closure has list of articles, and expect an
  ;; argument as string. The location of articles is set to
  ;; `articles-directory'. The return values is list of articles that match
  ;; with the tag given as an argument.
  ;; The list of articles are sorted with order by date. If any articles do
  ;; not have pairs of 'modify-date, this function makes pairs from
  ;; modify-date of filesystem.
  ;; (-> String (Listof Any))
  (let ([all-articles
	 (map (lambda (filename)
		(let* ([a-path (build-path articles-directory filename)]
		       [an-article 
			(eval (call-with-input-file a-path
				(lambda (in) (read in)))
			      (make-base-namespace))])
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
		    (source ,(string-replace (path->string filename) "." "_"))
		    ,@an-article)))
	      (directory-list articles-directory))]) 
    (lambda (a-tag)
      (filter-map (lambda (an-article)
		    (cond [(assq 'tag an-article) =>
			   (lambda (tags)
			     (and (member a-tag (cdr tags))
				  an-article))]
			  [else #f]))
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
	"no contents"
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
  ;; The return value is included html elements. `seconds' is time in
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
  ;; applied suffix depends on `lang'. `name' is converted to downcase.
  ;; -> String
  ;; name : String
  ;; lang : String
  (string-append (string-downcase name)
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
  ;; The author name is set to `author', and the author's e-mail addres is
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

(define (make-header title lang)
  ;; This function makes data for applying all pages commonly. The selector of
  ;; language requires the page name. Page names are converted to down case.
  ;; -> (Listof Any)
  ;; title : String
  ;; lang : String
  `(header (h1 ,(get-title lang))
	   (p ,(get-description lang)
	      ,@(make-language-selector (string-downcase title) lang))))

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
	     (br)
	     ,text1
	     (a ((rel "license")
		 (href "http://creativecommons.org/licenses/by/4.0/"))
		,text2)
	     ,text3)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for making main pages                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-mainpage-contents lang)
  ;; -> (Listof Any)
  ;; lang : String
  (map (lambda (a-tag)
	 `(section (h2 (a ((href ,(append-html-suffix a-tag lang)))
			  ,a-tag))
		   (p ((class "modify-date"))
		      ,(get-latest-update (find-articles a-tag)))))
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
	    ,(make-tag-html/ul a-tag (add-tags-to-list '()) lang))
    ,@(map (lambda (an-article)
	     `(article
	       (header
		(h3 ((id ,@(cdr (assq 'source an-article))))
		    ,@(cdr (assq 'title an-article)))
		(p ((class "modify-date"))
		   ,(format-date (cadr (assq 'modify-date an-article)))))
	       (section ,@(cdr (assq 'contents an-article)))
	       (footer
		,(make-tag-html/ul a-tag (cdr (assq 'tag an-article)) lang))))
	   (find-articles a-tag))))

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
