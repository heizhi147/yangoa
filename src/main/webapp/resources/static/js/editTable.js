;(function($){
	var currentRow={};
	function findnum(arr,value){ 
		var b = false; 
		for (var i = 0; i < arr.length; i++) { 
		if (arr[i] == value) { 
		b = true;break; 
		} 
		} 
		return b;
	}
	$.fn.extend({
		"editTable":function(value,data){
			$(this).children().remove();
			var thead=$("<thead><tr></tr></thead>");	
			var tbdody=$("<tbody></tbody>");
			var allCheckBox=$("<th id=\"check\" width=\"5%\"><input type=\"checkbox\" name=\"checkboxAll\"></th>");
			//全选和全不选
			allCheckBox.find("input").click(function(){
					if($(this).prop('checked')){
						$("input[name=checkboxSign]").trigger("click");
						$("input[name=checkboxSign]").prop("checked", true);
					}else{
						$("input[name=checkboxSign]").trigger("click");
						$("input[name=checkboxSign]").prop("checked", false);
					}
			});
			thead.append(allCheckBox);
			var columns=value.columns;
			for(var i=0;i<columns.length;i++){
				var column=columns[i];
				var th=$("<th title=\""+column.id+"\" width=\""+column.width+"\">"+column.name+"</th>");
				if(column.hide){
					th.hide();
				}
				thead.append(th);
			}
			
			if(!value.readOnly){
				if(value.ifUpdate!=false){
				var th=$("<th width=\"5%\">操作</th>");
				thead.append(th);
				}
			}
			for(var j=0;j<data.length;j++){
				var trdata=data[j];			
				var tr=$("<tr></tr>");
				var custCheckBox=$("<td title=\"checkbox\"><input type=\"checkbox\" name=\"checkboxSign\"></td>");
				tr.append(custCheckBox);
				for(var i=0;i<columns.length;i++){
					var newcolumn=columns[i];
					for (var k in trdata) {
					    var tdvalue = trdata[k];   				   					
							if(newcolumn.id==k){
								var td=$("<td title=\""+k+"\">"+tdvalue+"</td>");
								if(newcolumn.hide){
									td.hide();
								}
						    tr.append(td);
							}
						
						}
				
					}		
					tbdody.append(tr);
				
					var edittd;
					if(!value.readOnly){
						
						if(value.ifUpdate!=false){
							edittd=$("<td>"
									+"<a class=\"btn btn-mini\" name=\"update\"><i class=\"icon-edit\"></i></a></td>");
							tr.append(edittd);
						}
					}
					
			}
			
			$(this).append(thead);
			$(this).append(tbdody);		
		},
		"getCheckData":function(value){
			var postArray="[";
			var i=0;
			$(this).find("[name=checkboxSign]").each(function(){
				var checkBox=$(this);
				if(checkBox.prop("checked")){
					var roletr=checkBox.parent().parent();
					var roleTds=roletr.children();
				
					var postString="{";
					for(var f=1;f<roleTds.length-1;f++){
						var oldtd=$(roleTds[f]);
						var inputValue=oldtd.text();
						var attribute="\""+oldtd.attr('title')+"\":\""+inputValue+"\"";
						if(f==roleTds.length-2){
							postString=postString+attribute+"}";
						}else{
							postString=postString+attribute+",";
						}			
					}
					if(i==0){
					postArray=postArray+postString;
					}else{
						postArray=postArray+","+postString;
					}
					i++;
				};
			});
			postArray=postArray+"]";
			return postArray;
		}
		
	});
})(jQuery);