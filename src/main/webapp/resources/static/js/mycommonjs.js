function changeFormData(data){
	var fromjson="{"
		for(var i=0;i<data.length; i++){		
			if(i==(data.length-1)){
				fromjson=fromjson+"\""+data[i].name+"\""+":"+"\""+data[i].value+"\"";
			}else{
				fromjson=fromjson+"\""+data[i].name+"\""+":"+"\""+data[i].value+"\",";
			}
		}
	fromjson=fromjson+"}";
		return fromjson;
}

