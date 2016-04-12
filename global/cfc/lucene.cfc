<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.ccf
*
* Razuna is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero Public License for more details.
*
* You should have received a copy of the GNU Affero Public License
* along with Razuna. If not, see <http://www.gnu.org/licenses/>.
*
* You may restribute this Program with a special exception to the terms
* and conditions of version 3.0 of the AGPL as described in Razuna's
* FLOSS exception. You should have received a copy of the FLOSS exception
* along with Razuna. If not, see <http://www.razuna.com/licenses/>.
*
--->
<cfcomponent output="false" extends="extQueryCaching">
	
	<cffunction name="index_update_firsttime" access="public" output="false" returntype="void">
		<cfargument name="host_id" required="true">
		<cfset var hosts =querynew("")>
		<!--- Query hosts --->
		<cfquery datasource="#application.razuna.datasource#" name="hosts">
		SELECT host_id, host_shard_group, host_name
		FROM hosts
		WHERE host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.host_id#">
		AND ( host_shard_group IS NOT NULL OR host_shard_group <cfif application.razuna.thedatabase EQ "oracle" OR application.razuna.thedatabase EQ "db2"><><cfelse>!=</cfif> '' )
		<cfif cgi.http_host CONTAINS "razuna.com">
			AND host_type != 0
		</cfif>
		</cfquery>
		<cfif hosts.recordcount NEQ 0>
			<cfset console("*********RUNNING ONE TIME INDEXING TASK FOR NEW HOST #hosts.host_name#*************")>
			<cfset console(hosts)>
			<cfinvoke method="index_update">
				<cfinvokeargument name="hostid" value="#arguments.host_id#" />
				<cfinvokeargument name="prefix" value="#hosts.host_shard_group#" />
				<cfinvokeargument name="hosted" value="true" />
				<cfinvokeargument name="assetid" value="all" />
			</cfinvoke>
		</cfif>
	</cffunction>

	<!--- INDEX: Update --->
	<cffunction name="index_update_hosted" access="public" output="false" returntype="void">
		<cfargument name="thestruct" type="struct">
		<cfthread action="run" intstruct="#arguments.thestruct#" priority="low"> 
			<cfinvoke component="lucene" method="index_update_hosted_thread" thestruct="#attributes.intstruct#" />
		</cfthread>
	</cffunction>

	<cffunction name="index_update_hosted_thread" access="public" output="false" returntype="void">

		<cfargument name="thestruct" type="struct">
		<cfargument name="category" type="string" required="true">
		<cfargument name="assetid" type="string" required="false">
		<cfargument name="notfile" type="string" default="F" required="false">
		<cftry>
			<!--- Add to lucene delete table --->
			<cfquery datasource="#application.razuna.datasource#">
			INSERT INTO lucene
			(id, type, host_id)
			VALUES (
				<cfqueryparam value="#arguments.thestruct.id#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam value="#arguments.category#" cfsqltype="CF_SQL_VARCHAR">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
			)
			</cfquery>
			<cfcatch type="any">
				<cfset consoleoutput(true)>
				<cfset console(cfcatch)>
			</cfcatch>
		</cftry>
		<!--- Return --->
		<cfreturn />
	</cffunction>

	<!--- SEARCH --->
	<cffunction name="search" access="remote" output="false" returntype="query">
		<cfargument name="criteria" type="string">
		<cfargument name="category" type="string">
		<cfargument name="hostid" type="numeric">
		<cfargument name="startrow" type="numeric">
		<cfargument name="maxrows" type="numeric">
		<cfargument name="folderid" type="string">
		<cfargument name="search_type" type="string">
		<cfargument name="search_rendition" type="string">
		<!--- Param --->
		<cfset var _taskserver = "" />
		<!--- Query settings --->
		<cfinvoke component="settings" method="prefs_taskserver" returnvariable="_taskserver" />
		<!--- Taskserver URL according to settings --->
		<cfif _taskserver.taskserver_location EQ "remote">
			<cfset var _url = _taskserver.taskserver_remote_url />
		<cfelse>
			<cfset var _url = _taskserver.taskserver_local_url />
		</cfif>
		<!--- Search in task server --->
		<!--- URL and secret key should come from db --->
		<cfhttp url="#_url#/api/search.cfc" method="post" charset="utf-8">
			<cfhttpparam name="method" value="search" type="formfield" />
			<cfhttpparam name="secret" value="#_taskserver.taskserver_secret#" type="formfield" />
			<cfhttpparam name="collection" value="#arguments.hostid#" type="formfield" />
			<cfhttpparam name="criteria" value="#arguments.criteria#" type="formfield" />
			<cfhttpparam name="category" value="#arguments.category#" type="formfield" />
			<cfhttpparam name="startrow" value="#arguments.startrow#" type="formfield" />
			<cfhttpparam name="maxrows" value="#arguments.maxrows#" type="formfield" />
			<cfhttpparam name="folderid" value="#arguments.folderid#" type="formfield" />
			<cfhttpparam name="search_type" value="#arguments.search_type#" type="formfield" />
			<cfhttpparam name="search_rendition" value="#arguments.search_rendition#" type="formfield" />
		</cfhttp>
		<!--- if statuscode is not 200 --->
		<cfif cfhttp.statuscode CONTAINS "200">
			<cftry>
				<!--- Grab results and serialize --->
				<cfset _json = deserializeJSON(cfhttp.filecontent) />
				<!--- If we don't have an error --->
				<cfif _json.success>
					<!--- Log --->
					<!--- <cfset console(_json)> --->
					<!--- Return --->
					<cfreturn _json.results>
				<cfelse>
					<!--- <cfset console(_json.error)> --->
					<cfoutput>
						<h2>An error occured</h2>
						<p>Please report the below error to your Administrator.</p>
					</cfoutput>
					<cfdump var="#_json.error#" label="ERROR" />
					<cfabort>
				</cfif>
				<cfcatch type="any">
					<cfoutput>
						<h2>An error occured</h2>
						<p>Please report the below error to your Administrator.</p>
					</cfoutput>
					<cfdump var="#cfcatch#" label="ERROR">
					<cfabort>
				</cfcatch>
			</cftry>
		</cfif>
	</cffunction>
	
	<!--- INDEX: Delete Folder --->
	<cffunction name="index_delete_folder" access="public" output="false">
		<cfargument name="thestruct" type="struct">
		<cfargument name="dsn" type="string" required="true">
		<!--- Get all records which have this folder id --->
		<!--- FILES --->
		<cfquery name="arguments.thestruct.qrydetail" datasource="#arguments.dsn#">
	    SELECT file_id id, folder_id_r, file_name_org filenameorg, link_kind, link_path_url, lucene_key, path_to_asset
		FROM #session.hostdbprefix#files
		WHERE folder_id_r = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.thestruct.folder_id#">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		</cfquery>
		<cfif arguments.thestruct.qrydetail.recordcount NEQ 0>
			<cfloop query="arguments.thestruct.qrydetail">
				<cfset arguments.thestruct.link_kind = link_kind>
				<cfset arguments.thestruct.filenameorg = arguments.thestruct.qrydetail.filenameorg>
				<!--- Remove Lucene Index --->
			 	<cfinvoke component="lucene" method="index_delete" thestruct="#arguments.thestruct#" assetid="#id#" category="doc">
				<!--- Delete file in folder --->
				<cfquery datasource="#arguments.dsn#">
				DELETE FROM #session.hostdbprefix#files
				WHERE file_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#id#">
				AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
				</cfquery>
			</cfloop>
		</cfif>
		<!--- IMAGES --->
		<cfquery name="arguments.thestruct.qrydetail" datasource="#arguments.dsn#">
	    SELECT img_id id, folder_id_r, img_filename_org filenameorg, link_kind, link_path_url, lucene_key, path_to_asset
		FROM #session.hostdbprefix#images
		WHERE folder_id_r = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.thestruct.folder_id#">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		</cfquery>
		<cfif arguments.thestruct.qrydetail.recordcount NEQ 0>
			<cfloop query="arguments.thestruct.qrydetail">
				<cfset arguments.thestruct.link_kind = link_kind>
				<cfset arguments.thestruct.filenameorg = arguments.thestruct.qrydetail.filenameorg>
				<!--- Remove Lucene Index --->
			 	<cfinvoke component="lucene" method="index_delete" thestruct="#arguments.thestruct#" assetid="#id#" category="img">
			 	<!--- Delete file in folder --->
				<cfquery datasource="#arguments.dsn#">
				DELETE FROM #session.hostdbprefix#images
				WHERE img_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#id#">
				AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
				</cfquery>
			 </cfloop>
		</cfif>
		<!--- VIDEOS --->
		<cfquery name="arguments.thestruct.qrydetail" datasource="#arguments.dsn#">
	    SELECT vid_id id, folder_id_r, vid_name_org filenameorg, link_kind, link_path_url, lucene_key, path_to_asset
		FROM #session.hostdbprefix#videos
		WHERE folder_id_r = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.thestruct.folder_id#">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		</cfquery>
		<cfif arguments.thestruct.qrydetail.recordcount NEQ 0>
			<cfloop query="arguments.thestruct.qrydetail">
				<cfset arguments.thestruct.link_kind = link_kind>
				<cfset arguments.thestruct.filenameorg = arguments.thestruct.qrydetail.filenameorg>
				<!--- Remove Lucene Index --->
			 	<cfinvoke component="lucene" method="index_delete" thestruct="#arguments.thestruct#" assetid="#id#" category="vid">
				<!--- Delete file in folder --->
				<cfquery datasource="#arguments.dsn#">
				DELETE FROM #session.hostdbprefix#videos
				WHERE vid_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#id#">
				AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
				</cfquery> 
			</cfloop>
		</cfif>
		<!--- AUDIOS --->
		<cfquery name="arguments.thestruct.qrydetail" datasource="#arguments.dsn#">
	    SELECT aud_id id, folder_id_r, aud_name_org filenameorg, link_kind, link_path_url, lucene_key, path_to_asset
		FROM #session.hostdbprefix#audios
		WHERE folder_id_r = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.thestruct.folder_id#">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		</cfquery>
		<cfif arguments.thestruct.qrydetail.recordcount NEQ 0>
			<cfloop query="arguments.thestruct.qrydetail">
				<cfset arguments.thestruct.link_kind = link_kind>
				<cfset arguments.thestruct.filenameorg = arguments.thestruct.qrydetail.filenameorg>
				<!--- Remove Lucene Index --->
			 	<cfinvoke component="lucene" method="index_delete" thestruct="#arguments.thestruct#" assetid="#id#" category="aud">
				<!--- Delete file in folder --->
				<cfquery datasource="#arguments.dsn#">
				DELETE FROM #session.hostdbprefix#audios
				WHERE aud_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#id#">
				</cfquery> 
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="escapelucenechars" returntype="String" hint="Escapes lucene special characters in a given string">
		<!--- 
		The following lucene special characters will be escaped in searches
		\ ! {} [] - && || ()
		The following lucene special characters  will NOT be escaped as we want to allow users to use these in their search criterion 
		+ " ~ * ? : ^
		--->
		<cfargument name="lucenestr" type="String" required="true">
		<cfset lucenestr = replace(lucenestr,"\","\\","ALL")>
		<cfset lucenestr = replace(lucenestr,"!","\!","ALL")>	
		<cfset lucenestr = replace(lucenestr,"{","\{","ALL")>
		<cfset lucenestr = replace(lucenestr,"}","\}","ALL")>
		<cfset lucenestr = replace(lucenestr,"[","\[","ALL")>
		<cfset lucenestr = replace(lucenestr,"]","\]","ALL")>
		<cfset lucenestr = replace(lucenestr,"-","\-","ALL")>
		<cfset lucenestr = replace(lucenestr,"&&","\&&","ALL")>	
		<cfset lucenestr = replace(lucenestr,"||","\||","ALL")>	
		<cfset lucenestr = replace(lucenestr,"||","\||","ALL")>	
		<cfset lucenestr = replace(lucenestr,"(","\(","ALL")>
		<cfset lucenestr = replace(lucenestr,")","\)","ALL")>		
		<cfreturn lucenestr>	
	</cffunction>


	<!--- SEARCH --->
	<cffunction name="search" access="remote" output="false" returntype="query">
		<cfargument name="criteria" type="string">
		<cfargument name="category" type="string">
		<cfargument name="hostid" type="numeric">

		<cflog file="lucene" type="Information" text="****** Nouvelle recherche Lucene *******" >
		<cflog file="lucene" type="Information" text="Argument criteria: #arguments.criteria#" >

		<!--- Write dummy record (this fixes issues with collection not written to lucene!!!) --->
		<!--- Commented this out cause we fixed it and second it slows down the search coniderably!!!!!! --->
		<!--- <cftry>
			<cfset CollectionIndexcustom( collection=#arguments.hostid#, key="delete", body="#createuuid()#", title="#createuuid()#")>
			<cfcatch type="any"></cfcatch>
		</cftry> --->
		<!--- 
		 Decode URL encoding that is encoded using the encodeURIComponent javascript method. 
		 Preserve the '+' sign during decoding as the URLDecode methode will remove it if present.
		 Do not use escape(deprecated) or encodeURI (doesn't encode '+' sign) methods to encode. Use the encodeURIComponent javascript method only.
		--->
		<cfset arguments.criteria = replace(urlDecode(replace(arguments.criteria,"+","PLUSSIGN","ALL")),"PLUSSIGN","+","ALL")>

		<!--- If criteria is empty --->
		<cfif arguments.criteria EQ "">
			<cfset arguments.criteria = "">
		<!--- Put search together. If the criteria contains a ":" then we assume the user wants to search with his own fields --->
		<cfelseif NOT arguments.criteria CONTAINS ":" AND NOT arguments.criteria EQ "*">
			<cfset arguments.criteria = escapelucenechars(arguments.criteria)>
			<!--- Replace spaces with AND if query doesn't contain AND, OR  or " --->
			<cfif find(" AND ", arguments.criteria) EQ 0 AND find(" OR ", arguments.criteria) EQ 0 AND find('"', arguments.criteria) EQ 0 >
				<cfset arguments.criteria_sp = replace(arguments.criteria,chr(32)," AND ", "ALL")>
			<cfelse>	
				<cfset arguments.criteria_sp = arguments.criteria>
			</cfif>
			<cfif arguments.criteria CONTAINS '"' OR arguments.criteria CONTAINS "*" OR find(" AND ", arguments.criteria) NEQ 0 OR find(" OR ", arguments.criteria) NEQ 0>
				<cfset arguments.criteria = 'filename:(#arguments.criteria#*)'>
			<cfelse>
				<cfset arguments.criteria = 'filename:(#arguments.criteria#*) filename:("#arguments.criteria#")'>
			</cfif>
			<cfset arguments.criteria = '(' & arguments.criteria_sp  & ') ' & arguments.criteria & ' keywords:(#arguments.criteria_sp#) description:(#arguments.criteria_sp#) id:(#arguments.criteria_sp#) labels:(#arguments.criteria_sp#) customfieldvalue:(#arguments.criteria_sp#)'>
		</cfif>

		<cflog file="lucene" type="Information" text="criteria (après traitement): #arguments.criteria#" >

		<cftry>
			<cfsearch collection='#arguments.hostid#' criteria='#arguments.criteria#' name='qrylucene' category='#arguments.category#'>
			<cfcatch type="any">
				<cfset qrylucene = querynew("x")>
			</cfcatch>
		</cftry>

		<!--- <cfset console(arguments.criteria)> --->
		<!--- Return --->
		<cfreturn qrylucene>
	</cffunction>
	
	<!--- SEARCH DECODED --->
	<cffunction name="searchdec" access="public" output="false">
		<cfargument name="criteria" type="string">
		<cfargument name="category" type="string">
		<!--- If we come from VP we only query collection VP --->
		<cfif structkeyexists(session, "thisapp") AND session.thisapp EQ "vp">
			<cfsearch collection="#session.hostid#vp" criteria="#arguments.criteria#" name="qrylucenedec" category="#arguments.category#">
		<cfelse>
			<cfoutput>
				<h2>A connection error to the search server occured</h2>
				<p>Please report the below error to your Administrator.</p>
			</cfoutput>
			<cfdump var="#cfhttp#" label="ERROR" />
			<cfabort>
		</cfif>
		
	</cffunction>

	
	<!--- INDEX: Update from API --->
	<cffunction name="index_update_api" access="remote" output="false">
		<cfargument name="assetid" type="string" required="true">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="prefix" type="string" required="true">
		<cfargument name="hostid" type="string" required="true">
		<!--- Call to update asset --->
		<cfset rebuildIndex(assetid=arguments.assetid, dsn=arguments.dsn, prefix=arguments.prefix, hostid=arguments.hostid ) />
		<!--- Return --->
		<cfreturn />
	</cffunction>

	<!--- For status --->
	<cffunction name="statusOfIndex" access="public" output="false">
		<cfargument name="reset" required="true">
		<!--- If the user wants to reset index --->
		<cfif arguments.reset>
			<cfset rebuildIndex(assetid='all', dsn=application.razuna.datasource, prefix=session.hostdbprefix, hostid=session.hostid ) />
		</cfif>
		<!--- Var --->
		<cfset var qry = "" />
		<!--- Query how many files are not indexed --->
		<cfquery datasource="#application.razuna.datasource#" name="qry">
		SELECT count(img_id) as count, 'Images' as type
		FROM #session.hostdbprefix#images
		WHERE is_indexed = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		UNION ALL
		SELECT count(vid_id) as count, 'Videos' as type
		FROM #session.hostdbprefix#videos
		WHERE is_indexed = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		UNION ALL
		SELECT count(file_id) as count, 'Documents' as type
		FROM #session.hostdbprefix#files
		WHERE is_indexed = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		UNION ALL
		SELECT count(aud_id) as count, 'Audios' as type
		FROM #session.hostdbprefix#audios a
		WHERE is_indexed = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
		AND host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		</cfquery>
		<!--- Return --->
		<cfreturn qry />
	</cffunction>
	
	<!--- Rebuild Index --->
	<cffunction name="rebuildIndex" access="public" output="false">
		<cfargument name="assetid" type="string" required="true">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="prefix" type="string" required="true">
		<cfargument name="hostid" type="string" required="true">
		<!--- Param --->
		<cfset var _taskserver = "" />
		<!--- Query settings --->
		<cfinvoke component="settings" method="prefs_taskserver" returnvariable="_taskserver" />
		<!--- Taskserver URL according to settings --->
		<cfif _taskserver.taskserver_location EQ "remote">
			<cfset var _url = _taskserver.taskserver_remote_url />
		<cfelse>
			<cfset var _url = _taskserver.taskserver_local_url />
		</cfif>
		<!--- Call search server to rebuild collection --->
		<cfhttp url="#_url#/api/collection.cfc" method="post" charset="utf-8">
			<cfhttpparam name="method" value="rebuildCollection" type="formfield" />
			<cfhttpparam name="secret" value="#_taskserver.taskserver_secret#" type="formfield" />
			<cfhttpparam name="hostid" value="#arguments.hostid#" type="formfield" />
		</cfhttp>
		<!--- Set records to non indexed --->
		<cfquery datasource="#arguments.dsn#">
		UPDATE #arguments.prefix#images
		SET is_indexed = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="0">
		WHERE host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		<cfif arguments.assetid NEQ "all">
			AND img_id IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.assetid#" list="true">)
		</cfif>
		</cfquery>
		<cfquery datasource="#arguments.dsn#">
		UPDATE #arguments.prefix#videos
		SET is_indexed = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="0">
		WHERE host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		<cfif arguments.assetid NEQ "all">
			AND vid_id IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.assetid#" list="true">)
		</cfif>
		</cfquery>
		<cfquery datasource="#arguments.dsn#">
		UPDATE #arguments.prefix#audios
		SET is_indexed = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="0">
		WHERE host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		<cfif arguments.assetid NEQ "all">
			AND aud_id IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.assetid#" list="true">)
		</cfif>
		</cfquery>
		<cfquery datasource="#arguments.dsn#">
		UPDATE #arguments.prefix#files
		SET is_indexed = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="0">
		WHERE host_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.hostid#">
		AND in_trash = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="F">
		<cfif arguments.assetid NEQ "all">
			AND file_id IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.assetid#" list="true">)
		</cfif>
		</cfquery>
		<!--- Set hostid session (needed in resetcachetoken) --->
		<cfset session.hostid = arguments.hostid>
		<!--- Flush Caches --->
		<cfset resetcachetoken("images")>
		<cfset resetcachetoken("videos")>
		<cfset resetcachetoken("files")>
		<cfset resetcachetoken("audios")>
		<cfset resetcachetoken("search")>
		<!--- Return --->
		<cfreturn  />
	</cffunction>

</cfcomponent>