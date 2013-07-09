# Define: nrpe::plugin
#
# Installs and configures a Nrpe plugin
#
# == Parameters
#
# Module Specific parameters
#
# [*enable*]
#   Is this plugin enabled?
#
# [*package*]
#   Name of the package (if any) needed by the plugin
#
#
# == Examples#
# Provide a custom plugin:
#
# nrpe::plugin { 'check_sar_perf':
#   source => 'example42/nrpe/redis',
# }
#

define nrpe::plugin (
  $enable = true,
  $package = undef,
) {

  ## Ensures package, config and plugin are removed in case the
  ## specific plugin is turned off or NRPE is removed.
  $ensure = $nrpe::bool_absent ? {
    true    => 'absent',
    default => $enable ? {
      true    => 'present',
      default => 'absent',
    },
  }
  
  if $package != undef and $package != ''
  {
    nrpe::plugin_package {$package: 
      ensure => $ensure,
    }
  }
  
  nrpe::plugin_config {$name: 
    ensure => $ensure,
  }

  file { "Nrpe_plugin_${name}":
    path    => "${nrpe::pluginsdir}/${name}",
    owner   => root,
    group   => root,
    mode    => '0755',
    ensure  => $ensure,
    require => Package['nrpe'],
    notify  => Service['nrpe'],
    content => template("nrpe/plugin/${name}.erb"),
    seluser => "system_u",
    selrole => "object_r",
    seltype => "nagios_unconfined_plugin_exec_t",
    selrange => "s0",
  }

}
