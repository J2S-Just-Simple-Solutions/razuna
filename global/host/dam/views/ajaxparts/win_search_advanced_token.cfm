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
<cfparam default="0" name="attributes.folder_id">
<cfset myvar = structnew()>
<cfoutput>
	Historique de recherche : <select name="historyAdv"><option></option></select>
	<br>
	<iframe style="border:none;width:100%;"></iframe>
	<script data-main="underscore" src="/razuna/global/js/underscore-min.js"></script>
	<script data-main="rte" src="/razuna/global/js/jquery.richTokenEditor.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){
			//localStorage.setItem("last_search_adv", "");
			var lastSearch = null;
			var fields = <cfoutput>#serializeJson(qry_fields)#</cfoutput>;
			var searchHandler = function(value, html, text){
				// TODO: gérer un historique des requêtes
				
				// Je décompose ma recherche
				value = value.replace(/[\w-]+:"[^"]+"/g, function(match, contents){
					var operation = match.split(":");
					// On supprime les - de l'ID du customfield
					var operationField = operation[0].replace(/-/g,"");
					// On récupère la valeur 
					var operationValue = operation[1];
					// On transforme la chaine avec l'id de chaque customFields dans les recherche global
					var setCustomFieldValue = function(str) {
						str = str.replace(/\"/g, "");
						var strValues = str.split(" ");
						var result = [];
						_.each(fields.DATA, function(cf){
							_.each(strValues, function(strValue){
								result.push("customfieldvalue:("+cf[0].replace(/-/g,"")+strValue+")");
							});
						});
						return "(" + result.join(" OR ") + ")";
					}

					if(operationField === "ALL") {
						return "(description:("+operationValue+") OR "+setCustomFieldValue(operationValue) ;
					}
					else if(operation[0] === "ALLFIELDS") {
						return setCustomFieldValue(operationValue);
					}
					else if(operation[0] === "description") {
						return "description:("+operationValue+")";
					}
					else {
						// On supprime les guillemets qui entouraient la valeur 
						operationValue = operation[1].replace(/\"/g, "");
						// On remplace les espaces par espace+ID 
						operationValue = operationValue.replace(/\s/g, " "+operationField);
						return "customfieldvalue:(\""+operationField+operationValue+"\")";
					}
				});

				// Je lance la recherche
				$("input[name=simplesearchtext]").val(value);
				$("##form_simplesearch button").click();
				//$("input[name=simplesearchtext]").val("");

				var history = localStorage.getItem("last_search_adv")
				//Je la parse, si elle n'existe pas je la crée
				if(history)history = JSON.parse(history);
				else history = [];
				var currentSearch = {value : html, label : text}
				history.push(currentSearch);
				//J'enregistre en localstorage les 15 derniers
				localStorage.setItem("last_search_adv", JSON.stringify(history.slice(-15)));
			}

			//Je crée mon champ de recherche
			$("iframe").richTokenEditor({fields : fields.DATA, callback : searchHandler});	

				//L'historique
			$("select[name=historyAdv]").ready(function(){
				lastSearch = localStorage.getItem("last_search_adv");
				//Je la parse, si elle n'existe pas je la crée
				if(lastSearch){
					lastSearch = JSON.parse(lastSearch);
					$.each(lastSearch, function(i, search){
						$("select[name=historyAdv]").append("<option value='"+i+"'>"+search.label+"</option>");
					})
				}
			}).on("change", function(event){
				var content = $("iframe")[0].contentDocument;
				$(content).find("div").html(lastSearch[$(event.currentTarget).val()].value)
				this.selectedIndex = -1;
			});		
			
		});
	</script>	
</cfoutput>
	