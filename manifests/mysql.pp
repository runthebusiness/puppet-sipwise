# sipwise::mysq
#
# This class configures the mysql installation created by ngcp installer
#
# Parameters:
#  - mysqlrootpassword: mysql root user password (Default: 'UNSET')
#  - mysqloldpassword: old mysql root user password (Default: '')
#
# Sample Usage:
#  ::sipwise::mysql{"mysqlconfig":
#		mysqlpassword=>$mysqlpassword,
#  }
#
define sipwise::mysql(
	$mysqlrootpassword="UNSET",
	$mysqloldpassword=''
) {
	include sipwise::params
	
	# Modified from puppetlabs-mysql module
	# manage root password if it is set
	if $mysqlrootpassword != 'UNSET' {
		case $mysqloldpassword {
			'':      { $old_pw='' }
			default: { $old_pw="-p'${mysqloldpassword}'" }
		}
		
		exec { 'set_mysql_rootpw':
			command   => "mysqladmin -u root ${old_pw} password '${mysqlrootpassword}'",
			logoutput => true,
			unless    => "mysqladmin -u root -p'${mysqlrootpassword}' status > /dev/null",
			cwd=> $sipwise::params::executefrom,
			path=> $sipwise::params::execlaunchpaths,
			#notify    => Exec['mysqld-restart'],
		}
	}
  
  # Unused code from puppetlabs-mysql:
	# set the root password for mysql
	#class { 'mysql::config':
		#root_password => $mysqlpassword,
		#bind_address  => $::ipaddress,
	#}

	#class { 'mysql::server':
		#config_hash => {
			#root_password => $mysqlpassword,
		#}
	#}

	#set some useful shared variables
	#$execlaunchpaths= ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "/etc"]
	#$executefrom = "/tmp/"

	# commands to be run by exec
	#$mysqlpasswordcommand="mysqladmin password ${mysqlpassword}"


	# set mysql password
	#exec {"mysqlpassword":
		#command=> $mysqlpasswordcommand,
		#cwd=> $executefrom,
		#path=> $execlaunchpaths,
		#logoutput=> on_failure,
		#require=>file['conftemplateconfig'],
		#subscribe=>file['conftemplateconfig']
	#}

}
