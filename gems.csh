#/bin/csh
# 
# note this script assumes a jdk has already been installed
# downloading the latest jdk release from oracle/sun requires
# accepting their licensing agreement (via a button click on 
# the download page).
#
# feb 2014 releases:
set cwd = `pwd`
set envset = './env.csh' 
if ( ! -e ${envset} ) then
  echo "please make sure the current working directory includes ${envset} ..."
  exit
endif
source ${envset}
#
if ( $cwd:t != 'build' ) then
  mkdir ./build >& /dev/null
  pushd ./build
  set cwd = `pwd`
endif
setenv JRUBY_HOME $cwd/jruby
# rm Gemfile and Gemfile.lock
rm Gemfile Gemfile.lock >& /dev/null
set gemfile = Gemfile${JRUBYREL}_${REDMINEREL}
echo source \'https://rubygems.org\' > $gemfile
grep 'gem ' ./warbler/Gemfile > ./.Gemfile
grep 'gem ' $REDMINE/Gemfile >> ./.Gemfile
#echo 'gem "activesupport", "3.2.16"' >> ./.Gemfile
# some potentially useful gems:
echo 'gem "css2less"' >> ./.Gemfile
echo 'gem "execjs"' >> ./.Gemfile
echo 'gem "pandoc-ruby"' >> ./.Gemfile
#echo 'gem "rubyzip", "0.9.9"' >> ./.Gemfile
# 
# the following are backlog gem deps: 
echo 'gem "holidays", "~>1.0.3"' >> ./.Gemfile
echo 'gem "icalendar"' >> ./.Gemfile
echo 'gem "json"' >> ./.Gemfile
echo 'gem "liquid"' >> ./.Gemfile
#echo 'gem "nokogiri", "< 1.6.0"' >> ./.Gemfile
echo 'gem "open-uri-cached"' >> ./.Gemfile
echo 'gem "prawn"' >> ./.Gemfile
#
# plugins need this:
echo 'gem "multi_json", "=1.8.4"' >> ./.Gemfile
echo 'gem "redmine_acts_as_taggable_on"' >> ./.Gemfile
echo 'gem "ya2yaml"' >> ./.Gemfile
#
# try radiant cms?
#echo 'gem "radiant"' >> ./.Gemfile
#
# only want sqlite and evidently rmagick does not yet work in jruby
# also eliminate all leading whitespaces via sed
sort -u < ./.Gemfile | egrep -iv 'mysql|postgresql|rmagick' | grep -v '\#' | sed -e 's/^[ \t]*//' | sed -e 's/\,*\:*//' >> $gemfile
ln -s $gemfile Gemfile
if ( "$1" == "gemfile" ) then
  echo check new Gemfile.
  exit
endif
# need rake for all bundler installs ... 
# Gemfile should include rake and any other warbler deps
# bundler installs most deps. but war is smaller with just production configs.
#$JRUBY_HOME/bin/jruby -S gem install rake
echo install bundler using merged warbler and $REDMINE Gemfiles and run it...
$JRUBY_HOME/bin/jruby -S gem install bundler
$JRUBY_HOME/bin/jruby -S bundle install
echo done bundler install using merged warbler and $REDMINE Gemfiles. next, install warbler.
echo on some occasions the warbler install complains about something on the first try.
echo perhaps due to a network glitch ... but seems ok on a subsequent attempt...
$JRUBY_HOME/bin/jruby -S gem install warbler
echo done warbler install
popd
