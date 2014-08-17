#!/bin/csh
# feb 2014 releases
set jdat = `date "+%Y_%j_%H_%M"` # "_%S"
set cwd = `pwd`
if ( ${cwd:t} != "war" ) pushd ./build/war
if ( ! -e ./WEB-INF ) then
  echo "please make sure the current working directory provides ./WEB-INF ..."
  exit
endif
set envset = '../../env.csh'
if ( ! -e ${envset} ) then
  echo "please make sure the current working directory can invoke ${envset} ..."
  exit
endif
source ${envset} $argv >& /dev/null
#
# current assets in CM or production:
# set assets = ./assets
# set db {$assets}/web-inf/db
# set files = {$assets}/web-inf/files
set rcassets = ~/www//catalina88/domains/rc.redmjne.org/ROOT
set assets = ~/www/catalina80/domains/redmjne.org/ROOT
set db = {$assets}/WEB-INF/db
set app = {$assets}/WEB-INF/app
set files = {$assets}/WEB-INF/files
set imgs = {$assets}/images
set logo = ${assets}/images/redmjne_logo.png # production logo
set rclogo = ${assets}/images/rcredmjne_logo.png # release candidate logo
#
set filecnt = `ls -l ${files}/* | wc -l`
echo if filcnt ${filecnt} is greater than 1 ...
ls -al $files $db $rcdb $logo $rclogo
if ( -e $db ) then
  mv ./WEB-INF/db ./WEB-INF/views/layouts/${jdat}db
  rsync -lav --exclude='.svn' --exclude='.git' $db ./WEB-INF
else
  echo no db found -- $db
endif
if ( -e $imgs ) then
  rsync -lav --exclude='.svn' --exclude='.git' $imgs ./
else
  echo no images found -- $imgs
endif
if ( -e $app ) then
  mv ./WEB-INF/views/layouts/base.html.erb ./WEB-INF/views/layouts/${jdat}base.html.erb
# rsync -lav --exclude='.svn' --exclude='.git' $app ./WEB-INF
  sed 's/redmjne_logo/rcredmjne_logo/g' < $app/views/layouts/base.html.erb > ./WEB-INF/views/layouts/base.html.erb
else
  echo no app items found -- $app
endif
if ( -e $files && $filecnt > 1 ) then
  rsync -lav --exclude='.svn' --exclude='.git' $files ./WEB-INF
else
  echo no files found -- $files
endif
# stay in ./build/war
# popd
