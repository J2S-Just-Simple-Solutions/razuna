<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: first_time_account --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "first_time_account">
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
<cfset myFusebox.thisFuseaction = "first_time_account">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset session.firsttime.path_im = "#attributes.path_imagemagick#" />
<cfset session.firsttime.path_ffmpeg = "#attributes.path_ffmpeg#" />
<cfset session.firsttime.path_exiftool = "#attributes.path_exiftool#" />
<cfset session.firsttime.path_dcraw = "#attributes.path_dcraw#" />
<cfset session.firsttime.path_mp4box = "#attributes.path_mp4box#" />
<cfset session.firsttime.path_ghostscript = "#attributes.path_ghostscript#" />
<!--- do action="ajax.first_time_account" --->
<cfset myFusebox.thisCircuit = "ajax">
<cftry>
<cfoutput><cfinclude template="../views/ajaxparts/dsp_firsttime_account.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 25 and right(cfcatch.MissingFileName,25) is "dsp_firsttime_account.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_firsttime_account.cfm in circuit ajax which does not exist (from fuseaction ajax.first_time_account).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

