(defpackage :my-package
  (:use :cl)
  (:export #:hello))

(in-package :my-package)

(defun hello ()
  (print "Hello from my package."))