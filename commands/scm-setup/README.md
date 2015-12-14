Use *scm-setup* to get and update the SCM plugins.

## Examples

The examples below show how to setup and get the configuration for the SCM import plugin. 

### Config file
Typically, just three configuration keys are site specific:

* url: the URL to the git repo
* sshPrivateKeyPath: this is the path into the keystore containing the SSH key used to access Git
* dir: the directory to where the working directory (usually, $RDECK_BASE/projects/$PROJECT/scm)

Create a configuration: git-import.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<scmPluginConfig>
	  <config>
	    <entry key="url">git@github.com:ahonor/anvils-demo-jobs.git</entry>
	    <entry key="dir">/home/rundeck/projects/anvils-demo/scm</entry>
	    <entry key="committerEmail">${user.email}</entry>
	    <entry key="committerName">${user.fullName}</entry>
	    <entry key="strictHostKeyChecking">no</entry>
	    <entry key="sshPrivateKeyPath">keys/anvils-demo/git-access-key</entry>
	    <entry key="format">xml</entry>
	    <entry key="branch">master</entry>
	    <entry key="gitPasswordPath"/>
	    <entry key="pathTemplate">${job.group}${job.name}-${job.id}.${config.format}</entry>
	  </config>
	</scmPluginConfig>

> Note, be sure the key you referenced has already been loaded to the keystore before running the setup.

### Setup plugin

Set up the import plugin. Before running the setup, be sure you have already loaded the SSH key referenced in the config file to the Rundeck key store.

	$ rerun rundeck-project:scm-setup --project anvils-demo --scm-integration import --action post

### Get the plugin configuraiton

Get the current setup for the import plugin. 

	$ rerun rundeck-project:scm-setup --project anvils-demo --scm-integration import
	<?xml version="1.0" encoding="UTF-8"?>
	<scmProjectPluginConfig>
	  <config>
	    <entry key="url">git@github.com:ahonor/anvils-demo-jobs.git</entry>
	    <entry key="dir">/home/rundeck/projects/anvils-demo/scm</entry>
	    <entry key="committerEmail">${user.email}</entry>
	    <entry key="committerName">${user.fullName}</entry>
	    <entry key="strictHostKeyChecking">no</entry>
	    <entry key="sshPrivateKeyPath">keys/anvils-demo/git-access-key</entry>
	    <entry key="format">xml</entry>
	    <entry key="branch">master</entry>
	    <entry key="gitPasswordPath"/>
	    <entry key="pathTemplate">${job.group}${job.name}-${job.id}.${config.format}</entry>
	  </config>
	  <enabled>true</enabled>
	  <integration>import</integration>
	  <project>anvils-demo</project>
	  <type>git-import</type>
	</scmProjectPluginConfig>

> Note, the XML document is a bit different than the one used to setup the plugins. You can reuse the data by changing the root element to `scmPluginConfig` and keep just the `config` element.

