#!/bin/csh -f
set cwd = `pwd`
set build = ${cwd}/build
set release = '2.4.2_1.7.10_1.7'
set host = $HOST:r
if ( $host == 'honsys' ) setenv JAVA_HOME /usr/java/latest
echo "configuring RedmJne release $release -- Redmine_JRuby_Java release versions ..."
echo "workspace directory -- ${build}"
echo "runtime should also use latest stable apache tomcat."
echo '----------------- RedmJne Environment ------------------'
if ( ! $?GEMFILE ) setenv GEMFILE Gemfile${release} ; echo "GEMFILE = $GEMFILE"
if ( ! $?JAVAREL ) setenv JAVAREL 1.7 ; echo "JAVAREL = $JAVAREL"
if ( ! $?JRUBYRE ) setenv JRUBYREL 1.7.10 ; echo "JRUBYREL = $JRUBYREL"
if ( ! $?REDMINEREL ) setenv REDMINEREL 2.4.2 ; echo "REDMINEREL = $REDMINEREL"
#if ( ! $?TOMCATREL ) setenv TOMCATREL 7.0.50 ; echo "TOMCATREL = $TOMCATREL"
if ( ! $?TOMCATREL ) setenv TOMCATREL 8.0.1 ; echo "TOMCATREL = $TOMCATREL"
if ( ! $?ASSETS ) setenv ASSETS $cwd/assets ; echo "ASSETS = $ASSETS"
if ( ! $?JAVA_HOME ) setenv JAVA_HOME $cwd/openjdk ; echo "JAVA_HOME = $JAVA_HOME "
if ( ! $?JRUBY ) setenv JRUBY jruby-bin-${JRUBYREL} ; echo "JRUBY = $JRUBY"
if ( ! $?JRUBY_HOME ) setenv JRUBY_HOME $cwd/build/jruby ; echo "JRUBY_HOME = $JRUBY_HOME"
if ( ! $?JRUBY_OPTS ) setenv JRUBY_OPTS '-Xcext.enabled=true' ; echo "JRUBY_OPTS = $JRUBY_OPTS"
if ( ! $?RAILS_ENV ) setenv RAILS_ENV production ; echo "RAILS_ENV = $RAILS_ENV"
if ( ! $?REDMINE ) setenv REDMINE redmine-${REDMINEREL} ; echo "REDMINE = $REDMINE" 
if ( ! $?REDMINE_LANG ) setenv REDMINE_LANG 'en' ; echo "REDMINE_LANG = $REDMINE_LANG"
if ( ! $?REDMJNE ) setenv REDMJNE redmjne${release} ; echo "REDMJNE = $REDMJNE"
if ( ! $?TOMCAT ) setenv TOMCAT apache-tomcat-${TOMCATREL} ; echo "TOMCAT = $TOMCAT"
echo '----------------- RedmJne Environment ------------------'

