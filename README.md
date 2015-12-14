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

## Templates

With *rundeck-project:provision", you can provision projects using templates. Templates are organized in a structure shown below:

* project.xml: (obtain one via `rundeck-project:config --project <>  --format xml`)
* acl/: Contains abitrary .aclpolicy files
* scm/git-{export,import}.xml: (obtain one via `rundeck-project:scm-setup --project <>  --scm-integration import/export`)



Example templates directory

	templates/example
	├── acl
	│   ├── anyone-allow-resource.aclpolicy
	│   ├── anyone-node-allow.aclpolicy
	│   ├── anyone-resource-allow.aclpolicy
	│   ├── dev-jobs-allow-web_Restart.aclpolicy
	│   ├── dev-jobs-allow-web_Status.aclpolicy
	│   ├── dev-node-allow-www.aclpolicy
	│   ├── ops-jobs-allow-anvils.aclpolicy
	│   ├── ops-jobs-allow-db.aclpolicy
	│   ├── ops-jobs-deny-releng_Promote.aclpolicy
	│   ├── ops-node-allow-all.aclpolicy
	│   └── releng-jobs-allow-release_Promote.aclpolicy
	├── project.xml
	└── scm
	    ├── git-export.xml
	    └── git-import.xml

	2 directories, 14 files

