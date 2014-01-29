# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation errors
# and view a log of events) or by fully applying the test in a virtual environment
# (to compare the resulting system state to the desired state).
#
# Learn more about module testing here: http://docs.puppetlabs.com/guides/tests_smoke.html
#
include mailaliases

mailaliases::alias { 'rootuser':
  user  => "root",
  target => "postmaster@${::domain}",
}

mailaliases::alias { 'foobaruser':
  user  => "foo",
  target => [ "bar@${::domain}", "foobar@${::domain}", "fbar@${::domain}" ]
}

mailaliases::alias { 'foorbarnull':
  user  => "foobar",
  target => "/dev/null",
}

mailaliases::alias { 'foocmduser':
  user  => "foocmd",
  target => "|/some/command",
}

mailaliases::alias { 'fooincludeuser':
  user  => "fooinclude",
  target => ":include:/etc/mail/aliasfile",
}

#mailaliases::alias { 'failure':
#  user => "iforgotthetarget"
#}
