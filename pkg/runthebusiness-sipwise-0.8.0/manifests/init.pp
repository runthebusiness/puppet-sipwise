# sipwise
#
# This class installs sipwise package and configures it
#
# Parameters:
#  - cdrexportpassword: cdrexport users password (Default: undef)
#  - mysqlrootpassword: mysql root user password (Default: undef)
#  - mysqloldpassword: old mysql root user password (Default: undef)


define sipwise(
	$cdrexportpassword=undef,
	$mysqlrootpassword=undef,
	$mysqloldpassword=undef,
) {
	
	include sipwise::params
	# run the ngcp installer
	::sipwise::ngcp{"ngcpinstall":

	}

	# configure the crdexport
	::sipwise::cdrexport{"cdrexportconfig":
		cdrexportpassword=>$cdrexportpassword,
		require=>::Sipwise::Ngcp["ngcpinstall"]
	}

	# configure mysql
	::sipwise::mysql{"mysqlconfig":
		mysqlrootpassword=>$mysqlrootpassword,
		mysqloldpassword=>$mysqloldpassword,
		require=>::Sipwise::Ngcp["ngcpinstall"]
	}

	#TODO: find a way to configure the login for the web portal
}
