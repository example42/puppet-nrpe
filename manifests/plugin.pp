# Define: nrpe::plugin
#
# Adds or configures a Nrpe plugin
#
# == Parameters
#
# Module Specific parameters
#
# [*source*]
#   The source of the content to use as plugin.
#   Can be omitted if a template path is specified instead.
#
# [*source_prefix*]
#   Prefix of the source. Defaults to puppet:///
#
# [*template*]
#   The template to use for the plugin contents.
#
# [*enable*]
#   To enable, or not to enable - that's the question.
#
#
# == Examples#
# Provide a custom plugin:
#
# nrpe::plugin { 'check_redis':
#   source => 'example42/nrpe/redis',
# }
#

define nrpe::plugin (
  $source = '',
  $source_prefix = 'puppet:///',
  $template = undef,
  $enable = true,
) {

  $ensure = bool2ensure($enable)

  if ($source == undef or $source == '') {
    $source_path = undef
  } else {
    $source_path = "${source_prefix}${source}"
  }

  if ($template != undef) {
    $content = template($template)
  } else {
    $content = undef
  }

  if $source_path or $content {
    file { "Nrpe_plugin_${name}":
      ensure   => $ensure,
      path     => "${nrpe::pluginsdir}/${name}",
      owner    => root,
      group    => root,
      mode     => '0755',
      require  => Package['nrpe'],
      notify   => Service['nrpe'],
      source   => $source_path,
      content  => $content,
      seluser  => 'system_u',
      selrole  => 'object_r',
      seltype  => 'nagios_unconfined_plugin_exec_t',
      selrange => 's0',
    }
  }

}
