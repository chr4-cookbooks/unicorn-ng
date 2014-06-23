#
# Cookbook Name:: unicorn-ng
# Attributes:: default
#
# Copyright 2014, Chris Aumann
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

case node['platform']
when 'ubuntu'
  # Recent Ubuntu installs rubygems with the ruby package
  if node['platform_version'].to_f >= 14.04
    default['unicorn-ng']['packages'] = 'ruby'
  end
else
  default['unicorn-ng']['packages'] = 'rubygems'
end
