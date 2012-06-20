# generic vproxy template, probably not that useful for very custom vproxy
define apache2::vproxy($servername = '', $serveradmin = 'root@localhost',
                        $aloglevel = 'warn', $serveralias = '', $port = false,
                        $listen = '*', $ssl = false, $proxypass = false,
                        $proxypassreverse= false, $proxyrequests = 'off',
                        $proxyhost = false, $sslkeys = false )
{
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

    if $ssl != false
    {
        $sslcert = "${sslkeys}.cert"
        $sslkey = "${sslkeys}.key"
        $sslca = "${sslkeys}.ca"
    }

    file { "/etc/apache2/sites-available/$name.conf":
        ensure  => present,
        mode    => '0440',
        owner   => root,
        group   => root,
        notify  => Service[apache2],
        content => template('apache2/vproxy.conf.erb');
    }

    file { "/etc/apache2/sites-enabled/$name.conf":
        ensure => link,
        target => "/etc/apache2/sites-available/${name}.conf",
        notify => Service[apache2],
    }
}
