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
	<cfif !structKeyExists(variables,"cf_inline")><table border="0" cellpadding="0" cellspacing="0" width="450" class="grid"></cfif>
			<cfloop query="qry_cf">
			<tr>
				<cfif !structKeyExists(variables,"cf_inline")>
					<td width="130" nowrap="true"<cfif cf_type EQ "textarea"> valign="top"</cfif>><strong>#cf_text#</strong></td>
					<td width="320">
				<cfelse>
					<td>
				</cfif>
					<!--- For text --->
					<cfif cf_type EQ "text">
						<input type="text" style="width:300px;" id="cf_#cf_id#" name="cf_#cf_id#" <cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif cf_edit NEQ "true" AND (NOT listfind(cf_edit,session.theuserid) AND NOT listfind(cf_edit,session.thegroupofuser))> disabled="disabled"</cfif>>

					<!--- Radio --->
					<cfelseif cf_type EQ "radio">
						<input type="radio" name="cf_#cf_id#" value="T"<cfif cf_edit NEQ "true" AND (NOT listfind(cf_edit,session.theuserid) AND NOT listfind(cf_edit,session.thegroupofuser))> disabled="disabled"</cfif>>#myFusebox.getApplicationData().defaults.trans("yes")# <input type="radio" name="cf_#cf_id#" value="F"<cfif cf_edit NEQ "true" AND (NOT listfind(cf_edit,session.theuserid) AND NOT listfind(cf_edit,session.thegroupofuser))> disabled="disabled"</cfif>>#myFusebox.getApplicationData().defaults.trans("no")#

					<!--- Textarea --->
					<cfelseif cf_type EQ "textarea">
						<textarea name="cf_#cf_id#" style="width:310px;height:60px;"<cfif structKeyExists(variables,"cf_inline")> placeholder="#cf_text#"</cfif><cfif cf_edit NEQ "true" AND (NOT listfind(cf_edit,session.theuserid) AND NOT listfind(cf_edit,session.thegroupofuser))> disabled="disabled"</cfif>></textarea>

					<!--- Select --->
					<cfelseif cf_type EQ "select" OR cf_type EQ "select_multi">
						<select name="cf_#cf_id#" style="width:300px;"<cfif cf_edit NEQ "true" AND (NOT listfind(cf_edit,session.theuserid,",") AND NOT listfind(cf_edit,session.thegroupofuser,","))> disabled="disabled"</cfif><cfif cf_type EQ "select_multi"> multiple="multiple"</cfif>>
							<cfif cf_type NEQ "select_multi">
								<option value=""></option>
							</cfif>
							<cfloop list="#ListSort(cf_select_list, 'text', 'asc', ',')#" index="i">
								<option value="#i#">#i#</option>
							</cfloop>
						</select>

					<!--- Inventory --->
					<cfelseif cf_type EQ "inventory">
						<span>Modification non autorisée (contrainte d'unicité)</span>

					<!--- Select-search-multi --->
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
							<cfloop list="#ltrim(ListSort(listremoveduplicates(cf_select_list), 'text', 'asc', ','))#" index="i" delimiters=",">
								<option value="#i#" <!---<cfif listFind(cf_value2, #i#, ",")> selected="selected"</cfif>---> >#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var input = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var select = $("td select[selecSearchMulti='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var oldValues = null;

									select.select2({tags: true, tokenSeparators: [','] }).change(function(){
										var values = []; 
										var newValues = [];
										$.each(select[0].selectedOptions, function(index, item){
											values.push(item.text);
											if($(item).attr("data-select2-tag")){newValues.push(item.text);}
										})
										input.val(", "+values.join(", "));<!--- TODO: comment ", "+ --->
										
										$.get(
											"../../global/api2/J2S.cfc?method=appendCustomField&select_list=," + _.difference(newValues, oldValues).join(",") + "&cf_id=" + "#qry_cf.cf_id#" + "&prefix=" + prefix + "&user_id=#session.theuserid#", 
												// NITA Modif ajout du user id
											function(result){}
										);
										oldValues = newValues;
									});
											
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
												inputDescriptor.val(", "+getSelected().join(", "));<!--- TODO: comment ", "+ --->	
											}
											// Suppression d'un descripteur
											else {
												inputDescriptor.val(", "+getSelected().join(", "));<!--- TODO: comment ", "+ --->
											}
											//console.log(inputDescriptor.val());								
											drop.css("display", "none");
											setTimeout(hoverListener,100);								
										})
										//Le composant est prêt
										.ready(function(){

											var doThesaurus = function(values){
												var selectedList = "<cfoutput>#cf_value#</cfoutput>";

												$.each(values.sort(), function(index, item){
													var term = item[0];
													var replacement = item[1];

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
											};

											var thesaurusValues = localStorage.getItem("thesaurusValues");
											//Si j'ai en cache, je traite tous de suite
											if(thesaurusValues){doThesaurus(JSON.parse(thesaurusValues));}
											//Sinon je demande au serveur
											else {
												$.ajaxSetup({timeout: 10000});
												$.getJSON(
												"http://ima.j2s.net/Thesaurus_WS/AllTerms.php", 
												function(result){
													//Si j'ai bien une réponse, j'enregistre et traite
													if(result.err === 200){
														localStorage.setItem("thesaurusValues", JSON.stringify(result.values));
														doThesaurus(result.values);
													}
												});
											}
										   
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
						<input type="text" dir="auto" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<select multiple candidate="cf_#cf_id#" id="cf_select_#listlast(cf_id,'-')#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value="" data-placeholder="test"></option>
							<cfloop list="#ltrim(ListSort(cf_select_list, 'text', 'asc', ','))#" index="i" delimiters=",">
								<option value="#i#" <!--- <cfif listFind(REReplace(cf_value, ",\s?" , ',', 'ALL'), #i#, ",")> selected="selected"</cfif>---> >#i#</option>
							</cfloop>
						</select>
						<cfoutput>
							<!--- JS --->
							<script language="JavaScript" type="text/javascript">
								(function(self){
									var prefix = "<cfoutput>#session.hostdbprefix#</cfoutput>";
									var inputDescriptorCandidate = $("input[name='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var select = $("td select[candidate='cf_"+"<cfoutput>#cf_id#</cfoutput>"+"']");
									var oldValues = null;

									select.select2({tags: true, tokenSeparators: [','] }).change(function(){
										var values = []; 
										var newValues = [];
										$.each(select[0].selectedOptions, function(index, item){
											values.push(item.text);
											if($(item).attr("data-select2-tag")){newValues.push(item.text);}
										})
										inputDescriptorCandidate.val(", "+values.join(", "));<!--- TODO: comment ", "+ --->

										$.get(
											"../../global/api2/J2S.cfc?method=appendCustomField&select_list=," + _.difference(newValues, oldValues).join(",") + "&cf_id=" + "#qry_cf.cf_id#" + "&prefix=" + prefix + "&user_id=#session.theuserid#", 
												// NITA Modif ajout du user id
											function(result){}
										);
										oldValues = newValues;
									});
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
						<input type="text" dir="auto" style="width:300px;" id="cf_thesaurus_#listlast(cf_id,'-')#" name="cf_#cf_id#" value="#cf_value#" hidden>
						<cfset cf_value2="#REReplace(cf_value, ",\s", ",", "ALL")#">
						<!---<cfdump var="-#cf_value2#-"> --->
						<select multiple type="category" category="cf_#cf_id#" id="cf_select_category_#listlast(cf_id,'-')#" value="#cf_value#" style="width:300px;" data-placeholder="#myFusebox.getApplicationData().defaults.trans("select_some_options")#"<cfif !allowed> disabled="disabled"</cfif>>
							<option value=""></option>
							<cfloop list="#cf_select_list#" index="word">
								<option value="#word#" <!---<cfif ListFind("#cf_value2#", #word#, ",")> selected="selected"</cfif>---> >#word#</option>
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
										input.val(", "+values.join(", "));<!--- TODO: comment ", "+ --->										
									});
								})(this);
							</script>
						</cfoutput>
		
					<!--- select-sub-category --->
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
										input.val(", "+values.join(", "));<!--- TODO: comment ", "+ --->
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
					</cfif>
				</td>
			</tr>
		</cfloop>
	<cfif !structKeyExists(variables,"cf_inline")></table></cfif>
</cfoutput>