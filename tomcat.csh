#!/bin/csh -f
# while much of the apache-tomcat/config content
# is portable, each host must have its own unige keystore file.
# generated via:
# $JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA -keystore ./.keystore
#
# be sure to double-check these env items for properly set sym-links!
setenv JAVA_HOME /usr/java
set host = $HOST:r
if ( $host == 'honsys' ) setenv JAVA_HOME /usr/java/latest
setenv WWW_HOME /home/hon/www
setenv JRUBY_HOME /usr/local/jruby
# jruby & jython & node installs should be sym-links
# to latest relleases:
setenv JYTHON_HOME /usr/local/jython
setenv TOMCAT_HOME ${WWW_HOME}/apache-tomcat
setenv CATALINA_HOME $TOMCAT_HOME
setenv CATALINA_BASE $CATALINA_HOME
setenv HUDSON_HOME ${WWW_HOME}/apps/hudson
setenv REDMJNE_HOME ${WWW_HOME}/apps/redmjne
setenv SCM_HOME ${WWW_HOME}/apps/scm
setenv NODE_HOME /usr/local
setenv NODE_PATH ${NODE_HOME}/lib/node_modules
setenv NODE_ENV production
# this is for redmine:
setenv RAILS_ENV production
#
# to run redmine, use the war created with jruby warble -- see jruby-redmine.csh
#
# not sure how to create a jython trac war...
#
# just use the example provided with the solr tarball 
# (apache-solr should be sym-link to untar'd example directory):
# to run a single solr instance, simply use the the example war provided 
# in $SOLR_HOME/example/webapps/solr.war and provide a data directory
setenv SOLR_HOME ${WWW_HOME}/apps/apache-solr 
setenv SOLR_DATA ${SOLR_HOME}/data
#
# tomcat jvm opts:
setenv JXX_OPTS "-XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
setenv JRUBY_OPTS "-Xcext.enabled=true"
setenv HUDSON_OPTS "-DHUDSON_HOME=$HUDSON_HOME"
setenv SOLR_OPTS "-Dsolr.data.dir=$SOLR_HOME/data -Dsolr.solr.home=$SOLR_HOME"
setenv JAVA_OPTS "$HUDSON_OPTS $SOLR_OPTS $JXX_OPTS -server -Djava.awt.headless=true"
# tomcat 6 jvm opts:
#setenv JAVA_OPTS '-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -server -Djava.awt.headless=true'
#
echo "TOMCAT_HOME == $TOMCAT_HOME"
echo "CATALINA_HOME == $CATALINA_HOME"
echo "CATALINA_BASE == $CATALINA_BASE"
echo "HUDSON_HOME == $HUDSON_HOME" 
echo "REDMJNE_HOME == $REDMJNE_HOME" 
echo "SCM_HOME == $SCM_HOME" 
echo "JRUBY_HOME == $JRUBY_HOME" 
echo "JYTHON_HOME == $JYTHON_HOME" 
echo "NODE_HOME == $NODE_HOME"
echo "NODE_ENV == $NODE_ENV"
echo "RAILS_ENV == $RAILS_ENV"
echo "SOLR_DATA == $SOLR_DATA"
echo "JAVA_OPTS == $JAVA_OPTS"
echo "JAVA_HOME == $JAVA_HOME"
\ls -lF /usr/local | egrep 'j[ry]'
java -version
#
echo '--------------------------------------------------'
set opt = envshow
if ( $1 != "" ) set opt = "$1"
if ( "$opt" == "envshow" ) exit
if ( "$opt" == "start" ) then
  echo shutting down any current tomcat runtime and REMOVING all logs 
  echo '--------------------------------------------------'
  \mkdir -p $TOMCAT_HOME/logs >& /dev/null
  $TOMCAT_HOME/bin/shutdown.sh >& /dev/null
  \rm -rf $TOMCAT_HOME/logs/*
  $TOMCAT_HOME/bin/startup.sh
endif
if ( "$opt" == "restart" ) then
  echo shutting down any current tomcat runtime and PRESERVING all logs 
  echo '--------------------------------------------------'
  $TOMCAT_HOME/bin/shutdown.sh >& /dev/null
  $TOMCAT_HOME/bin/startup.sh
endif
if ( "$opt" == "stop" ) then
  echo shutting down any current tomcat runtime and PRESERVING all logs 
  echo '--------------------------------------------------'
  $TOMCAT_HOME/bin/shutdown.sh
endif

