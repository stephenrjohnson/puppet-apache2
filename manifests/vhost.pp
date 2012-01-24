# generic vhost template, probably not that useful for very custom vhosts
define apache2::vhost($servername = '', $serveradmin = 'root@localhost', $docroot = '/var/empty', 
                      $aloglevel = 'warn', $serveralias = '', $port = false, $listen = "*",
                       $ssl = false, $sslkeys = false ) 
{   
    #sort out the default port values 
    if ( $port == false and $ssl == false )
    {
        $aport = 80
    }
    elsif ( $port == false and $ssl != false )
    {
       $aport = 443
    }
    else
    {
        $aport = $port 
    }

    file { "/etc/apache2/sites-available/$name.conf":
        ensure => present,
        mode => 0440,
        owner => root,
        group => root,
        notify => Service[apache2],
        content => template("apache2/vhost.conf.erb");
    }

    if $ssl != false
    {
       $sslcert = $sslkeys + ".cert"
       $sslkey = $sslkeys + ".key"
       $sslca = $sslkeys + ".ca"
    }


    file { "/etc/apache2/sites-enabled/$name.conf":
          ensure => "/etc/apache2/sites-available/$name.conf",
          notify => Service[apache2],
    }
    
    file { $docroot:
        ensure => directory,
          require => Package[apache2],
    }

}


