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
    /(?i:RedHat|Centos|Scientific|Fedora)/ => $::architecture ? {
      x86_64  => '/usr/lib64/nagios/plugins',
      default => '/usr/lib/nagios/plugins',
    },
    default                                => '/usr/lib/nagios/plugins',
  }

  $pluginspackage = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora)/ => 'nagios-plugins-all',
    default                                => 'nagios-plugins',
  }

  # Needed for ntp checks
  $ntp = '0.pool.ntp.org'

  $command_timeout = '60'
  $connection_timeout = '300'
  $server_address = ''
  $command_prefix = ''

  # The template used to populate the config_file_init
  $file_init_template = $::operatingsystem ? {
    /(?i:RedHat|Centos|Scientific|Fedora)/ => 'nrpe/nrpe-init-redhat.erb',
    /(?i:Debian|Ubuntu|Mint)/              => 'nrpe/nrpe-init-debian.erb',
    default                                => 'nrpe/nrpe-init-redhat.erb',
  }

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios-nrpe-server',
    default                   => 'nrpe',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'nagios-nrpe-server',
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
    default                   => 'nrpe',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/nagios/nrpe.d',
    default                   => '/etc/nrpe.d',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/nagios/nrpe.cfg',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/nagios-nrpe-server',
    default                   => '/etc/sysconfig/nrpe',
  }

  $pid_file = $::operatingsystem ? {
    /(?i:Ubuntu|Mint)/                     => '/var/run/nagios/nrpe.pid',
    /(?i:Centos|RedHat|Scientific|Fedora)/ => '/var/run/nrpe/nrpe.pid',
    default                                => '/etc/run/nrpe.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '',
  }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/messages',
  }

  $port = '5666'
  $protocol = 'tcp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = 'false'
  $template = 'nrpe/nrpe.cfg.erb' # A default file with the checks we need
  $options = ''
  $service_autorestart = true
  $absent = false
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
