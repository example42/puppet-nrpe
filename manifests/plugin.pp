# Define: nrpe::plugin
#
# Adds or configures a Nrpe plugin
#
# Usage:
# Define the configuration file of an existing plugin:
# nrpe::plugin { 'squid':
#   source_config => 'example42/nrpe/squid-config',
# }
#
# Define the configuration file of an existing plugin in-line:
# nrpe::plugin { 'nginx':
#   content_config => "[nginx*]\nenv.url http://localhost/nginx_status";
# }
#
# Provide a custom plugin:
# nrpe::plugin { 'redis':
#   source => 'example42/nrpe/redis',
# }
#
# Provide a custom plugin with a custom configuration:
# nrpe::plugin { 'redis':
#   source        => 'example42/nrpe/redis',
#   source_config => 'example42/nrpe/redis-conf',
# }
#

define nrpe::plugin (
  $source = '',
  $source_config = '',
  $content = '',
  $content_config = '',
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

  if $content {
    file { "Nrpe_plugin_${name}":
      path    => "${nrpe::pluginsdir}/${name}",
      owner   => root,
      group   => root,
      mode    => '0755',
      ensure  => $ensure,
      require => Package['nrpe'],
      notify  => Service['nrpe'],
      content => $content,
    }
  }

  if $source_config {
    file { "Nrpe_plugin_conf_${name}":
      path    => "${nrpe::conf_dir_plugins}/${name}",
      owner   => root,
      group   => root,
      mode    => '0644',
      ensure  => $ensure,
      require => Package['nrpe'],
      notify  => Service['nrpe'],
      source  => "puppet:///$source_config",
    }
  }

  if $content_config {
    file { "Nrpe_plugin_conf_${name}":
      path    => "${nrpe::conf_dir_plugins}/${name}",
      owner   => root,
      group   => root,
      mode    => '0644',
      ensure  => $ensure,
      require => Package['nrpe'],
      notify  => Service['nrpe'],
      content => $content_config,
    }
  }
}

