redmjne
=======

JRuby Redmine deployments that are fully self-contained, with and without
customization via plugins and themes in JEE Apache-Tomcat WARs.

Redmjne releases will hopefully keep up-2-date with the latest stable releases 
of all essential runtime elements; as of March 2015, please see the deplyment
folder <https://github.com/honsys/redmjne/blob/master/deploy/README.md>
 
  * Java 7 or later -- <http://www.oracle.com/technetwork/java/javase/downloads/index.html>
  * HAProxy 1.5 or later -- <http://haproxy.1wt.eu/>
  * Apache Tomcat 7 or 8 -- Websocket support <http://tomcat.apache.org/tomcat-8.0-doc/web-socket-howto.html>
  * JRuby 1.7 or later -- <http://jruby.org> 
  * Redmine 2.x or 3.x -- <http://www.redmine.org>
  * Rails 3 or later <http://rubyonrails.org> (whatever Redmine needs)

Apache Tomcat example configs. included, with and without SSL/HTTPS.
HAProxy and IPTables firewall example configs. are also included to provide
a reverse-proxy setup. Note the configs allow for two tomcat runtimes
(port 8080 and either 8090 or 8070). Also, moving from tomcat 7 to tomcat 8
required one modest change (I vaguely recall) in the AJP section of server.xml
(since I use haproxy rather that apache httpd, there's little need to support mod_jk).
See AJP comments in <http://tomcat.apache.org/tomcat-8.0-doc/changelog.html>

Note the haproxy.conf is composed via:

cat haproxy_globaldefaults.conf haproxy_frontend_auth.conf haproxy_stats.conf \ <br\>
haproxy_jeebackends.conf haproxy_nodejsbackends.conf > haproxy.conf

The above configs will require edits for one's specific deployment. If no
Python-Flask or NodeJS backends are of interest, edit the "frontend" conf
and exclude the pythonbackends and nodejsbackends from the cat.


