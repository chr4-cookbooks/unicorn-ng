# CHANGELOG for unicorn-ng

This file is used to list changes made in each version of unicorn.

## 0.3.0:

* Support `node['unicorn-ng']['service']['name']` attribute, to allow multiple instances
* Remove `node['unicorn-ng']['service']['path']` in favor of name
* Add rubocup and foodcritic checks via Travis

## 0.2.1:

* Make initscript independent from users login shell.

  This fixes a bug happening when starting the initscript with a chruby wrapper on a non-bash shell

## 0.2.0:

* Support wrapper and wrapper\_opts

  This makes the use of chruby-exec and other wrappers possible.

## 0.1.1:

* Use pidfile variable in unicorn.rb

  This fixes a bug with unicorn restart when using config provider with custom pid attribute

## 0.1.0:

* Initial release of unicorn-ng
