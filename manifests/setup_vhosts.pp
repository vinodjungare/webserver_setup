define webserver_setup::setup_vhosts () {
notify {" Hello world : $name ": }


file { "${webserver_setup::apache_docroot}/${name}" :
  ensure => directory,
  mode   => '0755',
}

file { "${webserver_setup::apache_docroot}/${name}/index.html" :
  ensure => file,
  source => 'puppet:///modules/webserver_setup/index.html',
}

apache::vhost { $name  :
  ensure  => 'present',
  port    => '80',
  docroot => "${webserver_setup::apache_docroot}/${name}",
}

host { $name :
  ip => '127.0.0.1'
}
}
