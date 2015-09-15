<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: main --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "main">
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
<cfset myFusebox.thisFuseaction = "main">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset wisdom = myFusebox.getApplicationData().global.wisdom() >
<cfset qry_allhosts = myFusebox.getApplicationData().global.allhosts() >
<cfset appcheck = myFusebox.getApplicationData().settings.applicationcheck() >
<cfset newversion = myFusebox.getApplicationData().update.check_update() >
<!--- do action="v.main" --->
<cfset myFusebox.thisCircuit = "v">
<cftry>
<cfsavecontent variable="menuleft"><cfoutput><cfinclude template="../views/dsp_menu_left.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 17 and right(cfcatch.MissingFileName,17) is "dsp_menu_left.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_menu_left.cfm in circuit v which does not exist (from fuseaction v.main).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="rightcontent"><cfoutput><cfinclude template="../views/dsp_main.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "dsp_main.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_main.cfm in circuit v which does not exist (from fuseaction v.main).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="showcontent"><cfoutput><cfinclude template="../views/dsp_showcontent.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 19 and right(cfcatch.MissingFileName,19) is "dsp_showcontent.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_showcontent.cfm in circuit v which does not exist (from fuseaction v.main).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<!--- do action="l.lay_mainpage" --->
<cfset myFusebox.thisCircuit = "l">
<cfset myFusebox.thisFuseaction = "lay_mainpage">
<cfset xfa.switchlang = "c.switchlang" />
<cftry>
<cfsavecontent variable="headercontent"><cfoutput><cfinclude template="../views/layouts/lay_header.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 14 and right(cfcatch.MissingFileName,14) is "lay_header.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_header.cfm in circuit l which does not exist (from fuseaction l.lay_mainpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="leftcontent"><cfoutput><cfinclude template="../views/layouts/lay_left.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "lay_left.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_left.cfm in circuit l which does not exist (from fuseaction l.lay_mainpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="maincontent"><cfoutput><cfinclude template="../views/layouts/lay_right.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "lay_right.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_right.cfm in circuit l which does not exist (from fuseaction l.lay_mainpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="showcontent"><cfoutput><cfinclude template="../views/layouts/lay_showcontent.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 19 and right(cfcatch.MissingFileName,19) is "lay_showcontent.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_showcontent.cfm in circuit l which does not exist (from fuseaction l.lay_mainpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="footercontent"><cfoutput><cfinclude template="../views/layouts/lay_footer.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 14 and right(cfcatch.MissingFileName,14) is "lay_footer.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_footer.cfm in circuit l which does not exist (from fuseaction l.lay_mainpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfoutput><cfinclude template="../views/layouts/lay_main.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "lay_main.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_main.cfm in circuit l which does not exist (from fuseaction l.lay_mainpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>

