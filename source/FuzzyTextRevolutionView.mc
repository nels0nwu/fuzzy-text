using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Time.Gregorian as Calendar;

class FuzzyTextRevolutionView extends WatchUi.WatchFace {
    var numericFont;
    var fuzzyTextFont;
    var iconFont;
    var screenShape;
    var inLowPower=false;
    var previousInLowPower=false;
    var canBurnIn=false;
    var upTop=true;

    function initialize() {
        WatchFace.initialize();
        
        var sSettings=System.getDeviceSettings();
        if(sSettings has :requiresBurnInProtection) {
            canBurnIn=sSettings.requiresBurnInProtection;           
        }      
    }


    var primaryColour;
    var secondaryColour;
    var tertiaryColour;
    var fuzzyTextFontOffset = -14;
    var fuzzyTextFontSize = 42;
    var previousDisplayMinute = -1;
    
    var textMinuteArray;
    var textHourArray;
    var textHourOverridesArray;
    
    // Load your resources here
    function onLayout(dc) {
        numericFont = WatchUi.loadResource(Rez.Fonts.id_font_roboto_numeric);
        iconFont = WatchUi.loadResource(Rez.Fonts.id_font_icons);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

	enum {
	    Yellow = 1,
	    Red,
	    DarkRed,
	    Orange,
	    Green,
	    DarkGreen,
	    Cyan,
	    Blue,
	    Purple,
	    Magenta
	}
	
	// Date formats
    enum {
        MonthDate = 1,
        DayDate
    }

    function loadSettings() {
        var colourScheme = Application.getApp().getProperty("ColourScheme");
        primaryColour = 0xFFFFFF;
        tertiaryColour = 0x555555;
        if (colourScheme == Yellow) {
            secondaryColour = 0xFFAA00;
        } else if (colourScheme == Red) {
            secondaryColour = 0xFF0000;
        } else if (colourScheme == DarkRed) {
            secondaryColour = 0xAA0000;
        } else if (colourScheme == Orange) {
            secondaryColour = 0xFF5500;
        } else if (colourScheme == Green) {
            secondaryColour = 0x00FF00;
        } else if (colourScheme == DarkGreen) {
            secondaryColour = 0x00AA00;
        } else if (colourScheme == Cyan) {
            secondaryColour = 0x00AAFF;
        } else if (colourScheme == Blue) {
            secondaryColour = 0x0000FF;
        } else if (colourScheme == Purple) {
            secondaryColour = 0xAA00FF;
        } else if (colourScheme == Magenta) {
            secondaryColour = 0xFF00FF;
        } else if (colourScheme == Green) {
            secondaryColour = 0xAAAAAA;
        }
        
        previousDisplayMinute = -1;
        
        if (WatchUi.loadResource(Rez.Strings.Language).equals("eng") || Application.getApp().getProperty("AlwaysEnglish")) {
            textMinuteArray = { 
                0 => "0 o'clock", 5 => "Five Past 0", 10 => "Ten Past 0", 15 => "Quarter Past 0", 20 => "Twenty Past 0", 25 => "0 Twenty Five", 
		        30 => "Half Past 0", 35 => "0 Thirty Five", 40 => "Twenty To 1", 45 => "Quarter To 1", 50 => "Ten To 1", 55 => "Five To 1"
		    };
		    textHourArray = ["Twelve", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven"];
		    textHourOverridesArray = ["", "", "", "", "", "", "", "", "", "", "", ""];
        } else {
	        textMinuteArray = {
		        0 => WatchUi.loadResource(Rez.Strings.TimeMinute0), 
		        5 => WatchUi.loadResource(Rez.Strings.TimeMinute5), 
		        10 => WatchUi.loadResource(Rez.Strings.TimeMinute10),
		        15 => WatchUi.loadResource(Rez.Strings.TimeMinute15),
		        20 => WatchUi.loadResource(Rez.Strings.TimeMinute20),
		        25 => WatchUi.loadResource(Rez.Strings.TimeMinute25),
		        30 => WatchUi.loadResource(Rez.Strings.TimeMinute30),
		        35 => WatchUi.loadResource(Rez.Strings.TimeMinute35),
		        40 => WatchUi.loadResource(Rez.Strings.TimeMinute40),
		        45 => WatchUi.loadResource(Rez.Strings.TimeMinute45),
		        50 => WatchUi.loadResource(Rez.Strings.TimeMinute50),
		        55 => WatchUi.loadResource(Rez.Strings.TimeMinute55)
		    };
		    textHourArray = [
		        WatchUi.loadResource(Rez.Strings.Hour0),
		        WatchUi.loadResource(Rez.Strings.Hour1),
		        WatchUi.loadResource(Rez.Strings.Hour2),
		        WatchUi.loadResource(Rez.Strings.Hour3),
		        WatchUi.loadResource(Rez.Strings.Hour4),
		        WatchUi.loadResource(Rez.Strings.Hour5),
		        WatchUi.loadResource(Rez.Strings.Hour6),
		        WatchUi.loadResource(Rez.Strings.Hour7),
		        WatchUi.loadResource(Rez.Strings.Hour8),
		        WatchUi.loadResource(Rez.Strings.Hour9),
		        WatchUi.loadResource(Rez.Strings.Hour10),
		        WatchUi.loadResource(Rez.Strings.Hour11)
		    ];
            textHourOverridesArray = [
                WatchUi.loadResource(Rez.Strings.Hour0Override),
                WatchUi.loadResource(Rez.Strings.Hour1Override),
                WatchUi.loadResource(Rez.Strings.Hour2Override),
                WatchUi.loadResource(Rez.Strings.Hour3Override),
                WatchUi.loadResource(Rez.Strings.Hour4Override),
                WatchUi.loadResource(Rez.Strings.Hour5Override),
                WatchUi.loadResource(Rez.Strings.Hour6Override),
                WatchUi.loadResource(Rez.Strings.Hour7Override),
                WatchUi.loadResource(Rez.Strings.Hour8Override),
                WatchUi.loadResource(Rez.Strings.Hour9Override),
                WatchUi.loadResource(Rez.Strings.Hour10Override),
                WatchUi.loadResource(Rez.Strings.Hour11Override)
            ];
	    }
    }

    // Update the view
    function onUpdate(dc) {    
        var width, height;
        var screenWidth = dc.getWidth();
        var clockTime = System.getClockTime();
        var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        
        width = dc.getWidth();
        height = dc.getHeight();
        
        var minimalism = inLowPower && canBurnIn;


        // Clear the screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
        
        
        var screenIsSquare = screenShape == System.SCREEN_SHAPE_RECTANGLE;
        var screenIsFlatTyre = screenShape == System.SCREEN_SHAPE_SEMI_ROUND;
        
        if (!minimalism) {
	        // Draw battery level
	        if (Application.getApp().getProperty("ShowBatteryLevel")) {
	            var batteryLevel = System.getSystemStats().battery / 100.0;
		        dc.setColor(secondaryColour, Graphics.COLOR_TRANSPARENT);
		        if (screenIsSquare) {
		            dc.drawLine(width-1, height-1, width-1, height*(1-batteryLevel));
		            dc.drawLine(width-2, height-1, width-2, height*(1-batteryLevel));
		        } else {
			        dc.drawArc(width/2, height/2, width/2, Graphics.ARC_CLOCKWISE, 90, 90-batteryLevel*360);
			        dc.drawArc(width/2, height/2, width/2-1, Graphics.ARC_CLOCKWISE, 90, 90-batteryLevel*360);
		        }
	        }
	        
	        // Draw step goal
	        if (Application.getApp().getProperty("ShowStepGoalProgress")) {
		        var stepGoalProgress = ActivityMonitor.getInfo().steps.toDouble() / ActivityMonitor.getInfo().stepGoal;
		        dc.setColor(primaryColour, Graphics.COLOR_TRANSPARENT);
		        if (screenIsSquare) {
		            dc.drawLine(0, height-1, width*stepGoalProgress, height-1);
		            dc.drawLine(0, height-2, width*stepGoalProgress, height-2);
		        } else {
			        dc.drawArc(width/2, height/2, width/2-5, Graphics.ARC_CLOCKWISE, 90, 90-stepGoalProgress*360);
			        dc.drawArc(width/2, height/2, width/2-6, Graphics.ARC_CLOCKWISE, 90, 90-stepGoalProgress*360);
		        }
	        }
	        
	        // Exact Time
	        if (Application.getApp().getProperty("ShowNumericTime")) {
	            drawNumericTime(dc, width, height, clockTime);
	        }
        }        
        
        // Fuzzy Time
        drawFuzzyText(dc, width, height, clockTime);

        if (!minimalism) {
	        // Draw date
	        if (Application.getApp().getProperty("ShowDate")) {
		        var dateString = "";
		        var dateFormat = Application.getApp().getProperty("DateFormat");
		        
		        if (dateFormat == MonthDate) {
		           dateString = Lang.format(WatchUi.loadResource(Rez.Strings.MonthDateFormat), [info.month, info.day]);
		        } else if (dateFormat == DayDate) {
		           dateString = Lang.format(WatchUi.loadResource(Rez.Strings.DayDateFormat), [info.day_of_week, info.day]);
		        }
		        
	            dc.setColor(primaryColour, Graphics.COLOR_TRANSPARENT);
	            
	            var dateFontHeight = Graphics.getFontHeight(Graphics.FONT_SMALL);
		        if (screenIsSquare) {
		            dc.drawText(width-6, height-dateFontHeight-1, Graphics.FONT_SMALL, dateString, Graphics.TEXT_JUSTIFY_RIGHT);
		        } else if (screenIsFlatTyre) {
		            dc.drawText(width/2, height-dateFontHeight-1, Graphics.FONT_SMALL, dateString, Graphics.TEXT_JUSTIFY_CENTER);
		        } else { // round
		           dc.drawText(width/2, height-dateFontHeight-1-8, Graphics.FONT_SMALL, dateString, Graphics.TEXT_JUSTIFY_CENTER);
		        }
	        }
	        
	        var stats = System.getDeviceSettings();
	        
	        if (Application.getApp().getProperty("ShowIcons")) {
		        var iconText = "";
		        if (stats.notificationCount > 0) {
		            iconText += "Â";
		        }
		        if (stats.phoneConnected) {
		            iconText += "V";
		        }
		        if (stats.alarmCount > 0) {
		            iconText += "R";
		        }
		                
		        dc.setColor(primaryColour, Graphics.COLOR_TRANSPARENT);
		        if (screenIsSquare) {
		            dc.drawText(width-2, 0, iconFont, iconText, Graphics.TEXT_JUSTIFY_RIGHT);
		        } else if (screenIsFlatTyre) {
		            dc.drawText(width/2, 1, iconFont, iconText, Graphics.TEXT_JUSTIFY_CENTER);
		        } else { // round
		           dc.drawText(width/2, 8, iconFont, iconText, Graphics.TEXT_JUSTIFY_CENTER);
		        }
	        }
        }
    }
    
    function splitTimeText(s) {
        if (s.find("|") != null) {
            return split(s, "|");
        } else {
           return split(s, " ");
        }
    }
    
    function split(s, sep) {
	    var tokens = [];
	
	    var found = s.find(sep);
	    while (found != null) {
	        var token = s.substring(0, found);
	        tokens.add(token);
	
	        s = s.substring(found + sep.length(), s.length());
	
	        found = s.find(sep);
	    }
	
	    tokens.add(s);
	
	    return tokens;
	}
    
    class FuzzyComponent
	{
	   var text;
	   var isHour;
	   
	   function initialize(text, isHour) {
	       self.text = text;
	       self.isHour = isHour;
	   }
	}
    
    // Returns fuzzy text split up in lines
    function getFuzzyText(displayHour, displayMinute) {
        var unsplit = textMinuteArray[displayMinute];
        if (displayMinute == 0) {
            var override = textHourOverridesArray[displayHour%12];
            if (!override.equals("")) {
                unsplit = override;
            }
        }
        
        var textDisplayArray = splitTimeText(unsplit);
        for(var i = 0; i < textDisplayArray.size(); i++)
        {
            var text;
            var n = textDisplayArray[i].toNumber();
            if (n != null) { // hour text
                textDisplayArray[i] = new FuzzyComponent(textHourArray[(displayHour+n)%12].toLower(), true);
            } else {
                if (textDisplayArray[i].substring(0, 1).equals("*")) { // asterisk in override means treat it like hour text
                    textDisplayArray[i] = new FuzzyComponent(textDisplayArray[i].toLower().substring(1, textDisplayArray[i].length()), true);
                } else {
                    textDisplayArray[i] = new FuzzyComponent(textDisplayArray[i].toLower(), false);
                }
            }
        }
        
        return textDisplayArray;
    }

    
    function setFuzzyFontSize(dc, displayHour, displayMinute) {
        var mySettings = System.getDeviceSettings();
        screenShape = mySettings.screenShape;
        var screenIsSquare = screenShape == System.SCREEN_SHAPE_RECTANGLE;
        var useSmallerFont = Application.getApp().getProperty("SmallerFont");
        
        var maxWidthScreen = dc.getWidth();
        if (inLowPower && canBurnIn) {
            maxWidthScreen = maxWidthScreen * .6;
        }
        else if (useSmallerFont) {
            maxWidthScreen = maxWidthScreen * .75;
        }
        
        var fontCollection = [Rez.Fonts.id_font_roboto_text_140, Rez.Fonts.id_font_roboto_text_116, Rez.Fonts.id_font_roboto_text_76, Rez.Fonts.id_font_roboto_text_64, Rez.Fonts.id_font_roboto_text_56, Rez.Fonts.id_font_roboto_text_48];
        for (var f = 0; f < fontCollection.size(); f++) {
            fuzzyTextFont = WatchUi.loadResource(fontCollection[f]);
            var fontHeight = dc.getFontHeight(fuzzyTextFont);
            fuzzyTextFontSize = fontHeight / 1.85;
            
            var textDisplayArray = getFuzzyText(displayHour, displayMinute);
            var lines = textDisplayArray.size();
            var totalTextWidth;
            var fontTooLarge = false;
            var circleMargin = 5;
             
            for(var i = 0; i < lines; i++)
            {
                var ylines = ((i-1) + (1.5-0.5*lines));
                ylines += ylines > 0 ? .5 : -.5; 
                var y = ylines*fuzzyTextFontSize;
                var widthAtY = maxWidthScreen;
                if (!screenIsSquare) { 
                    var squaredDifferences = Math.pow(maxWidthScreen/2-circleMargin, 2) - Math.pow(y, 2);
                    if (squaredDifferences < 0) {
                        widthAtY = 0;
                    }  else {
                        widthAtY = Math.sqrt(squaredDifferences) * 2;
                    }
                }
                
                var text = textDisplayArray[i].text;
                
                // pad text to 6 characters so font size never gets unexpectly huge.
                while (text.length() < 6) {
                    text += "o";
                }
                
                // calculate width of text
                var textSpacingAdj = -2;
                totalTextWidth = 0;
                for (var j = 0; j < text.length(); j++ ) {
                    var char = text.substring(j,j+1);
                    var charWidth = dc.getTextWidthInPixels(char, fuzzyTextFont);
                    totalTextWidth += charWidth;
                    if (j < text.length()-1) {
                        totalTextWidth += textSpacingAdj;
                    }
                }
                
                if (totalTextWidth > widthAtY) {
                    fontTooLarge = true;
                    break;
                } else if (y.abs()*2 > dc.getHeight()) {
                    fontTooLarge = true;
                    break;
                }
            }
            
            if (!fontTooLarge) { // correct size!
                break;
            }
        }


    }
    
    function drawFuzzyText(dc, width, height, clockTime) {
        var displayHour = clockTime.hour;
        var displayMinute = ((clockTime.min + clockTime.sec/60.0)/5.0 + .5).toNumber() * 5; // round to the nearest 5 min
        if (displayMinute == 60) {
            displayMinute = 0;
            displayHour++;
        }
        var fuzzyTimeUpdate = displayMinute != previousDisplayMinute || previousInLowPower != inLowPower;
        previousDisplayMinute = displayMinute;
        previousInLowPower = inLowPower;
        if (fuzzyTimeUpdate) {
            setFuzzyFontSize(dc, displayHour, displayMinute);
        }
        
        var yOffset = 0;
        if (inLowPower && canBurnIn) {
            upTop = !upTop;
            yOffset=(upTop) ? -height/5 : height/5;
        }
        
        var textDisplayArray = getFuzzyText(displayHour, displayMinute);
        var lines = textDisplayArray.size(); 
        for(var i = 0; i < lines; i++)
        {
            var y = yOffset + height/2 + ((i-2) + (1.5-0.5*lines))*fuzzyTextFontSize;
            var text;
            
            var fuzzyComponent = textDisplayArray[i];
            if (fuzzyComponent.isHour) { // hour text
                dc.setColor(primaryColour, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(secondaryColour, Graphics.COLOR_TRANSPARENT);
            }
            text = fuzzyComponent.text;
            
            // calculate width of text
            var textSpacingAdj = -2;
            
            var totalTextWidth = 0;
            for (var j = 0; j < text.length(); j++ ) {
                var char = text.substring(j, j+1);
                var charWidth = dc.getTextWidthInPixels(char, fuzzyTextFont);
                totalTextWidth += charWidth;
                if (j < text.length()-1) {
                    totalTextWidth += textSpacingAdj;
                }
            }
            
            var x = 0;
            if (screenShape != System.SCREEN_SHAPE_RECTANGLE) { // For round watches, centre the text
                x = width/2-totalTextWidth/2;
            }
            for( var j = 0; j < text.length(); j++ ) {
                var char = text.substring(j,j+1);
                dc.drawText(x, y, fuzzyTextFont, char, Graphics.TEXT_JUSTIFY_LEFT);
                
                var charWidth = dc.getTextWidthInPixels(char, fuzzyTextFont);
                x += charWidth+textSpacingAdj;
            }
        }
    }
    
    var numericTimeOffset = -56;
    function drawNumericTime(dc, width, height, clockTime) {
        var timeStr = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min]);
        
        dc.setColor(tertiaryColour, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2-2, height/2 + numericTimeOffset, numericFont, clockTime.hour.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(width/2, height/2 + numericTimeOffset, numericFont, ":", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width/2+2, height/2 + numericTimeOffset, numericFont, clockTime.min.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        inLowPower=false;
        WatchUi.requestUpdate(); 
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        inLowPower=true;
        WatchUi.requestUpdate(); 
    }

}
