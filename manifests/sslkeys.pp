define apache2::sslkeys()
{
        file {"/etc/apache2/ssl/${name.cert}":
            ensure  => present,
            mode    => '0444',
            source  => "puppet:///modules/apache2/etc/apache2/ssl/${name.cert}",
            notify  => Service[apache2],
        }

        file {"/etc/apache2/ssl/${name.key}":
            ensure  => present,
            mode    => '0444',
            source  => "puppet:///modules/apache2/etc/apache2/ssl/${name.key}",
            notify  => Service[apache2],
        }

        file {"/etc/apache2/ssl/${name.ca}":
            ensure  => present,
            mode    => '0444',
            source  => "puppet:///modules/apache2/etc/apache2/ssl/${name.ca}",
            notify  => Service[apache2],
        }
}