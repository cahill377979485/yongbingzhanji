#Include Base.ahk

getWidthAndHeight(){
	IniRead, mWidth, %A_ScriptDir%\set.ini, Width, Width  ;读取ini中的数据
	IniRead, mHeight, %A_ScriptDir%\set.ini, Height, Height
	IniRead, XX, %A_ScriptDir%\set.ini, PositionX, pX
	IniRead, YY, %A_ScriptDir%\set.ini, PositionY, pY
}

showtip(tip){
	if debug{
		tooltip %tip% ,0,0
		sleep %debugSleep%
	}
}

getShenmixuanxiang(){
	ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *80 %A_ScriptDir%\shenmixuanxiang.png
	if (ErrorLevel = 2){
		Tooltip no pic named shenmixuanxiang ,0,0
	}else if (ErrorLevel = 1){
		if(debug){
			ToolTip 没找到神秘选项,0,0
		}
	}else{
		targetX=%FoundX%
		addLog("神秘选项在" . targetX)
		ToolTip 神秘选项在 %targetX% ,0,0
		;找到神秘选项之后，如果位置太靠底部，则用滚轮调整一下
		updateFoundY:=False
		if(FoundY>505){
			send {WheelDown}
			sleep 1000
			ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *80 %A_ScriptDir%\shenmixuanxiang.png
			if (ErrorLevel = 2){
				Tooltip no pic named shenmixuanxiang ,0,0
			}else if (ErrorLevel = 1){
				if(debug){
					ToolTip 没找到神秘选项,0,0
				}
			}else{
				;此处是为了滚轮动作之后更新FoundY的值
				updateFoundY:=True
			}
		}else{
			updateFoundY:=True
		}
		if(updateFoundY=True){ ; 283 427
			PixelSearch x, y, FoundX-40, FoundY+146, FoundX+85, FoundY+146, 0x6B4529, 10, RGB
			MouseMove %x%, %y%
			if(x>FoundX){
				toLeft:=True
				addLog("从右边走")
			}
		}
		return 1
	}
	return 0
}


getYizhe(){
	ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *80 %A_ScriptDir%\linghunyizhe.png
	if (ErrorLevel = 2){
		Tooltip no pic named linghunyizhe ,0,0
	}else if (ErrorLevel = 1){
		if(debug){
			ToolTip 没找到医者,0,0
		}
	}else{
		targetX=%FoundX%
		ToolTip 医者在 %targetX% ,0,0
		return 1
	}
	return 0
}

getCifulanse(){
	ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *80 %A_ScriptDir%\cifulanse.png
	if (ErrorLevel = 2){
		Tooltip no pic named cifulanse ,0,0
	}else if (ErrorLevel = 1){
		if(debug){
			ToolTip 没找到施法者赐福,0,0
		}
	}else{
		targetX=%FoundX%
		ToolTip 施法者赐福在 %targetX% ,0,0
		return 1
	}
	return 0
}

getCifuhongse(){
	ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *80 %A_ScriptDir%\cifuhongse.png
	if (ErrorLevel = 2){
		Tooltip no pic named cifuhongse ,0,0
	}else if (ErrorLevel = 1){
		if(debug){
			ToolTip 没找到护卫赐福,0,0
		}
	}else{
		targetX=%FoundX%
		ToolTip 护卫赐福在 %targetX% ,0,0
		return 1
	}
	return 0
}

getCifulvse(){
	ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *80 %A_ScriptDir%\cifulvse.png
	if (ErrorLevel = 2){
		Tooltip no pic named cifulvse ,0,0
	}else if (ErrorLevel = 1){
		if(debug){
			ToolTip 没找到斗士赐福,0,0
		}
	}else{
		targetX=%FoundX%
		ToolTip 斗士赐福在 %targetX% ,0,0
		return 1
	}
	return 0
}

isRed(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isRed? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(r*2/3>g+b){  ;940
		return True
	}
	return False
}

isGreen(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isGreen? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(g*2/3>r+b){
		return True
	}
	return False
}

isBlue(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isBlue? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(b*2/3>r+g){
		return True
	}
	return False
}

isBrown(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isBrown? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	;765,
	if(Abs(r-g)<=2 && Abs(g-b)<=2 && Abs(b-r)<=2){
		return True
	}
	return False
}

isBlack(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isBlack? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(r<=4 && g<=4 && b<=5 && Abs(r-g)<=2){
		return True
	}
	return False
}

isWhite(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isWhite? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(r>=10 && g>=10 && b>=10){
		return True
	}
	return False
}

isBtnYellow(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isBtnYellow? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(r>=6 && g>=5 && Abs(r-g)<=5 && b<=3){
		return True
	}
	return False
}

isBtnGreen(x,y){
	PixelGetColor, color, x, y, RGB
	str=%color%+""
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	if(debug){
		ToolTip isBtnGreen? x%x% y%y% str=%color% r=%r% g=%g% b=%b% ,0,0
		MouseMove x,y,2
		sleep %debugSleep%
	}
	if(g>r && g>b && g>=7 && r<=4 && b<=3){    ; 3 10 1; 2 7 0
		return True
	}
	return False
}

getColorFirstNum(str){
	;ToolTip str=%str%,0,0
	;sleep %debugSleep%
	if(str="0"){
		return 0
	}else if(str="1"){
		return 1
	}else if(str="2"){
		return 2
	}else if(str="3"){
		return 3
	}else if(str="4"){
		return 4
	}else if(str="5"){
		return 5
	}else if(str="6"){
		return 6
	}else if(str="7"){
		return 7
	}else if(str="8"){
		return 8
	}else if(str="9"){
		return 9
	}else if(str="A"){
		return 10
	}else if(str="B"){
		return 11
	}else if(str="C"){
		return 12
	}else if(str="D"){
		return 13
	}else if(str="E"){
		return 14
	}else if(str="F"){
		return 15
	}
	return 0
}

capture(){
	MouseMove, 999,687
	ToolTip,
	FindText().SavePic("C:\Users\Administrator\Desktop\1.png", 0, 0, mWidth, mHeight, 1)
	GuiControl,, pic, C:\Users\Administrator\Desktop\1.png
	addLog("更新截图")
	singleClick(999,687)
}

handleRoutine(){
	;初始化所有的可能出现的组合，用数组装着
	ArrayCount := 0
	Array := Object()
	Loop, Read, %A_ScriptDir%\list.txt
	{
		ArrayCount += 1
		Array%ArrayCount% := A_LoopReadLine
	}
	;Tooltip 找图中……共%ArrayCount%张 ,0,0
	loop %ArrayCount%
	{
		element := Array%A_Index%
		ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *20 %A_ScriptDir%\%element%.png
		if (ErrorLevel = 2){
			Tooltip no pic named %element% ,0,0
		}else if (ErrorLevel = 1){
			continue
		}else{
			Tooltip click %element% ,0,0
			;randomSleep(100)
			randomClick(FoundX, FoundY)
			randomSleep(1500)
		}
	}
}

findFlashLight(pic, isJustFind=0){
	ImageSearch, FoundX, FoundY, 120, 288, 880, 310, *30 %A_ScriptDir%\%pic%.png
	if (ErrorLevel = 2){
		Tooltip no pic named %pic% ,0,0
	}else if (ErrorLevel = 1){
		;ToolTip find no %pic% ,0,0
		return 0
	}else{
		;ToolTip 找到高光%pic% ,0,0
		;sleep %debugSleep%
		if(isJustFind=0){
			lastTargetX=%FoundX%
			;lastTargetY=%FoundY%
			singleClick(FoundX,FoundY)
		}
		return 1
	}
	return 0
}

clickSkill(skills, skillRound, highlight){
	char:=SubStr(skills, skillRound, 1)
	ToolTip 出第%char%个技能 ,0,0
	pos:=0
	if(char="3"){
		pos:=2
	}else if(char="2"){
		pos:=1
	}
	startX:=385+pos*135
	click %startX%, 400
	sleep 100
	PixelGetColor, color, 30, 580, RGB
	rStr := SubStr(color, 3, 1)
	gStr := SubStr(color, 5, 1)
	bStr := SubStr(color, 7, 1)
	r := getColorFirstNum(rStr)
	g := getColorFirstNum(gStr)
	b := getColorFirstNum(bStr)
	MouseMove,10,580
	sleep 200
	PixelGetColor, color2, 30, 580, RGB
	rStr2 := SubStr(color2, 3, 1)
	gStr2 := SubStr(color2, 5, 1)
	bStr2 := SubStr(color2, 7, 1)
	r2 := getColorFirstNum(rStr2)
	g2 := getColorFirstNum(gStr2)
	b2 := getColorFirstNum(bStr2)
	if(Abs(r-r2)<=1 && Abs(g-g2)<=1 && Abs(b-b2)<=1){
		ToolTip 无箭头，技能应该放完了 ,0,0
	}else{
		showtip(%color%  %color2%)
		if(isLuoshuizhuiji && leftMiddleRight=1 && pos=2){    ;说明是位置右边的考内留斯的3技能
			ToolTip 选择重拳 ,0,0
			if(leftMiddleRight=1){
				singleClick(kaoneiliusiX-235, 540)
			}
		}else{
			ToolTip 选择攻击敌人 ,0,0
			if(findFlashLight(highlight)=0){
				;ToolTip 无高光，则点击%lastTargetX%，%lastTargetY% ,0,0
				;sleep %debugSleep%
				singleClick(lastTargetX,lastTargetY)
			}
		}
	}
	sleep 100
	MouseClick,right
	ToolTip,
}

setStatisticsText(text=""){
	GuiControl, , statistics, %text%
}

addLog(log=""){
	ToolTip %log% ,0,0
	GuiControlGet, logList
	timeNow = %A_Now%
	time := Mod(timeNow, 1000000)
	FormatTime formatTime, time, HH':'mm':'ss
	logList:= formatTime . " " . log . "`n" . logList
	GuiControl, , logList, %logList%
}

sleepWithProgress(millis=0){
	t:=Ceil(millis/100)
	GuiControl, , progress, 100
	loop %t%
	{
		sleep 100
		p:=A_Index/t*100
		if(p>100){
			p:=100
		}
		p:=100-p
		GuiControl, , progress, %p%
		if(p>=100){
			break
		}
	}
	GuiControl, , progress, 0
}

getScoreOfTreasure(treasure){
	score:=0
	if(InStr(treasure, "被动")>0)
		score:=score+2
	if(InStr(treasure, "后备")>0)
		score:=score+1
	if(InStr(treasure, "对战开始时")>0)
		score:=score+3
	if(InStr(treasure, "：")>0)
		score:=score+2
	if(InStr(treasure, "条鱼")>0)
		score:=score+5
	if(InStr(treasure, "刷新")>0)
		score:=score+1
	if(InStr(treasure, "加快")>0)
		score:=score+1
	if(InStr(treasure, "获得")>0)
		score:=score+1
	if(InStr(treasure, "和")>0)
		score:=score+1
	if(InStr(treasure, "所有")>0)
		score:=score+1
	if(InStr(treasure, "且")>0)
		score:=score+1
	if(InStr(treasure, "0/")>0)
		score:=score-3
	if(InStr(treasure, "角色")>0)
		score:=score+1
	if(InStr(treasure, "只会")>0)
		score:=score+1
	if(InStr(treasure, "/+")>0) ;加身材
		score:=score+1
	if(isFireTeam=True && InStr(treasure, "火焰伤害")>0 && InStr(treasure, "人类")>0)
		score:=score+8
	else if(isFireTeam=True && InStr(treasure, "火焰伤害")>0)
		score:=score+5
	else if(isFireTeam=True && InStr(treasure, "火焰")>0)
		score:=score+2
	return %score%
}

getEnemyNum(){
	;出场时识别范围165,250 ~ 850,388，战斗中为165,177 ~ 850， 310
	;出场时识别佣兵y坐标为315，战斗中为241
	addLog("识别对手佣兵")
	x:=520
	tempI:=0
	stepLong:=57
	findNum:=0
	firstX:=520
	; 判断佣兵是奇数还是偶数
	even:=True ;是否是偶数
	MouseMove, x, 270
	sleep 500
	findTwo:=0
	showRange(x-47-5, 177, 10, 388-177)
	ImageSearch, FoundX, FoundY, x-47-5, 177, x-47+5, 388, *20 %A_ScriptDir%\baisegaoguang.png
	if (ErrorLevel = 0){
		addLog("左边缘")
		findTwo+=1
	}
	showRange(x+47-5, 177, 10, 388-177)
	ImageSearch, FoundX, FoundY, x+47-5, 177, x+47+5, 388, *20 %A_ScriptDir%\baisegaoguang.png
	if (ErrorLevel = 0){
		addLog("右边缘")
		findTwo+=1
	}
	if(findTwo==2){
		even:=False
	}
	addLog("偶数？" . even)
	;判断有几个佣兵
	loop
	{	
		addLog("A_Index=" . A_Index)
		if(Mod(A_Index,2)=1){
			x:=firstX+stepLong*tempI
			tempI++
		}else{
			x:=firstX-stepLong*tempI
		}
		if(even){
			x+=60
		}
		if(x<165 || x>850){
			break
		}
		MouseMove, x, 270
		sleep 500
		findTwo:=0
		showRange(x-47-5, 177, 10, 388-177)
		ImageSearch, FoundX, FoundY, x-47-5, 177, x-47+5, 388, *80 %A_ScriptDir%\baisegaoguang.png
		if (ErrorLevel = 0){
			findTwo+=1
		}
		showRange(x+47-5, 177, 10, 388-177)
		ImageSearch, FoundX, FoundY, x+47-5, 177, x+47+5, 388, *80 %A_ScriptDir%\baisegaoguang.png
		if (ErrorLevel = 0){
			findTwo+=1
		}	
		if(findTwo==2){
			addLog("找到一个佣兵")
			findNum++
			stepLong:=114
		}else if(findNum>=1){ ;没找到佣兵
			break
		}
	}
	addLog("找到" . findNum . "个佣兵")
}
