# sipwise::params
#
# Params for sipwise based on flavor of system
#

# Actions:
#
# Requires:
#
# Sample Usage:
#
class sipwise::params {
	
	case $::operatingsystem {
		'centos', 'redhat', 'fedora': {
			 #TODO: Change from debian defaults to work for these flavors
				$ngcpdownloadto="/usr/src/"
				$ngcppackageurl="http://deb.sipwise.com/spce/"
				$ngcppackagefile="ngcp-installer-latest.deb"
				$ngcpconffilepath ="/etc/ngcp-config/config.yml"
	    }
	    'ubuntu', 'debian': {
				$ngcpdownloadto="/usr/src/"
				$ngcppackageurl="http://deb.sipwise.com/spce/"
				$ngcppackagefile="ngcp-installer-latest.deb"
				$ngcpconffilepath ="/etc/ngcp-config/config.yml"
	    }
	    default: {
				$downloadpath='/usr/src/'
				$ngcpdownloadto="/usr/src/"
				$ngcppackageurl="http://deb.sipwise.com/spce/"
				$ngcppackagefile="ngcp-installer-latest.deb"
				$ngcpconffilepath ="/etc/ngcp-config/config.yml"
		}
	}
	$execlaunchpaths= ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "/etc"]
	$executefrom = "/tmp/"
}
