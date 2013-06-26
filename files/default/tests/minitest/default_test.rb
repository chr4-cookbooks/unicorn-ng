#
# Cookbook Name:: resolvconf
# Test:: default
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

require File.expand_path('../support/helpers', __FILE__)

describe 'unicorn-ng::default' do
  include Helpers::Testing

  it 'installs rubygems package' do
    package('rubygems').must_be_installed
  end

  it 'installs bundler gem' do
    cmd = shell_out('which bundle')
    cmd.exitstatus.to_s.must_match('0')
  end

  it 'installs unicorn gem' do
    cmd = shell_out('which unicorn')
    cmd.exitstatus.to_s.must_match('0')
  end

  it 'must deploy initscript' do
    file('/etc/init.d/unicorn').must_exist
  end

  it 'must enable unicorn service' do
    service('unicorn').must_be_enabled
  end
end
