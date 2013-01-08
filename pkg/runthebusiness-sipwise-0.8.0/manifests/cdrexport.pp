# cdrexport
#
# This class configs the cdrexport user
#
# Parameters:
#  - cdrexportpassword: cdrexport users password (Default: password)
#
# Sample Usage:
#  sipwise::cdrexpor{"cdrexportconfig":
#    cdrexportpassword=>$cdrexportpassword,
# }
#
define sipwise::cdrexport(
	$cdrexportpassword="password",
) {
	include sipwise::params
	
	# make sure the user exists with the right password
	user {"crdexportuser":
		name=>"cdrexport",
		ensure=>"present",
		password => $cdrexportpassword,
	}
}
