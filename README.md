redmjne
=======

JRuby Redmine deployments that are fully self-contained, with and without
customization via plugins and themes in JEE Apache-Tomcat WARs.

Redmjne releases will hopefully keep up-2-date with the latest stable releases 
of all essential runtime elements (as of March 2014):
 
  * Java 7 or later -- currently 1.7.0_51 from <http://www.oracle.com/technetwork/java/javase/downloads/index.html>
  * HAProxy 1.5-dev21 -- <http://haproxy.1wt.eu/>
  * Apache Tomcat 7.52 and 8.03 -- Websocket support <http://tomcat.apache.org/tomcat-8.0-doc/web-socket-howto.html>
  * JRuby 1.7.11 -- <http://jruby.org> 
  * Redmine 2.4.4 (2.5.0 jruby redcarpet glitch TBD) -- <http://www.redmine.org>
  * Rails 3.2.x -- <http://rubyonrails.org> (evidently Redmine has not yet moved to 4.x)

Apache Tomcat example configs. (TBD) included, with and without SSL/HTTPS.
HAProxy and IPTables firewall example configs. are also (TBD) included to provide
an optional reverse-proxy setup. 

C/C++ JobQuiz
=============

* ReadMe.md -- this file

* Makefile -- compiles & links each file into testable binary executable

* getid.c -- original quiz source runs, yielding inconsistent results due
to use of un-initialez function stack local variable.

* getid_static.c -- improved version yields consistent outcome via compiler
initialized & cleared stack static variable.

* getid_stack32k.c -- demonstrates maximum function-stack-based buffer

* getid_stack64k.c -- segfaults due to attempt to access memory betond stack

* getid_heap.c -- provides dynamically allocated buffer allowing larger size
  
* getid++.cc -- alternative function implementations using some c++ features
