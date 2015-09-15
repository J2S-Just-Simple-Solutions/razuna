<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: first_time_database_config --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "first_time_database_config">
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
<cfset myFusebox.thisFuseaction = "first_time_database_config">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset session.firsttime.database = "#attributes.db#" />
<cfset session.firsttime.database_type = "#attributes.db#" />
<cfif attributes.db EQ 'H2'>
<cfset attributes.db_name = "razuna" />
<cfset attributes.db_server = "" />
<cfset attributes.db_port = "0" />
<cfset attributes.db_schema = "razuna" />
<cfset attributes.db_user = "razuna" />
<cfset attributes.db_pass = "razunabd" />
<cfset thedsnarray = myFusebox.getApplicationData().global.checkdatasource() >
<cfif arrayisempty(thedsnarray)>
<cfset session.firsttime.db_action = "create" />
<cfset session.firsttime.db_name = "razuna" />
<cfset session.firsttime.db_server = "" />
<cfset session.firsttime.db_port = "0" />
<cfset session.firsttime.db_schema = "razuna" />
<cfset session.firsttime.db_user = "razuna" />
<cfset session.firsttime.db_pass = "razunabd" />
<cfset session.firsttime.database_type = "h2" />
<cfset myFusebox.getApplicationData().global.setdatasource() >
</cfif>
<!--- do action="first_time_database_done" --->
<cfset myFusebox.thisFuseaction = "first_time_database_done">
<cfset session.firsttime.db_name = "#attributes.db_name#" />
<cfset session.firsttime.db_server = "#attributes.db_server#" />
<cfset session.firsttime.db_port = "#attributes.db_port#" />
<cfset session.firsttime.db_schema = "#attributes.db_schema#" />
<cfset session.firsttime.db_user = "#attributes.db_user#" />
<cfset session.firsttime.db_pass = "#attributes.db_pass#" />
<!--- do action="ajax.first_time_database_setup" --->
<cfset myFusebox.thisCircuit = "ajax">
<cfset myFusebox.thisFuseaction = "first_time_database_setup">
<cftry>
<cfoutput><cfinclude template="../views/ajaxparts/dsp_firsttime_database_setup.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 32 and right(cfcatch.MissingFileName,32) is "dsp_firsttime_database_setup.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_firsttime_database_setup.cfm in circuit ajax which does not exist (from fuseaction ajax.first_time_database_setup).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "first_time_database_config">
<cfelse>
<cfset session.firsttime.db_action = "create" />
<cfset session.firsttime.db_name = "" />
<cfset session.firsttime.db_server = "" />
<cfset session.firsttime.db_port = "" />
<cfset session.firsttime.db_schema = "" />
<cfset session.firsttime.db_user = "" />
<cfset session.firsttime.db_pass = "" />
<cfset thedsnarray = myFusebox.getApplicationData().global.checkdatasource() >
<!--- do action="ajax.first_time_database_config" --->
<cfset myFusebox.thisCircuit = "ajax">
<cftry>
<cfoutput><cfinclude template="../views/ajaxparts/dsp_firsttime_database_config.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 33 and right(cfcatch.MissingFileName,33) is "dsp_firsttime_database_config.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_firsttime_database_config.cfm in circuit ajax which does not exist (from fuseaction ajax.first_time_database_config).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "c">
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>
