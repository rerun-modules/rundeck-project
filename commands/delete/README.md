Use **delete** to remove a project in the specified rundeck.

Examples
--------

Remove a project called "qa1":

    rerun rundeck-project:delete --project qa1 \
        --url http://rundeck1:4440 \
        --user admin --password admin
