#!/bin/csh -f
#echo 'usage: env.csh [clear]'
echo 'default tomcat port 8080 is poduction backend (other option is release cadidate "rc" port 8090)'
echo 'establish release via redmine, jruby and java versions (and maybe tomcat version)'
set host = ${HOST:r}
set jrb = '1.7.11'
set jre = '1.7' 
set apollo = '1.6.0'
set tomcat = '7.0.52'
#set tomcat = '8.0.3' 
set redmine = '2.4.4' # set redmine = '2.5.0' 
set release = "${redmine}_${jrb}_${jre}"
# setup both production and release candidate tomcat runtimes
set catalina = "catalina80"
set rccatalina = "catalina90" 
set cwd = `pwd`
set build = ${cwd}/build
echo "$HOST workspace directory -- ${build}"
echo "apache tomcat JEE RedmJne release $release -- Redmine_JRuby_Java release versions ..."
echo "runtime should also use latest stable apache tomcat."
set jdat = `date "+%Y_%j_%H_%M"` # "_%S"
echo "$jdat"
set opt = "show"
if ( "$1" != "" ) set opt = "$1"
set envlist = 'WWW_HOME ASSETS APOLLO_HOME CATALINA GEMFILE HUDSON_HOME HUDSON_OPTS JAVAREL JAVA_HOME JENKINS_HOME JRUBY JRUBY_HOME JRUBY_OPTS JRUBYREL JXX_OPTS JYTHON_HOME NODE_HOME NODE_PATH NODE_ENV RAILS_ENV RCCATALINA REDMINE REDMINE_LANG REDMINEREL REDMJNE SCM_HOME SCM_OPTS SOLR_HOME SOLR_DATA SOLR_OPTS TOMCAT_HOME TOMCATREL TOMCAT JAVA_OPTS'
if ( "$opt" == "show" ) echo $envlist
if ( "$opt" == "clear" ) then
  foreach e ($envlist)
    echo "unsetenv ${e}" 
    unsetenv ${e}
  end
endif
#
echo '--- Tomcat Catalina WebApp Environment (RedmJne, SCM-Manager, Hudson/Jenkins, Solr, ActiveMQ, public_html ...) ---'
#
echo 'note the assumption is ~/{scm,solr,wwww} are sym-links to ~/monthYear/{scm,solr,www}'
echo 'the numo.csh script may be used to initialize a new ~/monthYear and the above sym-links'
#
# honsy.com special case:
if ( $host == 'honsys' ) setenv JAVA_HOME /usr/java/latest
#
#if ( ! $?WWW_HOME ) setenv WWW_HOME ${HOME}/www.${host} ; echo "WWW_HOME == $WWW_HOME"
if ( ! $?WWW_HOME ) setenv WWW_HOME ${HOME}/www ; echo "WWW_HOME == $WWW_HOME"
if ( ! $?ASSETS ) setenv ASSETS $cwd/assets ; echo "ASSETS == $ASSETS"
if ( ! $?APOLLO_HOME ) setenv APOLLO_HOME ${WWW_HOME}/mom/apollo ; echo "APOLLO_HOME == $APOLLO_HOME"
if ( ! $?CATALINA ) setenv CATALINA ${WWW_HOME}/${catalina} ; echo "CATALINA == $CATALINA"
if ( ! $?GEMFILE ) setenv GEMFILE Gemfile${release} ; echo "GEMFILE == $GEMFILE"
if ( ! $?HUDSON_HOME ) setenv HUDSON_HOME ${WWW_HOME}/ci/hudson ; echo "HUDSON_HOME == $HUDSON_HOME"
if ( ! $?HUDSON_OPTS ) setenv HUDSON_OPTS "-DHUDSON_HOME=$HUDSON_HOME" ; echo "HUDSON_OPTS == $HUDSON_OPTS"
if ( ! $?JAVAREL ) setenv JAVAREL $jre ; echo "JAVAREL == $JAVAREL"
if ( ! $?JAVA_HOME ) setenv JAVA_HOME $cwd/openjdk ; echo "JAVA_HOME == $JAVA_HOME "
if ( ! $?JENKINS_HOME ) setenv JENKINS_HOME ${WWW_HOME}/ci/jenkins ; echo "JENKINS_HOME == $JENKINS_HOME"
if ( ! $?JENKINS_OPTS ) setenv JENKINS_OPTS "-DJENKINS_HOME=$JENKINS_HOME" ; echo "JENKINS_OPTS == $JENKINS_OPTS"
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
if ( ! $?RCCATALINA ) setenv RCCATALINA ${WWW_HOME}/${rccatalina} ; echo "RCCATALINA == $RCCATALINA"
if ( ! $?REDMINE ) setenv REDMINE redmine-${redmine} ; echo "REDMINE == $REDMINE"
if ( ! $?REDMINE_LANG ) setenv REDMINE_LANG 'en' ; echo "REDMINE_LANG == $REDMINE_LANG"
if ( ! $?REDMINEREL ) setenv REDMINEREL $redmine ; echo "REDMINEREL == $REDMINEREL"
if ( ! $?REDMJNE ) setenv REDMJNE redmjne${release} ; echo "REDMJNE == $REDMJNE"
if ( ! $?REDMJNE_HOME )setenv REDMJNE_HOME ${WWW_HOME}/redmjne ; echo "REDMJNE_HOME == $REDMJNE_HOME"
if ( ! $?SCM_HOME ) setenv SCM_HOME ${HOME}/scm ; echo "SCM_HOME == $SCM_HOME"
if ( ! $?SCM_OPTS ) setenv SCM_OPTS "-Dscm.home=$SCM_HOME" ; echo "SCM_OPTS == $SCM_OPTS"
if ( ! $?SOLR_HOME ) setenv SOLR_HOME ${HOME}/solr ; echo "SOLR_HOME == $SOLR_HOME"
#if ( ! $?SOLR_DATA ) setenv SOLR_DATA ${SOLR_HOME}/data ; echo "SOLR_DATA ==  $SOLR_DATA"
#if ( ! $?SOLR_OPTS ) setenv SOLR_OPTS "-Dsolr.data.dir=$SOLR_HOME/data -Dsolr.solr.home=$SOLR_HOME" ; echo "SOLR_OPTS == $SOLR_OPTS"
if ( ! $?SOLR_OPTS ) setenv SOLR_OPTS "-Dsolr.solr.home=$SOLR_HOME" ; echo "SOLR_OPTS == $SOLR_OPTS"
if ( ! $?TOMCATREL ) setenv TOMCATREL ${tomcat} ; echo "TOMCATREL == $TOMCATREL"
if ( ! $?TOMCAT ) setenv TOMCAT apache-tomcat-${TOMCATREL} ; echo "TOMCAT == $TOMCAT"
if ( ! $?TOMCAT_HOME ) setenv TOMCAT_HOME ${WWW_HOME}/${TOMCAT} ; echo "TOMCAT_HOME == $TOMCAT_HOME"
#
# ensure JAVA_OPTS includes any/all items defined above:
if ( ! $?JAVA_OPTS ) setenv JAVA_OPTS "$JENKINS_OPTS $HUDSON_OPTS $SCM_OPTS $SOLR_OPTS $JXX_OPTS -server -Djava.awt.headless=true"
#setenv JAVA_OPTS '-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -server -Djava.awt.headless=true'
echo
echo "JAVA_OPTS == $JAVA_OPTS"
#
echo
echo 'default tomcat port 8080 is poduction backend (other option is release cadidate "rc" port 8090)'
echo 'establish release via redmine, jruby and java versions (and maybe tomcat version)'
echo
echo 'note the assumption is ~/{scm,solr,wwww} are sym-links to ~/monthYear/{scm,solr,www}'
echo 'the numo.csh script may be used to initialize a new ~/monthYear and the above sym-links'
echo '--- Tomcat Catalina WebApp Environment (RedmJne, SCM-Manager, Hudson/Jenkins, Solr, Apollo ActiveMQ, public_html ...) ---'
echo
