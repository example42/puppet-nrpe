# Puppet module: nrpe

This is a Puppet module for nrpe based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-nrpe

Released under the terms of Apache 2 License.

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.

## USAGE - Basic management

* Install nrpe with default settings

        class { 'nrpe': }

* Disable nrpe service.

        class { 'nrpe':
          disable => true
        }

* Remove nrpe package

        class { 'nrpe':
          absent => true
        }

* Enable auditing without without making changes on existing nrpe configuration files

        class { 'nrpe':
          audit_only => true
        }


## USAGE - Module specific parameters

* Define the hosts allowed to connect to NRPE (typically the Nagios servers) 
  This can be an array. Local host and local IP should be kept

        class { 'nrpe':
          allowed_hosts => ['127.0.0.1', $::ipaddress , '10.42.42.20' ],
        }

* Some settings that harden the default configuration. Note that they require proper configuration on the sudoers file

        class { 'nrpe':
          allowed_hosts   => ['127.0.0.1', '10.42.42.20' ],
          dont_blame_nrpe => '0',
          command_prefix  => '/usr/bin/sudo',
          use_ssl         => true,             # Already true by default
          server_address  => $::ipadress_eth1, # Listen only on eth1 interface
        }

* Do not automatically install Nagios plugins

        class { 'nrpe':
          pluginspackage => '',
        }

* Include Nagios Plugin 

	    nrpe::plugin { 'check_foobar':
              source => 'files/nrpe/check_foobar'
        }

* Install nrpe with a specific version

        class { 'nrpe':
          version => '2.12-4'
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file. Note that by default the module provides a config file as a template, so you've to undet the template argument.

        class { 'nrpe':
          source   => [ "puppet:///modules/lab42/nrpe/nrpe.conf-${hostname}" , "puppet:///modules/lab42/nrpe/nrpe.conf" ], 
          template => undef,
        }

* Use custom source directory for the whole configuration dir

        class { 'nrpe':
          source_dir       => 'puppet:///modules/lab42/nrpe/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'nrpe':
          template => 'example42/nrpe/nrpe.conf.erb',
        }

* Automatically include a custom subclass

        class { 'nrpe':
          my_class => 'nrpe::example42',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'nrpe':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'nrpe':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { 'nrpe':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { 'nrpe':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


[![Build Status](https://travis-ci.org/example42/puppet-nrpe.png?branch=master)](https://travis-ci.org/example42/puppet-nrpe)
