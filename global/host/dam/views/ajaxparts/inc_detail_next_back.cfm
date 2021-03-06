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
	<cfif structKeyExists(attributes,"row") AND attributes.row NEQ 0>
		<cfif attributes.what EQ 'files'>
			<cfset file_extension = "file_extension=#qry_detail.detail.file_extension#">
		<cfelse>
			<cfset file_extension = "">
		</cfif>
		<div>
			<cfset rowback = attributes.row - 1>
			<cfset rownext = attributes.row + 1>
			<!--- Hide if row is 0 --->
			<cfif rowback NEQ 0>
				<div style="float:left;">
					<button type="button" class="awesome small green" onclick="navigate(#rowback#,#attributes.filecount#);">&lt; #myFusebox.getApplicationData().defaults.trans("back")#</button>
				</div>
			</cfif>

			<cfif structKeyExists(attributes,"filecount")><div style="text-align:center;position: absolute;width: 50%;margin-left: 25%;">#attributes.row#/#attributes.filecount#</div></cfif>

			<!--- Hide if filecount eq row --->
			<cfif NOT rownext GT attributes.filecount>
				<div style="float:right;">
					<button type="button" class="awesome small green" onclick="navigate(#rownext#,#attributes.filecount#);">#myFusebox.getApplicationData().defaults.trans("next")# &gt;</button>
				</div>
			</cfif>
		</div>
		<div style="clear:both;padding-bottom:10px;"></div>	
	</cfif>
</cfoutput>