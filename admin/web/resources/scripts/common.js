if( window.console == undefined ){ console = { log : function(){} }; }

var formatCurrencyOption = { colorize:false, region: 'ko-KR', roundToDecimalPlace: 2, symbol: "" };
var datePickerOption = {
	language : 'kr',
	defalutDate : new Date()
};

var ajaxLoaderTimeout = null;

$(document).ready(function(){
	$.ajaxSetup({
		beforeSend : function(xhr){
			// 0.5초 뒤에 로딩바 생성
			if( window.isAutoLoader == null || window.isAutoLoader ) {
				ajaxLoaderTimeout = setTimeout(function () {
					if (Loader) Loader.show();
					console.log("자동 로딩바 생성");
				}, 500);
			}
		}
		, complete : function(xhr,status){
			clearTimeout(ajaxLoaderTimeout);
			if( window.isAutoLoader == null || window.isAutoLoader ) {
				if (Loader) Loader.hide();
				console.log("자동 로딩바 제거");
			}
		}
		, error: function(res){
			clearTimeout(ajaxLoaderTimeout);
			// 권한 없음. 잘못된 요청
			if( res.status == 401 ){
				location.href = baseUrl + "/member/logout";
			} else {
				//alert("에러가 발생하였습니다.");
				if( mainLoader.is(":visible") ){
					_lm.hide();
				}
			}
			
			setTimeout(function(){
				if( Loader ) Loader.hide();
			}, 1000);
		}
	});
	
	$("a[href='#']").click(function(evt){
		evt.preventDefault();
	});
	
	$(".popCloseBtn").click(function(){
		self.close();
	});
	
	$("#searchBtn").click(function(){
		$("#pageNo").val("1");
		$("#pageGNo").val("0");
	});
	
	$("#backBtn, .backBtn").click(function(){
		if( window.backUrl == null )
			window.history.back();
		else
			location.href = backUrl;
	});
	
	//Paging
	$("#pagingNoList a, #pagingPrevBtn, #pagingNextBtn").click(function(){
		var data = $(this).data();
		var isNowPage = $(this).attr("class") != null && $(this).attr("class").indexOf("current-page") > -1;
		if( isNowPage )
			return false;
		
		if( data.pno == null || data.pno == "" ){
			data.pno = 1;
		}
		if( data.gno == null || data.gno == "" ){
			data.gno = 0;
		}
		
		if( data.pno == 0 ) data.pno = 1;
		
		if( $("#searchForm").length > 0 ){
			$("#searchForm input[name='pageNo']").val( data.pno );
			$("#searchForm input[name='pageGNo']").val( data.gno );
			$("#searchForm").submit();
		}
		if( $("#search").length > 0 ){
			$("#search input[name='pageNo']").val( data.pno );
			$("#search input[name='pageGNo']").val( data.gno );
			$("#search").submit();
		}
		return false;
	});
	
	//required
	if( window.redquiredFields != null ){
		$(window.redquiredFields).each(function(i, item){
			$("*[id='']").prop("required", true);
		});
	}
	
	//bootstrap mobile menu
	$(".navbar-toggle").click(function(){
		if( $(".navbar-collapse").hasClass("in") )
			$(".navbar-collapse").collapse('hide');
		else
			$(".navbar-collapse").collapse('show');
	});
	
	// 전체 선택
	$("#allCheckBtn").on("ifClicked", function(){
		if( this.checked ){
			$(".cb").iCheck("uncheck");
		} else {
			$(".cb").iCheck("check");
		}
	});
	
	// 개별 선택일때 전체가 선택되었을때
	$(".cb").on("ifChanged", function(){
		if( $(".cb").length == $(".cb:checked").length ){
			$("#allCheckBtn").iCheck("check");
		} else {
			$("#allCheckBtn").iCheck("uncheck");
		}
	});

	// textarea placeholder enter
	$('textarea').each(function(){
		$(this).attr("placeholder", $(this).attr("placeholder").replace(/\\n/g, '\n'));
	});
	
});

function getCheckedIds(){
	var ids = [];
	$(".cb:checked").each(function(){
		if( $(this).data("id") == null ){
			ids.push($(this).parents("tr").data("id"));
		} else {
			ids.push($(this).data("id"));
		}
	});
	return ids;
}

function removeConfirm(callback){
	return callback(confirm("您确定要删除吗？"));
}

function log(obj){
	console.log(obj);
}

function getElById(str) {
	if( document.getElementById(str) == null ){
		return $(document.getElementsByName(str));
	}
	return $(document.getElementById(str));
}

function validation(){
	if( window.redquiredFields != null ){
		for(var i=0; i<redquiredFields.length; i++){
			var field = redquiredFields[i];
			var msg = field.msg + ' 필수 항목입니다.';
			if( field.fulltext != null && field.fulltext )
				msg = field.msg;
			
			if( ValidateUtil.isBlank([field.id], msg, true) ) {
				return false;
			}
		}
	}
	return true;
}

/* 유효성 관련 유틸 */
var ValidateUtil = {
	
	/*
		공백 체크
		ValidateUtil.isBlank(Element ID, Alert 메세지, isFocus)
		ex) if( ValidateUtil.isBlank("userId", "아이디를 입력해주세요.") ) return;
		
	*/
	isBlank : function(ids, msg, isFocus, fn){
		if( typeof(ids) == "string" ){
			ids = [ids];
		}
		
		var isBlank = false;
		for(var i=0; i<ids.length; i++){
			var id = ids[i];
			var target = $("#"+id);
			if( target[0] != null ){
				if( $.trim(target.val()) == "" ){
					isBlank = true;
					
					if( msg != null ){
						if( fn == null ){
							alert(msg);
							target.focus();
						} else {
							fn();
							if( isFocus != null && isFocus ){
								target.focus();
							}
						}
						break;
					}
				}
				
			}
		}
		
		return isBlank;
	}

	/**
	 * 텍스트 입력 항목의 값 체크
	 * ValidateUtil.isBlankText("title", "제목을", isFocus)
	 */
	,isBlankText : function(id, msg, fn){
		var isBlank = ValidateUtil.isBlank(id, msg + " 입력해주세요.", true, fn);
		return isBlank;
	}
	
	/**
	 * 선택 항목의 값 체크
	 * ValidateUtil.isBlankSelect("title", "시간을", isFocus)
	 */
	,isBlankSelect : function(id, msg, fn){
		var isBlank = ValidateUtil.isBlank(id, msg + " 선택해주세요.", false, fn);
		return isBlank;
	}
	
	/**
	 * 체크박스 항목의 값 체크
	 * ValidateUtil.isBlankCheckbox( $("input[name='']") , "장르를", isFocus)
	 */
	,isBlankCheckbox : function(selector, msg, fn){
		var isChecked = selector.is(":checked");
		if( !isChecked ){
			alert(msg + " 선택해주세요.");
			return false;
		}
		return true;
	}

		
	/*
		해당 target 의 값이 숫자인지 체크하고, 아닐경우 제거한다.
		ex) ValidateUtil.numberOnly("teacher.phoneNo")
	*/
	,numberOnly : function(id){
		var target = getElById(id);
		//var target = $("#"+id);
		var regx = /^[0-9]*$/;
		target.keyup(function(){
			var val = this.value;
			var newVal = "";
			for(var i=0; i<val.length; i++){
				var tmpVal = val.substring(i, i+1);
				if( tmpVal != "" ){
					if( regx.test(tmpVal) ){
						newVal += tmpVal;
					}
				}
					
			}
			
			target.val( newVal );
			
		});
		
	}
	
	/*
		해당 target 의 값이 알파벳 대소문자(a-zA-Z) 체크하고, 아닐경우 제거한다.
		ex) ValidateUtil.numberOnly("teacher.phoneNo")
	*/
	,alphabetAllOnly : function(id){
		var target = getElById(id);
		//var target = $("#"+id);
		var regx = /^[a-zA-Z]*$/;
		target.keyup(function(){
			var val = this.value;
			var newVal = "";
			for(var i=0; i<val.length; i++){
				var tmpVal = val.substring(i, i+1);
				if( tmpVal != "" ){
					if( regx.test(tmpVal) ){
						newVal += tmpVal;
					}
				}
					
			}
			
			target.val( newVal );
			
		});
		
	}
	
	/*
		해당 target 의 값이 알파벳 소문자(a-z) 체크하고, 아닐경우 제거한다.
		ex) ValidateUtil.numberOnly("teacher.phoneNo")
	*/
	,alphabetLowerOnly : function(id){
		var target = getElById(id);
		//var target = $("#"+id);
		var regx = /^[a-z]*$/;
		target.keyup(function(){
			var val = this.value;
			var newVal = "";
			for(var i=0; i<val.length; i++){
				var tmpVal = val.substring(i, i+1);
				if( tmpVal != "" ){
					if( regx.test(tmpVal) ){
						newVal += tmpVal;
					}
				}
					
			}
			
			target.val( newVal );
			
		});
		
	}
		
	/*
		해당 target 의 값이 알파벳 대문자(A-Z) 체크하고, 아닐경우 제거한다.
		ex) ValidateUtil.numberOnly("teacher.phoneNo")
	*/
	,alphabetUpperOnly : function(id){
		var target = getElById(id);
		//var target = $("#"+id);
		var regx = /^[A-Z]*$/;
		target.keyup(function(){
			var val = this.value;
			var newVal = "";
			for(var i=0; i<val.length; i++){
				var tmpVal = val.substring(i, i+1);
				if( tmpVal != "" ){
					if( regx.test(tmpVal) ){
						newVal += tmpVal;
					}
				}
					
			}
			
			target.val( newVal );
			
		});
		
	}
		
	/*
		Enter 키를 막는다.
		ex) ValidateUtil.numberOnly("teacher.phoneNo", save)
	*/
	,noEnter : function(id, func){
		var target = getElById(id);
		target.keydown(function(e){
			if( e.keyCode == 13 ) {
				if( func != null ) func();
				return false;
			}
		});
	}
	
	/* URL 패턴 검사 */
	,isURL : function (url){
	    var RegExp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
	    if(RegExp.test(url)){
	        return true;
	    }else{
	        return false;
	    }
	} 
	
	/* 
	 * 이메일 패턴 검사 
	 * ex) ValidateUtil.isEmail("aaa@aa.com")
	 */
	,isEmail : function (email){
	    var RegExp = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
	    if(RegExp.test(email)){
	        return true;
	    }else{
	        return false;
	    }
	} 
	
	/**
	 * 파일 확장자 그룹
	 */
	,FILE_IMAGE : ['jpg', 'jpeg', 'gif', 'png']
	
	/**
	 * 파일 확장자 체크
	 * ValidateUtil.fileCheck("uploadFile", "업로드 파일은", ["jpg", "png"]);
	 */
	,fileCheck : function (names, msg, exts, required){
		console.log(exts);
		if( typeof(names) == "string" ){
			names = [names];
		}
		if( typeof(exts) == "string" ){
			exts = [exts];
		}
		for(var i=0; i<names.length; i++){
			var val = $("input[name='" + names[i] + "']").val();
			if( required != null && !required ){
				if( val == "" ) continue;
			}
			var idx = val.lastIndexOf(".");
			var ext = val.substring(idx+1, val.length);
			var isExt = false;
			for(var j=0; j<exts.length; j++){
				if( $.trim(exts[j].toUpperCase()) == $.trim(ext.toUpperCase()) ){
					isExt = true;
					break;
				}
			}
			if( !isExt ){
				isAllowFile = false;
				alert(msg + " " + exts + " 만 가능합니다.");
				return true;
				break;
			}
		}
		return false;
	}
	
	,fileChecks : function (objFiles){
		for(var i=0; i<objFiles.length; i++){
			var item = objFiles[i];
			
			var exts = item.exts;
			if( typeof(exts) == "string" ){
				exts = item.exts.split(",");
			}
			
			if( ValidateUtil.fileCheck(item.name, item.msg, exts, item.required) ) return true;
		}
		return false;
	}
	
	/**
	 * input file 속성에 allowExt 가 있을경우 체크 한다.
	 */
	,uploadFile : function (msg){
		var isAllowFile = true;
		var files = $("input[type='file']input[allowExt]");
		
		for(var i=0; i<files.length; i++){
			var item = files[i];
			var val = $(item).val();
			var idx = val.lastIndexOf(".");
			var ext = val.substring(idx+1, val.length);
			var exts = $(item).attr("allowExt").split(",");
			var isExt = true;
			for(var j=0; j<exts.length; j++){
				if( exts[j].toUpperCase() != ext.toUpperCase() ){
					isExt = false;
					break;
				}
			}
			
			if( !isExt ){
				isAllowFile = false;
				alert($(item).attr("msg") + " " + $(item).attr("allowExt") + " 만 가능합니다.");
				break;
			}
		}
		
		return isAllowFile;
	}

	, requiredCheck : function (formSelector){
		var validMsg = "";
		var frm = $(formSelector);
		frm.find("input").each(function(idx, item){
			if( $(item).attr("required") ){
				if( $(item).val().trim().length == 0 ){
					validMsg = $(item).parents(".form-group").find("label").text() + " 은(는) 필수 항목입니다.";
					$(item).focus();
					return false;
				}
			}
		});

		if( validMsg ){
			alert(validMsg);
			return false;
		}
		return true;
	}
};

Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};
 
String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

/* replaceAll */
String.prototype.replaceAll = function(target, replacement) {
	return this.split(target).join(replacement);
};

/**
 * @param Date startDate 
 * @param Date endDate
 */
function leftDate(startDate, endDate){
	var count = endDate.getTime() - startDate.getTime();
	count = Math.ceil( count / (24*60*60*1000) );
	return count;
}

jQuery(function($){
	if( $.datepicker != null ){
		$.datepicker.regional['ko'] = {
		  closeText: '닫기',
		  prevText: '이전',
		  nextText: '다음',
		  currentText: '오늘',
		  monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		  monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
		  dayNames: ['일','월','화','수','목','금','토'],
		  dayNamesShort: ['일','월','화','수','목','금','토'],
		  dayNamesMin: ['일','월','화','수','목','금','토'],
		  weekHeader: 'Wk',
		  dateFormat: 'yy-mm-dd',
		  firstDay: 0,
		  isRTL: false,
		  showMonthAfterYear: true,
		  yearSuffix: ''};
		$.datepicker.setDefaults($.datepicker.regional['ko']);
	}
	
	// bootstrap datepicker
	//$.fn.datepicker.dates['en'] = {
	//	days: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"],
	//	daysShort: ["일", "월", "화", "수", "목", "금", "토", "일"],
	//	daysMin: ["일", "월", "화", "수", "목", "금", "토", "일"],
	//	months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	//	monthsShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	//	format: 'yyyy-mm-dd'
	//};
	
	if( $("#_mainLoader").length == 0 ){
		mainLoader = $("<div />").attr("id", "_mainLoader").css({"position": "absolute", "display": "none"});
		var img = $("<img />").attr("src", baseUrl + "/resources/images/main-loader.gif");
		mainLoader.append(img);
		$("body").append(mainLoader);
	}
	if( $("#_uploadLoader").length == 0 ){
		uploadLoader = $("<div />").attr("id", "_uploadLoader").css({"position": "absolute", "display": "none"});
		var img = $("<img />").attr("src", baseUrl + "/resources/images/main-loader.gif");
		var percent = $("<div id='_uploadStatus' />").css({"color": "white", "text-align": "center"});
		uploadLoader.append(img);
		uploadLoader.append(percent);
		$("body").append(uploadLoader);
	}
});

function toNumber(num){
	num = String(num);
	if( num.length == 1 ) num = "0" + num;
	return num;
}

//VimeoPlayers
var Vimeo = {
	"PLAY" : "play"
	, "STOP" : "unload"
	, "PAUSE" : "pause"
	, "COLOR" : "setColor"
		
	, "players" : []
		
	, "action" : function(playerId, action, value) {
		var vplayer = null;
		
		for(var i=0; i<Vimeo.players.length; i++){
			if( playerId == Vimeo.players[i].playerId ){
				vplayer = Vimeo.players[i];
				break;
			}
		}
		
		if( vplayer != null ){
			var data = { method: action };
			
			if (value) {
			    data.value = value;
			}
			
			vplayer.iframe[0].contentWindow.postMessage(JSON.stringify(data), vplayer.url);	
		}
	}
};

function onEnterHandler(id, fn){
	var obj = getElById(id);
	obj.keydown(function(evt){
		if( evt.keyCode == 13 ){
			fn();
		}
	});
}

/* 폼 데이터를 json 으로 form plugin 필요 */
function formToJson(obj){
	var formData = obj.serializeArray();
	var resultJson = {};
	for(var i=0; i<formData.length; i++){
		resultJson[formData[i].name] = formData[i].value; 
	}
	return resultJson;
}

function jsonToFormData(obj){
	var result = {};
	for(key in obj){
		if( $.isArray(obj[key]) ){
			arrayToFormData(obj[key], key, result);
		} else {
			result[key] = obj[key];
		}
	}
	return result;
}

function arrayToFormData($arr, $prefix, $params) {
	for(var i=0; i<$arr.length; i++){
		for(key in $arr[i]){
			if( $.isArray($arr[i][key]) ){
				arrayToFormData($arr[i][key], $prefix + "[" + i + "]." + key, $params);
			} else if( typeof($arr[i][key]) == "object" ){
				$params[$prefix + "." + key] = $arr[i][key];
			} else {
				$params[$prefix + "[" + i + "]." + key] = $arr[i][key];
			}
		}
	}
	return $params;
};

function dateButtonHandler(idx, start, end){
	var startObj = $("input[name='" + start + "']");
	var endObj = $("input[name='" + end + "']");
	var datePattern = "yyyy-MM-dd";
	
	var startDate = new Date();
	var endDate = new Date();
	
	if( idx == 0 ){
		startDate.setDate( startDate.getDate() + 1 );
		endDate.setDate( startDate.getDate() - 1 );
	} else if( idx == 1 ){
		endDate.setDate( startDate.getDate() - 3 );
	} else if( idx == 2 ){
		endDate.setDate( startDate.getDate() - 7 );
	} else if( idx == 3 ){
		endDate.setMonth( startDate.getMonth() - 1 );
	} else if( idx == 4 ){
		endDate.setMonth( startDate.getMonth() - 3 );
	} else if( idx == 5 ){
		startObj.val("");
		endObj.val("");
		return false;
	}
	
	/* startObj.val( startDate.format(datePattern) );
	endObj.val( endDate.format(datePattern) ); */
	startObj.val( endDate.format(datePattern) );
	endObj.val( startDate.format(datePattern) );
}

function dateButtonHandler2(idx, start, end){
	var startObj = $("input[name='" + start + "']");
	var endObj = $("input[name='" + end + "']");
	var datePattern = "yyyy-MM-dd";
	
	var startDate = new Date();
	var endDate = new Date();
	
	if( idx == 0 ){
		startDate.setDate( startDate.getDate() + 1 );
		endDate.setDate( startDate.getDate() - 1 );
	} else if( idx == 1 ){
		endDate.setDate( startDate.getDate() - 3 );
	} else if( idx == 2 ){
		endDate.setDate( startDate.getDate() - 7 );
	} else if( idx == 3 ){
		endDate.setMonth( startDate.getMonth() - 1 );
	} else if( idx == 4 ){
		endDate.setMonth( startDate.getMonth() - 3 );
	} else if( idx == 5 ){
		endDate.setMonth( startDate.getMonth() - 6 );
	}
	
	/* startObj.val( startDate.format(datePattern) );
	endObj.val( endDate.format(datePattern) ); */
	startObj.val( endDate.format(datePattern) );
	endObj.val( startDate.format(datePattern) );
}

function dateButtonHandler3(idx, start, end){
	var startObj = $("input[name='" + start + "']");
	var endObj = $("input[name='" + end + "']");
	var datePattern = "yyyy-MM-dd";
	
	var startDate = new Date();
	var endDate = new Date();
	
	if( idx == 0 ){
		startDate.setDate( startDate.getDate() + 1 );
		endDate.setDate( startDate.getDate() - 1 );
	} else if( idx == 1 ){
		endDate.setDate( startDate.getDate() - 3 );
	} else if( idx == 2 ){
		endDate.setDate( startDate.getDate() - 7 );
	} else if( idx == 3 ){
		endDate.setMonth( startDate.getMonth() - 3 );
	} else if( idx == 4 ){
		startObj.val("");
		endObj.val("");
		return false;
	}
	
	startObj.val( endDate.format(datePattern) );
	endObj.val( startDate.format(datePattern) );
}

function dateButtonHandler4(idx, start, end){
	var startObj = $("input[id='" + start + "']");
	var endObj = $("input[id='" + end + "']");
	var datePattern = "yyyy.MM.dd";
	
	var startDate = new Date();
	var endDate = new Date();
	
	if( idx == 0 ){
		endDate.setMonth( startDate.getMonth() - 1 );
	} else if( idx == 1 ){
		endDate.setMonth( startDate.getMonth() - 3 );
	} else if( idx == 2 ){
		endDate.setMonth( startDate.getMonth() - 6 );
	}
	
	/* startObj.val( startDate.format(datePattern) );
	endObj.val( endDate.format(datePattern) ); */
	startObj.val( endDate.format(datePattern) );
	endObj.val( startDate.format(datePattern) );
}

function getInternetExplorerVersion()
//Returns the version of Internet Explorer or a -1
//(indicating the use of another browser).
{
	var rv = -1; // Return value assumes failure.
	if (navigator.appName == 'Microsoft Internet Explorer')
	{
	 var ua = navigator.userAgent;
	 var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
	 if (re.exec(ua) != null)
	   rv = parseFloat( RegExp.$1 );
	}
	return rv;
}


function formatCurrency(num) {
	if( num == null ) return 0.00;
    num = num.toString().replace(/\$|\,/g, '');
    if (isNaN(num)) num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num * 100 + 0.50000000001);
    cents = num % 100;
    num = Math.floor(num / 100).toString();
    if (cents < 10) cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3) ; i++)
        num = num.substring(0, num.length - (4 * i + 3)) + ',' + num.substring(num.length - (4 * i + 3));
//    return (((sign) ? '' : '-') + '$' + num + '.' + cents);
    return (((sign) ? '' : '-') + num + '.' + cents);
}

/**
 * parse.com push
 * param : { title, content, uniqueId }
 * callback
 * @returns
 */
function sendPushMessage(params, callback){
	console.log("push params ------------------");
	console.log(params);
	
	Parse.initialize("MJ0u5pDC5LjRjhWNFlxOMKx3umTyfBKjzLRnsGzv", "81HscgkMeCT7tk6Hy5VnjDYrwB5CgoNDLED72l5t");
	var parseQuery = new Parse.Query(Parse.Installation)
    , data = {
        alert: params.content
//        , data: {
//        	title: params.title
//        	, content: params.content
//        }
        , data: params
        , badge: "Increment"
    };
    //parseQuery.containedIn("uniqueId", ["A9A3D41B-1921-4B92-9D61-E29AA035DA95", "93ABD84C-070E-4FDB-887A-9F482193E281"]);
    //parseQuery.containedIn("uniqueId", [data.appInfo.ios, data.appInfo.android]);
	parseQuery.containedIn("uniqueId", params);
	
	Parse.Push.send({
		where: new Parse.Query(Parse.Installation)
		, data : data
	}).then(function(res) {
		console.log("Push sent!");
//		alert("발송이 완료되었습니다.");
		if( callback != null ) callback(res);
	}, function(error) {
		console.log(error);
//		alert("발송이 실패 하였습니다.\n\n" + JSON.stringify(error));
		if( callback != null ) callback(error);
	});
}

var newGuid = function () {
    var result = '';
    var hexcodes = "0123456789abcdef".split("");

    for (var index = 0; index < 32; index++) {
        var value = Math.floor(Math.random() * 16);

        switch (index) {
        case 8:
            result += '-';
            break;
        case 12:
            value = 4;
            result += '-';
            break;
        case 16:
            value = value & 3 | 8;
            result += '-';
            break;
        case 20:
            result += '-';
            break;
        }
        result += hexcodes[value];
    }
    return result;
};

function passwordCheck(str){
	if( str.length < 6 ){
		return false;
	}
	if( str.length > 12 ){
		return false;
	}
	var regex = /([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/;
	return regex.test($.trim(str));
}

function alertReload(str){
	alert(str);
	location.reload();
}

var Loader = {
	show: function(){
		if( $("._loader").length == 0 ){
			var html = "";
			html += '<div class="_loader" style="display: none; position: fixed; z-index: 9999">';
			html += '	<img class="image" src="' + baseUrl + '/resources/images/main-loader.gif" />';
			html += '</div>';
			$("body").append(html);
		}
		$("._loader").fadeIn();
	}	
	, hide: function(){
		$("._loader").fadeOut();
	}
};

function getItemThumbUrl(path, name){
	return baseUrl + "/resources/uploads" + path + "/" + name;
}

function addDelimiter(str, txt){
	if( str.length > 0 ){
		if( str.substring(1) != txt ){
			str = txt + str;
		}
	}
	if( str.length > 1 ){
		if( str.substring(str.length-1, str.length) != txt ){
			str += txt;
		}
	}
	return str;
}

$.fn.setPreview = function(opt){
	"use strict"
	var defaultOpt = {
		inputFile: $(this),
		img: null,
		w: 200,
		h: 200
	};
	$.extend(defaultOpt, opt);

	var previewImage = function(){
		if (!defaultOpt.inputFile || !defaultOpt.img) return;

		var inputFile = defaultOpt.inputFile.get(0);
		var img       = defaultOpt.img.get(0);

		// FileReader
		if (window.FileReader) {
			// image 파일만
			if (!inputFile.files[0].type.match(/image\//)) return;

			// preview
			try {
				var reader = new FileReader();
				reader.onload = function(e){
					img.src = e.target.result;
					img.style.width  = defaultOpt.w+'px';

					if( typeof(defaultOpt.h) == "string" )
						img.style.height = defaultOpt.h;
					else
						img.style.height = defaultOpt.h+'px';

					img.style.display = '';
				}
				reader.readAsDataURL(inputFile.files[0]);
			} catch (e) {
				// exception...
			}
			// img.filters (MSIE)
		} else if (img.filters) {
			inputFile.select();
			inputFile.blur();
			var imgSrc = document.selection.createRange().text;

			img.style.width  = defaultOpt.w+'px';
			img.style.height = defaultOpt.h+'px';
			img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\""+imgSrc+"\")";
			img.style.display = '';
			// no support
		} else {
			// Safari5, ...
		}
	};

	// onchange
	$(this).change(function(){
		previewImage();
	});
};

if (!String.prototype.format) {
	String.prototype.format = function () {
		var args = arguments;
		var str = this;

		function replaceByObjectProperies(obj) {
			for (var property in obj)
				if (obj.hasOwnProperty(property))
				//replace all instances case-insensitive
					str = str.replace(new RegExp(escapeRegExp("{" + property + "}"), 'gi'), String(obj[property]));
		}

		function escapeRegExp(string) {
			return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
		}

		function replaceByArray(arrayLike) {
			for (var i = 0, len = arrayLike.length; i < len; i++)
				str = str.replace(new RegExp(escapeRegExp("{" + i + "}"), 'gi'), String(arrayLike[i]));
		}

		if (!arguments.length || arguments[0] === null || arguments[0] === undefined)
			return str;
		else if (arguments.length == 1 && Array.isArray(arguments[0]))
			replaceByArray(arguments[0]);
		else if (arguments.length == 1 && typeof arguments[0] === "object")
			replaceByObjectProperies(arguments[0]);
		else
			replaceByArray(arguments);

		return str;
	};
}

Array.prototype.remove = function(el) {
	return this.splice(this.indexOf(el), 1);
}

Array.prototype.insert = function(index) {
	this.splice.apply(this, [index, 0].concat(
		Array.prototype.slice.call(arguments, 1)));
	return this;
};

function resizeKeepingRatio(width, height, destWidth, destHeight)
{
	if (!width || !height || width <= 0 || height <= 0)
	{
		throw "Params error";
	}
	var ratioW = width / destWidth;
	var ratioH = height / destHeight;
	if (ratioW <= 1 && ratioH <= 1)
	{
		var ratio = 1 / ((ratioW > ratioH) ? ratioW : ratioH);
		width *= ratio;
		height *= ratio;
	}
	else if (ratioW > 1 && ratioH <= 1)
	{
		var ratio = 1 / ratioW;
		width *= ratio;
		height *= ratio;
	}
	else if (ratioW <= 1 && ratioH > 1)
	{
		var ratio = 1 / ratioH;
		width *= ratio;
		height *= ratio;
	}
	else if (ratioW >= 1 && ratioH >= 1)
	{
		var ratio = 1 / ((ratioW > ratioH) ? ratioW : ratioH);
		width *= ratio;
		height *= ratio;
	}
	return {
		width : width,
		height : height
	};
}

function calculateAspectRatioFit(srcWidth, srcHeight, maxWidth, maxHeight) {

	var ratio = Math.min(maxWidth / srcWidth, maxHeight / srcHeight);

	return { width: srcWidth*ratio, height: srcHeight*ratio };
}

function codiynaviResizeImage(imgWidth, imgHeight){
	var resizeResult = {width:0,height:0,left:0,top:0};

	var destWidth = 530;
	var destHeight = 848;

	console.log("기준 정보", destWidth, destHeight);

	var imgRatio = (imgWidth > imgHeight) ? getRatio(imgWidth, imgHeight) : getRatio(imgHeight, imgWidth);

	console.log("이미지 정보", imgWidth, imgHeight);
	console.log("이미지 비율", imgRatio);

	if( imgWidth < destWidth && imgHeight < destHeight ) {
		// 컨테이너 크기보다 작을때
		resizeResult.width = imgWidth;
		resizeResult.height = imgHeight;

	} else {
		if (imgWidth < imgHeight) {
			resizeResult.height = destHeight;
			resizeResult.width = parseInt(imgWidth * ((destHeight / imgHeight)));

			if (resizeResult.width < 320) {
				resizeResult.width = destWidth;
				resizeResult.height = parseInt(imgHeight * ((destWidth / imgWidth)));

			}

		}

		if (imgWidth > imgHeight) {
			resizeResult.width = destWidth;
			resizeResult.height = parseInt(imgHeight * ((destWidth / imgWidth)));

			if (resizeResult.height < 450) {
				resizeResult.height = destHeight;
				resizeResult.width = parseInt(imgWidth * ((destHeight / imgHeight)));
			}
		}
	}

	// 위치
	if( resizeResult.width > destWidth ){
		resizeResult.left = -( (resizeResult.width / 2) - (destWidth/2) );
	}
	if( resizeResult.height > destHeight ){
		resizeResult.top = -( (resizeResult.height / 2) - (destHeight/2) );
	}

	return resizeResult;

}

function resizeImage(destWidth, destHeight, imgWidth, imgHeight){
	var resizeResult = {width:0,height:0,left:0,top:0};

	console.log("기준 정보", destWidth, destHeight);

	var imgRatio = (imgWidth > imgHeight) ? getRatio(imgWidth, imgHeight) : getRatio(imgHeight, imgWidth);

	console.log("이미지 정보", imgWidth, imgHeight);
	console.log("이미지 비율", imgRatio);

	if( imgWidth >= destWidth && imgHeight >= destHeight ){
		console.log("* 이미지가 컨테이너보다 가로 세로 클때");

		// 가로형
		if( imgWidth > imgHeight ) {
			console.log("\t- 가로형");
			resizeResult.width = parseInt(destHeight * imgRatio);
			resizeResult.height = destHeight;

			resizeResult.left = -(resizeResult.width/2 - (destWidth/2));
		}

		// 세로형
		else {
			console.log("\t- 세로형");
			resizeResult.width = destWidth;
			resizeResult.height = parseInt(destWidth * imgRatio);

			// 큰 세로형일때는 상단에 맞춘다.
//                    resizeResult.top = -(resizeResult.height/2 - (destHeight/2));
		}

	} else {
		console.log("* 이미지가 컨테이너보다 가로 또는 세로 작을때");

		// 가로형
		if( imgWidth > imgHeight ) {
			console.log("\t- 가로형");
			resizeResult.width = parseInt(imgHeight * imgRatio);
			resizeResult.height = imgHeight;

		}

		// 세로형
		else {
			console.log("\t- 세로형");
			resizeResult.width = imgWidth;
			resizeResult.height = parseInt(imgWidth * imgRatio);

		}

	}

	// 영역이 벗어나면 정렬
	if( resizeResult.width < destWidth ){
		resizeResult.left = -(resizeResult.width/2 - (destWidth/2));
	}
	if( resizeResult.height < destHeight ){
		resizeResult.top = -(resizeResult.height/2 - (destHeight/2));
	}
	return resizeResult;

}

function toFixed(number, fractionSize) {
	return +(Math.round(+(number.toString() + 'e' + fractionSize)).toString() + 'e' + -fractionSize);
}

function getRatio(width, height){
	return (Math.round((width/height)*100)/100)
}
