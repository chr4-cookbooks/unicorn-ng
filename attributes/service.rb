#
# Cookbook Name:: unicorn-ng
# Attributes:: service
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

default['unicorn-ng']['service']['rails_root'] = nil

# the following attributes will be set automatically
# relative to rails_root if not specified
default['unicorn-ng']['service']['unicorn_config'] = nil
default['unicorn-ng']['service']['bundle_gemfile'] = nil
default['unicorn-ng']['service']['pidfile'] = nil

default['unicorn-ng']['service']['wrapper'] = nil
default['unicorn-ng']['service']['wrapper_opts'] = ''
default['unicorn-ng']['service']['bundle'] = '/usr/local/bin/bundle'
default['unicorn-ng']['service']['environment'] = 'development'
default['unicorn-ng']['service']['locale'] = 'en_US.UTF-8'
default['unicorn-ng']['service']['user'] = 'root' # CHANGE ME!
default['unicorn-ng']['service']['gem_home'] = nil

default['unicorn-ng']['service']['owner'] = 'root'
default['unicorn-ng']['service']['group'] = 'root'
default['unicorn-ng']['service']['mode'] = 00755
default['unicorn-ng']['service']['cookbook'] = 'unicorn-ng'
default['unicorn-ng']['service']['source'] = 'unicorn.init.erb'
default['unicorn-ng']['service']['variables'] = {}
default['unicorn-ng']['service']['name'] = 'unicorn'
