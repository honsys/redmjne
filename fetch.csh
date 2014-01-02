#/bin/csh
#
# fetch latest releases via download or github clone. 
# note: downloading the latest jdk release from oracle/sun requires accepting
# their licensing agreement (via a button click on the download page).
# consider openjdk:
# http://www.java.net/download/openjdk/jdk7u40/promoted/b43/openjdk-7u40-fcs-src-b43-26_aug_2013.zip
# or alex kasko's unofficial builds:
# https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads
#
# dec 2013 releases:
setenv JAVAREL 1.7
setenv JRUBYREL 1.7.9
setenv JRUBY jruby-bin-${JRUBYREL}
setenv TOMCATREL 7.0.47
setenv TOMCAT apache-tomcat-${TOMCATREL}
setenv REDMINEREL 2.4.1
setenv REDMINE redmine-${REDMINEREL}
set cwd = `pwd`
if ( $cwd:t != 'build' ) then
  mkdir ./build >& /dev/null
  pushd ./build
  set cwd = `pwd`
endif
setenv JRUBY_HOME $cwd/jruby
#
# optionally fetch latest java:
if ( ! -e $JAVA_HOME ) then
  setenv JAVA_HOME $cwd/openjdk
  set unofficial_jdk = openjdk-${JAVAREL}.0-u40-unofficial-linux-amd64-image
  set openjdk = openjdk${JAVAREL}
  rm -rf openjdk* >& /dev/null
  wget -O {$openjdk}.zip https://bitbucket.org/alexkasko/openjdk-unofficial-builds/downloads/{$unofficial_jdk}.zip
  unzip {$openjdk}.zip
  if ( $? != 0 ) then
    echo aborting due to lack of $JAVA_HOME
    exit
  endif
  ln -s $openjdk unofficial_jdk
  ln -s $openjdk openjdk
  ln -s $openjdk java
endif
#
ln -s /usr/local/apache-tomcat-7.0.47 >& /dev/null
#
#optionally fecth latest apache tomcat:
if ( ! -e $TOMCAT ) then
  tar xzvf /downld/{$TOMCAT}.tar.gz
  if ( $? != 0 ) then
    echo need $TOMCAT or newer installed here -- $cwd 
    exit
  endif
  ln -s $TOMCAT catalina
endif
#
if ( ! -e ${JRUBY} ) then
  rm -rf jruby* # if older release and/or build artifacts are present
  wget -O ${JRUBY}.tar.gz http://jruby.org.s3.amazonaws.com/downloads/${JRUBYREL}/${JRUBY}.tar.gz
  tar xzvf ${JRUBY}.tar.gz
  if ( $? != 0 ) then
    echo aborting due to lack of $JRUBY
    exit
  endif
endif
ln -s jruby-${JRUBYREL} jruby >& /dev/null
#
# get latest redmine and may need to edit its Gemfile:
if ( ! -e $REDMINE ) then
  rm -rf redmine* # if older release and/or build artifacts are present
  wget -O ${REDMINE}.tar.gz http://www.redmine.org/releases/${REDMINE}.tar.gz
  tar zxvf ${REDMINE}.tar.gz
  if ( $? != 0 ) then
    echo aborting due to lack of $REDMINE
    exit
  endif
endif
#
if ( ! -e warbler ) then
  # get latest warbler and may need to edit its Gemfile:
  git clone https://github.com/jruby/warbler.git
endif
popd
which java ; java -version
$JRUBY_HOME/bin/jruby -v
ls -al ./build

