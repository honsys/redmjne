#!/bin/csh -f
echo default tomcat port 8080 is poduction backend \(other option is reclease cadidate 'rc' port 8088\)
echo establish release via redmine, jruby and java versions \(and maybe tomcat version\)
set host = ${HOST:r}
set redmine = '2.4.3' ; set jrb = '1.7.10' ; set jre = '1.7' ; set tomcat = '8.0.3' # set tomcat = '7.0.50'
set release = "${redmine}_${jrb}_${jre}"
set opt = "pro" # production or release candidate 'rc'
set catalina = "catalina80"
set cwd = `pwd`
set build = ${cwd}/build
echo "$HOST workspace directory -- ${build}"
echo "apache tomcat JEE RedmJne release $release -- Redmine_JRuby_Java release versions ..."
echo "runtime should also use latest stable apache tomcat."
if ( "$1" != "" ) set opt = "$1"
set envlist = 'WWW_HOME ASSETS CATALINA_HOME CATALINA_BASE GEMFILE HUDSON_HOME HUDSON_OPTS JAVAREL JAVA_HOME JENKINS_HOME JRUBY JRUBY_HOME JRUBY_OPTS JRUBYREL JXX_OPTS JYTHON_HOME NODE_HOME NODE_PATH NODE_ENV RAILS_ENV REDMINE_LANG REDMINEREL REDMJNE SCM_HOME SCM_OPTS SOLR_HOME SOLR_DATA SOLR_OPTS TOMCAT_HOME TOMCATREL TOMCAT JAVA_OPTS'
if ( $opt == 'clear' ) then
  foreach e ($envlist)
    echo "unsetenv $e" 
    unsetenv $e
  end
  if ( "$2" == "" ) then
    exit
  else
    set opt = "$2"
  endif
endif
if ( "$opt" != "pro" ) set catalina = 'catalina88'
#
echo "setenv: $envlist"
echo '--- Tomcat Catalina WebApp Environment (RedmJne, SCM-Manager, Hudson/Jenkins, Solr, ActiveMQ, public_html ...) ---'
#
# honsy.com special case:
if ( $host == 'honsys' ) setenv JAVA_HOME /usr/java/latest
#
if ( ! $?WWW_HOME ) setenv WWW_HOME $HOME/www ; echo "WWW_HOME == $WWW_HOME"
if ( ! $?ASSETS ) setenv ASSETS $cwd/assets ; echo "ASSETS == $ASSETS"
if ( ! $?CATALINA_HOME ) setenv CATALINA_HOME ${WWW_HOME}/${catalina} ; echo "CATALINA_HOME == $CATALINA_HOME"
if ( ! $?CATALINA_BASE ) setenv CATALINA_BASE $CATALINA_HOME ; echo "CATALINA_BASE == $CATALINA_BASE"
if ( ! $?GEMFILE ) setenv GEMFILE Gemfile${release} ; echo "GEMFILE == $GEMFILE"
if ( ! $?HUDSON_HOME ) setenv HUDSON_HOME ${WWW_HOME}/ci/hudson ; echo "HUDSON_HOME == $HUDSON_HOME"
if ( ! $?HUDSON_OPTS ) setenv HUDSON_OPTS "-DHUDSON_HOME=$HUDSON_HOME" ; echo "HUDSON_OPTS == $HUDSON_OPTS"
if ( ! $?JAVAREL ) setenv JAVAREL $jre ; echo "JAVAREL == $JAVAREL"
if ( ! $?JAVA_HOME ) setenv JAVA_HOME $cwd/openjdk ; echo "JAVA_HOME == $JAVA_HOME "
if ( ! $?JENKINS_HOME ) setenv JENKINS_HOME ${WWW_HOME}/ci/jenkins ; echo "JENKINS_HOME == $JENKINS_HOME"
if ( ! $?JRUBY ) setenv JRUBY jruby-bin-${jrb} ; echo "JRUBY == $JRUBY"
if ( ! $?JRUBY_HOME ) setenv JRUBY_HOME $cwd/build/jruby ; echo "JRUBY_HOME == $JRUBY_HOME"
if ( ! $?JRUBY_OPTS ) setenv JRUBY_OPTS '-Xcext.enabled=true' ; echo "JRUBY_OPTS == $JRUBY_OPTS"
if ( ! $?JRUBYREL ) setenv JRUBYREL $jrb ; echo "JRUBYREL == $JRUBYREL"
if ( ! $?JXX_OPTS ) setenv JXX_OPTS '-XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled' ; echo "JXX_OPTS == $JXX_OPTS"
if ( ! $?JYTHON_HOME ) setenv JYTHON_HOME /usr/local/jython ; echo "JYTHON_HOME == $JYTHON_HOME"
if ( ! $?NODE_HOME ) setenv NODE_HOME /usr/local ; echo "NODE_HOME == $NODE_HOME"
if ( ! $?NODE_PATH ) setenv NODE_PATH ${NODE_HOME}/lib/node_modules ; echo "NODE_PATH == $NODE_PATH"
if ( ! $?NODE_ENV ) setenv NODE_ENV production ; echo "NODE_ENV == $NODE_ENV"
if ( ! $?RAILS_ENV ) setenv RAILS_ENV production ; echo "RAILS_ENV == $RAILS_ENV"
if ( ! $?REDMINE ) setenv REDMINE redmine-${redmine} ; echo "REDMINE == $REDMINE"
if ( ! $?REDMINE_LANG ) setenv REDMINE_LANG 'en' ; echo "REDMINE_LANG == $REDMINE_LANG"
if ( ! $?REDMINEREL ) setenv REDMINEREL $redmine ; echo "REDMINEREL == $REDMINEREL"
if ( ! $?REDMJNE ) setenv REDMJNE redmjne${release} ; echo "REDMJNE == $REDMJNE"
if ( ! $?REDMJNE_HOME )setenv REDMJNE_HOME ${WWW_HOME}/redmjne ; echo "REDMJNE_HOME == $REDMJNE_HOME"
if ( ! $?SCM_HOME ) setenv SCM_HOME $HOME/scm ; echo "SCM_HOME == $SCM_HOME"
if ( ! $?SCM_OPTS ) setenv SCM_OPTS "-Dscm.home=$SCM_HOME" ; echo "SCM_OPTS == $SCM_OPTS"
if ( ! $?SOLR_HOME ) setenv SOLR_HOME ${WWW_HOME}/solr ; echo "SOLR_HOME == $SOLR_HOME"
if ( ! $?SOLR_DATA ) setenv SOLR_DATA ${SOLR_HOME}/data ; echo "SOLR_DATA ==  $SOLR_DATA"
if ( ! $?SOLR_OPTS ) setenv SOLR_OPTS "-Dsolr.data.dir=$SOLR_HOME/data -Dsolr.solr.home=$SOLR_HOME" ; echo "SOLR_OPTS == $SOLR_OPTS"
if ( ! $?TOMCAT_HOME ) setenv TOMCAT_HOME ${WWW_HOME}/${catalina} ; echo "TOMCAT_HOME == $TOMCAT_HOME"
if ( ! $?TOMCATREL ) setenv TOMCATREL ${tomcat} ; echo "TOMCATREL == $TOMCATREL"
if ( ! $?TOMCAT ) setenv TOMCAT apache-tomcat-${TOMCATREL} ; echo "TOMCAT == $TOMCAT"
#
# ensure JAVA_OPTS includes any/all items defined above:
if ( ! $?JAVA_OPTS ) setenv JAVA_OPTS "$HUDSON_OPTS $SCM_OPTS $SOLR_OPTS $JXX_OPTS -server -Djava.awt.headless=true"
#setenv JAVA_OPTS '-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -server -Djava.awt.headless=true'
echo "JAVA_OPTS == $JAVA_OPTS"
#
echo '--- Tomcat Catalina WebApp Environment (RedmJne, SCM-Manager, Hudson/Jenkins, Solr, ActiveMQ, public_html ...) ---'
