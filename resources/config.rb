#
# Cookbook Name:: unicorn-ng
# Resource:: config
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

actions        :create
default_action :create

attribute :path,              kind_of: String,  name_attribute: true
attribute :worker_processes,  kind_of: Integer, default: node['unicorn-ng']['config']['worker_processes']
attribute :user,              kind_of: String,  default: node['unicorn-ng']['config']['user']
attribute :working_directory, kind_of: String,  default: node['unicorn-ng']['config']['working_directory']
attribute :listen,            kind_of: String,  default: node['unicorn-ng']['config']['listen']
attribute :backlog,           kind_of: Integer, default: node['unicorn-ng']['config']['backlog']
attribute :pid,               kind_of: String,  default: node['unicorn-ng']['config']['pid']
attribute :timeout,           kind_of: Integer, default: node['unicorn-ng']['config']['timeout']
attribute :stderr_path,       kind_of: String,  default: node['unicorn-ng']['config']['stderr_path']
attribute :stdout_path,       kind_of: String,  default: node['unicorn-ng']['config']['stdout_path']
attribute :before_fork,       kind_of: String,  default: node['unicorn-ng']['config']['before_fork']
attribute :after_fork,        kind_of: String,  default: node['unicorn-ng']['config']['after_fork']
attribute :preload_app,       kind_of: [TrueClass, FalseClass], default: node['unicorn-ng']['config']['preload_app']

attribute :owner,             kind_of: String,  default: node['unicorn-ng']['config']['owner']
attribute :group,             kind_of: String,  default: node['unicorn-ng']['config']['group']
attribute :mode,              kind_of: String,  default: node['unicorn-ng']['config']['mode']
attribute :cookbook,          kind_of: String,  default: node['unicorn-ng']['config']['cookbook']
attribute :source,            kind_of: String,  default: node['unicorn-ng']['config']['source']
attribute :variables,         kind_of: Hash,    default: node['unicorn-ng']['config']['variables']
