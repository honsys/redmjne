#!/bin/csh
# feb 2014 releases
set gitc = 'git clone'
set cwd = `pwd`
if ( ${cwd:h:t} != "build" ) then
  echo "please make sure the current working directory is under 'build' area"
  exit
endif 
set envset = '../../env.csh' 
if ( ! -e ${envset} ) then
  echo "please make sure the current working directory can access ${envset} ..."
  exit
endif
source ${envset} $argv
#
# assumes fetch.csh has populated the plugins subdir
set plugs = "redmine_banner redmine_blogs redmine_knowledgebase redmine_wiki_books redmine_startpage redmine_latex_mathjax redmine-wiki_graphviz_plugin"
#
echo war.csh has initialized a default empty database, now supplement it with plugins db schema...
#
# this ref. https://wiki.blue-it.org/Redmine
# suggests the rake target will migrate all plugins found under the plugin directory: 
#
if ( ! -e ./plugins ) mkdir ./plugins 
foreach p ($plugs)
  echo ${p}
  pushd ./plugins # fetch each plugin
# ln -s ../../plugins/$p  >& /dev/null
  cp -a ../../plugins/$p .
  popd
  $JRUBY_HOME/bin/rake redmine:plugins NAME=${p} RAILS_ENV=production
end
#$JRUBY_HOME/bin/rake redmine:plugins:migrate RAILS_ENV=production
