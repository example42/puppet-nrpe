# Define: nrpe::plugin
#
# Adds or configures a Nrpe plugin
#
# Usage:
#
# Provide a custom plugin:
# nrpe::plugin { 'check_redis':
#   source => 'example42/nrpe/redis',
# }
#

define nrpe::plugin (
  $source = '',
  $enable = true ) {

  $ensure = bool2ensure($enable)

  if $source {
    file { "Nrpe_plugin_${name}":
      path    => "${nrpe::pluginsdir}/${name}",
      owner   => root,
      group   => root,
      mode    => '0755',
      ensure  => $ensure,
      require => Package['nrpe'],
      notify  => Service['nrpe'],
      source  => "puppet:///$source",
    }
  }


}

