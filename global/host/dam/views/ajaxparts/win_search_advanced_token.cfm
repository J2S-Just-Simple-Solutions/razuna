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
	Recherche par champs : 
	<br>
	<iframe style="border:none;width:100%;"></iframe>
	<script data-main="underscore" src="/razuna/global/js/underscore-min.js"></script>
	<script data-main="rte" src="/razuna/global/js/jquery.richTokenEditor.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){
			var fields = <cfoutput>#serializeJson(qry_fields)#</cfoutput>;
			var searchHandler = function(value){
				// TODO
				// Gèrer un historique des requetes
				//Je décompose ma recherche en customfield
				value = value.replace(/[\w-]+:'[\w\s]+'/g, function(match, contents){
					var operation = match.split(":");
					var operationValue = operation[1].replace(/\'/g, "").replace(/\s/g, "+");
					var operationField = operation[0];
					if(operationField === "ALL")return "(description:("+operationValue+") OR customfieldvalue:("+operationValue+"))";
					else if(operation[0] === "ALLFIELDS")return "customfieldvalue:("+operationValue+")";
					else if(operation[0] === "description")return "description:("+operationValue+")";
					else return "customfieldvalue:(+"+operationField+"+"+operationValue+")";
				});

				//Je lance la recherche
				$("input[name=simplesearchtext]").val(value);
				$("##form_simplesearch button").click();
				//$("input[name=simplesearchtext]").val("");
			}

			//Je crée mon champ de recherche
			$("iframe").richTokenEditor({fields : fields.DATA, callback : searchHandler});	

			
		});
	</script>	
</cfoutput>
	
