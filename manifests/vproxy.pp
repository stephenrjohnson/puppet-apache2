# generic vhost template, probably not that useful for very custom vhosts
define apache2::vproxy($servername = '', $serveradmin = 'root@localhost', $aloglevel = 'warn', 
                        $serveralias = '', $port = false, $listen = "*", $ssl = false, 
                        $sslcert = "", $sslkey = "",$sslca = "", $proxypass = false, $proxypassreverse= false,
                        $proxyrequests = "off", $proxyhost = false ) 
{   
    #sort out that we need apache2
    Class['apache2']->Apache2::Vproxy[$name]

    #if we are ssl then we need the ssl module
    if $ssl != false
    {
       Class['apache2::ssl']->Apache2::Vproxy[$name] 
    }

    #sort out the default port values 
    if $port == false and ssl == false
    {
        $aport = 80
    }
    elsif $port == false and ssl != false
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
        require => [Package[apache2],File["/var/log/apache2"],File[$docroot]],
        notify => Service[apache2],
        content => template("apache2/vproxy.conf.erb");
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
            require => Package[apache2];
        }
        
         file {
            "/etc/apache2/ssl/$sslkey":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslkey",
            require => Package[apache2];
        }
        
         file {
            "/etc/apache2/ssl/$sslca":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslca",
            require => Package[apache2];
        } 
    }
}


