
Example config file:

	<scmPluginConfig>
		<config>
			<entry key="dir">$dirname</entry>
			<entry key="url">$gitdir</entry>
			<entry key="committerName">A User</entry>
			<entry key="committerEmail">aUser@test.com</entry>
			<entry key="pathTemplate">\${job.group}\${job.name}-\${job.id}.\${config.format}</entry>
			<entry key="format">xml</entry>
			<entry key="branch">master</entry>
			<entry key="strictHostKeyChecking">yes</entry>
		</config>
	</scmPluginConfig>