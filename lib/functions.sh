# Shell functions for the rundeck module.
#/ usage: source RERUN_MODULE_DIR/lib/functions.sh command
#

# Read rerun's public functions
. $RERUN || {
	echo >&2 "ERROR: Failed sourcing rerun function library: \"$RERUN\""
	return 1
}

# Check usage. Argument should be command name.
[[ $# = 1 ]] || rerun_option_usage

# Source the option parser script.
#
if [[ -r $RERUN_MODULE_DIR/commands/$1/options.sh ]]
then
	. $RERUN_MODULE_DIR/commands/$1/options.sh || {
		rerun_die "Failed loading options parser."
	}
fi

# - - -
# Your functions declared here.
# - - -


# Curl opts to accept insecure certs, follow redirects, show only errors
CURLOPTS="-k -s -S -L"

#
# _rundeck_curl_ - The curl wrapper function
#
#     rundeck_curl ?curl-args?
#
# Arguments:
#
# * curl-args: Any valid set of curl arguments
#
# Notes:
rundeck_curl() {
	command curl --user-agent "rerun/$RERUN_VERSION rundeck-project/${RERUN_MODULE_VERSION:-}" $CURLOPTS "$@"
}

#
# - - -
#

#
# _rundeck_login_ - Login to rundeck and get a session
#
#     rundeck_login_session url user password
#
# Arguments:
#
# * url:      The URL to rundeck.
# * user:     The login user name.
# * password: The password for login.
#
# Notes:
rundeck_login_session(){
	(( $# != 3 )) && {
		rerun_die 2 "usage: rundeck_login: url user password"
	}
	local -r url=$1 user=$2 password=$3

	# Where to store the login cookies
	local COOKIES=$(mktemp -t "cookies.XXXXX")

	local http_code errors
	local loginurl="${url}/j_security_check"
	local xmlstarletopts='-H'

	# Request the login form.
	if http_code=$(rundeck_curl --fail -w "%{http_code}" $url 2>/dev/null)
	then
		# Temporary file to store results.
		local -r curl_out=$(mktemp -t "login.XXXXX")

		# Submit the username and password to the login form.
		if ! http_code=$(rundeck_curl -c $COOKIES -b $COOKIES -w "%{http_code}"  -d j_username=$user -d j_password=$password \
			-X POST $loginurl 2>/dev/null -o $curl_out)
		then
			rerun_die 3 "curl request failed to $loginurl (exit code: $?)"
		fi
	else
		if [ "$http_code" = "404" ]
		then
			xmlstarletopts=''
			local loginurl="${url}/api/2/system/info"
			local -r curl_out=$(mktemp -t "login.XXXXX")
		  CURLOPTS="$CURLOPTS -u ${user}:${password}"
			if ! http_code=$(rundeck_curl -c $COOKIES -b $COOKIES -w "%{http_code}" $loginurl 2>/dev/null -o $curl_out)
			then
				rerun_die 3 "curl request failed to $loginurl (exit code: $?)"
			fi
		else
			rerun_die 3 "curl request failed to $url (exit code: $?)"
		fi
	fi
	case ${http_code:-} in
		200) : ;; # successful
		* ) rerun_die 3 "login failure (http_code: '$http_code'): ${url}" ;;
	esac
	# Parse the login result page. It might contain an error.
	# Convert the result into well formed xhtml so we can query it.
	if ! errors=$(xmlstarlet fo -R $xmlstarletopts $curl_out 2>/dev/null |
		# Query the result page for the error message.
		xmlstarlet sel -N x=http://www.w3.org/1999/xhtml \
			-t -m "//x:div[@class='login']/x:form/x:div[@class='message']/x:span[@class='error']" -v .)
		then
			:; # no login error message. successfully logged in.
		fi
		rm "${curl_out}"; # clean up.

		# Fail if there was an error.
		[[ -n "${errors:-}" ]] && {
		rerun_die 3 "Login failure. error: $errors"
	}

	echo $COOKIES
	return 0
}

#
# - - -
#

rundeck_authenticate() {
	OPTIND=1
	local url username password apikey cookies
	while getopts "u:U:p:k:" opt; do
		case "$opt" in
			u) url=$OPTARG ;;
			U) username=$OPTARG ;;
			p) password=$OPTARG ;;
			k) apikey=$OPTARG ;;
		esac
	done

	if [[ -n "${password:-}" && -n "${username:-}" ]]
	then
		COOKIES=$(rundeck_login_session "$URL" "$username" "$password")
		CURLOPTS="$CURLOPTS -c $COOKIES -b $COOKIES -u ${username}:${password}"
	elif [[ -z "${password:-}" && -n "${apikey:-}" ]]; then
		CURLOPTS="$CURLOPTS -H X-Rundeck-Auth-Token:$apikey"
	else
		rerun_die 2 "Either use --username <> --password <> ...or... --apikey <>"
	fi
}
