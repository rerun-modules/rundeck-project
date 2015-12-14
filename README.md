## Overview

Use *rundeck-project* to administrate Rundeck project life cycle.

## Common options

Most of the rundeck-project commands use the same options to connect to the rundeck server and specify the project to administrate. Several of these can be defaulted to environment variable values.

	--project <> --<$RUNDECK_URL> --user <$RUNDECK_USER> --password <$RUNDECK_PASSWORD>

## Examples
Use environment variables to default URL and credentials

	export RUNDECK_URL=http://targa.local:4440 RUNDECK_USER=admin RUNDECK_PASSWORD=admin

List existng projects

	$ rerun  rundeck-project:list
	guitars-demo
	anvils-demo

Add a new project. 

	$ rerun rundeck-project:create --project foo --templates $RERUN_MODULES/rundeck-project/templates/example


List the projects again. You will see the 'foo' project listed.

	guitars-demo
	anvils-demo
	foo

There are no ACLs for this project yet:

	$ rerun  rundeck-project:acls-list --project foo

Add a new ACL policy to the project:

	$ rerun  rundeck-project:acls-create --project foo --file anyone-allow-resource.aclpolicy

Run the listing again. The anyone-allow-resource.aclpolicy policy is shown.

	$ rerun  rundeck-project:acls-list --project foo
	anyone-allow-resource.aclpolicy

Get the ACL policy file

	$ rerun  rundeck-project:acls-get --project foo --aclpolicy anyone-allow-resource.aclpolicy
	description: 'Given user in group ".*" and for resource, then allow action [read].'
	for:
	  resource:
	    - allow: [read]
	by:
	  group: '.*'

Delete an ACL Policy

	$ rerun  rundeck-project:acls-delete --project foo --aclpolicy anyone-allow-resource.aclpolicy
