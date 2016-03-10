/**
 * @author Deschepper Alain J2S 2014
 * 
 * JQuery richTokenEditor plugin
 * 
 * 
 */

(function($){
	'use strict';
		
	var version = "v1.0";
	
	//------------------------------------------------------------------
	//L'éditeur
	var _editor ='<iframe></iframe>';
	
	//------------------------------------------------------------------
	//Mes controles	
	var _controlTokenEditor = 
		'<select contentEditable="false"><option value="" selected>Sélectionner un champ</option>\n\
		<option value="ALL">Dans tous les champs</option>\n\
		<option value="ALLFIELDS">Dans tous les champs personnalisés</option>\n\
		<option value="description">Dans le champ Description</option>\n\
		<option disabled>───────────────────────────</option>\n\
		</select>\n\
		<button value="AND" action contentEditable="false">Et</button>\n\
		<button value="OR" action contentEditable="false">Ou</button>\n\
		<button value="NOT" action contentEditable="false">Sauf</button>\n\
		<div class="editor"/>\n\
		<button id="search">Rechercher</button>';
		
	//------------------------------------------------------------------
	//Ma feuille de style
	var _style = '<link type="text/css" rel="Stylesheet" href="/razuna/global/js/jquery.richTokenEditor.css" />';
			
	$.fn.richTokenEditor = function(options) {		
		//Je remplace mon textArea pas un richTokenEditor
		$(this).each(function(){
			var content = this.contentDocument;
			$(content).find("body").html(_controlTokenEditor);
			$(content).find("div").prop("contentEditable", true).html($(this).text()).focus();
			$(content).find("head").append(_style);	

			//Je rempli ma liste de champ
			var fields = options.fields.sort(function (a, b) {
			    if (a[5].toLowerCase() > b[5].toLowerCase())return 1;
			    if (a[5].toLowerCase() < b[5].toLowerCase())return -1;
			    return 0;
			});
			_.each(options.fields, function(field){
				$(content).find('select').append("<option value='"+field[0]+"''>"+field[5]+" commence par</option>");
			})
			
			//------------------------------------------------------------------
			//Retourne la chaine générée
			var getValueText = function(){
				var text = "";
				_.each($(content).find("div").contents(),function(content){
					if(content === "&nbsp;"){return;}
					else if(content.nodeName === "SELECT"){
						text += $(content).val() + ":";
					}
					else if(content.nodeName === "BUTTON"){
						text += " " + $(content).val() + " ";
					}
					else {
						if(trim(content.textContent) != "")
						text += "'" + trim(content.textContent) + "'";
					}
				});
				return text;
			};
			
			//------------------------------------------------------------------
			//Ajout champ
			$(content).find('select').on('change', function(event) {
				var $select = event.target.cloneNode();
				_.each(this.options, function(option, index){
					if(option.value !== ""){
						$($select).append("<option value='"+option.value+"' "+(index === this.selectedIndex ? "selected" : "")+">"+option.label+"</option>");
					}
				}, this);
				content.execCommand("insertHTML", false, "&nbsp;"+$select.outerHTML+"&nbsp;");
				this.selectedIndex = 0;
			});
			
			//------------------------------------------------------------------
			//Ajout opérateur
			$(content).find('button[action]').on('click', function(event) {
				content.execCommand("insertHTML", false, "&nbsp;"+event.target.outerHTML+"&nbsp;");
				$(content).find("button").prop("contenteditable", false);
			});

			//------------------------------------------------------------------
			//search
			$(content).find('#search').on('click', function(event) {
				options.callback.call(null, getValueText());
			});
		});		
    };

})(jQuery);