# generic vhost template, probably not that useful for very custom vhosts
define apache2::vhost($servername = '', $serveradmin = 'root@localhost', $docroot = '/var/empty', 
                      $aloglevel = 'warn', $serveralias = '', $logtime = false, $logextra = true, 
                      $port = "80", $listen = "*", $ssl = false, $sslcert = "", $sslkey = "",$sslca = "" ) 
{   
    #sort out that we need apache2
    Class['apache2']->Apache2::Vhost[$name]


    file { "/etc/apache2/sites-available/$name.conf":
        ensure => present,
        mode => 0440,
        owner => root,
        group => root,
        require => [Package[apache2],File["/var/log/apache2"],File[$docroot]],
        notify => Service[apache2],
        content => template("apache2/vhost.conf.erb");
    }

    file { "/etc/apache2/sites-enabled/$name.conf":
	      ensure => "/etc/apache2/sites-available/$name.conf",
	      notify => Service[apache2],
    }
    
    file { $docroot:
        ensure => directory,
    	  require => Package[apache2],
    }

    if ($ssl == true)
    {
        file {
            "/etc/apache2/ssl/$sslcert":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslcert",
            require => [Package[apache2], Class[apache2::ssl]];
        }
        
         file {
            "/etc/apache2/ssl/$sslkey":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslkey",
            require => [Package[apache2], Class[apache2::ssl]];
        }
        
         file {
            "/etc/apache2/ssl/$sslca":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslca",
            require => [Package[apache2], Class[apache2::ssl]];
        } 
    }
}


