# Class: webserver_setup
# ===========================
#
# Full description of class webserver_setup here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'webserver_setup':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class webserver_setup ( 
$mysql_root_pwd, 
$mysql_user = 'shyam', 
$database_list = ['mysql_db1', 'mysql_db2'],   
$apache_docroot = "/var/www/vhosts/",
$vhosts_list = ['1.skillbuilder.net','2.skillbuilder.net']){

  ### MySQL database setup code starts here  
# Setting defaults as hash. Useful in long term.
$fresh_databases = {
  'db_defaults' => {
    ensure             => 'present',
    charset            => 'utf8',
  },
  'user_defaults'            => {
    ensure                   => 'present',
    max_connections_per_hour => '0',
    max_queries_per_hour     => '0',
    max_updates_per_hour     => '0',
    max_user_connections     => '0',
  },
  'grant_defaults' => {
    ensure         => 'present',
    options        => ['GRANT'],
    privileges     => ['SELECT'],
  },

}

class { '::mysql::server' : 
    root_password  => $mysql_root_pwd,
}


mysql_database { $database_list :
   ensure  => $fresh_databases['db_defaults']['ensure'],
   charset => $fresh_databases['db_defaults']['charset'],
}

mysql_user { '${mysql_user}@localhost' :
  ensure => $fresh_databases['user_defaults']['ensure'],
}

mysql_grant { '${mysql_user}@localhost/*.*' :
  ensure     => $fresh_databases['grant_defaults']['ensure'],
  options    => $fresh_databases['grant_defaults']['options'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => '${mysql_user}@localhost',
}
### MySQL database setup code ends here.

### Apache webserver setup code starts here.

class { '::apache' :
  default_vhost => false,
}

file { $apache_docroot :
  ensure => directory,
  mode   => '0755',
}

webserver_setup::setup_vhosts { $vhosts_list : } 

### Apache code ends

}
