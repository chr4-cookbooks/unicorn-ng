#
# Cookbook Name:: unicorn-ng
# Recipe:: default
#
# Copyright 2013, Chris Aumann
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

unicorn_ng_config 'default' do
  path      node['unicorn-ng']['config']['config_file']
  only_if { node['unicorn-ng']['config']['config_file'] }
end

unicorn_ng_service 'default' do
  rails_root node['unicorn-ng']['service']['rails_root']
  only_if  { node['unicorn-ng']['service']['rails_root'] }
end
