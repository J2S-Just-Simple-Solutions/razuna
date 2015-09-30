<!---
*
* Copyright (C) 2005-2008 Razuna
*
* This file is part of Razuna - Enterprise Digital Asset Management.
*
* Razuna is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
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
<cfif Request.securityobj.CheckSystemAdminUser() OR Request.securityobj.CheckAdministratorUser()>
	<cfset isadmin = true>
<cfelse>
	<cfset isadmin = false>
</cfif>
<cfoutput>
	<cfset uniqueid = createuuid()>
	<cfif attributes.qry_filecount NEQ 0>
		<form name="#kind#form" id="#kind#form" action="#self#" onsubmit="combinedsavedoc();return false;">
		<input type="hidden" name="kind" value="#kind#">
		<input type="hidden" name="thetype" value="doc">
		<input type="hidden" name="#theaction#" value="c.folder_combined_save">
		<input type="hidden" name="folder_id" id="folder_id" value="#attributes.folder_id#">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="grid">
			<tr>
				<td width="100%" colspan="6">
					<!--- Show notification of folder is being shared --->
					<cfinclude template="inc_folder_header.cfm">
					<cfinclude template="dsp_folder_navigation.cfm">
				</td>
			</tr>
			<tr>
				<cfset thetype = "#kind#">
				<cfset thexfa = "c.folder_files">
				<cfset thediv = "#kind#">
				<td colspan="6" class="gridno"><cfinclude template="dsp_icon_bar.cfm"></td>
			</tr>
			<!--- The Icon view --->
			<cfif session.view EQ "">
				<tr>
					<td id="selectme">
						<!--- Show Subfolders --->
						<cfinclude template="inc_folder_thumbnail.cfm">
						<cfloop query="qry_files">
							<cfset mycurrentRow = (session.offset * session.rowmaxpage) + currentRow>
							<div class="assetbox" style="<cfif cs.assetbox_width NEQ "">width:#cs.assetbox_width#px;</cfif><cfif cs.assetbox_height NEQ "">min-height:#cs.assetbox_height#px;</cfif>">
								<cfif is_available>
									<script type="text/javascript">
									$(function() {
										$("##draggable#file_id#").draggable({
											appendTo: 'body',
											cursor: 'move',
											addClasses: false,
											iframeFix: true,
											opacity: 0.25,
											zIndex: 6,
											helper: 'clone',
											start: function() {
												//$('##dropbaskettrash').css('display','none');
												//$('##dropfavtrash').css('display','none');
											},
											stop: function() {
												//$('##dropbaskettrash').css('display','');
												//$('##dropfavtrash').css('display','');
											}
										});
										<cfif isdate(expiry_date) AND expiry_date LT now()>
										$('##iconbar_file_#file_id#').css('display','none');
										</cfif>
									});
									</script>
									<!--- custom metadata fields to show --->
									<cfloop list="#attributes.cs_place.top.file#" index="m" delimiters=",">
										<span class="assetbox_title">#myFusebox.getApplicationData().defaults.trans("#listlast(m," ")#")#</span>
										<cfif m CONTAINS "_filename">
											<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;"><strong>#evaluate(listlast(m," "))#</strong></a>
										<cfelseif m CONTAINS "_size">
											#myFusebox.getApplicationData().global.converttomb('#evaluate(listlast(m," "))#')# MB
										<cfelseif m CONTAINS "_time">
											#dateformat(evaluate(listlast(m," ")), "#myFusebox.getApplicationData().defaults.getdateformat()#")# #timeformat(date_create, "HH:mm")#
										<cfelseif m CONTAINS "expiry_date">
											#dateformat(evaluate(listlast(m," ")), "#myFusebox.getApplicationData().defaults.getdateformat()#")#
										<cfelse>
											#evaluate(listlast(m," "))#
										</cfif>
										<br />
									</cfloop>
									<!--- Show custom fields here (its a list) --->
									<cfloop list="#customfields#" index="i" delimiters=",">
										<cfif listfind (attributes.cs_place.cf_top.file,gettoken(i,2,"|"))>
											<br />
											<!--- Get label --->
											<cfset cflabel = listFirst(i,"|")>
											<!--- Get value --->
											<cfset cfvalue = listlast(i,"|")>
											<!--- Output --->
											<span class="assetbox_title">#cflabel#:</span>
											<cfif cflabel NEQ cfvalue>
												#cfvalue#
											</cfif>
										</cfif>
									</cfloop>
									<br/><br/>
									<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;">
									<div id="draggable#file_id#" type="#file_id#-doc" class="theimg">
									<!--- Show the thumbnail --->
									<cfset thethumb = replacenocase(file_name_org, ".#file_extension#", ".jpg", "all")>
									<cfif application.razuna.storage EQ "amazon" AND cloud_url NEQ "">
										<img src="#cloud_url#" border="0" img-tt="img-tt">
									<cfelseif application.razuna.storage EQ "local" AND FileExists("#attributes.assetpath#/#session.hostid#/#path_to_asset#/#thethumb#") >
										<img src="#cgi.context_path#/assets/#session.hostid#/#path_to_asset#/#thethumb#?#uniqueid#" border="0" img-tt="img-tt">
									<cfelse>
										<img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" border="0" onerror = "this.src='#dynpath#/global/host/dam/images/icons/icon_txt.png'">
									</cfif>
									</div>
									</a>
									<div style="float:left;padding:3px 0px 3px 0px;">
										<input type="checkbox" name="file_id" value="#file_id#-doc" onclick="enablesub('#attributes.kind#form');"<cfif listfindnocase(session.file_id,"#file_id#-doc") NEQ 0> checked="checked"</cfif>>
									</div>
									<div style="float:right;padding:6px 0px 0px 0px;">
										<div id="iconbar_file_#file_id#" style="display:inline">
											<a href="##" onclick="showwindow('#myself#c.file_download&file_id=#file_id#&kind=doc&folderaccess=#attributes.folderaccess#','#JSStringFormat(myFusebox.getApplicationData().defaults.trans("download"))#',650,1);return false;" title="#myFusebox.getApplicationData().defaults.trans("download_to_desktop")#"><img src="#dynpath#/global/host/dam/images/go-down.png" width="16" height="16" border="0" /></a>
											<cfif cs.show_basket_part AND cs.button_basket AND (isadmin OR cs.btn_basket_slct EQ "" OR listfind(cs.btn_basket_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.btn_basket_slct,session.thegroupofuser) NEQ "")><a href="##" onclick="loadcontent('thedropbasket','#myself#c.basket_put&file_id=#file_id#-doc&thetype=#file_id#-doc');flash_footer('#myFusebox.getApplicationData().defaults.trans("item_basket")#');return false;" title="#myFusebox.getApplicationData().defaults.trans("put_in_basket")#"><img src="#dynpath#/global/host/dam/images/basket-put.png" width="16" height="16" border="0" /></a></cfif>
											<cfif cs.button_send_email AND (isadmin OR cs.btn_email_slct EQ "" OR listfind(cs.btn_email_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.btn_email_slct,session.thegroupofuser) NEQ "")>
												<a href="##" onclick="showwindow('#myself##xfa.sendemail#&file_id=#file_id#&thetype=doc','#myFusebox.getApplicationData().defaults.trans("send_with_email")#',700,2);return false;" title="#myFusebox.getApplicationData().defaults.trans("send_with_email")#"><img src="#dynpath#/global/host/dam/images/mail-message-new-3.png" width="16" height="16" border="0" /></a>
											</cfif>
											<cfif cs.show_favorites_part>
												<a href="##" onclick="loadcontent('thedropfav','#myself#c.favorites_put&favid=#file_id#&favtype=file&favkind=doc');flash_footer('#myFusebox.getApplicationData().defaults.trans("item_favorite")#');return false;" title="Add to favorites"><img src="#dynpath#/global/host/dam/images/favs_16.png" width="16" height="16" border="0" /></a>
											</cfif>
										</div>
										<cfif attributes.folderaccess NEQ "R">
											<cfif cs.show_trash_icon AND (isadmin OR  cs.show_trash_icon_slct EQ "" OR listfind(cs.show_trash_icon_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.show_trash_icon_slct,session.thegroupofuser) NEQ "")>
												<cfif attributes.folder_id NEQ folder_id_r>
													<a href="##" onclick="showwindow('#myself#ajax.trash_alias&id=#file_id#&loaddiv=#attributes.kind#&folder_id=#attributes.folder_id#&showsubfolders=#attributes.showsubfolders#&offset=#session.offset#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("alias_remove_button"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a>
												<cfelse>
													<a href="##" onclick="showwindow('#myself#ajax.trash_record&id=#file_id#&what=files&loaddiv=#attributes.kind#&folder_id=#attributes.folder_id#&showsubfolders=#attributes.showsubfolders#&offset=#session.offset#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("trash"))#',400,1);return false;" title="#myFusebox.getApplicationData().defaults.trans("trash")#"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a>
												</cfif>
											</cfif>
										</cfif>
									</div>
									<div style="clear:left;"></div>
									<!--- custom metadata fields to show --->
									<cfif attributes.cs.files_metadata EQ "">
										<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;"><strong>#left(file_name,50)#</strong></a>
									<cfelse>
										<br />
										<cfloop list="#attributes.cs_place.bottom.file#" index="m" delimiters=",">
											<span class="assetbox_title">#myFusebox.getApplicationData().defaults.trans("#listlast(m," ")#")#</span>
											<cfif m CONTAINS "_filename">
												<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;"><strong>#evaluate(listlast(m," "))#</strong></a>
											<cfelseif m CONTAINS "_size">
												#myFusebox.getApplicationData().global.converttomb('#evaluate(listlast(m," "))#')# MB
											<cfelseif m CONTAINS "_time">
												#dateformat(evaluate(listlast(m," ")), "#myFusebox.getApplicationData().defaults.getdateformat()#")# #timeformat(date_create, "HH:mm")#
											<cfelseif m CONTAINS "expiry_date">
												#dateformat(evaluate(listlast(m," ")), "#myFusebox.getApplicationData().defaults.getdateformat()#")#
											<cfelse>
												#evaluate(listlast(m," "))#
											</cfif>
											<br />
										</cfloop>
									</cfif>
									<!--- Show custom fields here (its a list) --->
									<cfloop list="#customfields#" index="i" delimiters=",">
										<cfif listfind (attributes.cs_place.cf_bottom.file,gettoken(i,2,"|"))>
											<br />
											<!--- Get label --->
											<cfset cflabel = listFirst(i,"|")>
											<!--- Get value --->
											<cfset cfvalue = listlast(i,"|")>
											<!--- Output --->
											<span class="assetbox_title">#cflabel#:</span>
											<cfif cflabel NEQ cfvalue>
												#cfvalue#
											</cfif>
										</cfif>
									</cfloop>
									<cfif attributes.folder_id NEQ folder_id_r>
										<div style="float:right">
											<em>(Alias)</em>
										</div>
										<div style="clear:both;"></div>
									</cfif>
								<cfelse>
									"#file_name#" en cours de traitement !
									<br /><br>
									#myFusebox.getApplicationData().defaults.trans("date_created")#:<br>
									#dateformat(file_create_date, "#myFusebox.getApplicationData().defaults.getdateformat()#")# #timeformat(file_create_date, "HH:mm")#
									<br><br>
									<a href="##" onclick="showwindow('#myself#ajax.remove_record&id=#file_id#&what=files&loaddiv=#attributes.kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("remove"))#',400,1);return false;">Delete</a>
								</cfif>
							</div>
						</cfloop>
					</td>
				</tr>
			<!--- View: Combined --->
			<cfelseif session.view EQ "combined">
				<tr>
					<td colspan="4" align="right"><div id="updatestatusdoc" style="float:left;"></div><input type="button" value="#myFusebox.getApplicationData().defaults.trans("save_changes")#" onclick="combinedsavedoc();return false;" class="button"></td>
				</tr>
				<cfloop query="qry_files">
					<cfset mycurrentRow = (session.offset * session.rowmaxpage) + currentRow>
					<cfset labels = labels>
					<script type="text/javascript">
					$(function() {
						$("##draggable#file_id#").draggable({
							appendTo: 'body',
							cursor: 'move',
							addClasses: false,
							iframeFix: true,
							opacity: 0.25,
							zIndex: 6,
							helper: 'clone',
							start: function() {
								//$('##dropbaskettrash').css('display','none');
								//$('##dropfavtrash').css('display','none');
							},
							stop: function() {
								//$('##dropbaskettrash').css('display','');
								//$('##dropfavtrash').css('display','');
							}
						});
						<cfif isdate(expiry_date) AND expiry_date LT now()>
						$('##iconbar_file_#file_id#').css('display','none');
						</cfif>
					});
					</script>
					<tr class="list thumbview">
						<td valign="top" width="1%" nowrap="true">
							<cfif is_available>
								<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;">
									<div id="draggable#file_id#" type="#file_id#-doc">
										<!--- Show the thumbnail --->										<cfif (application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix") AND (file_extension EQ "PDF" OR file_extension EQ "indd")>
											<cfif cloud_url NEQ "">
												<img src="#cloud_url#" border="0" img-tt="img-tt">
											<cfelse>
												<img src="#dynpath#/global/host/dam/images/icons/image_missing.png" border="0">
											</cfif>
										<cfelseif application.razuna.storage EQ "local" AND (file_extension EQ "PDF" OR file_extension EQ "indd")>
											<cfset thethumb = replacenocase(file_name_org, ".#file_extension#", ".jpg", "all")>
											<cfif FileExists("#attributes.assetpath#/#session.hostid#/#path_to_asset#/#thethumb#") IS "no">
												<img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" width="128" height="128" border="0">
											<cfelse>
												<img src="#cgi.context_path#/assets/#session.hostid#/#path_to_asset#/#thethumb#?#uniqueid#" border="0" img-tt="img-tt">
											</cfif>
										<cfelse>
											<cfif FileExists("#ExpandPath("../../")#global/host/dam/images/icons/icon_#file_extension#.png") IS "no"><img src="#dynpath#/global/host/dam/images/icons/icon_txt.png" width="128" height="128" border="0"><cfelse><img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" width="128" height="128" border="0"></cfif>
										</cfif>
									</div>
								</a>
								<cfif attributes.folder_id NEQ folder_id_r>
									<div style="float:right">
										<em>(Alias)</em>
									</div>
									<div style="clear:both;"></div>
								</cfif>
							<cfelse>
								"#file_name#" en cours de traitement !
								<br /><br>
								#myFusebox.getApplicationData().defaults.trans("date_created")#:<br>
								#dateformat(file_create_date, "#myFusebox.getApplicationData().defaults.getdateformat()#")# #timeformat(file_create_date, "HH:mm")#
								<br>
							</cfif>
							<!--- Icons --->
							<div style="padding-top:5px;width:130px;white-space:nowrap;">
								<div style="float:left;">
									<input type="checkbox" name="file_id" value="#file_id#-doc" onclick="enablesub('#attributes.kind#form');"<cfif listfindnocase(session.file_id,"#file_id#-doc") NEQ 0> checked="checked"</cfif>>
								</div>
								<div style="float:right;padding-top:2px;">
									<div id="iconbar_file_#file_id#" style="display:inline">
										<a href="##" onclick="showwindow('#myself#c.file_download&file_id=#file_id#&kind=doc&folderaccess=#attributes.folderaccess#','#JSStringFormat(myFusebox.getApplicationData().defaults.trans("download"))#',650,1);return false;" title="#myFusebox.getApplicationData().defaults.trans("download_to_desktop")#"><img src="#dynpath#/global/host/dam/images/go-down.png" width="16" height="16" border="0" /></a>
										<cfif cs.show_basket_part AND cs.button_basket AND (isadmin OR cs.btn_basket_slct EQ "" OR listfind(cs.btn_basket_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.btn_basket_slct,session.thegroupofuser) NEQ "")><a href="##" onclick="loadcontent('thedropbasket','#myself#c.basket_put&file_id=#file_id#-doc&thetype=#file_id#-doc');flash_footer('#myFusebox.getApplicationData().defaults.trans("item_basket")#');return false;" title="#myFusebox.getApplicationData().defaults.trans("put_in_basket")#"><img src="#dynpath#/global/host/dam/images/basket-put.png" width="16" height="16" border="0" /></a></cfif>
										<cfif cs.button_send_email AND (isadmin OR cs.btn_email_slct EQ "" OR listfind(cs.btn_email_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.btn_email_slct,session.thegroupofuser) NEQ "")>
											<a href="##" onclick="showwindow('#myself##xfa.sendemail#&file_id=#file_id#&thetype=doc','#myFusebox.getApplicationData().defaults.trans("send_with_email")#',700,2);return false;" title="#myFusebox.getApplicationData().defaults.trans("send_with_email")#"><img src="#dynpath#/global/host/dam/images/mail-message-new-3.png" width="16" height="16" border="0" /></a>
										</cfif>
										<cfif cs.show_favorites_part>
											<a href="##" onclick="loadcontent('thedropfav','#myself#c.favorites_put&favid=#file_id#&favtype=file&favkind=doc');flash_footer('#myFusebox.getApplicationData().defaults.trans("item_favorite")#');return false;" title="Add to favorites"><img src="#dynpath#/global/host/dam/images/favs_16.png" width="16" height="16" border="0" /></a>
										</cfif>
									</div>
									<cfif attributes.folderaccess NEQ "R">
										<cfif cs.show_trash_icon AND (isadmin OR  cs.show_trash_icon_slct EQ "" OR listfind(cs.show_trash_icon_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.show_trash_icon_slct,session.thegroupofuser) NEQ "")>
											<cfif attributes.folder_id NEQ folder_id_r>
												<a href="##" onclick="showwindow('#myself#ajax.trash_alias&id=#file_id#&loaddiv=#attributes.kind#&folder_id=#attributes.folder_id#&showsubfolders=#attributes.showsubfolders#&offset=#session.offset#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("alias_remove_button"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a>
											<cfelse>
												<a href="##" onclick="showwindow('#myself#ajax.trash_record&id=#file_id#&what=files&loaddiv=#attributes.kind#&folder_id=#attributes.folder_id#&showsubfolders=#attributes.showsubfolders#&offset=#session.offset#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("trash"))#',400,1);return false;" title="#myFusebox.getApplicationData().defaults.trans("trash")#"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a>
											</cfif>
										</cfif>
									</cfif>
								</div>
							</div>
						</td>
						<!--- Keywords, etc --->
						<td valign="top" width="100%">
							<div style="float:left;padding-right:10px;">
								#myFusebox.getApplicationData().defaults.trans("file_name")#<br />
								<input type="text" name="#file_id#_doc_filename" value="#file_name#" style="width:300px;"><br />
								#myFusebox.getApplicationData().defaults.trans("description")#<br />
								<textarea name="#file_id#_doc_desc_1" style="width:300px;height:30px;">#description#</textarea>
							</div>
							<div style="float:left;">
								#myFusebox.getApplicationData().defaults.trans("labels")#<br />
								<select data-placeholder="#myFusebox.getApplicationData().defaults.trans('choose_label')#" class="chzn-select" style="width:410px;" id="tags_doc_qe_#file_id#" onchange="razaddlabels('tags_doc_qe_#file_id#','#file_id#','doc','#myFusebox.getApplicationData().defaults.trans("change_saved")#');" multiple="multiple">
									<option value=""></option>
									<cfloop query="attributes.thelabelsqry">
										<option value="#label_id#"<cfif ListFind(labels,'#label_id#') NEQ 0> selected="selected"</cfif>>#label_path#</option>
									</cfloop>
								</select>
								<br />
								#myFusebox.getApplicationData().defaults.trans("keywords")#<br />
								<textarea name="#file_id#_doc_keywords_1" style="width:400px;height:30px;">#keywords#</textarea>									
							</div>
						</td>
					</tr>
				</cfloop>
				<tr>
					<td colspan="4" align="right"><div id="updatestatusdoc2" style="float:left;"></div><input type="button" value="#myFusebox.getApplicationData().defaults.trans("save_changes")#" onclick="combinedsavedoc();return false;" class="button"></td>
				</tr>
			<!--- List view --->
			<cfelseif session.view EQ "list">
				<tr>
					<td></td>
					<td nowrap="true"></td>
					<td nowrap="true" align="center"><b>#myFusebox.getApplicationData().defaults.trans("date_created")#</b></td>
					<td nowrap="true" align="center"><b>#myFusebox.getApplicationData().defaults.trans("date_changed")#</b></td>
				</tr>
				<!--- Show Subfolders --->
				<cfinclude template="inc_folder_list.cfm">
				<cfloop query="qry_files">
					<cfset mycurrentRow = (session.offset * session.rowmaxpage) + currentRow>
					<script type="text/javascript">
					$(function() {
						$("##draggable#file_id#").draggable({
							appendTo: 'body',
							cursor: 'move',
							addClasses: false,
							iframeFix: true,
							opacity: 0.25,
							zIndex: 6,
							helper: 'clone',
							start: function() {
								//$('##dropbaskettrash').css('display','none');
								//$('##dropfavtrash').css('display','none');
							},
							stop: function() {
								//$('##dropbaskettrash').css('display','');
								//$('##dropfavtrash').css('display','');
							}
						});
						<cfif isdate(expiry_date) AND expiry_date LT now()>
						$('##iconbar_file_#file_id#').css('display','none');
						</cfif>
					});
					</script>
					<tr class="list thumbview">
						<td valign="center">
							<cfif is_available>
								<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;">
									<div id="draggable#file_id#" type="#file_id#-doc">
										<!--- Show the thumbnail --->										<cfif (application.razuna.storage EQ "amazon" OR application.razuna.storage EQ "nirvanix") AND (file_extension EQ "PDF" OR file_extension EQ "indd")>
											<cfif cloud_url NEQ "">
												<img src="#cloud_url#" border="0" img-tt="img-tt">
											<cfelse>
												<img src="#dynpath#/global/host/dam/images/icons/image_missing.png" border="0">
											</cfif>
										<cfelseif application.razuna.storage EQ "local" AND (file_extension EQ "PDF" OR file_extension EQ "indd")>
											<cfset thethumb = replacenocase(file_name_org, ".#file_extension#", ".jpg", "all")>
											<cfif FileExists("#attributes.assetpath#/#session.hostid#/#path_to_asset#/#thethumb#") IS "no">
												<img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" width="128" height="128" border="0">
											<cfelse>
												<img src="#cgi.context_path#/assets/#session.hostid#/#path_to_asset#/#thethumb#?#uniqueid#" border="0" img-tt="img-tt">
											</cfif>
										<cfelse>
											<cfif FileExists("#ExpandPath("../../")#global/host/dam/images/icons/icon_#file_extension#.png") IS "no"><img src="#dynpath#/global/host/dam/images/icons/icon_txt.png" width="128" height="128" border="0"><cfelse><img src="#dynpath#/global/host/dam/images/icons/icon_#file_extension#.png" width="128" height="128" border="0"></cfif>
										</cfif>
									</div>
								</a>
								<cfif attributes.folder_id NEQ folder_id_r>
									<div style="float:right">
										<em>(Alias)</em>
									</div>
									<div style="clear:both;"></div>
								</cfif>
							<cfelse>
								"#file_name#" en cours de traitement !
								<br />
							</cfif>
						</td>
						<td width="100%" valign="top">
							<a href="##" onclick="showwindow('#myself##xfa.assetdetail#&file_id=#file_id#&what=files&loaddiv=#kind#&folder_id=#folder_id#&showsubfolders=#attributes.showsubfolders#&row=#mycurrentRow#&filecount=#qry_filecount.thetotal#','',1070,1);return false;"><strong>#file_name#</strong></a>
							<br />
							<!--- Icons --->
							<div style="float:left;padding-top:5px;">
								<div style="float:left;padding-top:2px;">
									<input type="checkbox" name="file_id" value="#file_id#-doc" onclick="enablesub('#attributes.kind#form');"<cfif listfindnocase(session.file_id,"#file_id#-doc") NEQ 0> checked="checked"</cfif>>
								</div>
								<div style="float:right;padding-top:2px;">
									<div id="iconbar_file_#file_id#" style="display:inline">
										<a href="##" onclick="showwindow('#myself#c.file_download&file_id=#file_id#&kind=doc&folderaccess=#attributes.folderaccess#','#JSStringFormat(myFusebox.getApplicationData().defaults.trans("download"))#',650,1);return false;" title="#myFusebox.getApplicationData().defaults.trans("download_to_desktop")#"><img src="#dynpath#/global/host/dam/images/go-down.png" width="16" height="16" border="0" /></a>
										<cfif cs.show_basket_part AND cs.button_basket AND (isadmin OR cs.btn_basket_slct EQ "" OR listfind(cs.btn_basket_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.btn_basket_slct,session.thegroupofuser) NEQ "")><a href="##" onclick="loadcontent('thedropbasket','#myself#c.basket_put&file_id=#file_id#-#kind#&thetype=#file_id#-img');flash_footer('#myFusebox.getApplicationData().defaults.trans("item_basket")#');return false;" title="#myFusebox.getApplicationData().defaults.trans("put_in_basket")#"><img src="#dynpath#/global/host/dam/images/basket-put.png" width="16" height="16" border="0" /></a></cfif>
										<cfif cs.button_send_email AND (isadmin OR cs.btn_email_slct EQ "" OR listfind(cs.btn_email_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.btn_email_slct,session.thegroupofuser) NEQ "")>
											<a href="##" onclick="showwindow('#myself##xfa.sendemail#&file_id=#file_id#&thetype=#kind#','#myFusebox.getApplicationData().defaults.trans("send_with_email")#',700,2);return false;" title="#myFusebox.getApplicationData().defaults.trans("send_with_email")#"><img src="#dynpath#/global/host/dam/images/mail-message-new-3.png" width="16" height="16" border="0" /></a>
										</cfif>
										<cfif cs.show_favorites_part>
											<a href="##" onclick="loadcontent('thedropfav','#myself#c.favorites_put&favid=#file_id#&favtype=file&favkind=#kind#');flash_footer('#myFusebox.getApplicationData().defaults.trans("item_favorite")#');return false;" title="Add to favorites"><img src="#dynpath#/global/host/dam/images/favs_16.png" width="16" height="16" border="0" /></a>
										</cfif>
									</div>
									<cfif attributes.folderaccess NEQ "R">
										<cfif cs.show_trash_icon AND (isadmin OR  cs.show_trash_icon_slct EQ "" OR listfind(cs.show_trash_icon_slct,session.theuserid) OR myFusebox.getApplicationData().global.comparelists(cs.show_trash_icon_slct,session.thegroupofuser) NEQ "")>
											<cfif attributes.folder_id NEQ folder_id_r>
												<a href="##" onclick="showwindow('#myself#ajax.trash_alias&id=#file_id#&loaddiv=#attributes.kind#&folder_id=#attributes.folder_id#&showsubfolders=#attributes.showsubfolders#&offset=#session.offset#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("alias_remove_button"))#',400,1);return false;"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a>
											<cfelse>
												<a href="##" onclick="showwindow('#myself#ajax.trash_record&id=#file_id#&what=files&loaddiv=#attributes.kind#&folder_id=#attributes.folder_id#&showsubfolders=#attributes.showsubfolders#&offset=#session.offset#','#Jsstringformat(myFusebox.getApplicationData().defaults.trans("trash"))#',400,1);return false;" title="#myFusebox.getApplicationData().defaults.trans("trash")#"><img src="#dynpath#/global/host/dam/images/trash.png" width="16" height="16" border="0" /></a>
											</cfif>
										</cfif>
									</cfif>
								</div>
							</div>
						</td>
						<td nowrap="true" width="1%" align="center" valign="top">#dateformat(file_create_date, "#myFusebox.getApplicationData().defaults.getdateformat()#")#</td>
						<td nowrap="true" width="1%" align="center" valign="top">#dateformat(file_change_date, "#myFusebox.getApplicationData().defaults.getdateformat()#")#</td>
					</tr>
				</cfloop>
			</cfif>
			<!--- Icon Bar --->
			<tr>
				<td colspan="6" class="gridno"><cfset attributes.bot = true><cfinclude template="dsp_icon_bar.cfm"></td>
			</tr>
		</table>
		</form>
	
		<!--- JS for the combined view --->
		<script language="JavaScript" type="text/javascript">
			<cfif session.file_id NEQ "">
				enablesub('#attributes.kind#form');
			</cfif>
			// Submit form
			function combinedsavedoc(){
				loadinggif('updatestatusdoc');
				loadinggif('updatestatusdoc2');
				$("##updatestatusdoc").fadeTo("fast", 100);
				$("##updatestatusdoc2").fadeTo("fast", 100);
				var url = formaction("#kind#form");
				var items = formserialize("#kind#form");
				// Submit Form
		       	$.ajax({
					type: "POST",
					url: url,
				   	data: items,
				   	success: function(){
						// Update Text
						$("##updatestatusdoc").css('color','green');
						$("##updatestatusdoc2").css('color','green');
						$("##updatestatusdoc").css('font-weight','bold');
						$("##updatestatusdoc2").css('font-weight','bold');
						$("##updatestatusdoc").html("#myFusebox.getApplicationData().defaults.trans("success")#");
						$("##updatestatusdoc2").html("#myFusebox.getApplicationData().defaults.trans("success")#");
						$("##updatestatusdoc").animate({opacity: 1.0}, 3000).fadeTo("slow", 0.33);
						$("##updatestatusdoc2").animate({opacity: 1.0}, 3000).fadeTo("slow", 0.33);
				   	}
				});
		        return false; 
			}
			<cfif session.view EQ "combined">
				// Activate Chosen
				$(".chzn-select").chosen({search_contains: true});
			</cfif>
			$(document).ready(function() {
				$("###kind#form ##selectme").selectable({
					cancel: 'a,:input',
					stop: function(event, ui) {
						var fileids = '';
						$( ".ui-selected input[name='file_id']", this ).each(function() {
							fileids += $(this).val() + ','
						});
						getselected#kind#(fileids);
						// Now uncheck all
						$('###kind#form :checkbox').prop('checked', false);
					}
				});
			});
			function getselected#kind#(fileids){
				// Get all that are selected
				// alert(fileids);
				$('##div_forall').load('index.cfm?fa=c.store_file_values',{file_id:fileids});
				enablefromselectable('#kind#form');
			}
		</script>
	</cfif>
</cfoutput>