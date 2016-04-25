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

<!---
	<cfsearch collection="#session.hostid#" criteria="000" name="results" />
	<cfdump var="#results.recordCount#" />--->

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
					<td valign="top" width="130" nowrap="true"<cfif cf_type EQ "textarea"> valign="top"</cfif>><strong>#cf_text#</strong></td>
					<td>
				<cfelse>
					<td>
				</cfif>

					<!---------------->
					<!--- For text --->
					<!---------------->
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


						<!--- Razuna Code --->
						<!--- <input type="text" style="width:400px;" id="cf_text_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')>onchange="document.form#attributes.file_id#.cf_meta_text_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_text_#listlast(cf_id,'-')#.value;" </cfif>  <cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif !allowed> disabled="disabled"</cfif>>--->

						<!--- J2S Code --->
						<input type="text" dir="auto" style="width:300px;" id="cf_text_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')>onchange="document.form#attributes.file_id#.cf_meta_text_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_text_#listlast(cf_id,'-')#.value;" </cfif>  <cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif !allowed> disabled="disabled"</cfif>>


					<!------------->
					<!--- Radio --->
					<!------------->
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
					
					<!---------------->
					<!--- Textarea --->
					<!---------------->
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

						<!--- J2S: adding of dir="auto" to display correctly arabic texts --->
						<textarea name="cf_#cf_id#" dir="auto" id="cf_textarea_#listlast(cf_id,'-')#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')> onchange="document.form#attributes.file_id#.cf_meta_textarea_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_textarea_#listlast(cf_id,'-')#.value;" </cfif> style="width:400px;height:50px;"<cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif !allowed> disabled="disabled"</cfif>>#cf_value#</textarea>

					<!-------------->
					<!--- Select --->
					<!-------------->
					<cfelseif cf_type EQ "select" OR cf_type EQ "select_multi">

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
						<select name="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" <cfif listFindNoCase(custom_fields,'#qry_cf.cf_id#',',')> onchange="document.form#attributes.file_id#.cf_meta_select_#listlast(cf_id,'-')#.value = document.form#attributes.file_id#.cf_select_#listlast(cf_id,'-')#.value;" </cfif> style="width:300px;"<cfif !allowed> disabled="disabled"</cfif><cfif cf_type EQ "select_multi"> multiple="multiple"</cfif>>
							<cfif cf_type NEQ "select_multi">
								<option value=""></option>
							</cfif>
							<cfloop list="#ltrim(ListSort(replace(cf_select_list,', ',',','ALL'), 'text', 'asc', ','))#" index="i">
								<cfif cf_type NEQ "select_multi">
									<option value="#i#"<cfif i EQ "#cf_value#"> selected="selected"</cfif>>#i#</option>
								<cfelse>
									<option value="#i#"<cfif ListFindnocase(cf_value, i, ",")> selected="selected"</cfif>>#i#</option>
								</cfif>
							</cfloop>
						</select>

					<!--------------------->
					<!--- Select-search --->
					<!--------------------->
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
						<select name="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_an_option")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#ltrim(ListSort(cf_select_list, 'text', 'asc', ','))#" index="i" delimiters=",">
								<option value="#i#"<cfif i EQ "#cf_value#"> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var select = $("td select[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									select.chosen({add_contains: true, no_results_text:"<cfoutput>#myFusebox.getApplicationData().defaults.trans("no_match")#</cfoutput>"});		

									var chosen = select.next(".chosen-container");
									//Sur entrée
									chosen.find("input").on("keyup", function(ev){	
										//J'ajoute à la liste							
										if(ev.keyCode === 13 && chosen.find(".chosen-results .active-result").length === 0){
											//Je mets à jour ma liste
											var currentValue = $(this).val();
											select.append('<option value="'+currentValue+'">'+currentValue+'</option>');								
											select.trigger("chosen:updated");
											//Je mets à jour le serveur
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
											chosen.find(".chosen-results .no-results").html("<cfoutput>#myFusebox.getApplicationData().defaults.trans("select_no_match")#</cfoutput>");
										}
									})
								})(this);
							</script>
						</cfoutput>	

					<!----------------------->
					<!--- select-category --->
					<!----------------------->
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
						<input type="text" dir="auto" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<cfset cf_value2="#REReplace(cf_value, ",\s", ",", "ALL")#">
						<!---<cfdump var="-#cf_value2#-"> --->
						<select multiple type="category" category="cf_#cf_id#" id="cf_select_category_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#cf_select_list#" index="word">
								<option value="#word#" <cfif ListFind("#cf_value2#", #word#, ",")> selected="selected"</cfif>>#word#</option>
							</cfloop>						
						</select>						
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var category = $("select[category='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");

									category.chosen({no_results_text:"<cfoutput>#myFusebox.getApplicationData().defaults.trans("no_match")#</cfoutput>"}).change(function(){
										var values = []; 
										$.each(category[0].selectedOptions, function(index, item){values.push(item.text)})
										input.val(values.join(", "));
									});
								})(this);
							</script>
						</cfoutput>
					<!----------------------->			
					<!--- select-sub-category --->
					<!----------------------->
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
						<input type="text" dir="auto" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select  multiple type="sub-category" sub-category="cf_#cf_id#" id="cf_select_sub_category_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<cfset list = "#cf_select_list#"> 
							<cfset category = listToArray(list, ";", true)>							
							<cfloop array=#category# index="i" delimiters=";" item="name">								
								<cfset category[#i#] = "#ltrim(ListSort(name, 'text', 'asc', ','))#" />
							</cfloop>					
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var category = $("select[type=category]");
									var subCategory = $("select[sub-category='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									
									subCategory.chosen({no_results_text:"<cfoutput>#myFusebox.getApplicationData().defaults.trans("no_match")#</cfoutput>"}).change(function(){
										var values = []; 
										$.each(subCategory[0].selectedOptions, function(index, item){values.push(item.text)})
										input.val(values.join(", "));
									});

									//La catégorie parente change, je charge la sous-catégorie
									var categoryChangeHandler = function(event){
										//les valeurs sélectionnées
										var selectedList = [];
										$.each( subCategory[0].selectedOptions, 
											function(index, item){
												selectedList.push(item.text)
											}
										);
										if(selectedList.length === 0 ){
											selectedList = "<cfoutput>#cf_value#</cfoutput>";
										}

										//La liste complète
										var #toScript(category, "values")#
										var list = values.join(",").split(",");
										var categoryList = [];

										//Je nettoie
										subCategory.val("");
										subCategory.empty();
										
										//Je récupère les catégories sélectionnées
										for ( var j = 0 ; j < category[0].selectedOptions.length ; j++) {
											var cat = values[category[0].selectedOptions[j].index - 1];
											categoryList = categoryList.concat(cat? cat.split(",") : "");
										}

										//Pour chaque valeur
										for(var i = 0 ; i < list.length ; i++){
											var item = list[i];
											//Si elle est dans la liste des catégories
											if(categoryList.indexOf(item) > - 1 ) {
												//Je l'ajoute avec l'option selected si elle est sélectionnée
												if(selectedList.indexOf(item) > -1) {
													subCategory.append("<option value="+item+" selected=selected>"+item+"</option>");
												}
												else {
													subCategory.append("<option value="+item+" >"+item+"</option>");
												}
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

					<!------------------->
					<!--- Descripteur --->
					<!------------------->
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
						<input type="text" dir="auto" style="width:300px;" id="cf_descriptor_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select multiple type="descriptor" descriptor="cf_#cf_id#" id="cf_select_descriptor_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>					
						</select>						
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									$(document).ready(function(){
									// identifiants des composants du champ "Descripteurs"
									var inputDescriptor = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var selectDescriptor = $("select[descriptor='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var tgGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("TG")#</cfoutput>" >');
									var taGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("TA")#</cfoutput>" >');
									var tsGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("TS")#</cfoutput>" >');

									//Je construis mon champ multiple avec les valeurs initiales
									selectDescriptor.chosen({no_results_text:"<cfoutput>#myFusebox.getApplicationData().defaults.trans("no_match")#</cfoutput>"})
										//Changement
										.change(function(event, params){
											// Ajout d'un descripteur
											if (params && params['selected']) {
												var term = params.selected;
												var replacement = $(event.target).find("option[value='"+term+"']").attr("replacement");
												// on désélectionne l'option correspondant au mot interdit...
												selectDescriptor.find("option[value='"+term+"']").removeProp("selected");
												// ...pour sélectionner le terme remplaçant à la place
												selectDescriptor.find("option[value='"+replacement+"']").prop("selected", true);
												// on dispatche l'event pour que le composant se mette à jour 
												selectDescriptor.trigger("chosen:updated");
												//
												inputDescriptor.val(getSelected().join(", "));	
											}
											// Suppression d'un descripteur
											else {
												inputDescriptor.val(getSelected().join(", "));
											}
											//console.log(inputDescriptor.val());								
											drop.css("display", "none");
											setTimeout(hoverListener,100);								
										})
										//Le composant est prêt
										.ready(function(){
											$.getJSON(
											"http://ima.j2s.net/Thesaurus_WS/AllTerms.php", 
											function(result){
												if(result.err === 200){
													var selectedList = "<cfoutput>#cf_value#</cfoutput>";
													
													//console.log("selectedList: "+selectedList);

													$.each(result.values.sort(), function(index, item){
														var term = item[0];
														var replacement = item[1];

														//console.log("item:"+item+"  0:"+item[0]+"   1:"+item[1]);

														// le terme est-il un terme interdit ?
														var isBanTerm = term !== replacement;// index 0 -> mot interdit, index 1 -> le terme remplaçant	
														// le terme est-il sélectionné ?
														var isSelected = selectedList.split(", ").indexOf(term) > -1;

														// style des termes interdits
														var banTermStyle = isBanTerm ? "style='color: red'" : "";
														// Termes sélectionnés
														var selectedAttr = isSelected ? "selected='selected'" : "";

														// Ajout de l'option
														selectDescriptor.append("<option "+banTermStyle+" value='"+term+"' replacement='"+replacement+"' "+selectedAttr+" >"+term+"</option>");
													});
													selectDescriptor.trigger("chosen:updated");
													setTimeout(hoverListener,100);	
												}
											});
										})
										//J'affiche la liste
										.on("chosen:showing_dropdown", function(){setTimeout(hoverListener,100);});

									//Je tape des caractères, j'écoute le hover sur les éléments
									selectDescriptor.next(".chosen-container").find("input").keyup(function(){setTimeout(hoverListener,100);});
									
									$("body").click(
										function(){
											drop.css("display", "none");
										}
									);
									var drop = $(
										'<div class="thesaurus-drop"><ul class="thesaurus-results">'+
										'<li class="thesaurus-result-group tg"><cfoutput>#myFusebox.getApplicationData().defaults.trans("TG")#</cfoutput></li>'+
										'<li class="thesaurus-result-group ta"><cfoutput>#myFusebox.getApplicationData().defaults.trans("TA")#</cfoutput></li>'+
										'<li class="thesaurus-result-group ts"><cfoutput>#myFusebox.getApplicationData().defaults.trans("TS")#</cfoutput></li>'+
										'</ul></div>');
									var hovered = null;
									var hoverTimer = null;
									var hoverHandler = function(ev){
										cleartHoverTimer();
										hovered = this;
										drop.css("display", "none");
										hoverTimer = setTimeout(function(){hoverShow(ev);}, 1000);
									};
									var hoverListener = function(){
										selectDescriptor.next(".chosen-container").find("li").unbind().hover(hoverHandler, cleartHoverTimer);
									};									
									var cleartHoverTimer = function(ev){
										if(hoverTimer){
											clearTimeout(hoverTimer);
										}
									};
									var hoverShow = function(ev){
										$("body").append(drop);
										drop.find(".thesaurus-result").remove();
										$.getJSON(
										"http://ima.j2s.net/Thesaurus_WS/ForDescriptor.php?uniterm="+ $(hovered).text(), 
											function(result){
												//J'ai un résultat
												if(result.err === 200){
													if(result.TG.length > 0 || result.TA.length > 1 || result.TS.length > 0 ) {
														drop.css("display", "block").css("top", ev.pageY).css("left", ev.pageX-300);
														drop.find(".ta,.tg,.ts").hide();
														//TG
														if(result.TG.length > 0){
															drop.find(".tg").show().after('<li class="thesaurus-result" value="'+result.TG+'">'+result.TG+'</li>');
														}
														//TA
														if(result.TA.length > 0){
															$.each(result.TA.reverse(), function(i,TA){
																drop.find(".ta").show().after('<li class="thesaurus-result" value="'+TA+'">'+TA+'</li>');
															});
														}
														//TS
														if(result.TS.length > 0){
															$.each(result.TS.reverse(), function(i,TS){
																drop.find(".ts").show().after('<li class="thesaurus-result" value="'+TS+'">'+TS+'</li>');
															});
														}
													}
													//J'écoute la sélection
													drop.find(".thesaurus-result").click(function(){
														selectDescriptor.find("option[value='"+$(hovered).text()+"']").removeProp("selected");
														selectDescriptor.find("option[value='"+$(this).text()+"']").prop("selected", true);
														selectDescriptor.trigger("chosen:updated");
														selectDescriptor.trigger("change");
														drop.css("display", "none");
														setTimeout(hoverListener,100);
													})
												}
											}
										);
									}

									//Demande la sélection
									var getSelected = function() {
										var values = []; 
										console.log("getSelected:");
										$.each(selectDescriptor[0].selectedOptions, function(index, item){
											console.log("  "+item.text);
											values.push(item.text);
										});
										return values;
									}
									});

								})(this);
							</script>
						</cfoutput>	
<!---				<cfelseif cf_type EQ "descriptor">
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
						<select multiple type="descriptor" descriptor="cf_#cf_id#" id="cf_select_descriptor_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
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
									var tdGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("DESCRIPTEUR")#</cfoutput>" >');
									var tgGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("TG")#</cfoutput>" >');
									var taGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("TA")#</cfoutput>" >');
									var tsGroup = $('<optgroup label="<cfoutput>#myFusebox.getApplicationData().defaults.trans("TS")#</cfoutput>" >');
									descriptor.append(tdGroup, tgGroup, taGroup, tsGroup);
									//Je construit mon Cchamp multiple avec les valeurs initiale
									descriptor.chosen().change(function(event, params){
										input.val(getSelected().join(", "));
										/*if(params.deselected)setTimeout(function(){descriptor.next(".chosen-container").find("ul").trigger("mousedown").trigger("click");},0);
										else*/ descriptor.next(".chosen-container").find("ul").trigger("mousedown").trigger("click");									
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
										//Sur la pression d'une touche, j'interroge le thesaurus
										.on("keyup", function(ev){	
											clearTimeout(inputChangeTimer);
											inputChangeTimer = setTimeout(function(){inputChange(ev)}, 200);								
										});

									//gestion thésaurus
									var inputChange = function(ev){
										var input = descriptor.next(".chosen-container").find("input");
										input.css("width", "auto");
										$.getJSON(
										"http://ima.j2s.net/Thesaurus_WS/ForDescriptor.php?uniterm="+input.val(), 
										function(result){
											//J'ai un résultat
											if(result.err === 200){
												if(result.TG.length > 0 || result.TA.length > 1 || result.TS.length > 0 ) {
													var values = getSelected();
													//je nettoie les options qui ne sont plus nécessaire
													$.each(descriptor.find("option"), function(index, item){
														if(values.indexOf(item.text) === -1) {
															$(item).remove();
														}
														else{
															$(item).css("display", "none").detach().appendTo(descriptor);
														}
													});
													//J'ajoute la nouvelle option
													//DESCRIPTEUR
													if(result.DESCRIPTEUR && result.DESCRIPTEUR.length > 0){
														tdGroup.append('<option value="'+result.DESCRIPTEUR+'">'+result.DESCRIPTEUR+'</option>');
													}
													//TG
													if(result.TG.length > 0){
														tgGroup.append('<option value="'+result.TG+'">'+result.TG+'</option>');
													}
													//TA
													if(result.TA.length > 0){
														$.each(result.TA, function(i,TA){
															taGroup.append('<option value="'+TA+'">'+TA+'</option>');
														});
													}
													//TS
													if(result.TS.length > 0){
														$.each(result.TS, function(i,TS){
															tsGroup.append('<option value="'+TS+'">'+TS+'</option>');
														});
													}
													descriptor.trigger("chosen:updated");
													descriptor.trigger("chosen:activate");
													input.trigger("click");
												}
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
--->

					<!---------------------------->
					<!--- Candidat descripteur --->
					<!---------------------------->
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
						<input type="text" dir="auto" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select multiple candidate="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value="" data-placeholder="test"></option>
							<cfloop list="#ltrim(ListSort(cf_select_list, 'text', 'asc', ','))#" index="i" delimiters=",">
								<option value="#i#" <cfif listFind(REReplace(cf_value, ",\s?" , ',', 'ALL'), #i#, ",")> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var inputDescriptorCandidate = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var select = $("td select[candidate='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");

									select.chosen({add_contains: true, no_results_text : ""}).change(function(){
										var values = []; 
										$.each(select[0].selectedOptions, function(index, item){values.push(item.text)})
										inputDescriptorCandidate.val(values.join(", "));
									});		

									var chosen = select.next(".chosen-container");
									//Sur entrée
									chosen.find("input").on("keyup", function(ev){	
										//J'ajoute à la liste							
										if(ev.keyCode === 13 && (chosen.find(".chosen-results .active-result").length === 0) ){
											//Je mets à jour ma liste
											var currentValue = $(this).val()/*.toUpperCase()*/;
											var current = $('<option value="'+currentValue+'" selected>'+currentValue+'</option>');
											select.append(current);								
											select.trigger("chosen:updated");
											select.trigger("chosen:activate");
											//Je mets à jour le serveur
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
											select.trigger("change")	
										}
										else {
											chosen.find(".chosen-results .no-results").html("<cfoutput>#myFusebox.getApplicationData().defaults.trans("select_no_match")#</cfoutput>");
										}
									})
								})(this);
							</script>
						</cfoutput>

					<!-------------------------------------------->
					<!--- select avec search et choix multiple --->
					<!-------------------------------------------->
					<cfelseif cf_type EQ "select-search-multi">
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
						<input type="text" dir="auto" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<!---<cfdump var="-#cf_value#-">--->
						<cfset cf_value2="#REReplace(cf_value, ",\s", ",", "ALL")#">
						<!---<cfdump var="-#cf_value2#-">--->
						<select multiple selecSearchMulti="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value="" data-placeholder="test"></option>
							<cfloop list="#ltrim(ListSort(cf_select_list, 'text', 'asc', ','))#" index="i" delimiters=",">
								<option value="#i#" <cfif listFind(cf_value2, #i#, ",")> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var select = $("td select[selecSearchMulti='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");

									select.chosen({add_contains: true, no_results_text : ""}).change(function(){
										var values = []; 
										$.each(select[0].selectedOptions, function(index, item){values.push(item.text)})
										console.log(values)
										input.val(values.join(", "));
									});		

									var chosen = select.next(".chosen-container");
									//Sur entrée
									chosen.find("input").on("keyup", function(ev){	
										//J'ajoute à la liste							
										if(ev.keyCode === 13 && (chosen.find(".chosen-results .active-result").length === 0) ){
											//Je mets à jour ma liste
											var currentValue = $(this).val();
											var current = $('<option value="'+currentValue+'" selected>'+currentValue+'</option>');
											select.append(current);								
											select.trigger("chosen:updated");
											select.trigger("chosen:activate");
											//Je mets à jour le serveur
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
											select.trigger("change")	
										}
										else {
											chosen.find(".chosen-results .no-results").html("<cfoutput>#myFusebox.getApplicationData().defaults.trans("select_no_match")#</cfoutput>");
										}
									})
								})(this);
							</script>
						</cfoutput>

					<cfelseif cf_type EQ "inventory">
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
						<form><input type="text" dir="auto" style="width:300px;" id="cf_text_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" inventory="true"<cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif !allowed> disabled="disabled"</cfif>></form>
						<cfoutput>
							<!--- JS --->
							<style type="text/css">
								.inventory-error{
									border-color: red;
									outline-color:red;
								}
							</style>
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									input.on("input", function(){
										$.get("../../global/api2/search.cfc?method=searchassets&searchfor=customfieldvalue:(3A5A7EB0F8444B1483A6DF40AF5C4EC2"+input.val()+")&api_key=BFF1B5BAEDDE433D975C502C3C79EE55", 
										function(result){
											var data = JSON.parse(result).DATA;
											if(data.length > 0){input.addClass("inventory-error");}
											else{input.removeClass("inventory-error");}
										});
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
