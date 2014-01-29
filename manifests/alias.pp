# == Definition: mailaliases::alias
#
# Manages a single line of /etc/aliases using the File Fragment Pattern.
#
# == Usage:
# mailaliases::alias { 'root':
#   target => "postmaster@${::domain}",
# }
#
# # specify an array of targets
# mailaliases::alias { 'root':
#   target => ["postmaster@${::domain}",'postmaster],
# }
#
define mailaliases::alias(
  $target = '',
) {

  # Verify the target is defined
  if !($target) {
    fail("Must define target attribute for mailaliases::alias::${name}")
  }

  # If we have an array, concatenate items together with comma
  if is_array($target) {
    $all_targets = join($target,",")
  }
  else {
    $all_targets = $target
  }

  # Write name line to file and trigger newaliases
  file { "${mailaliases::alias_directory}/${name}":
    content => "${name}: ${all_targets}\n",
    notify  => Exec['rebuild-aliases'],
  }
}
