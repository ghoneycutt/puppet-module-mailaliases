# == Class: mailaliases
#
# Manages your /etc/mail/aliases file
#
class mailaliases (
  $alias_directory = '/etc/aliases.d',
  $root            = 'root',
) {

  include common

  # If $root_target is an array, concatenate the elements into a string,
  # delimited by commas
  if is_array($root) {
    $root_target = join($root,",")
  }
  else {
    $root_target = $root
  }

  common::mkdir_p { $alias_directory: }

  file { 'aliases_dot_d':
    ensure  => directory,
    path    => $alias_directory,
    purge   => true,
    recurse => true,
    require => Common::Mkdir_p[$alias_directory],
  }

  file { 'aliases_base':
    path    => "${alias_directory}/00-aliases-base",
    content => template('mailaliases/00-aliases-base.erb'),
    notify  => Exec['rebuild-aliases'],
  }

  exec { 'rebuild-aliases':
    command     => "/bin/cat ${alias_directory}/* > /etc/aliases && newaliases",
    refreshonly => true,
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    subscribe   => File['aliases_dot_d'],
  }
}
