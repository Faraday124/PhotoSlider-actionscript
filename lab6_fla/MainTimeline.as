package lab6_fla
{
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var img6_mc:MovieClip;
        public var rectangle1_mc:MovieClip;
        public var img4_mc:MovieClip;
        public var img5_mc:MovieClip;
        public var rectangle2_mc:MovieClip;
        public var goBack_btn:SimpleButton;
        public var present:SimpleButton;
        public var img2_mc:MovieClip;
        public var img3_mc:MovieClip;
        public var img1_mc:MovieClip;
        public var rectangle1:Rectangle;
        public var rectangle2:Rectangle;
        public var rectangle3:Rectangle;
        public var rectangle4:Rectangle;
        public var rectangle5:Rectangle;
        public var rectangle6:Rectangle;
        public var rectangles:Array;
        public var images:Array;
        public var img:MovieClip;
        public var recEmpty:Array;
        public var url:URLRequest;
        public var loader:URLLoader;
        public var container:Sprite;
        public var nameImg:Object;
        public var my_slideshow:Sprite;
        public var my_image_slides:Sprite;
        public var my_loaders_array:Array;
        public var my_labels_array:Array;
        public var my_success_counter:Number;
        public var my_playback_counter:Number;
        public var my_total:Number;
        public var my_timer:Timer;
        public var my_prev_tween:Tween;
        public var my_tweens_array:Array;
        public var my_image:Loader;

        public function MainTimeline()
        {
            addFrameScript(0, this.frame1);
            return;
        } 

        public function createRectangles()
        {
            this.rectangles = new Array();
            this.rectangle1 = new Rectangle(15, 340, 150, 100);
            this.rectangle2 = new Rectangle(180, 340, 150, 100);
            this.rectangle3 = new Rectangle(345, 340, 150, 100);
            this.rectangle4 = new Rectangle(510, 340, 150, 100);
            this.rectangle5 = new Rectangle(675, 340, 150, 100);
            this.rectangle6 = new Rectangle(840, 340, 150, 100);
            this.rectangles.push(this.rectangle1, this.rectangle2, this.rectangle3, this.rectangle4, this.rectangle5, this.rectangle6);
            this.images = new Array();
            this.images.push(this.img1_mc, this.img2_mc, this.img3_mc, this.img4_mc, this.img5_mc, this.img6_mc);
            this.recEmpty = new Array();
            this.container = new Sprite();
            return;
        } 

        public function listeners() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.images.length)
            {
                
                this.images[_loc_1].addEventListener(MouseEvent.MOUSE_DOWN, this.startDragging);
                this.images[_loc_1].addEventListener(MouseEvent.MOUSE_UP, this.stopDragging);
                _loc_1 = _loc_1 + 1;
            }
            return;
        } 

        public function removeListeners() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < this.images.length)
            {
                
                this.images[_loc_1].removeEventListener(MouseEvent.MOUSE_DOWN, this.startDragging);
                this.images[_loc_1].removeEventListener(MouseEvent.MOUSE_UP, this.stopDragging);
                _loc_1 = _loc_1 + 1;
            }
            return;
        } 

        public function startDragging(event:MouseEvent) : void
        {
            this.img = MovieClip(event.target);
            this.img.startDrag();
            setChildIndex(this.img, (numChildren - 1));
            return;
        } 

        public function stopDragging(event:MouseEvent) : void
        {
            this.img = MovieClip(event.target);
            this.img.stopDrag();
            this.matchImg(this.img);
            return;
        } 

        public function matchImg(param1:MovieClip) : void
        {
            var _loc_3:* = undefined;
            var _loc_4:* = undefined;
            var _loc_5:* = undefined;
            var _loc_6:* = undefined;
            var _loc_2:* = 0;
            while (_loc_2 < this.rectangles.length)
            {
                
                _loc_3 = Math.abs(param1.x - this.rectangles[_loc_2].x);
                _loc_4 = Math.abs(param1.y - this.rectangles[_loc_2].y);
                if (_loc_3 < 30 && _loc_4 < 30)
                {
                    if (this.recEmpty[_loc_2] == null)
                    {
                        param1.x = this.rectangles[_loc_2].x;
                        param1.y = this.rectangles[_loc_2].y;
                        this.recEmpty[_loc_2] = param1;
                        setChildIndex(this.recEmpty[_loc_2], numChildren - 6);
                    }
                    else if (this.recEmpty[_loc_2] != null && this.recEmpty[_loc_2] == param1)
                    {
                        param1.x = this.rectangles[_loc_2].x;
                        param1.y = this.rectangles[_loc_2].y;
                    }
                }
                else if (this.recEmpty[_loc_2] != null)
                {
                    _loc_5 = true;
                    _loc_6 = 0;
                    while (_loc_6 < this.images.length && _loc_5)
                    {
                        
                        if (this.images[_loc_6].x != this.rectangles[_loc_2].x)
                        {
                            this.recEmpty[_loc_2] = null;
                        }
                        else
                        {
                            this.recEmpty[_loc_2] = this.images[_loc_6];
                            _loc_5 = false;
                        }
                        _loc_6 = _loc_6 + 1;
                    }
                }
                if (_loc_3 < 140 && _loc_4 < 140 && this.recEmpty[_loc_2] != null && this.recEmpty[_loc_2] != param1)
                {
                    param1.y = param1.y - 100;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        } 

        public function onComplete(event:Event) : void
        {
            var _loc_2:* = this;
            var _loc_3:* = this.my_success_counter + 1;
            _loc_2.my_success_counter = _loc_3;
            if (this.my_success_counter == this.my_total)
            {
                this.startShow();
            }
            return;
        } 

        public function onFadeOut(event:TweenEvent) : void
        {
            if (this.my_image_slides.getChildAt(0) != null)
            {
                this.my_image_slides.removeChildAt(0);
            }
            return;
        } 

        public function nextImage() : void
        {
            this.my_image = Loader(this.my_loaders_array[this.my_playback_counter]);
            this.my_image_slides.addChild(this.my_image);
            this.my_image.x = (stage.stageWidth - this.my_image.width) / 2;
            this.my_image.y = (stage.stageHeight - this.my_image.height) / 2;
            this.my_tweens_array[0] = new Tween(this.my_image, "alpha", Strong.easeOut, 0, 1, 1, true);
            return;
        } 

        public function hidePrev() : void
        {
            var _loc_1:* = Loader(this.my_image_slides.getChildAt(0));
            this.my_prev_tween = new Tween(_loc_1, "alpha", Strong.easeOut, 1, 0, 1, true);
            this.my_prev_tween.addEventListener(TweenEvent.MOTION_FINISH, this.onFadeOut);
            return;
        } 

        public function startShow() : void
        {
            this.goBack_btn.visible = true;
            this.goBack_btn.addEventListener(MouseEvent.CLICK, this.goBack);
            addChild(this.my_slideshow);
            this.my_slideshow.addChild(this.my_image_slides);
            this.nextImage();
            if (this.my_total > 1)
            {
                this.my_timer = new Timer(2000);
                this.my_timer.addEventListener(TimerEvent.TIMER, this.timerListener);
                this.my_timer.start();
            }
            this.clearIcons();
            return;
        } 

        public function timerListener(event:TimerEvent) : void
        {
            this.hidePrev();
            var _loc_2:* = this;
            var _loc_3:* = this.my_playback_counter + 1;
            _loc_2.my_playback_counter = _loc_3;
            if (this.my_playback_counter == this.my_loaders_array.length)
            {
                this.my_playback_counter = 0;
            }
            this.nextImage();
            return;
        } 

        public function loadImages(event:MouseEvent) : void
        {
            var _loc_3:* = undefined;
            var _loc_4:* = null;
            var _loc_2:* = 0;
            while (_loc_2 < this.recEmpty.length)
            {
                
                if (this.recEmpty[_loc_2] != null)
                {
                    this.removeListeners();
                    this.clearIcons();
                    this.present.removeEventListener(MouseEvent.CLICK, this.loadImages);
                    _loc_3 = this.recEmpty[_loc_2].name;
                    _loc_4 = new Loader();
                    _loc_4.load(new URLRequest("img/" + _loc_3 + ".jpg"));
                    _loc_4.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
                    this.my_loaders_array.push(_loc_4);
                    var _loc_5:* = this;
                    var _loc_6:* = this.my_total + 1;
                    _loc_5.my_total = _loc_6;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        } 

        public function clearIcons() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < numChildren)
            {
                
                if (getChildAt(_loc_1) is MovieClip)
                {
                    getChildAt(_loc_1).visible = false;
                    this.present.visible = false;
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        } 

        public function showIcons() : void
        {
            var _loc_1:* = 0;
            while (_loc_1 < numChildren)
            {
                
                if (getChildAt(_loc_1) is MovieClip)
                {
                    getChildAt(_loc_1).visible = true;
                    this.present.visible = true;
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        } 

        public function checkRec() : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = undefined;
            var _loc_1:* = 0;
            while (_loc_1 < this.rectangles.length)
            {
                
                _loc_2 = true;
                _loc_3 = 0;
                while (_loc_3 < this.images.length && _loc_2)
                {
                    
                    if (this.images[_loc_3].x != this.rectangles[_loc_1].x)
                    {
                        this.recEmpty[_loc_1] = null;
                    }
                    else
                    {
                        this.recEmpty[_loc_1] = this.images[_loc_3];
                        _loc_2 = false;
                    }
                    _loc_3 = _loc_3 + 1;
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        } 

        public function goBack(event:MouseEvent) : void
        {
            this.my_playback_counter = 0;
            var _loc_2:* = 0;
            while (_loc_2 < this.recEmpty.length)
            {
                
                this.recEmpty[_loc_2] = null;
                _loc_2 = _loc_2 + 1;
            }
            var _loc_3:* = 0;
            while (_loc_3 < this.my_loaders_array.length)
            {
                
                this.my_loaders_array[_loc_3].unload();
                _loc_3 = _loc_3 + 1;
            }
            if (this.my_prev_tween != null)
            {
                this.my_prev_tween.removeEventListener(TweenEvent.MOTION_FINISH, this.onFadeOut);
                this.my_prev_tween = null;
            }
            if (this.my_timer != null)
            {
                this.my_timer.stop();
                this.my_timer.removeEventListener(TimerEvent.TIMER, this.timerListener);
            }
            removeChild(this.my_slideshow);
            this.showIcons();
            this.listeners();
            this.present.addEventListener(MouseEvent.CLICK, this.loadImages);
            this.recEmpty = new Array();
            this.my_loaders_array = new Array();
            this.checkRec();
            this.my_success_counter = 0;
            this.my_total = 0;
            this.goBack_btn.visible = false;
            return;
        } 

        public function snow(event:Event) : void
        {
            var _sf:snowflake;
            var speed:Number;
            var lf:int;
            var snowfall:Function;
            var event:* = event;
            snowfall = function (event:Event) : void
            {
                _sf.y = _sf.y + speed;
                _sf.rotation = _sf.rotation + Math.random() * 20;
                _sf.x = _sf.x + Math.random() * 2 * lf;
                return;
            } 
            ;
            var scale:* = Math.random() * 0.6;
            _sf = new snowflake();
            _sf.x = Math.random() * 1005;
            _sf.scaleX = scale;
            _sf.scaleY = scale;
            speed = Math.random() * 2;
            var RA:* = new Array(-1, 1);
            lf = RA[Math.round(Math.random())];
            stage.addChild(_sf);
            _sf.addEventListener(Event.ENTER_FRAME, snowfall);
            return;
        } 

        function frame1()
        {
            stop();
            this.present.addEventListener(MouseEvent.CLICK, this.loadImages);
            this.createRectangles();
            this.listeners();
            this.my_slideshow = new Sprite();
            this.my_image_slides = new Sprite();
            this.my_loaders_array = [];
            this.my_labels_array = [];
            this.my_success_counter = 0;
            this.my_playback_counter = 0;
            this.my_total = 0;
            this.my_tweens_array = [];
            this.my_slideshow.addChild(this.my_image_slides);
            addEventListener(Event.ENTER_FRAME, this.snow);
            return;
        } 

    }
}
