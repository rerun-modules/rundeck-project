Use **delete** to remove a project in the specified rundeck.

Examples
--------

Remove a project called "qa1":

    rerun rundeck-project:delete --project qa1 \
        --url http://rundeck1:4440 \
        --user admin --password admin

ACL
---
	description: allow api_token_group to delete executions in myproject
	by:
	  group: api_token_group
	context:
	  application: rundeck
	for:
	  project:
	  - allow: delete_execution
	    equals:
	      name: myproject
