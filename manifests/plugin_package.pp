# WARNING
#
# - This should not be directly invoked.
#
# WARNING
#
# Define: nrpe::plugin_package
#
# Installs packages needed by a NRPE plugin.
#
# == Parameters
#
# Module Specific parameters
#
# [*ensure*]
#
#
# == Examples#
# Install package for a plugin:
#
# nrpe::plugin_package { 'sysstat':
#   ensure => 'present',
# }
#

define nrpe::plugin_package (
  $ensure = 'absent',
) {

  package { $name:
    ensure => $ensure,
  }

}
