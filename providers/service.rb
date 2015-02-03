#
# Cookbook Name:: unicorn-ng
# Provider:: service
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
  template "/etc/init.d/#{new_resource.service_name}" do
    owner new_resource.owner
    group new_resource.group
    mode  new_resource.mode

    cookbook new_resource.cookbook
    source   new_resource.source

    # default to paths relative to rails_root
    config         = new_resource.config         || "#{new_resource.rails_root}/config/unicorn.rb"
    pidfile        = new_resource.pidfile        || "#{new_resource.rails_root}/tmp/pids/unicorn.pid"
    bundle_gemfile = new_resource.bundle_gemfile || "#{new_resource.rails_root}/Gemfile"

    if new_resource.variables.empty?
      variables config:         config,
                bundle_gemfile: bundle_gemfile,
                pidfile:        pidfile,
                wrapper:        new_resource.wrapper,
                wrapper_opts:   new_resource.wrapper_opts,
                bundle:         new_resource.bundle,
                environment:    new_resource.environment,
                locale:         new_resource.locale,
                user:           new_resource.user,
                service_name:   new_resource.service_name
    else
      variables new_resource.variables
    end
  end

  service new_resource.service_name do
    supports restart: true, status: true, reload: true
    action [:enable, :start]
  end
end
