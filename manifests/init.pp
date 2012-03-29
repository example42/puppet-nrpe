# = Class: nrpe
#
# This is the main nrpe class
#
#
# == Parameters
#
# Module Specific parameters
#
# [*allowed_hosts*]
#   The Hosts that can connect to local NRPE server.
#   Typically the Nagios server(s) Can be an array.
#   Default: [ '127.0.0.1' , $::ipaddress ]
#
# [*dont_blame_nrpe*]
#   If you allow arguments in Nrpe commands.
#   This can be a security risk.
#   Default: '1' (allow arguments) is needed for Example42 automated checks
#   via Nagios.
#
# [*use_ssl*]
#   If you want to encrypt Nagios/Nrpe communications on ssl
#   A coherent configuration has to be placed on the Nagios server for
#   the check_nrpe command. Default: true
#
# [*pluginsdir*]
#   Where Nagios plugins are placed. Default value is calculated according
#   to $::operatingsystem and $::architecture
#
# [*pluginspackage*]
#   Name of the Nagios plugins package name. Default is automatically set
#   for different distros, set to blank ( pluginspackage => '' ) to
#   disable installation of Nagios plugins.
#
# [*ntp*]
#   This setting is specific for the ntp checks. It defines the ntp server
#   to use when verifying if local time is correct. Default:  '0.pool.ntp.org'
#
# [*command_timeout*]
#   The timeout for commands executed by Nrpe. Default: '60'
#
# [*connection_timeout*]
#   The Nrpe connection timeout. Default: '300'
#
# [*server_address*]
#   The listening address to which NRPE should bind.
#   Default: '' (NRPE listens on any interface)
#
# [*command_prefix*]
#   A command to prefix to every Nrpe command. Default: ''
#   Typically this value can be '/usr/bin/sudo' to launch commands via sudo
#
# [*file_init_template*]
#   The template to use to populate the init configuration file.
#   Default is provided by the module.
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, nrpe class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $nrpe_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, nrpe main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $nrpe_source
#   Note that by default a template file is specified, so if you want to
#   set the content of the main configu file via source you have also to
#   set template => undef
#
# [*source_dir*]
#   If defined, the whole nrpe configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $nrpe_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $nrpe_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, nrpe main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $nrpe_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $nrpe_options
#
# [*service_autorestart*]
#   Automatically restarts the nrpe service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $nrpe_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $nrpe_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $nrpe_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $nrpe_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for nrpe checks
#   Can be defined also by the (top scope) variables $nrpe_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $nrpe_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $nrpe_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $nrpe_puppi_helper
#   and $puppi_helper
#
# [*firewall*]
#   Set to 'true' to enable firewalling of the services provided by the module
#   Can be defined also by the (top scope) variables $nrpe_firewall
#   and $firewall
#
# [*firewall_tool*]
#   Define which firewall tool(s) (ad defined in Example42 firewall module)
#   you want to use to open firewall for nrpe port(s)
#   Can be defined also by the (top scope) variables $nrpe_firewall_tool
#   and $firewall_tool
#
# [*firewall_src*]
#   Define which source ip/net allow for firewalling nrpe. Default: 0.0.0.0/0
#   Can be defined also by the (top scope) variables $nrpe_firewall_src
#   and $firewall_src
#
# [*firewall_dst*]
#   Define which destination ip to use for firewalling. Default: $ipaddress
#   Can be defined also by the (top scope) variables $nrpe_firewall_dst
#   and $firewall_dst
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $nrpe_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $nrpe_audit_only
#   and $audit_only
#
# Default class params - As defined in nrpe::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of nrpe package
#
# [*service*]
#   The name of nrpe service
#
# [*service_status*]
#   If the nrpe service init script supports status argument
#
# [*process*]
#   The name of nrpe process
#
# [*process_args*]
#   The name of nrpe arguments. Used by puppi and monitor.
#   Used only in case the nrpe process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user nrpe runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*port*]
#   The listening port, if any, of the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Note: This doesn't necessarily affect the service configuration file
#   Can be defined also by the (top scope) variable $nrpe_port
#
# [*protocol*]
#   The protocol used by the the service.
#   This is used by monitor, firewall and puppi (optional) components
#   Can be defined also by the (top scope) variable $nrpe_protocol
#
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include nrpe"
# - Call nrpe as a parametrized class
#
# See README for details.
#
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#
class nrpe (
  $allowed_hosts       = params_lookup( 'allowed_hosts' ),
  $dont_blame_nrpe     = params_lookup( 'dont_blame_nrpe' ),
  $use_ssl             = params_lookup( 'use_ssl' ),
  $pluginsdir          = params_lookup( 'pluginsdir' ),
  $pluginspackage      = params_lookup( 'pluginspackage' ),
  $command_timeout     = params_lookup( 'command_timeout' ),
  $connection_timeout  = params_lookup( 'connection_timeout' ),
  $command_prefix      = params_lookup( 'command_prefix' ),
  $server_address      = params_lookup( 'server_address' ),
  $file_init_template  = params_lookup( 'file_init_template' ),
  $ntp                 = params_lookup( 'ntp' ),
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $monitor             = params_lookup( 'monitor' , 'global' ),
  $monitor_tool        = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target      = params_lookup( 'monitor_target' , 'global' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $firewall            = params_lookup( 'firewall' , 'global' ),
  $firewall_tool       = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src        = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst        = params_lookup( 'firewall_dst' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $package             = params_lookup( 'package' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $process_user        = params_lookup( 'process_user' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $pid_file            = params_lookup( 'pid_file' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' ),
  $port                = params_lookup( 'port' ),
  $protocol            = params_lookup( 'protocol' )
  ) inherits nrpe::params {

  $bool_use_ssl=any2bool($use_ssl)
  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_firewall=any2bool($firewall)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $nrpe::bool_absent ? {
    true  => 'absent',
    false => 'present',
  }

  $manage_service_enable = $nrpe::bool_disableboot ? {
    true    => false,
    default => $nrpe::bool_disable ? {
      true    => false,
      default => $nrpe::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $nrpe::bool_disable ? {
    true    => 'stopped',
    default =>  $nrpe::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $nrpe::bool_service_autorestart ? {
    true    => Service[nrpe],
    false   => undef,
  }

  $manage_file = $nrpe::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $nrpe::bool_absent == true or $nrpe::bool_disable == true or $nrpe::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  if $nrpe::bool_absent == true or $nrpe::bool_disable == true {
    $manage_firewall = false
  } else {
    $manage_firewall = true
  }

  $manage_audit = $nrpe::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $nrpe::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $nrpe::source ? {
    ''        => undef,
    default   => $nrpe::source,
  }

  $manage_dir_source = $nrpe::source_dir ? {
    ''        => undef,
    default   => $nrpe::source_dir,
  }

  $manage_file_content = $nrpe::template ? {
    ''        => undef,
    default   => template($nrpe::template),
  }

  $manage_file_init_content = $nrpe::file_init_template ? {
    ''        => undef,
    default   => template($nrpe::file_init_template),
  }

  ### Managed resources
  package { 'nrpe':
    ensure => $nrpe::manage_package,
    name   => $nrpe::package,
  }

  service { 'nrpe':
    ensure     => $nrpe::manage_service_ensure,
    name       => $nrpe::service,
    enable     => $nrpe::manage_service_enable,
    hasstatus  => $nrpe::service_status,
    pattern    => $nrpe::process,
    require    => Package['nrpe'],
  }

  file { 'nrpe.conf':
    ensure  => $nrpe::manage_file,
    path    => $nrpe::config_file,
    mode    => $nrpe::config_file_mode,
    owner   => $nrpe::config_file_owner,
    group   => $nrpe::config_file_group,
    require => Package['nrpe'],
    notify  => $nrpe::manage_service_autorestart,
    source  => $nrpe::manage_file_source,
    content => $nrpe::manage_file_content,
    replace => $nrpe::manage_file_replace,
    audit   => $nrpe::manage_audit,
  }

  file { 'nrpe.init':
    ensure  => $nrpe::manage_file,
    path    => $nrpe::config_file_init,
    mode    => $nrpe::config_file_mode,
    owner   => $nrpe::config_file_owner,
    group   => $nrpe::config_file_group,
    require => Package['nrpe'],
    notify  => $nrpe::manage_service_autorestart,
    content => $nrpe::manage_file_init_content,
    replace => $nrpe::manage_file_replace,
    audit   => $nrpe::manage_audit,
  }

  file { 'nrpe.dir':
    ensure  => directory,
    path    => $nrpe::config_dir,
    require => Package['nrpe'],
    notify  => $nrpe::manage_service_autorestart,
    source  => $nrpe::manage_dir_source,
    recurse => true,
    purge   => $nrpe::source_dir_purge,
    replace => $nrpe::manage_file_replace,
    audit   => $nrpe::manage_audit,
  }

  ### Install Nagios Plugins
  if $nrpe::pluginspackage != '' {
    if ! defined(Package[$nrpe::pluginspackage]) {
      package { $nrpe::pluginspackage : ensure => present }
    }
  }

  ### Include custom class if $my_class is set
  if $nrpe::my_class {
    include $nrpe::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $nrpe::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'nrpe':
      ensure    => $nrpe::manage_file,
      variables => $classvars,
      helper    => $nrpe::puppi_helper,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $nrpe::bool_monitor == true {
    monitor::port { "nrpe_${nrpe::protocol}_${nrpe::port}":
      protocol => $nrpe::protocol,
      port     => $nrpe::port,
      target   => $nrpe::monitor_target,
      tool     => $nrpe::monitor_tool,
      enable   => $nrpe::manage_monitor,
    }
    monitor::process { 'nrpe_process':
      process  => $nrpe::process,
      service  => $nrpe::service,
      pidfile  => $nrpe::pid_file,
      user     => $nrpe::process_user,
      argument => $nrpe::process_args,
      tool     => $nrpe::monitor_tool,
      enable   => $nrpe::manage_monitor,
    }
  }


  ### Firewall management, if enabled ( firewall => true )
  if $nrpe::bool_firewall == true {
    firewall { "nrpe_${nrpe::protocol}_${nrpe::port}":
      source      => $nrpe::firewall_src,
      destination => $nrpe::firewall_dst,
      protocol    => $nrpe::protocol,
      port        => $nrpe::port,
      action      => 'allow',
      direction   => 'input',
      tool        => $nrpe::firewall_tool,
      enable      => $nrpe::manage_firewall,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $nrpe::bool_debug == true {
    file { 'debug_nrpe':
      ensure  => $nrpe::manage_file,
      path    => "${settings::vardir}/debug-nrpe",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
