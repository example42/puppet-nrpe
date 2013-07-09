# WARNING
#
# - This should not be directly invoked.
#
# WARNING
#
# Define: nrpe::plugin_config
#
# Installs config for the NRPE plugin.
#
# == Parameters
#
# Module Specific parameters
#
# [*enable*]
#
#
# == Examples#
# Install config for a plugin:
#
# nrpe::plugin_config { 'check_sar_perf':
#   ensure => 'present',
# }
#

define nrpe::plugin_config (
  $ensure = 'absent',
) {
  
  file { "nrpe_plugin_config_${name}":
    ensure  => $ensure,
    path    => "${nrpe::config_dir}/${name}.cfg",
    mode    => $nrpe::config_file_mode,
    owner   => $nrpe::config_file_owner,
    group   => $nrpe::config_file_group,
    require => Package['nrpe'],
    notify  => $nrpe::manage_service_autorestart,
    content => template("nrpe/plugin/${name}.cfg.erb"),
    replace => $nrpe::manage_file_replace,
    audit   => $nrpe::manage_audit,
  }

}
