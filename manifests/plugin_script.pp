# WARNING
#
# - This should not be directly invoked.
#
# WARNING
#
# Define: nrpe::plugin_script
#
# Installs the plugin it self
#
# == Parameters
#
# Module Specific parameters
#
# [*ensure*]
#
#
# == Examples#
# Provide a custom plugin:
#
# nrpe::plugin { 'check_sar_perf':
#   $ensure = 'present',
# }
#

define nrpe::plugin_script (
  $ensure = 'absent',
) {

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
