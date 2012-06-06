class apache2 ($defaultsite = false, $disablehttp = false,
    $enablessl = false, $enableproxy = false,
    $defaultsslsite = false, $security = true){
    ##Install the apache module
    package { 'apache2': ensure => installed; }

    service { 'apache2':
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
        require     => File['/etc/apache2/apache2.conf'];
    }

    if ($enablessl == true)
    {
        class { 'apache2::ssl': defaultsite => $defaultsslsite ;}
    }

    if ($enableproxy == true)
    {
        class { 'apache2::proxy': ;}
    }

    File {
        owner => root,
        group => root,
    }

    file {'/etc/apache2/ports.conf':
        ensure  => present,
        mode    => '0440',
        owner   => root,
        group   => root,
        require => Package[apache2],
        notify  => Service[apache2],
        content => template('apache2/ports.conf.erb');
    }

    file {'/etc/apache2/apache2.conf':
            ensure  => present,
            mode    => '0444',
            source  => 'puppet:///modules/apache2/etc/apache2/conf/apache2.conf',
            notify  => Service[apache2],
            require => Package[apache2];

        '/var/log/apache2':
            ensure  => directory,
            require => Package[apache2],
            mode    => '0755';
    }

    file {'/etc/apache2/mods-enabled/rewrite.load':
    ensure   => link,
    target   => '../mods-available/rewrite.load',
    require  => Package[apache2],
    }

    if ($security == true)
    {

        file {'/etc/apache2/conf.d/security':
            ensure  => present,
            mode    => '0444',
            source  => 'puppet:///modules/apache2/etc/apache2/conf.d/security',
            notify  => Service[apache2],
            require => Package[apache2];
        }

    }
    if ( $defaultsite == true)
    {
        file {'/etc/apache2/sites-enabled/000-default':
              ensure    => link,
              target    => '/etc/apache2/sites-available/default',
              require   => Package[apache2],
              notify    => Service[apache2],
        }
    }
    else
    {
        file {'/etc/apache2/sites-enabled/000-default':
                ensure    => absent,
                require   => Package[apache2],
                notify    => Service[apache2],
            }
    }
}