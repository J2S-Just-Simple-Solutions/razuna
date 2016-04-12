<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: c --->
<!--- fuseaction: login --->
<cftry>
<cfset myFusebox.thisPhase = "appinit">
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "login">
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
<cfset myFusebox.thisFuseaction = "login">
			<cfset myFusebox.getApplication().applicationStarted = true />
		</cfif>
	</cflock>
</cfif>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset xfa.submitform = "c.dologin" />
<cfset xfa.forgotpass = "c.forgotpass" />
<cfset xfa.switchlang = "c.switchlang" />
<cfif not isDefined("attributes.firsttime")><cfset attributes.firsttime = "F" /></cfif>
<cfif not isDefined("attributes.loginerror")><cfset attributes.loginerror = "F" /></cfif>
<cfif not isDefined("attributes.nohost")><cfset attributes.nohost = "F" /></cfif>
<cfif not isDefined("attributes.choosehost")><cfset attributes.choosehost = "F" /></cfif>
<cfset attributes.pathoneup = "#pathoneup#" />
<cfset attributes.pathhere = "#thispath#" />
<cfif application.razuna.firsttime>
<cfset attributes.firsttime = "T" />
<cfset attributes.host_lang = "1" />
<cfset session.hostid = "1" />
<cfset xfa.submitform = "c.firsttimerun" />
<cfset attributes.thepath = "#thispath#" />
<cfset xml_langs = myFusebox.getApplicationData().defaults.getlangsadmin(attributes.thepath) >
<!--- do action="v.firsttime" --->
<cfset myFusebox.thisCircuit = "v">
<cfset myFusebox.thisFuseaction = "firsttime">
<cftry>
<cfsavecontent variable="body"><cfoutput><cfinclude template="../views/dsp_firsttime.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 17 and right(cfcatch.MissingFileName,17) is "dsp_firsttime.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_firsttime.cfm in circuit v which does not exist (from fuseaction v.firsttime).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<!--- do action="l.lay_loginpage" --->
<cfset myFusebox.thisCircuit = "l">
<cfset myFusebox.thisFuseaction = "lay_loginpage">
<cftry>
<cfsavecontent variable="thecontent"><cfoutput><cfinclude template="../views/layouts/lay_login.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "lay_login.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_login.cfm in circuit l which does not exist (from fuseaction l.lay_loginpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfoutput><cfinclude template="../views/layouts/lay_index.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "lay_index.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_index.cfm in circuit l which does not exist (from fuseaction l.lay_loginpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "login">
<cfelse>
<!--- do action="update" --->
<cfset myFusebox.thisFuseaction = "update">
<cfif not isDefined("attributes.firsttime")><cfset attributes.firsttime = "T" /></cfif>
<cfset session.updatedb = myFusebox.getApplicationData().update.update_for() >
<cfif session.updatedb>
<cflocation url="#myself#v.update&_v=#createuuid('')#" addtoken="false">
<cfabort>
</cfif>
<!--- do action="v.login" --->
<cfset myFusebox.thisCircuit = "v">
<cfset myFusebox.thisFuseaction = "login">
<cftry>
<cfsavecontent variable="body"><cfoutput><cfinclude template="../views/dsp_login.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "dsp_login.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_login.cfm in circuit v which does not exist (from fuseaction v.login).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<!--- do action="l.lay_loginpage" --->
<cfset myFusebox.thisCircuit = "l">
<cfset myFusebox.thisFuseaction = "lay_loginpage">
<cftry>
<cfsavecontent variable="thecontent"><cfoutput><cfinclude template="../views/layouts/lay_login.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "lay_login.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_login.cfm in circuit l which does not exist (from fuseaction l.lay_loginpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfoutput><cfinclude template="../views/layouts/lay_index.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 13 and right(cfcatch.MissingFileName,13) is "lay_index.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse lay_index.cfm in circuit l which does not exist (from fuseaction l.lay_loginpage).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "c">
<cfset myFusebox.thisFuseaction = "login">
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

