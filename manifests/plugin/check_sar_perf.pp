# Class: nrpe::plugin::check_sar_perf
#
# Installs check_sar_perf Nrpe plugin
#
class nrpe::plugin::check_sar_perf {

  if (! defined( Package[$nrpe::sysstat_package] )) {
    package { $nrpe::sysstat_package: }
  }

  nrpe::plugin { 'check_sar_perf':
    template => 'nrpe/plugin/check_sar_perf.py.erb'
  }

  file { 'nrpe_plugin_check_sar_perf_config':
    ensure  => $nrpe::manage_file,
    path    => "${nrpe::config_dir}/check_sar_perf.cfg",
    mode    => $nrpe::config_file_mode,
    owner   => $nrpe::config_file_owner,
    group   => $nrpe::config_file_group,
    require => Package['nrpe'],
    notify  => $nrpe::manage_service_autorestart,
    content => template('nrpe/plugin/check_sar_perf.cfg.erb'),
    replace => $nrpe::manage_file_replace,
    audit   => $nrpe::manage_audit,
  }

}
