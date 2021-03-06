# = Class: icinga::repository
#
# This class configures the repository for Icinga
#
#
class icinga::repository {

  if ( $::icinga::bool_enable_debian_repo_legacy != true and
       $::operatingsystem =~ /(?i:Ubuntu|Mint)/ and
       $::icinga::bool_manage_repos == true
  ) {

    # The repos as suggested by icinga:
    # https://wiki.icinga.org/display/howtos/Setting+up+Icinga+Web+on+Ubuntu
    #
    apt::repository { 'icinga-web':
      url        => 'http://ppa.launchpad.net/formorer/icinga-web/ubuntu',
      distro     => 'precise',
      repository => 'main',
    }

    apt::repository { 'icinga':
      url        => 'http://ppa.launchpad.net/formorer/icinga/ubuntu',
      distro     => 'precise',
      repository => 'main',
    }

    apt::key { 'icinga':
      keyserver => 'keyserver.ubuntu.com',
      fingerprint => '36862847',
    }
  }

  if ( $::icinga::bool_enable_debian_repo_legacy == true or
     ($::operatingsystem =~ /(?i:Debian)/ and $::icinga::bool_manage_repos == true)
  ) {

    if $::lsbmajdistrelease < 7 {
      if $::icinga::bool_firewall {
        firewall { 'icinga-apt-repo':
          destination    => 'icingabuild.dus.dg-i.net',
          port           => 80,
          protocol       => 'tcp',
          direction      => 'output'
        }
      }
  
      # Perhaps on Debian we should use the packages from debmon.org
      apt::repository { 'icinga':
        url        => 'http://icingabuild.dus.dg-i.net/',
        distro     => "icinga-web-${::lsbdistcodename}",
        repository => 'main',
      }
    } else {
      if $::icinga::bool_firewall {
        firewall { 'icinga-apt-repo':
          destination    => 'debmon.org',
          port           => 80,
          protocol       => 'tcp',
          direction      => 'output'
        }
      }
  
      # Perhaps on Debian we should use the packages from debmon.org
      apt::repository { 'icinga':
        url        => 'http://debmon.org/debmon',
        distro     => "debmon-${::lsbdistcodename}",
        repository => 'main',
        key        => '2048R/29D662D2',
        key_url    => 'http://debmon.org/debmon/repo.key',
      }
    }
  }
}
