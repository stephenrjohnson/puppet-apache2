define apache2::sslkey( $sslcert = "", $sslkey = "",$sslca = "" ) 
{   
        file {
            "/etc/apache2/ssl/$sslcert":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslcert",
             notify => Service[apache2],
        }
        
         file {
            "/etc/apache2/ssl/$sslkey":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslkey",
            notify => Service[apache2],
        }
        
         file {
            "/etc/apache2/ssl/$sslca":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/ssl/$sslca",
            notify => Service[apache2],
        }
}