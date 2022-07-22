#Include PaddleOCR\PaddleOCR.ahk
#Include FindText.ahk

findOnce(pic, isJustFind=1, px=0, py=0){
	return findPic(pic, isJustFind, px, py)
}

findUntilGet(pic, waitTime=0, isJustFind=0, px=0, py=0){
	startTime := A_TickCount
	loop{
		sleep 100
		if(findPic(pic, isJustFind, px, py)=1){
			return 1
		}
		if(waitTime>0){
			pastTime:=A_TickCount - startTime
			if(pastTime>waitTime){
				return 0
			}
		}
	}
}

findUntilLose(pic, waitTime=0, isJustFind=0, px=0, py=0){
	startTime := A_TickCount
	loop{
		if(findPic(pic, isJustFind, px, py)=0){
			return 1
		}
		if(waitTime>0){
			pastTime:=A_TickCount - startTime
			if(pastTime>waitTime){
				return 0
			}
		}
	}
}

findAndClick(pic, waitTime=0, px=0, py=0){
	return findUntilGet(pic, waitTime, 0, px, py)
}

findAndClickWithCheck(pic, target, waitTime=0, px=0, py=0){
	startTime := A_TickCount
	loop{
		if(findPic(pic, 0, px, py)=1){
			sleep 1000
		}
		;检查是否跳往目标页面
		if(findPic(target, 1)=1){
			return 1
		}
		;如果超出一段时间仍然没有找到目标图片，则跳出
		if(waitTime>0){  
			pastTime:=A_TickCount - startTime
			if(pastTime>waitTime){
				break
			}
		}else{
			break
		}
	}
	sleep 200
	return 0
}

findPic(pic, isJustFind=0, px=0, py=0){
	;FindText().ImageSearch(FoundX, FoundY, 0, 0, mWidth, mHeight, %A_ScriptDir%\%pic%.png)
	ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *20 %A_ScriptDir%\%pic%.png
	if (ErrorLevel = 2){
		Tooltip no pic named %pic% ,0,0
	}else if (ErrorLevel = 1){
		if(debug){
			ToolTip find no %pic% ,0,0
		}
		return 0
	}else{
		if(debug){
			ToolTip find %pic% ,0,0
		}
		sleep 500
		if(isJustFind=0){
			singleClick(FoundX+px,FoundY+py)
		}
		return 1
	}
	return 0
}

;+++++++++++++++++++++++++++最基础方法++++++++++++++++++++++++++++++++

tip(str){
	tipWithTime(str, 1000)
}

tipWithTime(str, time){
	ToolTip %str% ,0,0
	sleep %time%
	ToolTip
}

clickSpace(){
	sleep 1000
	singleClick(45, 975)
}

clickChanYe(){
	sleep 500
	singleClick(45, 975)
}

clickClose(){
	findAndClick("close", 1000)
}

closeAll(){
	loop 5{
		ImageSearch, FoundX, FoundY, 0, 0, mWidth, mHeight, *20 %A_ScriptDir%\zhujiemianchanye.png
		if (ErrorLevel = 2){
			Tooltip no pic named zhujiemianchanye ,0,0
		}else if (ErrorLevel = 1){
			clickClose()
		}else{
			clickChanYe()
			break
		}
	}
}

saveMousePos(){
	global OX
	global OY
	MouseGetPos, OX, OY
}

resetMousePos(){
	MouseMove OX, OY,2
}

singleClick(X, Y){
	;MouseGetPos, OX, OY
	;tooltip 移动鼠标到 %X% %Y% ,0,0
	; BlockInput, MouseMove
	MouseMove, X, Y, 8
	sleep 100
	click
	sleep 100
	; BlockInput, MouseMoveOff
	;MouseMove, OX, OY, 5
}

randomSleep(time){
	Random, random, 300, %time%
	;ToolTip random sleep %random% ,0,0
	sleep %random%
}

randomClick(X, Y){
	Random, random, 1, 3
	X:=X+random
	Random, random2, 1, 3
	Y:=Y+random2
	;ToolTip random click %random% %random2% ,0,0
	singleClick(X, Y)
}

findWord(startX=0, startY=0, width=1024, height=768){
	timeStart := Mod(A_Now, 1000000)
	showRange(startX, startY, width, height)
	result := PaddleOCR([startX, startY, width, height])
	timeFinish := Mod(A_Now, 1000000)
	timeHost := timeFinish-timeStart
	if(debug){
		ToolTip 找文字消耗%timeFinish%-%timeStart% =%timeHost%秒 文字为%result% ,0,0
		sleep 2000
	}
	return %result%
}

hasWord(target="", startX=0, startY=0, width=1024, height=768){
	result:=findWord(startX, startY, width, height)
	return hasWordInResult(target, result)
}

hasWordInResult(target="", result=""){
	IfInString,result,%target%
	{
		if(debug){
			ToolTip 包含文字 `n %result% `n %target% ,0,0
			sleep 1000
		}
		return True
	}else{
		if(debug){
			ToolTip 不包含文字 `n %result% `n %target% ,0,0
			sleep 1000
		}
	}
	return False
}

showRange(x,y,width,height){
	if(showRangeSwitch==True){
		Loop 2
		{
			FindText().RangeTip(x,y,width,height, (A_Index & 1 ? "Red":"Blue"), 4)
			;在找到图像的边缘显示一个矩形框，边框颜色在红色和蓝色间每半秒切换一次。
			Sleep, 300
		}
		FindText().RangeTip(0,0,0,0)
	}
}