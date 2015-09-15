<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: users_save --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "users_save">
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
<cfset myFusebox.thisFuseaction = "users_save">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfif #attributes.user_id# EQ 0>
<cfset attributes.newid = myFusebox.getApplicationData().users.add(attributes) >
<cfset myFusebox.getApplicationData().groups_users.addtogroups(attributes) >
<cfset attributes.module_id_struct = myFusebox.getApplicationData().modules.getIdStruct() >
<cfelse>
<cfset attributes.newid = "#attributes.user_id#" />
<cfset attributes.module_id_struct = myFusebox.getApplicationData().modules.getIdStruct() >
<cfset myFusebox.getApplicationData().groups_users.addtogroups(attributes) >
<cfset myFusebox.getApplicationData().users.update(attributes) >
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

