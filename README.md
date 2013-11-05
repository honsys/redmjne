redmjne
=======

JRuby Redmine deployments that are fully self-contained, with and without
custimazation via plugins and themes in JEE Apache-Tomcat WARs.

Redmjne releases will hopefully keep up-2-date with the latest stable releases 
of all essential runtime elements (as of Nov. 2013):
 
  * Java 7 or later
  * Apache Tomcat 7.0.47 -- Websocket support <http://tomcat.apache.org/tomcat-7.0-doc/web-socket-howto.html>
  * JRuby 1.7.6 -- <http://jruby.org> 
  * Redmine 2.3.3 -- <http://www.redmine.org>
  * Rails 3.2.13 -- <http://rubyonrails.org> (evidently Redmine has not yet moved to 4.x)

Apache Tomcat example configs. with and without SSL are included.
HAProxy and IPTables firewall example configs. are also included
to provide an optional reverse-proxy setup. 

