#
# Cookbook Name:: unicorn-ng
# Provider:: config
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

use_inline_resources
action :create do
  template new_resource.path do
    owner     new_resource.owner
    group     new_resource.group
    mode      new_resource.mode
    cookbook  new_resource.cookbook
    source    new_resource.source

    if new_resource.variables.empty?
      variables prescript: new_resource.prescript,
                worker_processes: new_resource.worker_processes,
                user: new_resource.user,
                working_directory: new_resource.working_directory,
                listen: new_resource.listen,
                backlog: new_resource.backlog,
                pid: new_resource.pid,
                timeout: new_resource.timeout,
                stderr_path: new_resource.stderr_path,
                stdout_path: new_resource.stdout_path,
                before_fork: new_resource.before_fork,
                after_fork: new_resource.after_fork,
                preload_app: new_resource.preload_app
    else
      variables new_resource.variables
    end
  end
end
