class apache2::proxy
{ 
 file {
        "/etc/apache2/mods-enabled/proxy.conf":
          ensure => "/etc/apache2/mods-available/proxy.conf",
          require => Package[apache2],
          notify => Service[apache2],
        }
        
 file {
        "/etc/apache2/mods-enabled/proxy_http.load":
          ensure => "/etc/apache2/mods-available/proxy_http.load",
          require => Package[apache2],
          notify => Service[apache2],
        }   

  file {
        "/etc/apache2/mods-enabled/proxy.load":
          ensure => "/etc/apache2/mods-available/proxy.load",
          require => Package[apache2],
          notify => Service[apache2],
        }   
}