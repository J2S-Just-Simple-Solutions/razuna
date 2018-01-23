<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: first_time_final --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "first_time_final">
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
<cfset myFusebox.thisFuseaction = "first_time_final">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<!--- do action="first_time_final_include" --->
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisFuseaction = "first_time_final_include">
<cfset session.firsttime.database = "#session.firsttime.database_type#" />
<cfset application.razuna.theschema = "#session.firsttime.db_schema#" />
<cfset application.razuna.thedatabase = "#session.firsttime.database_type#" />
<cfset application.razuna.datasource = "#session.firsttime.database_type#" />
<cfset attributes.dsn = "#session.firsttime.database_type#" />
<cfset attributes.theschema = "#session.firsttime.db_schema#" />
<cfset attributes.host_db_prefix = "raz1_" />
<cfset attributes.database = "#session.firsttime.database_type#" />
<cfset attributes.host_lang = "1" />
<cfset attributes.langs_selected = "1_English" />
<cfset attributes.pathhere = "#thispath#" />
<cfset attributes.pathoneup = "#pathoneup#" />
<cfset attributes.path_assets = "#session.firsttime.path_assets#" />
<cfset attributes.email_from = "#attributes.user_email#" />
<cfset attributes.host_path = "raz1" />
<cfset attributes.from_first_time = "true" />
<cfset attributes.host_name = "Demo" />
<cfset attributes.imagemagick = "#session.firsttime.path_im#" />
<cfset attributes.ffmpeg = "#session.firsttime.path_ffmpeg#" />
<cfset attributes.exiftool = "#session.firsttime.path_exiftool#" />
<cfset attributes.dcraw = "#session.firsttime.path_dcraw#" />
<cfset attributes.mp4box = "#session.firsttime.path_mp4box#" />
<cfset attributes.ghostscript = "#session.firsttime.path_ghostscript#" />
<cfset attributes.conf_database = "#session.firsttime.database_type#" />
<cfset attributes.conf_schema = "#session.firsttime.db_schema#" />
<cfset attributes.conf_datasource = "#session.firsttime.database_type#" />
<cfset attributes.conf_storage = "local" />
<cfset myFusebox.getApplicationData().hosts.cleardb(thedatabase=session.firsttime.database_type) >
<cfset myFusebox.getApplicationData().hosts.setupdb(attributes) >
<cfset myFusebox.getApplicationData().settings.update_global(attributes) >
<cfset myFusebox.getApplicationData().settings.update_tools(attributes) >
<cfset myFusebox.getApplicationData().settings.firsttime_false('false') >
<cfset myFusebox.getApplicationData().update.setoptionupdate() >
<cfset attributes.db_path = "#expandpath('..')#db" />
<cfset myFusebox.getApplicationData().settings.indexingDbInfoPrepare(db_path=attributes.db_path) >
<cfset session.firsttime.database = "razuna_client" />
<cfset session.firsttime.database_type = "mysql" />
<cfset session.firsttime.db_name = "razuna_clients" />
<cfset session.firsttime.db_server = "db.razuna.com" />
<cfset session.firsttime.db_port = "3306" />
<cfset session.firsttime.db_user = "razuna_client" />
<cfset session.firsttime.db_pass = "D63E61251" />
<cfset session.firsttime.db_action = "create" />
<cfset myFusebox.getApplicationData().global.setdatasource() >
<!--- do action="ajax.first_time_done" --->
<cfset myFusebox.thisCircuit = "ajax">
<cfset myFusebox.thisFuseaction = "first_time_done">
<cftry>
<cfoutput><cfinclude template="../views/ajaxparts/dsp_firsttime_done.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 22 and right(cfcatch.MissingFileName,22) is "dsp_firsttime_done.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_firsttime_done.cfm in circuit ajax which does not exist (from fuseaction ajax.first_time_done).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

