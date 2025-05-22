/*	version: "v4.1.6"	*/

$.noConflict();
var $ = jQuery;

var _duration = 0.4;

var $el_scales = [0.525, 0.65, 0.5];
var $final_scale = 0.5;

var $final_el_pos = [[-1,-29], [-36,15], [34,16]];

var _delay = 0.1;
var _ellipse_duration = 0.6;

var _sf_name_ = true;
var _portal = false;
var _legal = true;

/************************************ Custom JS *****************************************/

function init_animation() {
	"use strict";
	position();
    init_logo();
	gsap.delayedCall(0.8, intro_start);
}

function intro_start() {
	gsap.to("#intro1", _duration, {x:0, alpha:1, delay:_duration*2, ease:Power2.easeIn});
    
    if (_portal) {
		gsap.to("#portal", _duration*2, {x:0, ease:Power2.easeOut});
		gsap.to("#ls", _duration*2, {alpha:1, delay:_duration*2, ease:Power2.easeOut});
		
		gsap.delayedCall(5, intro_two);
		gsap.delayedCall(9, intro_three);
		gsap.delayedCall(13, intro_end);
	} else {
		gsap.delayedCall(4, intro_two);
		gsap.delayedCall(9, intro_three);
		gsap.delayedCall(12, intro_end);
	}
}

function intro_two() {
	gsap.to("#intro1", _duration, {alpha:0});
	gsap.to("#intro2", _duration, {x:0, alpha:1, delay:_duration, ease:Power2.easeIn});
    
	if (_legal) {
		gsap.to("#legal", _duration, {alpha:1, delay:_duration*2, ease:Power2.easeIn});
	}
}

function intro_three() {
	if (_legal) {
		gsap.to("#legal", _duration, {alpha:0, ease:Power2.easeIn});
	}
	
	gsap.to("#intro2", _duration, {alpha:0});
	gsap.to("#intro3", _duration, {x:0, alpha:1, delay:_duration, ease:Power2.easeIn});
}

function intro_end() {  
	gsap.to("#intro3", _duration, {alpha:0, delay:_duration, ease:Power2.easeIn});
	gsap.to("#intro4", _duration, {x:0, alpha:1, delay:_duration*2, ease:Power2.easeIn});

	gsap.to($("#cta"), 1, {scale:1, alpha:1, delay:_duration*3, ease:Expo.easeOut, onComplete:init_cta});

	if (_legal) {
		gsap.to("#legal2", _duration, {alpha:1, delay:_duration*4, ease:Power2.easeIn});
	}
}

function init_cta() {
	$("#main-panel").on("mouseover", function(evt) {
		gsap.to($("#cta_red"), 0.25, {alpha:1, force3D:false});
	});

	$("#main-panel").on("mouseout", function(evt) {
		gsap.to($("#cta_red"), 0.25, {alpha:0, force3D:false});
	});
}

/************************************ Logo Animation *****************************************/

function init_logo() {
	gsap.set("#ellipse1", {x:-20, y:-85});
    gsap.set("#ellipse2", {x:-45, y:50});
    gsap.set("#ellipse3", {x:60, y:-5});
    
    gsap.delayedCall(.4, connect_ellipses);
    
	gsap.to("#ellipse1", _ellipse_duration, {scale:$el_scales[0], ease:Expo.easeOut});
    gsap.to("#ellipse2", _ellipse_duration, {scale:$el_scales[1], delay:_delay, ease:Expo.easeOut});
    gsap.to("#ellipse3", _ellipse_duration, {scale:$el_scales[2], delay:_delay*2, ease:Expo.easeOut});
}

function connect_ellipses() {
    
    gsap.delayedCall(0.65, init_standin_logo);
    
    gsap.to("#ellipse1", 0.65, {x:$final_el_pos[0][0], y:$final_el_pos[0][1], scale:$final_scale, ease:Expo.easeIn});
    gsap.to("#ellipse2", 0.65, {x:$final_el_pos[1][0], y:$final_el_pos[1][1], scale:$final_scale, ease:Expo.easeIn});
    gsap.to("#ellipse3", 0.65, {x:$final_el_pos[2][0], y:$final_el_pos[2][1], scale:$final_scale, ease:Expo.easeIn});
    
	if (_sf_name_) {
		gsap.to("#logo-name", 0.4, {x:0, alpha:1, delay:0.35, ease:Expo.easeIn});
	} else {
		gsap.to("#orbs-reg", 0.25, {alpha:1, delay:0.6});
	}
}

function init_standin_logo() {
	gsap.to("#logo-orbs", 0.05, {alpha:1});
    gsap.to("#ellipses", 0.1, {alpha:0});
}

/*********************************************************************************************/

function position() {
	var $offset = $("#intro").offset();
	$("#cta").css({
		"top" : $offset.top + $("#intro4").height() + 25 + "px"
	});
}

function init_hit_areas($target, $num, $delay) {
	if ($delay) {
		gsap.to($target, 0.8, {alpha:1, scale:$num, delay:$delay, ease:Elastic.easeOut, onComplete:function() {
			gsap.to($target, 0.5, {scale:0, alpha:0, ease:Back.easeIn});
		}});
	} else {
		gsap.to($target, 0.8, {alpha:1, scale:$num, ease:Elastic.easeOut, onComplete:function() {
			gsap.to($target, 0.5, {scale:0, alpha:0, ease:Back.easeIn});
		}});
	}
}
