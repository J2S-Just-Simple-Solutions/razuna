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
<cfoutput>
	<cffunction name="searchforthesaurus" access="remote" returntype="string">
		<!--- If no total search or multi search --->
		<cfif search_value NEQ "*" and find(' OR ', search_value) eq 0>
			<!--- Get thesaurus data --->
			<cfhttp url="http://ima.j2s.net/thesaurus_ws/ForSearch.php?uniterm=#search_value#" method="post" result="result" charset="utf-8"/>
			<cfset response = deserializeJSON(result.filecontent)> 
			<!--- I got response --->
			<cfif response.err EQ 200>
				<cfset str="">
				<!--- Construct and return fomatted search value --->
				<cfloop array=#response.values# index="name">
					<cfif str eq ""><cfset str="'#name#'" ></cfif>
					<cfelse><cfset str="#str# OR '#name#'" >
				</cfloop>
				<cfreturn str/>
			</cfif>	
		</cfif>
		<cfreturn search_value/>
	</cffunction>
	<!---RAZ-2834:: Assign the custom field customized --->
	<cfset custom_fields = "">
	<cfif !structKeyExists(variables,"cf_inline")><table border="0" cellpadding="0" cellspacing="0" width="450" class="grid"></cfif>
		<cfloop query="qry_cf">
			<cfif ! (qry_cf.cf_show EQ attributes.cf_show OR qry_cf.cf_show EQ 'all')>
				<cfcontinue>
			</cfif>
			<cfset custom_fields = listappend(custom_fields,"#cs.customfield_images_metadata#",',')>
			<cfset custom_fields = listappend(custom_fields,"#cs.customfield_audios_metadata#",',')>
			<cfset custom_fields = listappend(custom_fields,"#cs.customfield_videos_metadata#",',')>
			<cfset custom_fields = listappend(custom_fields,"#cs.customfield_files_metadata#",',')>
			<cfset custom_fields = listappend(custom_fields,"#cs.customfield_all_metadata#",',')>
			<tr>
				<cfif !structKeyExists(variables,"cf_inline")>
					<td width="130" nowrap="true"<cfif cf_type EQ "textarea"> valign="top"</cfif>><strong>#cf_text#</strong></td>
					<td width="320">
				<cfelse>
					<td>
				</cfif>
					<!--- For text --->
					<cfif cf_type EQ "text">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<input type="text" style="width:300px;" id="cf_text_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')>onchange="document.form#attributes.file_id#.cf_meta_text_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_text_#listlast(cf_id,'-')#.value;" </cfif>  <cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif !allowed> disabled="disabled"</cfif>>
					<!--- Radio --->
					<cfelseif cf_type EQ "radio">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<input type="radio" name="cf_#cf_id#" id="cf_radio_yes#listlast(cf_id,'-')#" value="T" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')> onchange="document.form#attributes.file_id#.cf_meta_radio_yes#listlast(cf_id,'-')#.checked = document.form#attributes.file_id#.cf_radio_yes#listlast(cf_id,'-')#.checked;" </cfif> <cfif cf_value EQ "T"> checked="true"</cfif><cfif !allowed> disabled="disabled"</cfif>>#myFusebox.getApplicationData().defaults.trans("yes")# 
						<input type="radio" name="cf_#cf_id#" id="cf_radio_no#listlast(cf_id,'-')#" value="F" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')> onchange="document.form#attributes.file_id#.cf_meta_radio_no#listlast(cf_id,'-')#.checked = document.form#attributes.file_id#.cf_radio_no#listlast(cf_id,'-')#.checked;" </cfif> <cfif cf_value EQ "F" OR cf_value EQ ""> checked="true"</cfif><cfif !allowed> disabled="disabled"</cfif>>#myFusebox.getApplicationData().defaults.trans("no")#
					<!--- Textarea --->
					<cfelseif cf_type EQ "textarea">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<textarea name="cf_#cf_id#" id="cf_textarea_#listlast(cf_id,'-')#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')> onchange="document.form#attributes.file_id#.cf_meta_textarea_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_textarea_#listlast(cf_id,'-')#.value;" </cfif> style="width:310px;height:60px;"<cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif !allowed> disabled="disabled"</cfif>>#cf_value#</textarea>
					<!--- Select --->
					<cfelseif cf_type EQ "select">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<select name="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')> onchange="document.form#attributes.file_id#.cf_meta_select_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_select_#listlast(cf_id,'-')#.value;" </cfif> style="width:300px;"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#ltrim(ListSort(replace(cf_select_list,', ',',','ALL'), 'text', 'asc', ','))#" index="i">
								<option value="#i#"<cfif i EQ "#cf_value#"> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
					<!--- Select-search --->
					<cfelseif cf_type EQ "select-search">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<select name="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" style="width:300px;"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#ltrim(ListSort(REReplace(cf_select_list, ",(?![^()]+\))\s?" ,';','ALL'), 'text', 'asc', ';'))#" index="i" delimiters=";">
								<option value="#i#"<cfif i EQ "#cf_value#"> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var select = $("td select[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									select.chosen({add_contains: true});		

									var chosen = select.next(".chosen-container");
									//Sur entrée
									chosen.find("input").on("keyup", function(ev){	
										//J'ajoute à la liste							
										if(ev.keyCode === 13 && chosen.find(".chosen-results .active-result").length === 0){
											//Je mets à jour ma liste
											var currentValue = $(this).val();
											select.append('<option value="'+currentValue+'">'+currentValue+'</option>');								
											select.trigger("chosen:updated");
											//Je met à jour le serveur
											var values = [];
											$.each(select.find("option"), function(index, item){
												if($(item).html().length > 0)
													values.push($(item).html())
											})
											var self = this;
											$.get(
												"../../global/api2/J2S.cfc?method=updateCustomField&select_list=" + values.join(",") + "&cf_id=" + "#qry_cf.cf_id#" + "&prefix=" + prefix + "&user_id=#session.theuserid#", 
													// NITA Modif ajout du user id
												function(result){}
											);
											//Je trigger l'event à nouveau
											$(this).val(currentValue).trigger("keyup").trigger(ev);					
										}
										else {
											chosen.find(".chosen-results .no-results").append(". Press enter to add and select");
										}
									})
								})(this);
							</script>
						</cfoutput>	
					<!--- select-category --->
					<cfelseif cf_type EQ "select-category">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<input type="text" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select multiple type="category" category="cf_#cf_id#" id="cf_select_category_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" <cfif !allowed> disabled="disabled"</cfif>>
							<cfset x = ["mars","earth", "venus", "jupiter"]>
							<option value=""></option>
							<cfloop list="#ltrim(replace(cf_select_list,', ',',','ALL'))#" index="i">
								<option value="#i#" <cfif listContains("#cf_value#", #i#, ",")> selected="selected"</cfif>>#i#</option>
							</cfloop>						
						</select>						
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var category = $("select[category='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");

									category.chosen().change(function(){
										var values = []; 
										$.each(category[0].selectedOptions, function(index, item){values.push(item.text)})
										input.val(values.join(","));
									});
								})(this);
							</script>
						</cfoutput>						
					<!--- select-category --->
					<cfelseif cf_type EQ "select-sub-category">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<input type="text" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select  multiple type="sub-category" sub-category="cf_#cf_id#" id="cf_select_sub_category_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" <cfif !allowed> disabled="disabled"</cfif>>
							<cfset list = "#cf_select_list#"> 
							<cfset category = listToArray(list, ";", true)>							
							<cfloop array=#category# index="i" delimiters=";" item="name">								
								<cfset category[#i#] = "#ltrim(ListSort(REReplace(name, ",(?![^()]+\))\s?" ,';','ALL'), 'text', 'asc', ';'))#" />
							</cfloop>					
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var category = $("select[type=category]");
									var subCategory = $("select[sub-category='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");

									
									subCategory.chosen().change(function(){
										var values = []; 
										$.each(subCategory[0].selectedOptions, function(index, item){values.push(item.text)})
										input.val(values.join(","));
									});

									//La catégorie parente change, je charge la sous-catégorie
									var categoryChangeHandler = function(event){
										//les valeurs sélectionnées
										var selectedList = [];
										$.each( subCategory[0].selectedOptions, function(index, item){selectedList.push(item.text)})
										if(selectedList.length === 0 ){selectedList = "<cfoutput>#cf_value#</cfoutput>"}

										//La liste complète
										var #toScript(category, "values")#
										var list = values.join(";").split(";");
										var categoryList = [];

										//Je nettoie
										subCategory.val("");
										subCategory.empty();
										
										//Je récupère les catégories sélectionnées
										for ( var j = 0 ; j < category[0].selectedOptions.length ; j++) {
											categoryList = categoryList.concat(values[category[0].selectedOptions[j].index - 1].split(";"));
										}

										//Pour chaque valeurs
										for(var i = 0 ; i < list.length ; i++){
											var item = list[i];
											//Si elle est dans la liste des catégorie
											if(categoryList.indexOf(item) > - 1 ) {
												//Je l'ajoute avec l'option selected si elle est sélectionnée
												if(selectedList.indexOf(item) > -1) {subCategory.append("<option value="+item+" selected=selected>"+item+"</option>");}
												else {subCategory.append("<option value="+item+" >"+item+"</option>");}
											}			
										}
										//je mets à jour
										subCategory.trigger("chosen:updated").trigger("change");										
									};

									category.chosen().change(categoryChangeHandler);
									categoryChangeHandler();
								})(this);
							</script>
						</cfoutput>
					<!--- Descripteur --->
					<cfelseif cf_type EQ "descriptor">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<input type="text" style="width:300px;" id="cf_descriptor_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select multiple type="descriptor" descriptor="cf_#cf_id#" id="cf_select_descriptor_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" <cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#ltrim(replace(cf_value,', ',',','ALL'))#" index="i">
								<option value="#i#" <cfif listContains("#cf_value#", #i#, ",")> selected="selected"</cfif>>#i#</option>
							</cfloop>						
						</select>						
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var descriptor = $("select[descriptor='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");

									//Je construit mon Cchamp multiple avec les valeurs initiale
									descriptor.chosen().change(function(){
										input.val(getSelected().join(","));
									});

									var inputChangeTimer = null;
									descriptor.next(".chosen-container").find("input").unbind()
										//Sur "Enter", je valide la sélection
										.on("keydown", function(ev){
											if(ev.keyCode===13){
												ev.stopPropagation();
												ev.preventDefault();
												descriptor.next(".chosen-container").find(".highlighted").trigger("mousedown").trigger("mouseup");
											}
										})
										//Sur la pression d'une touche, j'intérroge le thesaurus
										.on("keyup", function(ev){	
											clearTimeout(inputChangeTimer);
											inputChangeTimer = setTimeout(function(){inputChange(ev)}, 200);								
										});

									//gestion thésaurus
									var inputChange = function(ev){
										var input = descriptor.next(".chosen-container").find("input");
										input.css("width", "auto");
										$.getJSON(
										"http://ima.j2s.net/thesaurus_ws/ForDescriptor.php?uniterm="+input.val(), 
										function(result){
											//J'ai un résultat
											if(result.value){
												var values = getSelected();
												//je nettoie les options qui ne sont plus nécessaire
												$.each(descriptor.find("option"), function(index, item){
													if(values.indexOf(item.text) === -1)
														$(item).remove()
												})
												//J'ajoute la nouvelle option
												if(descriptor.find("option[value='"+result.value+"']").length == 0)
													descriptor.append('<option value="'+result.value+'">'+result.value+'</option>');								
												descriptor.trigger("chosen:updated");
												descriptor.trigger("chosen:activate");
												input.trigger("click");
											}
										});
									};

									//Demande la sélection
									var getSelected = function() {
										var values = []; 
										$.each(descriptor[0].selectedOptions, function(index, item){values.push(item.text)});
										return values;
									}
	
								})(this);
							</script>
						</cfoutput>	
					<!--- Candidat descripteur --->
					<cfelseif cf_type EQ "candidate-descriptor">
						<!--- Variable --->
						<cfset allowed = false>
						<!--- Check for Groups --->
						<cfloop list="#session.thegroupofuser#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<!--- Check for users --->
						<cfloop list="#session.theuserid#" index="i">
							<cfif listfind(cf_edit,i)>
								<cfset allowed = true>
								<cfbreak>
							</cfif>
						</cfloop>
						<cfif !isnumeric(cf_edit) AND cf_edit EQ "true">
							<cfset allowed = true>
						</cfif>
						<select name="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" style="width:300px;"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#ltrim(ListSort(REReplace(cf_select_list, ",(?![^()]+\))\s?" ,';','ALL'), 'text', 'asc', ';'))#" index="i" delimiters=";">
								<option value="#i#"<cfif i EQ "#cf_value#"> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var select = $("td select[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									select.chosen({add_contains: true});		

									var chosen = select.next(".chosen-container");
									//Sur entrée
									chosen.find("input").on("keyup", function(ev){	
										//J'ajoute à la liste							
										if(ev.keyCode === 13 && chosen.find(".chosen-results .active-result").length === 0){
											//Je mets à jour ma liste
											var currentValue = $(this).val();
											select.append('<option value="'+currentValue+'">'+currentValue+'</option>');								
											select.trigger("chosen:updated");
											//Je met à jour le serveur
											var values = [];
											$.each(select.find("option"), function(index, item){
												if($(item).html().length > 0)
													values.push($(item).html())
											})
											var self = this;
											$.get(
												"../../global/api2/J2S.cfc?method=updateCustomField&select_list=" + values.join(",") + "&cf_id=" + "#qry_cf.cf_id#" + "&prefix=" + prefix + "&user_id=#session.theuserid#", 
													// NITA Modif ajout du user id
												function(result){}
											);
											//Je trigger l'event à nouveau
											$(this).val(currentValue).trigger("keyup").trigger(ev);					
										}
										else {
											chosen.find(".chosen-results .no-results").append(". Press enter to add and select");
										}
									})
								})(this);
							</script>
						</cfoutput>			
					</cfif>
				</td>
			</tr>
		</cfloop>
	<cfif !structKeyExists(variables,"cf_inline")></table></cfif>
</cfoutput>