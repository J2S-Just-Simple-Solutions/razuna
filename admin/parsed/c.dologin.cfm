<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: dologin --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "dologin">
<cfif myFusebox.applicationStart or
		not myFusebox.getApplication().applicationStarted>
	<cflock name="#application.ApplicationName#_fusebox_#FUSEBOX_APPLICATION_KEY#_appinit" type="exclusive" timeout="30">
		<cfif not myFusebox.getApplication().applicationStarted>
<!--- fuseaction action="m.initialize" --->
<cfset myFusebox.thisCircuit = "m">
<cfset myFusebox.thisFuseaction = "initialize">
<cfset myFusebox.getApplicationData().Login = createObject("component","global.cfc.login") >
<cfset myFusebox.getApplicationData().Login.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Groups = createObject("component","global.cfc.groups") >
<cfset myFusebox.getApplicationData().Groups.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Groups_Users = createObject("component","global.cfc.groups_users") >
<cfset myFusebox.getApplicationData().Groups_Users.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Users = createObject("component","global.cfc.users") >
<cfset myFusebox.getApplicationData().Users.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Modules = createObject("component","global.cfc.modules") >
<cfset myFusebox.getApplicationData().Modules.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Global = createObject("component","global.cfc.global") >
<cfset myFusebox.getApplicationData().Global.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Hosts = createObject("component","global.cfc.hosts") >
<cfset myFusebox.getApplicationData().Hosts.init(application.razuna.datasource, application.razuna.thedatabase) >
<cfset myFusebox.getApplicationData().Settings = createObject("component","global.cfc.settings") >
<cfset myFusebox.getApplicationData().Settings.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#",setid="#application.razuna.setid#") >
<cfset myFusebox.getApplicationData().Folders = createObject("component","global.cfc.folders") >
<cfset myFusebox.getApplicationData().Folders.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#") >
<cfset myFusebox.getApplicationData().security = createObject("component","global.cfc.security") >
<cfset myFusebox.getApplicationData().security.init(application.razuna.datasource) >
<cfset myFusebox.getApplicationData().rssparser = createObject("component","global.cfc.rssparser") >
<cfset myFusebox.getApplicationData().rssparser.init() >
<cfset myFusebox.getApplicationData().update = createObject("component","global.cfc.update") >
<cfset myFusebox.getApplicationData().update.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#") >
<cfset myFusebox.getApplicationData().amazon = createObject("component","global.cfc.amazon") >
<cfset myFusebox.getApplicationData().amazon.init() >
<cfset myFusebox.getApplicationData().defaults = createObject("component","global.cfc.defaults") >
<cfset myFusebox.getApplicationData().defaults.init(dsn="#application.razuna.datasource#") >
<cfset myFusebox.getApplicationData().backuprestore = createObject("component","global.cfc.backuprestore") >
<cfset myFusebox.getApplicationData().backuprestore.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#") >
<cfset myFusebox.getApplicationData().rfs = createObject("component","global.cfc.rfs") >
<cfset myFusebox.getApplicationData().rfs.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#") >
<cfset myFusebox.getApplicationData().plugins = createObject("component","global.cfc.plugins") >
<cfset myFusebox.getApplicationData().plugins.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#") >
<cfset application.razuna.trans = createObject("component","global.cfc.ResourceManager") >
<cfset application.razuna.trans.init(resourcePackagePath="translations",baseLocale="en",admin="admin") >
<cfset myFusebox.getApplicationData().scheduler = createObject("component","global.cfc.scheduler") >
<cfset myFusebox.getApplicationData().scheduler.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#",setid="#application.razuna.setid#") >
<cfset myFusebox.getApplicationData().lucene = createObject("component","global.cfc.lucene") >
<cfset myFusebox.getApplicationData().lucene.init(dsn="#application.razuna.datasource#",database="#application.razuna.thedatabase#") >
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "dologin">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfif not isDefined("attributes.passsend")><cfset attributes.passsend = "F" /></cfif>
<cfif not isDefined("attributes.rem_login")><cfset attributes.rem_login = "F" /></cfif>
<cfif not isDefined("attributes.loginto")><cfset attributes.loginto = "admin" /></cfif>
<cfset logindone = myFusebox.getApplicationData().Login.login(attributes) >
<cfif logindone.notfound EQ 'F'>
<cfset qry_sysadmingrp = myFusebox.getApplicationData().groups.getdetail('SystemAdmin') >
<cfset qry_admingrp = myFusebox.getApplicationData().groups.getdetail('Administrator') >
<cfset qry_groups_user = myFusebox.getApplicationData().groups_users.getGroupsOfUser(logindone.qryuser.user_id) >
<cfset Request.securityobj = myFusebox.getApplicationData().security.initUser(0,logindone.qryuser.user_id,'adm') >
<!--- do action="choosehost" --->
<cfset myFusebox.thisFuseaction = "choosehost">
<cfset attributes.user_id = "#session.theuserid#" />
<cfset userhosts = myFusebox.getApplicationData().users.userhosts(attributes) >
<cfset session.hostdbprefix = "#userhosts.host_shard_group#" />
<cfset session.hostid = "#userhosts.host_id#" />
<cfset session.host_count = "1" />
<cflocation url="#myself#c.main&_v=#createuuid('')#" addtoken="false">
<cfabort>
<cfset myFusebox.thisFuseaction = "dologin">
<cfelse>
<cflocation url="#myself#c.logoff&loginerror=T" addtoken="false">
<cfabort>
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

