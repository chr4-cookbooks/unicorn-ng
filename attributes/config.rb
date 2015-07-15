#
# Cookbook Name:: unicorn-ng
# Attributes:: config
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

default['unicorn-ng']['config']['config_file'] = nil
default['unicorn-ng']['config']['working_directory'] = nil
default['unicorn-ng']['config']['prescript'] = nil
default['unicorn-ng']['config']['worker_processes'] = 1
default['unicorn-ng']['config']['listen'] = 8080
default['unicorn-ng']['config']['backlog'] = nil
default['unicorn-ng']['config']['pid'] = 'tmp/pids/unicorn.pid'
default['unicorn-ng']['config']['timeout'] = 60
default['unicorn-ng']['config']['stderr_path'] = 'log/unicorn.stderr.log'
default['unicorn-ng']['config']['stdout_path'] = 'log/unicorn.stdout.log'
default['unicorn-ng']['config']['preload_app'] = true

# When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
# immediately start loading up a new version of itself (loaded with a new
# version of our app). When this new Unicorn is completely loaded
# it will begin spawning workers. The first worker spawned will check to
# see if an .oldbin pidfile exists. If so, this means we've just booted up
# a new Unicorn and need to tell the old one that it can now die. To do so
# we send it a QUIT.
#
# Using this method we get 0 downtime deploys.
#
# Stolen from: https://github.com/blog/517-unicorn

# pidfile will be set to pid in unicorn.rb
default['unicorn-ng']['config']['before_fork'] =  <<-EOS
  old_pid = "\#{pidfile}.oldbin"
  if File.exists?(old_pid) and server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
EOS

default['unicorn-ng']['config']['after_fork'] =  <<-EOS
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
EOS

default['unicorn-ng']['config']['owner'] = 'root'
default['unicorn-ng']['config']['group'] = 'root'
default['unicorn-ng']['config']['mode'] = 00644
default['unicorn-ng']['config']['cookbook'] = 'unicorn-ng'
default['unicorn-ng']['config']['source'] = 'unicorn.rb.erb'
default['unicorn-ng']['config']['variables'] = {}
