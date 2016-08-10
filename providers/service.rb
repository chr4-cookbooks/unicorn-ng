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
  # Default to paths relative to rails_root
  config         = new_resource.config || "#{new_resource.rails_root}/config/unicorn.rb"
  pidfile        = new_resource.pidfile || "#{new_resource.rails_root}/tmp/pids/unicorn.pid"
  bundle_gemfile = new_resource.bundle_gemfile || "#{new_resource.rails_root}/Gemfile"

  # Make systemd learn new configuration files
  execute "daemon-reload for #{new_service.service_name}" do
    command 'systemctl daemon-reload'
    action :nothing
    only_if { new_resource.systemd }
  end

  template "/etc/systemd/system/#{new_resource.service_name}.service" do
    mode     0o644
    cookbook 'unicorn-ng'
    source   'systemd.service.erb'
    variables config:         config,
              bundle_gemfile: bundle_gemfile,
              pidfile:        pidfile,
              wrapper:        new_resource.wrapper,
              wrapper_opts:   new_resource.wrapper_opts,
              bundle:         new_resource.bundle,
              environment:    new_resource.environment,
              locale:         new_resource.locale,
              user:           new_resource.user,
              service_name:   new_resource.service_name,
              chdir:          new_resource.chdir,
              gem_home:       new_resource.gem_home

    # Run daemon-reload when service is changed
    notifies :run, "execute[daemon-reload for #{new_service.service_name}]", :immediately

    only_if { new_resource.systemd }
  end

  template "/etc/init.d/#{new_resource.service_name}" do
    owner new_resource.owner
    group new_resource.group
    mode  new_resource.mode

    cookbook new_resource.cookbook
    source   new_resource.source

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
                service_name:   new_resource.service_name,
                chdir:          new_resource.chdir,
                gem_home:       new_resource.gem_home
    else
      variables new_resource.variables
    end

    not_if { new_resource.systemd }
  end

  service new_resource.service_name do
    supports restart: true, status: true, reload: true
    action [:enable, :start]
  end
end
