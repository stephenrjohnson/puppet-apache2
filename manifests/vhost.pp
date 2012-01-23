# generic vhost template, probably not that useful for very custom vhosts
define apache2::vhost($servername = '', $serveradmin = 'root@localhost', $docroot = '/var/empty', 
                      $aloglevel = 'warn', $serveralias = '', $port = false, $listen = "*",
                       $ssl = false, $sslcert = "", $sslkey = "",$sslca = "" ) 
{   
    #sort out that we need apache2
    Class['apache2']->Apache2::Vhost[$name]

    #if we are ssl then we need the ssl module
    if $ssl != false
    {
       Class['apache2::ssl']->Apache2::Vhost[$name] 
    }

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
        }
        
         file {
            "/etc/apache2/ssl/$sslkey":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslkey",
        }
        
         file {
            "/etc/apache2/ssl/$sslca":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslca",
        } 
    }
}


