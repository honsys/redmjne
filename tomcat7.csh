#!/bin/csh -f
# while much of the apache-tomcat/config content
# is portable, each host must have its own unige keystore file.
# generated via:
# $JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA -keystore ./.keystore
#
# also be sure to double-check these env items for properly set sym-links!
# and this version version is currently only runnable from the specific www directory
#
set cwd = `pwd` ; echo $cwd
#set www = $cwd:t:r # ; echo $www ala $cwd
#if ( "$www" != "www" ) then
echo $cwd | grep 'www'
if ( $? != 0 ) then
  echo this should be a www directory name, not $cwd
  exit
endif
if ( -e env.csh ) then
  source env.csh clear
else
  echo need env.csh ...
  exit
endif
set opt = "start" # or stop or restart
if ( "$1" != "" ) set opt = "$1"
#
pkill tail >& /dev/null
echo "------------------------- $0 $opt -------------------------"
if ( "$opt" == "stop" ) then
  echo shutting down tomcat runtimes \(production only -- not release candidate\) and PRESERVING all logs 
  env CATALINA_BASE=${CATALINA} ${CATALINA}/bin/shutdown.sh >& /dev/null
  env CATALINA_BASE=${IRCATALINA} ${IRCATALINA}/bin/shutdown.sh >& /dev/null
# env CATALINA_BASE=${RCCATALINA} ${RCCATALINA}/bin/shutdown.sh >& /dev/null
# pkill java
  exit
endif
if ( "$opt" != "start" && "$opt" != "restart" ) then
  echo unsupported option -- did you mean '"tomcat7.csh [stop or [re]start]"?'
  exit
endif
if ( "$opt" == "start" ) then
  echo REMOVING all logs and start tomcat runtimes \(production only -- not release candidate\)
  env CATALINA_BASE=${CATALINA} ${CATALINA}/bin/shutdown.sh >& /dev/null
  env CATALINA_BASE=${IRCATALINA} ${IRCATALINA}/bin/shutdown.sh >& /dev/null
# env CATALINA_BASE=${RCCATALINA} ${RCCATALINA}/bin/shutdown.sh >& /dev/null
  \mkdir -p ${CATALINA}/logs ${IRCATALINA}/logs # ${RCCATALINA}/logs >& /dev/null
  \rm -rf ${RCCATALINA}/logs/* ${IRCATALINA}/logs/* # ${RCCATALINA}/logs/* >& /dev/null
else # restart indicated ...
  echo restarting tomcat runtime and PRESERVING all logs 
endif
env CATALINA_BASE=${CATALINA} ${CATALINA}/bin/shutdown.sh >& /dev/null
env CATALINA_BASE=${IRCATALINA} ${IRCATALINA}/bin/shutdown.sh >& /dev/null
#env CATALINA_BASE=${RCCATALINA} ${RCCATALINA}/bin/shutdown.sh >& /dev/null
#pkill java
\mv logs/solr.log logs/${jdat}solr.log >& /dev/null
\mv ${CATALINA}/logs/catalina.out ${CATALINA}/logs/${jdat}catalina.out >& /dev/null
env CATALINA_BASE=${CATALINA} ${CATALINA}/bin/startup.sh >& /dev/null
set started = `grep -n 'INFO: Server startup' $CATALINA/logs/catalina.out`
\mv ${IRCATALINA}/logs/catalina.out ${IRCATALINA}/logs/${jdat}catalina.out >& /dev/null
env CATALINA_BASE=${IRCATALINA} ${IRCATALINA}/bin/startup.sh >& /dev/null
set irstarted = `grep -n 'INFO: Server startup' $IRCATALINA/logs/catalina.out`
#\mv ${RCCATALINA}/logs/catalina.out ${RCCATALINA}/logs/${jdat}catalina.out >& /dev/null
#env CATALINA_BASE=${RCCATALINA} ${RCCATALINA}/bin/startup.sh >& /dev/null
#set rcstarted = `grep -n 'INFO: Server startup' $RCCATALINA/logs/catalina.out`
#while ( "$started" == "" && "$irstarted" == "" && "$rcstarted" == "" )
while ( "$started" == "" && "$irstarted" == "" )
  echo ... sleeping until all tomcat catalina logs indicate successful startup ...
  sleep 5
  set started = `grep -n 'INFO: Server startup' $CATALINA/logs/catalina.out`
  set irstarted = `grep -n 'INFO: Server startup' $IRCATALINA/logs/catalina.out`
# set rcstarted = `grep -n 'INFO: Server startup' $RCCATALINA/logs/catalina.out`
end
echo "$started and $irstarted" 
echo ok all tomcat catalinas up ... start haproxy ...

