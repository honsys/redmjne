#!/bin/csh
# refs:
# joe kutner -- "deploying with jruby" pragmatic programmers facets of ruby series
# http://saltnlight5.blogspot.com/2012/08/how-to-generate-redmine-war-application.html
# http://thenice.tumblr.com/post/133345213/deploying-a-rails-application-in-tomcat-with-jruby-a
# http://jabox.tumblr.com/post/18973862661/how-to-get-redmine-1-3-1-running-in-2-minutes
#
# work with the latest releases (redmine, jruby, tomcat):
set opt = env
set cwd = `pwd`
setenv JRUBYREL 1.7.9
setenv JRUBY jruby-bin-${JRUBYREL}
setenv REDMINEREL 2.4.1
setenv REDMINE redmine-${REDMINEREL}
setenv REDMINE_LANG 'en'
setenv REDMJNE redmjne${REDMINEREL}
setenv RAILS_ENV production
# presumably a sym-link to the latest (>= 1.7.9)
#setenv JRUBY_HOME /usr/local/jruby
setenv JRUBY_HOME $cwd/build/jruby
setenv JRUBY_OPTS '-Xcext.enabled=true'
setenv ASSETS $cwd/assets
if ( $1 != "" ) set opt = "$1"
echo "REDMINE == $REDMINE"
echo "REDMJNE == $REDMJNE"
echo "JRUBY_HOME == $JRUBY_HOME"
ls -al $JRUBY_HOME
find $ASSETS -type d | egrep -v '\.svn|\.git|\.\.'
if ( "$opt" == "env" ) exit
#
# do all work in ,./build sub-dir:
# fetch apache-tomcat, jruby, and redmine dependencies
if ( "$opt" == "all" ) source ./fetch.csh # can be runstand-alone, so it also pushd and popd to/from ./build
#
# note minor hand edits of Gemfiles for version deps. may be needed too:
if ( "$opt" == "all" ) source ./gems.csh # can be run stand-alone, so it also pushd and popd to/from ./build
#
# dependency gems from merged redmine and warberl Gemfiles ...
if ( $cwd:t != 'build' ) then
  mkdir ./build >& /dev/null
  pushd ./build
endif
#
if ( ! -e ./${REDMINE} ) then
  echo "need ./${REDMINE} initialized -- untar/unzip -- before proceeding, abort ..."
  exit
endif
pushd ./${REDMINE} # untar'd binary distrib.
#
# init sqlite db conf:
set db = ./config/database.yml
if ( -e $db ) then
  rm $db
endif
touch $db
cat << ENDHERE >> $db
production:
  adapter: jdbcsqlite3
  database: db/redmine.sqlite3
  host: localhost
  username: redmine
  password: redmine
  encoding: utf8

development:
  adapter: jdbcsqlite3
  database: db/redmine_dev.sqlite3
  host: localhost
  username: redmine
  password: redmine
  encoding: utf8

test:
  adapter: jdbcsqlite3
  database: db/redmine_test.sqlite3
  host: localhost
  username: redmine
  password: redmine
  encoding: utf8
ENDHERE
#
# run wabler to init warble.conf:
set wb = ./config/warble.rb
if ( -e $wb ) then
  rm $wb
endif
$JRUBY_HOME/bin/jruby -S warble config
#
# edit newly initialized config/warble.rb -- insert 3 lines at the start of the do loop:
#Warbler::Config.new do |config|
#  config.dirs = %w(app config db extra files lang lib log plugins vendor tmp)
#  config.gems += ["activerecord-jdbcsqlite3-adapter", "jruby-openssl", "i18n", "rack", "tree"]
#  config.webxml.rails.env = ENV['RAILS_ENV'] || 'production'
#end
mv $wb ./config/.warble.rb
set wl = `wc -l ./config/.warble.rb | cut -d' ' -f1`
set hd = `grep -n '\# \- compiled\:' ./config/.warble.rb | cut -d':' -f1`
@ tl = $wl - $hd
head -{$hd} ./config/.warble.rb > $wb
# application directories and gems required in the webapp:
cat << ENDHERE >> $wb
  config.dirs = %w(app config db extra files lang lib log plugins public/plugin_assets vendor tmp)
  config.gems += ["activerecord-jdbcsqlite3-adapter", "jruby-openssl", "i18n", "rack", "tree"]
  config.webxml.rails.env = ENV['RAILS_ENV'] || 'production'
ENDHERE
tail -{$tl} ./config/.warble.rb >> $wb
#
# init the db:
$JRUBY_HOME/bin/rake db:migrate
$JRUBY_HOME/bin/rake redmine:load_default_data
$JRUBY_HOME/bin/rake generate_secret_token
#
# evidently redmine 2.4.2 need another secret token?
# got this error (other folks get this too -- randomly on first ajax request):
# ArgumentError (A secret is required to generate an integrity hash for cookie session data.
# Use config.secret_token = "some secret phrase of at least 30 characters"in config/initializers/secret_token.rb):
# actionpack (3.2.16) lib/action_dispatch/middleware/cookies.rb:322:in `ensure_secret_secure'
#
#echo 'config.secret_token = "0123456789.0123456789.0123456789"' > ./config/initializers/secret_token.rb
sed 's/#secret_token/secret_token/g' < ./config/configuration.yml.example | sed 's/change it to a long random string/0123456789012345678901234567890123456789/g' > ./config/configuration.yml
#
# plugins
rsync -lav --exclude='.svn' --exclude='.git' ../../../github/redmine/redmine_banner plugins 
#$JRUBY_HOME/bin/jruby -S bundle exec redmine:plugins NAME=redmine_banner RAILS_ENV=production
$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_banner RAILS_ENV=production
rsync -lav --exclude='.svn' --exclude='.git' ../../../github/redmine/redmine_knowledgebase plugins
$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_knowledgebase RAILS_ENV=production
rsync -lav --exclude='.svn' --exclude='.git' ../../../github/redmine/redmine_wiki_books plugins
$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_wiki_books RAILS_ENV=production
rsync -lav --exclude='.svn' --exclude='.git' ../../../github/redmine/redmine_startpage plugins
$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_startpage RAILS_ENV=production
rsync -lav --exclude='.svn' --exclude='.git' ../../../github/redmine/redmine_latex_mathjax plugins
$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_latex_mathjax RAILS_ENV=production
#$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_crm RAILS_ENV=production
#$JRUBY_HOME/bin/rake redmine:plugins NAME=redmine_cms RAILS_ENV=production
#
# finally, create the war file:
#
$JRUBY_HOME/bin/jruby -S warble
popd # no longer in ./build/{$REDMINE}
echo hopefully a fresh warfile is now ready to deploy...
ls -al {$REDMINE}/{$REDMINE}.war
if ( $? != 0 ) then
  echo need {$REDMINE}/{$REDMINE}.war to proceed -- $cwd
  exit
endif
# copy vanilla war file here for unzipping
cp -p {$REDMINE}/{$REDMINE}.war ./
# unzip it and add any other items of interest -- db content, files, www assets
# and custimizations then re-zip as redmjne.war
if ( -e war ) rm -f war
mkdir war
pushd war
unzip ../{$REDMINE}.war
#if ( -e {$ASSETS}/web-inf/db ) then
#  mv WEB-INF/db WEB-INF/.db
#  rsync -lav --exclude='.svn' --exclude='.git' {$ASSETS}/web-inf/db WEB-INF
#endif
#if ( -e {$ASSETS}/images ) rsync -lav --exclude='.svn' --exclude='.git' {$ASSETS}/images ./
#if ( -e {$ASSETS}/web-inf ) rsync -lav --exclude='.svn' --exclude='.git' {$ASSETS}/web-inf/app WEB-INF
#if ( -e {$ASSETS}/web-inf/files ) rsync -lav --exclude='.svn' --exclude='.git' {$ASSETS}/web-inf/files WEB-INF
zip -r ../{$REDMJNE}.war .
popd
ls -al {$REDMJNE}.war {$REDMINE}.war

