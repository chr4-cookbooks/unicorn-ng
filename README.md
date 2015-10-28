# unicorn-ng Cookbook

[![Build Status](https://travis-ci.org/chr4-cookbooks/unicorn-ng.svg?branch=master)](https://travis-ci.org/chr4-cookbooks/unicorn-ng)

Manage your [unicorn](http://unicorn.bogomips.org/) application server with this cookbook.

This cookbook provides a decent initscript for Debian/Ubuntu, as well as takes care of the unicorn configuration.

Features

* Provides a decent initscript for Debian/Ubuntu
* Automatically takes care of ActiveRecord connections (if ActiveRecord is used)
* Hightly configureable for your needs
* Use either a system-wide installed unicorn, or one that gets deployed with your application


## Requirements

An installed unicorn. Alterantively you can use the install recipe to install it using rubygems.

Furthermore you need to add the following line to your metadata.rb

```ruby
depends 'unicorn-ng'
```


## Attributes

### Packages

To install unicorn, rubygems is required. The cookbook tries to figure out automatically which packages are required depending on your current OS.
It is possible to override the automatic settings and specify them manually, though

```ruby
node['unicorn-ng']['packages'] = %w(rubygems)
```

### Configuration

Everything in your unicorn.rb can be maintained using attributes.
Consider using the provides LWRPs (see below)

Most importantly, you need to specify the path to your unicorn.rb.
If this is not specified, the default recipe will do nothing.
You can also specify a working directory, if needed

```ruby
node['unicorn-ng']['config']['config_file'] = '/var/www/examples.com/config/unicorn.rb'
node['unicorn-ng']['config']['working_directory'] = '/var/www/examples.com'
```

This section describes the supported attributes, as well as their default settings.

```ruby
node['unicorn-ng']['config']['worker_processes'] = 1
node['unicorn-ng']['config']['listen'] = 8080
node['unicorn-ng']['config']['backlog'] = nil
node['unicorn-ng']['config']['pid'] = 'tmp/pids/unicorn.pid'
node['unicorn-ng']['config']['timeout'] = 60
node['unicorn-ng']['config']['stderr_path'] = 'log/unicorn.stderr.log'
node['unicorn-ng']['config']['stdout_path'] = 'log/unicorn.stdout.log'
node['unicorn-ng']['config']['preload_app'] = true

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
node['unicorn-ng']['config']['before_fork'] =  <<-EOS
  old_pid = '#{node['unicorn-ng']['config']['pid']}.oldbin'
  if File.exists?(old_pid) and server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection_handler.clear_all_connections!
  end
EOS

node['unicorn-ng']['config']['after_fork'] =  <<-EOS
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection_handler.verify_active_connections!
  end
EOS
```

It's also possible to add arbitrary commands to the top of `unicorn.rb` in case you need something
like a special `require` statement.

```ruby
node['unicorn-ng']['config']['prescript'] = <<-EOS
  # Load the GELF logging extension
  require 'gelf'
  logger ::GELF::Logger.new('graylog', 1234, 'LAN', {facility: 'unicorn'})
EOS

```

Furthermore, you can define more advanced settings, if needed

```ruby
node['unicorn-ng']['config']['owner'] = 'root'
node['unicorn-ng']['config']['group'] = 'root'
node['unicorn-ng']['config']['mode'] = 00644
node['unicorn-ng']['config']['cookbook'] = 'unicorn-ng'
node['unicorn-ng']['config']['source'] = 'unicorn.rb.erb'
node['unicorn-ng']['config']['variables'] = {}
```

### Service

This cookbook can set up unicorn so it gets properly started at boot time.

Analogue to the configuration, you need to specify the path to your rails application.
If this is not specified, the default recipe will do nothing.

```ruby
node['unicorn-ng']['service']['rails_root'] = '/var/www/example.com'
```

The following attributes will be set automatically relative to the rails_root, if not specified.

```ruby
node['unicorn-ng']['service']['config'] = nil
node['unicorn-ng']['service']['bundle_gemfile'] = nil
node['unicorn-ng']['service']['pidfile'] = nil
```

If you need a different bundler (e.g. a wrapper from rvm), you can specify it here

```ruby
node['unicorn-ng']['service']['bundle'] = '/usr/local/bin/bundle'
```

It's also possible (since 0.2.0) to specify a wrapper (like chruby-exec) (disabled by default)

```ruby
node['unicorn-ng']['service']['wrapper'] = '/usr/local/bin/chruby-exec'
node['unicorn-ng']['service']['wrapper_opts'] = "#{my_ruby_string} --"
node['unicorn-ng']['service']['bundle'] = 'bundle'
```

In the same way, you can set your custom `GEM_HOME` path:

```ruby
node['unicorn-ng']['service']['gem_home'] = '/usr/local/ruby/gems'
```

Since version `1.2.1`, you can specify the `--chdir` flag for `start-stop-daemon`, which results in
a chdir before the app starts

```ruby
node['unicorn-ng']['service']['chdir'] = '/home/myapp'
```

The RAILS_ENV. Set this to 'production' in your production environment

```ruby
node['unicorn-ng']['service']['environment'] = 'development'
```

The user unicorn runs at. **NOTE: THIS SHOULD BE CHANGED TO AN UNPRIVILEDGED USER**

```ruby
node['unicorn-ng']['service']['user'] = 'root' # CHANGE ME! (e.g. 'www-data')
```

The locale (set by the initscript)

```ruby
node['unicorn-ng']['service']['locale'] = 'en_US.UTF-8'
```

Since 0.3.0, you can specify the service name. The initscript will be deployed to `/etc/init.d/SERVICENAME`.
Defaults to `'unicorn'`

```ruby
node['unicorn-ng']['service']['name'] = 'unicorn'
```

Additional options for the initscript (if required)

```ruby
node['unicorn-ng']['service']['owner'] = 'root'
node['unicorn-ng']['service']['group'] = 'root'
node['unicorn-ng']['service']['mode'] = 00755
node['unicorn-ng']['service']['cookbook'] = 'unicorn-ng'
node['unicorn-ng']['service']['source'] = 'unicorn.init.erb'
node['unicorn-ng']['service']['variables'] = {}
```


## Recipes

### default

Configures unicorn.rb configuration, as well as the unicorn initscript according to the attributes above.
Unless you specify at least one of the following attributes, this recipe will do nothing.

```ruby
node['unicorn-ng']['config']['config_file'] # path to your unicorn.rb (will configure unicorn.rb)
node['unicorn-ng']['service']['rails_root'] # path to your rails_root (will configure the unicorn service)
```

### install

Installs bundler and unicorn using the systems "rubygems".
Consider installing a more recent environment using tools like rvm.


## Provider

### unicorn_ng_config

Configures unicorn.rb.
This LWRP uses the given attributes (see above) as defaults, if not specified otherwise.

Example:

```ruby
unicorn_ng_config '/var/www/example.com/shared/config/unicorn.rb'
```

Or, a more complex setup:

```ruby
unicorn_ng_config '/var/www/example.com/shared/config/unicorn.rb' do
  worker_processes 16 if node.chef_environment == 'production'
  worker_processes  6 if node.chef_environment == 'staging'
  worker_processes  2 if node.chef_environment == 'development'

  case node.chef_environment
  when 'production', 'staging'
    # We may be started by root, thus dropping privileges
    user 'deploy'
    working_directory '/var/www/example.com/current'

    # Listen on UNIX domain socket only
    # Shorter backlog for quicker failover when busy
    listen  'unix:tmp/sockets/unicorn.sock'
    backlog 1024

  when 'development'
    listen 8080
  end

  # Kill workers after 30 seconds on production
  timeout (node.chef_environment == 'production' ? 30 : 60)
end
```

### unicorn_ng_service

Deploys and configures unicorn initscript.
This LWRP uses the given attributes (see above) as defaults, if not specified otherwise.

Example:

```ruby
unicorn_ng_service '/var/www/example.com/current'
```

In case you e.g. want to use the unicorn bundled with your configuration, you may set up a rvm wrapper for bundler

Using [fnichol-rvm](https://github.com/fnichol/chef-rvm):

```ruby
rvm_wrapper 'init' do
  binary 'bundle'
  ruby_string 'ruby-2.0.0@myapp'
end
```

Or do it manually

```bash
rvm wrapper ruby-2.0.0@myapp init bundler
```

The initscript then uses this bundler to call unicorn with

```bash
bundle exec unicorn [ARGS]
```

Then tell the service to use your custom bundler:

```ruby
unicorn_ng_service '/var/www/example.com/current' do
  environment   node.chef_environment
  user          'deploy'

  # use a custom bundle-environment
  bundle        '/usr/local/rvm/bin/init_bundle'
end
```

An example with chruby-exec

```ruby
unicorn_ng_service '/var/www/example.com/current' do
  wrapper       '/usr/local/bin/chruby-exec'
  wrapper_opts  '1.9.3-p448 --''
  bundle        'bundle'
  environment   node.chef_environment
  user          'deploy'
end
```

# Contributing

Contributions are very welcome!

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


# License and Authors

Author: Chris Aumann <me@chr4.org>

Contributor: Moshe Bergman <bergmanm@gmail.com>

License: GPLv3
