
var ItemEvent = {
    LOAD_COMPLATE : "LOAD_COMPLATE"
    , LOAD_COMPLATE_CATEGORY : "LOAD_COMPLATE_CATEGORY"
    , LOAD_COMPLATE_PROPERTY : "LOAD_COMPLATE_PROPERTY"
    , LOAD_COMPLATE_DETAIL_PROPERTY : "LOAD_COMPLATE_DETAIL_PROPERTY"
    , LOAD_COMPLATE_NORMAL_PROPERTY : "LOAD_COMPLATE_NORMAL_PROPERTY"
    , LOAD_COMPLATE_COLOR_PROPERTY : "LOAD_COMPLATE_COLOR_PROPERTY"
};

function getCategories(depth, parentId){
    ////Loader.show();
    var params = { depth: depth, parentId: parentId };
    var items = $(".category select");
    //console.log("getCategories", params);
    for(var i=depth-1; i<categoryConfig.maxDepth; i++){
        //console.log("카테고리 초기화 ", i);
        items.eq(i).children().remove();
    }
    $.post(baseUrl + "/category/list", params, function(res){
        if( res.result && res.data.categories ){
            $(res.data.categories).each(function(idx, item){
                var opt = $("<option/>");
                opt.attr("value", item.id);
                opt.text(item.name);
                items.eq(depth - 1).append(opt);
            });

        } else {
            alert("카테고리 데이터 조회 실패");
        }

        $(document).trigger( ItemEvent.LOAD_COMPLATE, {type: "CATEGORY", depth: depth});
        //Loader.hide();
    });
}

function getProperties(depth, type, parentId, callback){
    //Loader.show();
    var params = { depth: depth, parentId: parentId, type: type.toUpperCase() };
    var items = $(".property." + type.toLowerCase() + " select");
    //console.log("getProperties", params);
    for(var i=depth-1; i<categoryConfig.maxDepth; i++){
        items.eq(i).children().remove();
    }
    $.post(baseUrl + "/property/list", params, function(res){
        if( res.result && res.data.properties ){

            if( type == "DETAIL" ){
                $(res.data.properties).each(function (idx, item) {
                    var opt = $("<option/>");
                    opt.attr("value", item.id);
                    opt.text(item.name);
                    items.eq(depth - 1).append(opt);
                });
                $(document).trigger( ItemEvent.LOAD_COMPLATE, {type: type, depth: depth});
            }

            if( type == "NORMAL" ){
                $(".property.normal").remove();
                $(res.data.properties).each(function (idx, item) {
                    var div = $("<div class='property normal'/>");
                    var select = $("<select class='form-control' size='7'/>");

                    if( item.items && item.items.length > 0 ) {
                        select.attr("data-parent", item.items[0].parentId);
                        // 일반 속성은 하위 노출
                        $(item.items).each(function () {
                            var opt = $("<option/>");
                            opt.attr("value", this.id);
                            opt.text(this.name);
                            select.append(opt);
                        });

                        div.append("<h5 class='category-title'>" + item.name + "</h5>");
                        div.append(select);
                        $(".categories").append(div);
                    }
                    $(document).trigger( ItemEvent.LOAD_COMPLATE, {type: type, depth: depth});
                });

            }

            if( type == "COLOR" ){
                $(".property.color").remove();
                var div = $("<div class='property color'/>");
                div.append("<h5 class='category-title'>색상</h5>");
                var colors = $("<div class='colors'/>");
                $(res.data.properties).each(function (idx, item) {
                    colors.append("<div data-id='" + item.id + "' class='color-item' style='background-color: " + item.name + "'/>")
                });
                div.append(colors);
                $(".categories").append(div);
                $(document).trigger( ItemEvent.LOAD_COMPLATE, {type: type, depth: depth});
            }

        } else {
            alert("세부특성 데이터 조회 실패");
        }

        if( callback ) callback();

        //Loader.hide();
    });
}

function getSelectedCategory(depth){
    var categoryIds = [];

    // 카테고리 선택 항목
    $(".category select").each(function(idx){
        if( $(this).val() ) {
            if( depth == null && depth == (idx+1) ){
                categoryIds = $(this).val();
            } else {
                categoryIds.push( $(this).val() );
            }
        }
    });

    return categoryIds;
}

function getSelectedProperty(type){
    var propertyIds = [];

    if( type == null || type == 'detail' ) {
        // 세부 특성 선택 항목
        $(".property.detail select").each(function (idx) {
            if ($(this).val()) {
                propertyIds.push($(this).val());
            }
        });
    }

    if( type == null || type == 'normal' ) {
        // 일반 특성 선택 항목
        $(".property.normal select").each(function (idx) {
            if ($(this).val()) {
                propertyIds.push($(this).data("parent"));
                propertyIds.push($(this).val());
            }
        });
    }

    if( type == null || type == 'color' ) {
        // 색상 선택 항목
        $(".property.color .color-item").each(function (idx) {
            if ($(this).find(".color-check").length > 0) {
                propertyIds.push($(this).data("id"));
            }
        });
    }

    return propertyIds;
}

function getItems(search, callback){
    // console.log("getItem", search);
    $(".items .item").remove();
    $.ajax({
        url: baseUrl + "/item/items/json",
        data: JSON.stringify(search),
        type: "POST",
        dataType:"json",
        contentType:'application/json',
        success: function(res){
            $(res.data.items).each(function(idx, item){
                var itemEl = $(".template .item").clone();
                itemEl.data(item);
                itemEl.find("input[type='checkbox']").val( item.id );
                itemEl.find(".pic").append("<img src='" + getItemThumbUrl(item.thumbPath, item.thumbName) + "'/>");
                itemEl.find(".text1").html(item.title);
                itemEl.find(".text2").html(item.name);
                itemEl.find(".text3").html(Number(item.price).toLocaleString('ko'));
                $(".items").append(itemEl);
            });

            if( callback ){
                callback();
            }
        },
        error: function(){
            //Loader.hide();
        }
    });

    //$.post("items/json", search, function(res){
    //    console.log(res);
    //    $(".items .item").remove();
    //    $(res.data.items).each(function(idx, item){
    //        var itemEl = $(".template .item").clone();
    //        itemEl.find(".pic").append("<img src='" + getItemThumbUrl(item.thumbPath, item.thumbName) + "'/>");
    //        itemEl.find(".text1").html(item.title);
    //        itemEl.find(".text2").html(item.name);
    //        itemEl.find(".text3").html(item.price);
    //        $(".items").append(itemEl);
    //    });
    //});
}

function colorSelectHandler(){
    if( $(this).children().length == 0 ){
        $(this).append("<i class='fa fa-check-circle color-check'></i>");
    } else {
        $(this).children().remove();
    }
    if( window.colorSelectFunc != null ){
        colorSelectFunc();
    }
}

function itemFilterSearch(){
    var itemSearch = new ItemSearch();
    itemSearch.category = addDelimiter(getSelectedCategory().toString(), ",");
    itemSearch.detailProperty = addDelimiter(getSelectedProperty('detail').toString(), ",");
    itemSearch.colorProperty = addDelimiter(getSelectedProperty('color').toString(), ",");

    var normalPropList = getSelectedProperty('normal');
    for(var i=0; i<normalPropList.length; i+=2){
        itemSearch.normalProperties.push(normalPropList[i] + "," + normalPropList[i+1] + "|");
    }

    getItems(itemSearch);
}

var ItemSearch = function(){
    this.category = null;
    this.detailProperty = null;
    this.colorProperty = null;
    this.normalProperty = null;
    this.normalProperties = [];
};

$(document).ready(function(){
    $(document).on('click', '.color-item', colorSelectHandler);

    $("#itemFilterResetBtn").click(function(){
        getCategories(1);
        getProperties(1, "DETAIL");
        getProperties(1, "NORMAL", 0, function(){
            getProperties(1, "COLOR");
        });
        getItems(new ItemSearch());
    });
});