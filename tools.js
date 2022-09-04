window.onload = function(){
	$(document).ready(function(){
		//拼装属性
		var array = new Array();
		var cur = 0;
		$('*[class*="page"]').find("*").each(function(){
		  var isClass = false;
		  var className = "";
	  	  $.each(this.attributes, function() {
	  	    if(this.specified) {
				var name = this.name;
				var value = this.value;
				if(name == "class"){
					className = value;
					
					isClass = true;
				}
	  	    }
	  	  });
		  if(isClass == true){
			  //拼装属性
			  var map = {};
			  map["cur"] = cur.toString();cur ++;
			  map["className"] = className.toString();
			  var tagName = $(this)[0].tagName;  map["tagName"] = tagName.toString();
			  var index = $(this).parents().length;  map["index"] = index.toString();
			  var brother_index = $(this).index();  map["brother_index"] = brother_index.toString();
			  var parent = $(this).parent().prop("class"); map["parent"] = parent.toString(); 
			  var left = $(this).offset().left;  map["left"] = left.toString();
			  var top = $(this).offset().top;  map["top"] = top.toString();
			  var width = $(this).width();  map["width"] = width.toString();
			  var height = $(this).height();  map["height"] = height.toString();
			  var background_color = $(this).css("background-color");  map["background_color"] = background_color.toString();
			  var left = $(this).css("left");  map["left"] = left.toString();
			  var top = $(this).css("top");  map["top"] = top.toString();
			  var right = $(this).css("right");  map["right"] = right.toString();
			  var bottom = $(this).css("bottom");  map["bottom"] = bottom.toString();
			  var margin = $(this).css("margin");  map["margin"] = margin.toString();
			  var margin_top = $(this).css("margin-top");  map["margin_top"] = margin_top.toString();
			  var margin_left = $(this).css("margin-left");  map["margin_left"] = margin_left.toString()
			  var margin_right = $(this).css("margin-right");  map["margin_right"] = margin_right.toString();
			  var margin_bottom = $(this).css("margin-bottom");  map["margin_bottom"] = margin_bottom.toString();
			  var color = $(this).css("color");  map["color"] = color.toString();
			  var font_size = $(this).css("font-size");  map["font_size"] = font_size.toString();
			  var font_family = $(this).css("font-family");  map["font_family"] = font_family.toString();
			  var line_height = $(this).css("line-height");  map["line_height"] = line_height.toString();
			  var text_align = $(this).css("text-align");  map["text_align"] = text_align.toString();
			  var border = $(this).css("border");  map["border"] = border.toString();
			  var border_radius = $(this).css("border-radius");  map["border_radius"] = border_radius.toString();
			  var background = $(this).css("background");  map["background"] = background.toString();
			  var justify_content = $(this).css("justify-content");  map["justify_content"] = justify_content.toString();
			  var display = $(this).css("display");  map["display"] = display.toString();
			  var flex_direction = $(this).css("flex-direction");  map["flex_direction"] = flex_direction.toString();
			  var opacity = $(this).css("opacity");  map["opacity"] = opacity.toString();
			  var align_items = $(this).css("align-items");  map["align_items"] = align_items.toString();
			  array.push(map);
		  }
		});
		// console.log(array.toString());
		
		$('*').css({"visibility":"visible"}); 
		$('*[class^="page "]').find("*").on({
			click: function (event) {
				// $(this).css({"outline":"red solid 1px"});
				// var className = $(this).prop("class");
				// var view = $('*[class*="page1"]').find("*[class*='"+className+"']");
				// var visibility = view.css('visibility'); 
				// if(visibility == 'hidden'){
				// 	view.css({"visibility":"visible"}); 
				// }else{
				// 	view.css({"visibility":"hidden"}); 
				// }
				// event.stopPropagation();
			},
			dblclick: function (event) {
				$(this).css({"outline":"red solid 1px"});
				var className = $(this).prop("class");
				var view = $('*[class*="page1"]').find("*[class*='"+className+"']");
				var visibility = view.css('visibility'); 
				if(visibility == 'hidden'){
					view.css({"visibility":"visible"}); 
				}else{
					view.css({"visibility":"hidden"}); 
				}
				event.stopPropagation();
			},
			mouseover: function (event) { $(this).css({"outline":"red dashed 1px"});event.stopPropagation(); },
			mouseout: function (event) { $(this).css({"outline":""}); event.stopPropagation(); }
	  });
	  
	});
};