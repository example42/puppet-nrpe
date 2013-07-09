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
# [*plugin*]
#   Name of the plugin (if any) to be installed
#
# [*config*]
#   Name of the config (if any) to be installed for the plugin
#
# [*package*]
#   Name of the package (if any) needed by the plugin
#
#
# == Examples#
# Provide a custom plugin:
#
# nrpe::plugin { 'check_sar_perf':
#   enable  => $bool_enable_sysstat,
#   plugin => 'check_sar_perf',
#   config => 'check_sar_perf',
#   package => $nrpe::sysstat_package,
# }
#

define nrpe::plugin (
  $enable = false,
  $plugin = undef,
  $config = undef,
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

  if $plugin != undef and $plugin != ''
  {
	  nrpe::plugin_script {$name: 
	    ensure => $ensure,
	  }
  }

  if $config != undef and $config != ''
  {
    nrpe::plugin_config {$config: 
      ensure => $ensure,
    }
  }

  if $package != undef and $package != ''
  {
    nrpe::plugin_package {$package: 
      ensure => $ensure,
    }
  }

}
