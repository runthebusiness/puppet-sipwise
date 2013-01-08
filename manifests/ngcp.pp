#  ngcp
#
# This class installs sipwise package main components from ngcp installer
#
# Parameters:
#  - ngcpeaddress: a config file setting for ngcp (Default: 127.0.0.1)

# Sample Usage:
#	::sipwise::ngcp{"ngcpinstall":
#
#	}
#
define sipwise::ngcp(
	$ngcpeaddress="127.0.0.1",
) {
	include sipwise::params

	#general use variables:
	$downloadpath = "${sipwise::params::ngcpdownloadto}${sipwise::params::ngcppackagefile}"
	$sourceurl = "${sipwise::params::ngcppackageurl}${sipwise::params::ngcppackagefile}"

	#test if the admin service got installed -- the whole package probably is if this service is installed
	$testservicename = "ngcp-www-admin"
	$testifinstalled = "dpkg -s ${testservicename} | /bin/grep 'Status: install ok installed'"

	# commands to be run by exec
	$wgetcommand ="wget -O ${downloadpath} ${sourceurl}"
	$installcommand = "yes | /bin/bash /usr/sbin/ngcp-installer"
	$ngcpcfgcommand ="ngcpcfg apply"


	# Download the ngcp installer
	# since ngcp does not have an apt package and puppet can't do http sources we have to get it this way
	exec {"getngcppackage":
		command=>$wgetcommand,
		cwd=> $sipwise::params::executefrom,
		path=> $sipwise::params::execlaunchpaths,
		creates=>$downloadpath,
		logoutput=> on_failure,
		#require=>file["installersdirectory"]
	}

	#Install ngcp installer package
	package { 'installngcppackage':
		name=> "ngcp",
		ensure=> present,
		provider=>dpkg,
		source=> $downloadpath,
		require=>exec['getngcppackage'],
  }

  # run the installer
 	exec {"runngcpinstaller":
		command=> $installcommand,
		cwd=> $sipwise::params::executefrom,
		path=> $sipwise::params::execlaunchpaths,
		logoutput=> on_failure,
		unless=>$testifinstalled,
		timeout=>1200,
		require=>package['installngcppackage']
	}


	# template the config.yaml file
	file {"conftemplateconfig":
		path=>$sipwise::params::ngcpconffilepath,
		ensure=>"present",
		content => template('sipwise/config.erb'),
		require=>exec['runngcpinstaller'],
	}

	# applies the changes in the config file and restarts the service
	exec {"restartngcp":
		command=> $ngcpcfgcommand,
		cwd=> $sipwise::params::executefrom,
		path=> $sipwise::params::execlaunchpaths,
		logoutput=> on_failure,
		subscribe=>file['conftemplateconfig']
	}


}
