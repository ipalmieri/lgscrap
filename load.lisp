(load ".quicklisp/setup.lisp")

(push #p"./ltools/" asdf:*central-registry*)
(push #p"./lgrabber/" asdf:*central-registry*)

(ql:quickload "lgrabber")                                                                              
