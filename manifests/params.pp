# Class: nrpe::params
#
# This class defines default parameters used by the main module class nrpe
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to nrpe class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class nrpe::params {

  ## Class specific parameters
  $allowed_hosts = [ '127.0.0.1' , $::ipaddress ]

  $dont_blame_nrpe = '1'

  $use_ssl = true

  $pluginsdir = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora|Amazon|Linux)/ => $::architecture ? {
      x86_64  => '/usr/lib64/nagios/plugins',
      default => '/usr/lib/nagios/plugins',
    },
    /(?i:Solaris)/                                      => '/opt/csw/libexec/nagios-plugins',
    /(?i:OpenBSD)/                                      => '/usr/local/libexec/nagios',
    default                                             => '/usr/lib/nagios/plugins',
  }

  $pluginsdir_source = undef

  $pluginspackage = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora|Amazon|Linux)/ => 'nagios-plugins-all',
    /(?i:Solaris)/                                      => 'nagios_plugins',
    default                                             => 'nagios-plugins',
  }

  # Needed for ntp checks
  $ntp = '0.pool.ntp.org'
  $checkdisk_warning = '20'
  $checkdisk_critical = '10'

  $command_timeout = '60'
  $connection_timeout = '300'
  $server_address = ''
  $command_prefix = ''

  # The template used to populate the config_file_init
  $file_init_template = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora|Amazon|Linux)/ => 'nrpe/nrpe-init-redhat.erb',
    /(?i:Debian|Ubuntu|Mint)/                           => 'nrpe/nrpe-init-debian.erb',
    /(?i:Solaris)/                                      => 'nrpe/nrpe-init-solaris.erb',
    default                                             => 'nrpe/nrpe-init-redhat.erb',
  }

  ### Application related parameters

  $package_provider = $::operatingsystem ? {
    /(?i:Solaris)/ => 'pkgutil',
    default        => undef,
  }

  $package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios-nrpe-server',
    /(?i:SLES|OpenSuSE)/      => $::operatingsystemrelease ? {
      '12.3'   => 'nrpe',
      default  => 'nagios-nrpe',
    },
    default                   => 'nrpe',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios-nrpe-server',
    /(?i:Solaris)/            => 'cswnrpe',
    default                   => 'nrpe',
  }

  $service_status = $::operatingsystem ? {
    /(?i:Debian)/ => false,
    default       => true,
  }

  $process = $::operatingsystem ? {
    default => 'nrpe',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios',
    /(?i:SLES|OpenSuSE)/      => $::operatingsystemrelease ? {
      '12.3'   => 'nagios',
      default  => 'nrpe',
    },
    /(?i:Solaris)/            => 'nagios',
    /(?i:OpenBSD)/            => '_nrpe',
    default                   => 'nrpe',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/nagios/nrpe.d',
    /(?i:Solaris)/            => '/etc/opt/csw/nrpe.d',
    default                   => '/etc/nrpe.d',
  }

  $oldcsw = $::operatingsystem ? {
    /(?i:Solaris)/ => true,
    default        => false,
  }

  $oldcsw_config_file = $::operatingsystem ? {
    /(?i:Solaris)/ => '/opt/csw/etc/nrpe.cfg',
    default        => '',
  }

  $oldcsw_config_dir = $::operatingsystem ? {
    /(?i:Solaris)/ => '/opt/csw/etc/nrpe.d',
    default        => '',
  }

  $config_file = $::operatingsystem ? {
    /(?i:SLES|OpenSuSE)/      => $::operatingsystemrelease ? {
      '12.3'   => '/etc/nrpe.cfg',
      default  => '/etc/nagios/nrpe.cfg',
    },
    /(?i:OpenBSD)/            => '/etc/nrpe.cfg',
    /(?i:Solaris)/            => '/etc/opt/csw/nrpe.cfg',
    default                   => '/etc/nagios/nrpe.cfg',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    /(?i:OpenBSD)/ => 'wheel',
    default        => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/nagios-nrpe-server',
    /(?i:OpenBSD)/            => '',
    /(?i:Solaris)/            => '/etc/opt/csw/nrpe-init',
    default                   => '/etc/sysconfig/nrpe',
  }

  $pid_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/                           => '/var/run/nagios/nrpe.pid',
    /(?i:Centos|RedHat|Scientific|Fedora|Amazon|Linux)/ => '/var/run/nrpe/nrpe.pid',
    /(?i:Solaris)/                                      => '/var/run/nrpe.pid',
    default                                             => '/var/run/nrpe/nrpe.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '',
  }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    /(?i:Solaris)/ => '/var/adm/messages',
    default        => '/var/log/messages',
  }

  $enable_sysstat  = false
  $sysstat_package = 'sysstat'

  $port = '5666'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = 'nrpe/nrpe.cfg.erb' # A default file with the checks we need
  $options = ''
  $service_autorestart = true
  $absent = false
  $version = ''
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
