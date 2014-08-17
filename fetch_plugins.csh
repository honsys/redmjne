#/bin/csh
#
# fetch latest iredmine plugin releases via github clone. 
#
# march 2014 releases:
set cwd = `pwd`
set gitc = 'git clone'
set envset = './env.csh' 
if ( ! -e ${envset} ) then
  echo "please make sure the current working directory includes ${envset} ..."
  exit
endif
source ${envset} $argv
if ( $cwd:t != 'build' ) then
  # make sure there is a ./build and ./build/plugins subdir:
  mkdir -p ./build/plugins >& /dev/null
  pushd ./build/plugins
  set cwd = `pwd`
endif
#
set plugs = "AgileDwarf redmine_banner redmine_knowledgebase redmine_wiki_books redmine_startpage redmine_latex_mathjax redmine-wiki_graphviz_plugin"
#set plugs = "redmine_banner redmine_knowledgebase redmine_wiki_books redmine_startpage redmine_latex_mathjax redmine-wiki_graphviz_plugin"
set url = https://github.com/iRessources/AgileDwarf
$gitc $url
#
set url = https://github.com/akiko-pusu/redmine_banner.git
$gitc $url
#
#set url = https://github.com/ichizok/redmine_blogs.git
#$gitc $url
#
set url = https://github.com/alexbevi/redmine_knowledgebase.git
$gitc $url
#
set url = https://github.com/process91/redmine_latex_mathjax.git
$gitc $url
#
set url = https://github.com/txinto/redmine_startpage.git
$gitc $url
#
set url = https://github.com/txinto/redmine_wiki_books.git
$gitc $url
#
set url = https://github.com/tckz/redmine-wiki_graphviz_plugin.git
$gitc $url
#
popd # back to build
#
echo 'fetched all required jruby-redmine (redmjne) components and plugins:'
echo $plugs
#
popd # out of plugins subdir
ls -al ./build ./build/plugins
