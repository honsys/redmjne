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

Apache Tomcat example configs. included, with and without SSL/HTTPS.
HAProxy and IPTables firewall example configs. are also included to provide
a reverse-proxy setup. Note the configs allow for two tomcat runtimes
(port 8080 and either 8090 or 8070). Also, moving from tomcat 7 to tomcat 8
required one modest change (I vaguely recall) in the AJP section of server.xml
(since I use haproxy rather that apache httpd, there's little need to support mod_jk).
See AJP comments in <http://tomcat.apache.org/tomcat-8.0-doc/changelog.html>

Note the haproxy.conf is composed via:

cat haproxy_globaldefaults.conf haproxy_frontend_auth.conf haproxy_stats.conf haproxy_jeebackends.conf haproxy_nodejsbackends.conf > haproxy.conf

All the above will require edits for one's specific deployment. If no NodeJS backends
are of interest, edit the "frontend" conf and exclude the nodejsbackends from the cat.

This is overdue some updates (as of Aug 2014) -- newer releases of all elements are
available, and a number of scripts changes too. I plan to return to this "next week
or next month" (whatever that means).

