class apache2::ssl ($defaultsite = false)
{
  file 
      {
        "/etc/apache2/ssl":
        ensure => directory,
        require => Package[apache2],
        mode => 0755;
      }
	 
  if ( $defaultsite == true)
  {
    file {
            "/etc/apache2/sites-enabled/000-default-ssl":
            ensure => "/etc/apache2/sites-available/default-ssl",
            require => Package[apache2],
            notify => Service[apache2],
          }
  }
 file {
        "/etc/apache2/mods-enabled/ssl.conf":
          ensure => "/etc/apache2/mods-available/ssl.conf",
          require => Package[apache2],
          notify => Service[apache2],
        }
        
 file {
        "/etc/apache2/mods-enabled/ssl.load":
          ensure => "/etc/apache2/mods-available/ssl.load",
          require => Package[apache2],
          notify => Service[apache2],
        }   
}