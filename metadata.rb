name             'unicorn-ng'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GNU Public License 3.0'
description      'Installs/Configures unicorn'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

recipe           'unicorn-ng', 'Configures unicorn.rb and sets up a service according to attributes'
recipe           'unicorn-ng::install', 'Installs bundler and unicorn using rubygems'

supports         'ubuntu', '>= 12.04'
supports         'debian', '>= 6.0'
