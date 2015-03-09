redmjne deployment war
======================
redmjne2.6.2_jruby1.7.19_jvm8.war
JRuby Redmine deployment war for Redmine 2.6.2 using Jruby 1.7.19 tested with Java 8 via Tomcat 7

This is the most recent (March 2015) build. The Feb. 2015 release of Redmine 3.0.0 
indicated Active Record issues in JRuby, consequently this is the Feb. 2015 
release 2.6.2, with the plugins listed below. The most recent release of redmine-wiki_graphviz_plugin
is lacking due to its github readme assertion that it now only supports 3.0.0 (I tried
it with 2.6.2 and indeed it complained and refused to function!). See
https://github.com/tckz/redmine-wiki_graphviz_plugin

This war is "virgin" with no content and unitialized/configured plugins (only the
admin user with default password "admin").

Plugins
Agile dwarf plugin Agile for Redmine
http://www.agiledwarf.com
Mark Ablovacky 	0.0.3

Redmine Banner plugin Plugin to show site-wide message, such as maintenacne informations or notifications. https://github.com/akiko-pusu/redmine_banner
Akiko Takano 	0.1.1

Knowledgebase A plugin for Redmine that adds knowledgebase functionality https://github.com/alexbevi/redmine_knowledgebase
Alex Bevilacqua 	3.0.7

Redmine LaTeX MathJax Employ MathJax in all settings: wiki, issues, or every page.
https://github.com/process91/redmine_latex_mathjax
Michael Boratko 	0.1.0 	

Redmine Startpage plugin This is a plugin for Redmine. It allows the user to select almost any redmine sub page as start page for a Redmine website
https://github.com/txinto/redmine_startpage
Txinto Vaz 	0.1.0

Redmine Wiki Books plugin This is a plugin for Redmine that allows the user to read books written in wiki pages http://gatatac.org/projects/redmine-wikibooks/wiki 
Txinto Vaz 	0.0.3
