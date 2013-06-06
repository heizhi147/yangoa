;
(function($) {
	var defultRulesMessage = [ {
		not_empty : '不能为空'
	} ];
	function findValidate(defultRulesMessage, value) {
		for ( var i = 0; i < defultRulesMessage.length; i++) {
			var defultRule = defultRulesMessage[i];
			for (k in defultRule) {
				if (value == k) {
					return defultRule[k];
				}

			}
		}
		return null;
	}
	;
	function findValidateMethod(validateMethod, value) {
		for (k in validateMethod) {
			var methodName=k;
			if (value == methodName) {
				return validateMethod[k];
			}

		}
		return null;
	}
	;

	var validateMethod={
			not_empty : function(data) {
				console.log(data);
				if (data == null ||data == "" ) {
					return false;
				} else {
					return true;
				}
			}
	};
	$.fn.extend({

		validate : function(validateSetting) {
			
			var form = this;
			var result = true;
			for (k in validateSetting.rules) {
				var name = k;
				var ruleValues = validateSetting.rules[k];
				for ( var i = 0; i < ruleValues.length; i++) {
					var value = ruleValues[0];
					console.log(value);
					var method = findValidateMethod(validateMethod, value);

					var formInput = form.find("input[name=" + name + "]");
					var res = validateMethod[value](formInput.val());
					if (!res) {
						var message = findValidate(defultRulesMessage, value);
						var divGroup=formInput.closest(".control-group");
						if(divGroup.hasClass("error")){
							divGroup.removeClass("error");
							
						}
						var oldSpan=divGroup.find("span");
						if(oldSpan.length>0){
							oldSpan.remove();
						}
						divGroup.addClass("error");
						var span = $("<span class=\"help-inline\">" + message
								+ "</span>");
						formInput.after(span);
						result = false;
					}else{
						var divGroup=formInput.closest(".control-group");
						if(divGroup.hasClass("error")){
							divGroup.removeClass("error");
							
						}
						var oldSpan=divGroup.find("span");
						if(oldSpan.length>0){
							oldSpan.remove();
						}
					}

				}
				
			}
			return result;
		},
		removeValidateClss:function(validateSetting){
		
			var form = this;
			for (k in validateSetting.rules) {
				var name = k;
				var ruleValues = validateSetting.rules[k];
				for ( var i = 0; i < ruleValues.length; i++) {		
					var formInput = form.find("input[name=" + name + "]");
						var divGroup=formInput.closest(".control-group");
						if(divGroup.hasClass("error")){
							divGroup.removeClass("error");
							
						}
						var oldSpan=divGroup.find("span");
						if(oldSpan.length>0){
							oldSpan.remove();
						}
				}
				
			}
		}
	});

})(jQuery);