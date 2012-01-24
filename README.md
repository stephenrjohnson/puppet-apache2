# Apache Puppet Module

Just a quick hacked together module to handle the installation of apache and a simple vhost setup.

## Usage

### Install apache

Add the follow to your node def

 class { "apache2": enablessl => true ;}

 Or even 

 class { "apache2": enablessl => true, enableproxy => true ;}

 Please look at the source to find out other options

### SSL Certs
apache2::sslkeys{"wildcard": ;}

It will pull the files out of apache2/etc/apache2/ssl/$name.ca, apache2/etc/apache2/ssl/$name.key, apache2/etc/apache2/ssl/$name.cert


### Vhost

 apache2::vhost { "testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com', docroot => '/var/testsite' ; }
 apache2::vhost { "testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com', docroot => '/var/testsite',
                 ssl => true,  sslkeys => "wildcard" ; }

### Proxy
  apache2::vproxy{ "testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com',
                 proxypass => "/  http://localhost:8080/", proxypassreverse => "/ , http://localhost:8080/", proxyhost => "http://localhost:8080/" }
  apache2::vproxy{ "testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com', 
                 ssl => true, proxypass => "/ , http://localhost:8080/", proxypassreverse => "/,  http://localhost:8080/", proxyhost => "http://localhost:8080/", sslkeys => "wildcard"; }
{   
### Issues
  * Dedian / ubuntu only
  * No require for the ssl keys
  * Can't define custom ssl options
  * Can't use custom ports just yet
  * Vhosts are very brittle ( not that many options)
  * NO TESTS
  * Written by me lol 
