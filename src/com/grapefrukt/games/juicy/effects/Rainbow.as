﻿package com.grapefrukt.games.juicy.effects {
	
	import com.grapefrukt.display.utilities.ColorConverter;
	import com.grapefrukt.games.general.gameobjects.GameObject;
	import com.grapefrukt.games.juicy.Settings;
	import de.polygonal.core.ObjectPool;
	import flash.display.Shape;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Martin Jonasson (grapefrukt@grapefrukt.com)
	 */
	public class Rainbow extends Shape {
		
		private var maxLen		:Number = 	8;
		private var _segments	:Vector.<Segment>;
		
		private var _colorCount	:uint = 	1;
		private var _colorOffset:Number = 	0.0;
		
		private static var _objectPool:ObjectPool;
		private var tmpPoint:Point;
		
		public static function init():void { 
			_objectPool = new ObjectPool(true);
			_objectPool.allocate(Segment, 100);
		}
		
		public function Rainbow(size:uint = 1) {
			tmpPoint = new Point;
			_colorOffset = Math.random();
			_segments = new Vector.<Segment>;
			_colorCount = size;
			
			if (!_objectPool) init();
		}
		
		public function addSegment(x:Number, y:Number):void {
			var seg:Segment;
			
			while (_segments.length > maxLen) _objectPool.object = _segments.shift();
			seg = _objectPool.object
			seg.x = x;
			seg.y = y;
			
			_segments.push(seg);
		}
		
		public function redrawSegments(offsetX:Number = 0, offsetY:Number = 0):void {
			graphics.clear();		
			if (!Settings.EFFECT_BALL_DRAW_TRAILS) return;
			
			var ang		:Number;
			var s1		:Segment;	// current segment
			var s2		:Segment;	// current segment
			var step	:int 	= 0;
			var offset	:Number = 0.0;
						
			for (var i:uint = 0; i < _colorCount; ++i) {
				graphics.lineStyle(5, getColor(i / _colorCount));
				step = 0;
				offset = 2.0 * (i - _colorCount * .5);
				for (var j:int = _segments.length - 1; j >= 0; j -= 1 ) {
					s1 = Segment(_segments[j]);
					if(s2){
						ang = Math.atan2(s1.y - s2.y, s1.x - s2.x) + 1.57079633;
						tmpPoint.x = Math.cos(ang) * offset;
						tmpPoint.y = Math.sin(ang) * offset;
						
						if (step == 1) graphics.moveTo(s1.x + tmpPoint.x - offsetX, s1.y + tmpPoint.y - offsetY);
						graphics.lineTo(s1.x + tmpPoint.x - offsetX, s1.y + tmpPoint.y - offsetY);
					}
					step++;
					s2 = s1;
				}
				s2 = null;
			}
		}
		
		private function getColor(percent:Number):uint {	
			return ColorConverter.HSBtoUINT(percent + _colorOffset, 1, 1);
		}
		
		private function get head():Segment {
			return _segments.length ? _segments[int(_segments.length - 1)] : null;
		}
		
		private function get tail():Segment {
			return _segments.length ? _segments[0] : null;
		}
		
	}
	
}

class Segment  {
	public var x:Number = 0.0;
	public var y:Number = 0.0;	
}