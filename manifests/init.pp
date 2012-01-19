class apache2 ($defaultsite = false, $disablehttp = false, $enablessl = false, $defaultsslsite = false, $security = true){
       
    ##Install the apache module
    package { apache2: ensure => installed; }
       
    service { apache2:
        ensure => running,
        enable => true,
        hasrestart => true,
        hasstatus => true,
        require => [File["/etc/apache2/apache2.conf"],Package[apache2]];
    }

    if ($enablessl == true)
    {
        class { "apache2::ssl": defaultsite => $defaultsslsite ;}
        
        file 
        {
            "/etc/apache2/ssl":
            ensure => directory,
            require => Package[apache2],
            mode => 0755;
        }

    }

    File {
        owner => root,
        group => root,
    }
    
    ##disable http if we want to 
    file { "/etc/apache2/ports.conf":
        ensure => present,
        mode => 0440,
        owner => root,
        group => root,
        require => Package[apache2],
        notify => Service[apache2],
        content => template("apache2/ports.conf.erb");
    }
    
    file {
        # Roll out a consistent httpd.conf
        "/etc/apache2/apache2.conf":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/conf/apache2.conf",
            notify => Service[apache2], # maybe not a great idea, but restarts should be rare
            require => Package[apache2];

        "/var/log/apache2":
            ensure => directory,
            require => Package[apache2],
            mode => 0755;
    }

    file {
	 "/etc/apache2/mods-enabled/rewrite.load":
	 ensure => "../mods-available/rewrite.load",
	 require => Package[apache2],
	}
	
    if ($security == true)
    {
        
        file {
            "/etc/apache2/conf.d/security":
            ensure => present,
            mode => 0444,
            source => "puppet:///modules/apache2/etc/apache2/conf.d/security",
            notify => Service[apache2], # maybe not a great idea, but restarts should be rare
            require => Package[apache2];
        }

    }
	if ( $defaultsite == true)
	{
		 file {
            "/etc/apache2/sites-enabled/000-default":
              ensure => "/etc/apache2/sites-available/default",
              require => Package[apache2],
              notify => Service[apache2],
            } 
	}
	else
	{
		 file {
            "/etc/apache2/sites-enabled/000-default":
              ensure => absent,
              require => Package[apache2],
              notify => Service[apache2],
            } 
	}
	  
}
