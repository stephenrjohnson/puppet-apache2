# Apache Puppet Module

Just a quick hacked together module to handle the installation of apache and a simple vhost setup.

## Usage

### Install apache

Add the follow to your node def

 class { "apache2": enablessl => true ;}

 Or even 

 class { "apache2": enablessl => true, enableproxy => true ;}

 Please look at the source to find out other options

### Vhost

 apache2::vhost { "testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com', docroot => '/var/testsite' ; }
 apache2::vhost { "testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com', docroot => '/var/testsite',
                 ssl => true, sslcert => "somecert", sslkey => "somekey", sslca => "someca"; }

### Proxy

  apache2::vproxy("testsite" : servername => 'testsites.testdomain.com', serveradmin => 'root@testite.com', docroot => '/var/testsite',
                 ssl => true, sslcert => "somecert", sslkey => "somekey", sslca => "someca"; proxypass => "/  http://localhost:8080/", 
                 proxypassreverse => "/  http://localhost:8080/", proxyhost => "http://localhost:8080/" ) 
{   
### Issues
  * Dedian / ubuntu only
  * Can't define custom ssl options
  * Can't use custom ports just yey
  * Can't use the same ssl keys for multiple vhosts
  * Vhosts are very brittle ( not that many options)
  * NO TESTS
  * Written by me lol 
