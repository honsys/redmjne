#!/bin/csh
# feb 2014 releases
set cwd = `pwd`
set envset = './env.csh' 
if ( ! -e ${envset} ) then
  echo "please make sure the current working directory includes ${envset} ..."
  exit
endif
source ${envset} $argv
#
if ( $cwd:t != 'build' ) then
  mkdir ./build >& /dev/null
  pushd ./build
endif
#
if ( ! -e ./${REDMINE} ) then
  echo "need ./${REDMINE} initialized -- untar/unzip -- before proceeding, abort ..."
  exit
endif
pushd ./${REDMINE} # untar'd binary distrib. with or without custom assets (themes, files, images, etc.)
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
# evidently redmine 2.4.x needs another secret token?
# got this error (other folks get this too -- randomly on first ajax request):
# ArgumentError (A secret is required to generate an integrity hash for cookie session data.
# Use config.secret_token = "some secret phrase of at least 30 characters"in config/initializers/secret_token.rb):
# actionpack (3.2.16) lib/action_dispatch/middleware/cookies.rb:322:in `ensure_secret_secure'
#
#echo 'config.secret_token = "0123456789.0123456789.0123456789"' > ./config/initializers/secret_token.rb
sed 's/#secret_token/secret_token/g' < ./config/configuration.yml.example | sed 's/change it to a long random string/0123456789012345678901234567890123456789/g' > ./config/configuration.yml
#
# plugins (TBD: change to direct git clone of each plugin)
if ( "$opt" == "new" ) then
  source ../../plugins.csh $argv
endif
#
# finally, create the war file:
#
$JRUBY_HOME/bin/jruby -S warble
popd # no longer in build/{$REDMINE}
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
if ( -e war ) mv war .war
mkdir war
pushd war
unzip ../{$REDMINE}.war
if ( "$opt" != "new" ) then
  echo 'migrate prior release (production) assets & DB to this release ...'
  if ( ! -e ../../assets.csh ) then
    echo "$opt indicates assets should be included, but cannot find assets.csh script..."
  else # assets.csh should not pop out of build/war sub-dir.
    source ../../assets.csh $argv
  endif
endif
zip -r ../{$REDMJNE}.war .
popd # no longer in redmjne/build/war
popd # return to redmjne
