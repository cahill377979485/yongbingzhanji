;我的电脑的分辨率是2560*1440（2k)。炉石传说设置是：1024*768窗口模式，画质和帧率都是高。非全屏。
;开发日志：20220511v1.0构建版
;20220716：1、各身份的出招顺序由UI进行设置。2、截屏可显示神秘选项或者营火。
#NoEnv
#SingleInstance
#Include Util.ahk
#Include PaddleOCR\PaddleOCR.ahk
SetBatchLines,-1
SetWinDelay,2000
ListLines Off
CoordMode, Mouse, Window
CoordMode, Tooltip, Screen
global debug:=False
global showRangeSwitch:=True
global mWidth:=1040
global mHeight:=806
global cCount  ;当前通关次数
global mCount  ;历史通关次数
global targetX:=375  ;神秘选项或者赐福医者的横坐标
global bossName:="群龟之王"
;下面三行是普通队的出招
global skills1="1111"  ;蓝色
global skills2="1111"  ;红色
global skills3="1111"  ;绿色
;下面是火焰队的出招
global skillsFireBlue="22"
global skillsFireRed="22"
global skillsFireGreen="11"
;下面三行是落水追击队的出招
global skillsZhongquan="23"
global skillsLuokala="12"
global skillsKaoneiliusi="13"
global skills4="1"
global skillLen1:=StrLen(skills1)
global skillLen2:=StrLen(skills2)
global skillLen3:=StrLen(skills3)
global skillLen4:=StrLen(skills4)
global skillLenFireBlue:=StrLen(skillsFireBlue)
global skillLenFireRed:=StrLen(skillsFireRed)
global skillLenFireGreen:=StrLen(skillsFireGreen)
global skillLenZhongquan:=StrLen(skillsZhongquan)
global skillLenLuokala:=StrLen(skillsLuokala)
global skillLenKaoneiliusi:=StrLen(skillsKaoneiliusi)
global skillRound1:=1
global skillRound2:=1
global skillRound3:=1
global skillRound4:=1
global WinXOffset:=0 ;-7
global WinYOffset:=0 ;-25
global lastTargetX:=540
global lastTargetY:=238
global btnX:=954
global btnY:=390
global skillBorderX:=450    ;306343
global skillBorderY:=456   ;373447 
global skillBgX:=450
global skillBgY:=420
global debugSleep:=1000
global startBtnX:=840
global startBtnY:=675
global startBtnX2:=970
global startBtnY2:=631
global leftMiddleRight:=1
global kaoneiliusiX
global isFireTeam:=False
global toLeft:=False
global manual:=False
global manualBoss:=False
global edge:=2
global setWindowWidth:=520
global setWindowHeight:=240

Gui, -Caption +ToolWindow -SysMenu +HwndMoveGuiHwnd  ;+AlwaysOnTop
Gui Font, s9, Segoe UI
buttonX:=mWidth+edge
editY:=mHeight-30
editH:=400
progressY:=editY+editH
progressH:=5
lineHeight:=25
widgetWidth:=100
widgetHeight:=lineHeight
startY:=lineHeight*0+edge
offsetY:=-30
halfButtonWidth:=widgetWidth/2
halfButtonX:=buttonX+halfButtonWidth+edge
Gui Add, Button, x%buttonX% y%startY% w%halfButtonWidth% h%widgetHeight%, 隐藏F8
Gui Add, Button, x%halfButtonX% y%startY% w%halfButtonWidth% h%widgetHeight%, 关闭
startY:=startY+lineHeight*2+edge
Gui Add, DropDownList, x%buttonX% y%startY% w%widgetWidth% vteam, 普通队伍||落水追击|火焰队
startY:=startY+lineHeight+edge
Gui Add, Button, x%buttonX% y%startY% w%widgetWidth% h%widgetHeight%, 设置出招顺序
startY:=startY+lineHeight*2+edge
Gui Add, CheckBox, x%buttonX% y%startY% h%widgetHeight% vdebugSet, 调试
startY:=startY+lineHeight+edge
Gui Add, CheckBox, x%buttonX% y%startY% h%widgetHeight% vmanualSet, 手动出招
startY:=startY+lineHeight+edge
Gui Add, CheckBox, x%buttonX% y%startY% h%widgetHeight% vmanualBossSet, 手动打首领


startY:=lineHeight*10+edge
Gui Add, Button, x%buttonX% y%startY% w%widgetWidth% h%widgetHeight%, 重新开始F6
startY:=lineHeight*11+edge
Gui Add, Text, x%buttonX% y%startY% w%widgetWidth% h%widgetHeight% +0x200 vstatistics, 首领通关统计
Gui Add, Edit, x0 y%editY% w%mWidth% h%editH% vlogList, 日志
Gui Add, Progress, x0 y%progressY% w%mWidth% h%progressH% vprogress, 100
Gui Add, Picture, x0 y%offsetY% w%mWidth% h%mHeight% vpic, C:\Users\Administrator\Desktop\1.png
tempY=%mHeight%
guiY:=30
tempY:=mHeight+editH+progressH-guiY
tempW:=mWidth+100+edge+edge
Gui Show, x0 y%guiY% w%tempW% h%tempY%
; Generated using SmartGUI Creator 4.0
;界面初始化

cCount:=0
IniRead, mCount, %A_ScriptDir%\set.ini , 统计, 已通关
if(mCount/1!=mCount){
	mCount:=0
}
setStatisticsText("已/总：" . cCount . "/" . mCount)
IniRead, debugMode, %A_ScriptDir%\set.ini , 设置, 调试
if(debugMode/1!=debugMode){
	debugMode:=0
}
if(debugMode=1){
	debug:=True	
}else{
	debug:=False
}
GuiControl,, debugSet, %debugMode%
IniRead, manualMode, %A_ScriptDir%\set.ini , 设置, 手动出招
if(manualMode/1!=manualMode){
	manualMode:=0
}
if(manualMode=1){
	manual:=True	
}else{
	manual:=False
}
GuiControl,, manualSet, %manualMode%
IniRead, manualBossMode, %A_ScriptDir%\set.ini , 设置, 手动打首领
if(manualBossMode/1!=manualBossMode){
	manualBossMode:=0
}
GuiControl,, manualBossSet, %manualBossMode%
IniRead, team, %A_ScriptDir%\set.ini , 设置, 队伍 
if(team=""){
	team:="普通队伍"
}else if(team="火焰队"){
	isFireTeam:=True
}
GuiControl, ChooseString, team, %team%
;普通队初始化
skills1=%skills1%%skills1%%skills1%321
skills2=%skills2%%skills2%%skills2%321
skills3=%skills3%%skills3%%skills3%321
skillLen1:=StrLen(skills1)
skillLen2:=StrLen(skills2)
skillLen3:=StrLen(skills3)
;火焰队初始化
skillsFireBlue=%skillsFireBlue%%skillsFireBlue%%skillsFireBlue%321
skillsFireRed=%skillsFireRed%%skillsFireRed%%skillsFireRed%321
skillsFireGreen=%skillsFireGreen%%skillsFireGreen%%skillsFireGreen%321
skillLenFireBlue:=StrLen(skillsFireBlue)
skillLenFireRed:=StrLen(skillsFireRed)
skillLenFireGreen:=StrLen(skillsFireGreen)
; WinSet, AlwaysOnTop, On, ahk_exe Hearthstone.exe ;方便调试，不要开启
;主程序
loop
{	
	;登录战网
	ifWinNotExist,ahk_exe Battle.net.exe
	{
		addLog("登录战网")
		Run D:\MyGames\hs\Battle\Battle.net\Battle.net Launcher.exe
		ToolTip 打开战网中 ,0,0
		sleepWithProgress(10000)
	}
	;断网、网络掉线
	ifWinExist,ahk_exe Hearthstone.exe  ;检测炉石传说窗口是否存在
	{			
		ifWinActive,ahk_exe Hearthstone.exe  ;检测炉石传说窗口是否激活
		{
			WinGetPos, X, Y, Width, Height, ahk_exe Hearthstone.exe	;判断窗口是否改变
			if(mWidth<>Width || mHeight<>Height || X<>WinXOffset || Y<>WinYOffset){
				addLog("重置窗口属性")
				WinMove,ahk_exe Hearthstone.exe,,%WinXOffset%,%WinYOffset%,%mWidth%,%mHeight%
			}
			ToolTip 运行中 ,0,0
			;选择首领
			if(findPic("xuanshang",1)=1){
				addLog("选择首领")
				singleClick(startBtnX2,startBtnY2)
				findUntilGet("xuanzeduiwu", 5000, 1)
			}
			;选择队伍
			if(findPic("xuanzeduiwu",1)=1){
				addLog("选择队伍")
				sleepWithProgress(2000)
				singleClick(startBtnX,startBtnY)
				sleep 1000
				findPic("tongyongquerenanniu")
				sleepWithProgress(5000)
				if(findUntilGet("xuanguanyemian",15000,1)){
					sleepWithProgress(3000)
				}
				singleClick(776,380)
				targetX:=375
				toLeft:=False
				if(getShenmixuanxiang()=0){
					singleClick(776,530)
					if(getShenmixuanxiang()=0){
						singleClick(776,230)
						getShenmixuanxiang()
					}
				}
				if(manualBossMode=1 && manualBoss=True){
					manualBoss:=False
				}
				capture()
				findUntilGet("xuanguanyemian", 5000, 1)
			}
			;爬楼选关
			if(findPic("xuanguanyemian",1)=1){
				;点已完成任务
				if(findPic("renwu")=1){
					addLog("已完成任务")
					sleepWithProgress(8000)
				}
				if(targetX=375){
					ToolTip 爬楼选关 未找到神秘选项 ,0,0
					getShenmixuanxiang()
				}else{
					ToolTip 爬楼选关 神秘选项在 %targetX% ,0,0
				}
				;点神秘选项
				ImageSearch, FoundX, FoundY, 0, 0, 707, 678, *60 %A_ScriptDir%\shenmixuanxiangjinse.png
				if (ErrorLevel = 0){
					singleClick(FoundX,FoundY)
				}
				;循环找神秘选项周围的关卡
				if(findPic("kaishianniubukedianji",1)=1){
					tempTargetX:=targetX
					if(toLeft){
						tempTargetX+=50
					}else {
						tempTargetX-=1
					}
					tempX:=tempTargetX
					tempI:=0
					loop 12
					{	
						if(Mod(A_Index,2)=1){
							tempX:=tempTargetX+60*tempI
							tempI++
						}else{
							tempX:=tempTargetX-60*tempI
						}
						if(tempX<30 || tempX>720){
							continue
						}
						singleClick(tempX,384)
						if(findPic("kaishianniubukedianji",1)=0){
							findUntilLose("kaishitongyong",3000,1)
							break
						}
					}
					ret:=findWord(820,414,204,46)
					if(ret!=""){
						addLog("选择：" . ret)						
					}
					singleClick(startBtnX2,startBtnY2)
				}else{
					ret:=findWord(820,414,204,46)
					if(ret!=""){
						addLog("选择：" . ret)
						if(manualBossMode=1 && manualBoss=False){
							if(InStr(ret, bossName)>0){
								SoundPlay, %A_ScriptDir%\surprise.mp3
								manualBoss:=True
							}
						}
					}
					singleClick(startBtnX2,startBtnY2)
				}
				skillRound1:=1
				skillRound2:=1
				skillRound3:=1
				if(findUntilGet("kaishiyouxi", 3000, 1)=1){
					if(findUntilLose("kaishiyouxi", 15000, 1)=1){
						sleepWithProgress(5000)
					}
				}
			}
			;黄色按钮分为已登场黄色按钮和开战黄色按钮
			if(isBtnYellow(btnX,btnY)){
				ImageSearch, FoundX, FoundY, 290, 672, 753, mHeight, *20 %A_ScriptDir%\gaoguanglvse.png
				if (ErrorLevel = 0){
					addLog("出佣兵")
					singleClick(btnX, btnY)
					sleepWithProgress(9500)
				}else if(manual=False && manualBoss=False){
					addLog("出招")
					lastTargetX:=540
					lastTargetY:=238
					loop 8
					{
						BlockInput, MouseMove
						MouseMove btnX,btnY
						sleep 200
						;找开战绿色按钮，找到则点击退出出招流程
						if(isBtnGreen(btnX,btnY)){
							BlockInput, MouseMoveOff
							break
						}
						;没找到黄色按钮，说明已经不是出招阶段了
						if(isBtnYellow(btnX,btnY)=False){
							BlockInput, MouseMoveOff
							break
						}
						ImageSearch, FoundX, FoundY, 880, 340, mWidth, 430, *20 %A_ScriptDir%\anniubaisebianyuan.png
						if (ErrorLevel <> 0){
							addLog("没找到按钮白边" . A_Index)
							BlockInput, MouseMoveOff
							break
						}
						BlockInput, MouseMoveOff
						;找技能背景 450,456 往上找色差突变的点
						findSkillBg:=False
						searchY:=456
						loop 16
						{
							PixelGetColor, color, skillBorderX, searchY, RGB
							rStr := SubStr(color, 3, 1)
							gStr := SubStr(color, 5, 1)
							bStr := SubStr(color, 7, 1)
							r := getColorFirstNum(rStr)
							g := getColorFirstNum(gStr)
							b := getColorFirstNum(bStr)
							if(A_Index==1){
								r0 = %r%
								g0 = %g%
								b0 = %b%
							}else{
								if(Abs(r-r0)>=3 || Abs(g-g0)>=3 || Abs(b-b0)>=3){
									findSkillBg:=True
									skillBorderY:=searchY
									skillBgY:=skillBorderY-30
									break
								}
							}
							searchY--
						}
						if(team="落水追击"){
							ImageSearch, FoundX, FoundY, 130, 455, 890, 470, *60 %A_ScriptDir%\chuzhaozhuangtai.png
							if (ErrorLevel = 0){
								if(findSkillBg && isRed(skillBgX,skillBgY)){
									ToolTip 红色护卫出招 ,0,0
									if(FoundX<515){
										leftMiddleRight:=-1
										clickSkill(skillsZhongquan, skillRound1, "gaoguanglvse")
										skillRound1:=skillRound1+1
										if(skillRound1>skillLenZhongquan){
											skillRound1:=1
										}
									}else{
										leftMiddleRight:=1
										kaoneiliusiX=%FoundX%
										clickSkill(skillsKaoneiliusi, skillRound3, "gaoguanglvse")
										skillRound3:=skillRound3+1
										if(skillRound3>skillLenKaoneiliusi){
											skillRound3:=1
										}
									}
								}else if(findSkillBg && isGreen(skillBgX,skillBgY)){
									ToolTip 绿色斗士出招 ,0,0
									leftMiddleRight:=0
									clickSkill(skillsLuokala, skillRound2, "gaoguanglanse")
									skillRound2:=skillRound2+1
									if(skillRound2>skillLenLuokala){
										skillRound2:=1
									}
								}else if(findSkillBg && isBrown(skillBgX, skillBgY)){
									ToolTip 临时佣兵出招 ,0,0
									clickSkill(skills4, skillRound4, "gaoguanglanse") ;这里的高光没有用到
									skillRound4:=skillRound4+1
									if(skillRound4>skillLen4){
										skillRound4:=1
									}
								}
							}else if(isBtnGreen(btnX,btnY)=False){
								singleClick(540,540)
							}
						}else if (isFireTeam){
							if(findSkillBg && isBlue(skillBgX,skillBgY)){
								ToolTip 蓝色施法者出招 ,0,0
								clickSkill(skillsFireBlue, skillRound1, "gaoguanghongse")
								skillRound1:=skillRound1+1
								if(skillRound1>skillLenFireBlue){
									skillRound1:=1
								}
							}else if(findSkillBg && isRed(skillBgX,skillBgY)){
								ToolTip 红色护卫出招 ,0,0
								clickSkill(skillsFireRed, skillRound2, "gaoguanglvse")
								skillRound2:=skillRound2+1
								if(skillRound2>skillLenFireRed){
									skillRound2:=1
								}
							}else if(findSkillBg && isGreen(skillBgX,skillBgY)){
								ToolTip 绿色斗士出招 ,0,0
								clickSkill(skillsFireGreen, skillRound3, "gaoguanglanse")
								skillRound3:=skillRound3+1
								if(skillRound3>skillLenFireGreen){
									skillRound3:=1
								}
							}else if(findSkillBg && isBrown(skillBgX, skillBgY)){
								ToolTip 临时佣兵出招 ,0,0
								clickSkill(skills4, skillRound4, "gaoguanglanse") ;这里的高光没有用到
								skillRound4:=skillRound4+1
								if(skillRound4>skillLen4){
									skillRound4:=1
								}
							}else if(isBtnGreen(btnX,btnY)=False){
								singleClick(540,540)
							}
						}else{ ;普通队伍
							if(findSkillBg && isBlue(skillBgX,skillBgY)){
								ToolTip 蓝色施法者出招 ,0,0
								clickSkill(skills1, skillRound1, "gaoguanghongse")
								skillRound1:=skillRound1+1
								if(skillRound1>skillLen1){
									skillRound1:=1
								}
							}else if(findSkillBg && isRed(skillBgX,skillBgY)){
								ToolTip 红色护卫出招 ,0,0
								clickSkill(skills2, skillRound2, "gaoguanglvse")
								skillRound2:=skillRound2+1
								if(skillRound2>skillLen2){
									skillRound2:=1
								}
							}else if(findSkillBg && isGreen(skillBgX,skillBgY)){
								ToolTip 绿色斗士出招 ,0,0
								clickSkill(skills3, skillRound3, "gaoguanglanse")
								skillRound3:=skillRound3+1
								if(skillRound3>skillLen3){
									skillRound3:=1
								}
							}else if(findSkillBg && isBrown(skillBgX, skillBgY)){
								ToolTip 临时佣兵出招 ,0,0
								clickSkill(skills4, skillRound4, "gaoguanglanse") ;这里的高光没有用到
								skillRound4:=skillRound4+1
								if(skillRound4>skillLen4){
									skillRound4:=1
								}
							}else if(isBtnGreen(btnX,btnY)=False){
								singleClick(540,540)
							}
						}
						sleep 1000
					}
					;在尝试出招后直接开战，避免卡在黄色开战按钮上
					singleClick(btnX, btnY)
					sleepWithProgress(5000)
				}
			}else{
				;开战（或手动出佣兵完成）
				if(isBtnGreen(btnX, btnY)){
					singleClick(btnX, btnY)
					sleepWithProgress(5000)
				}
			}
			;结算
			ImageSearch, FoundX, FoundY, 962, 571, mWidth, mHeight, *20 %A_ScriptDir%\jiesuan.png
			if (ErrorLevel = 0){
				ToolTip 结算 ,0,0
				singleClick(FoundX, FoundY)
				sleep 2000
			}
			ImageSearch, FoundX, FoundY, 962, 571, mWidth, mHeight, *20 %A_ScriptDir%\jiesuan2.png
			if (ErrorLevel = 0){
				ToolTip 结算2 ,0,0
				singleClick(FoundX, FoundY)
				sleep 2000
			}
			ImageSearch, FoundX, FoundY, 962, 571, mWidth, mHeight, *20 %A_ScriptDir%\jiesuan3.png
			if (ErrorLevel = 0){
				ToolTip 结算3 ,0,0
				singleClick(FoundX, FoundY)
				sleep 2000
			}
			;选择宝藏
			if(findPic("xuanzeyifenbaozang",1)=1){
				addLog("选宝藏")
				singleClick(632,425)
				treasure1 := StrReplace(PaddleOCR([305, 420, 180, 100]), "`n") ;去掉换行符，化成一句话
				treasure1 := StrReplace(treasure1,  A_Space, "")
				addLog("宝藏1："+treasure1)
				treasure2 := StrReplace(PaddleOCR([540, 420, 180, 100]), "`n")
				treasure2 := StrReplace(treasure2,  A_Space, "")
				addLog("宝藏2："+treasure2)
				treasure3 := StrReplace(PaddleOCR([775, 420, 180, 100]), "`n")
				treasure3 := StrReplace(treasure3,  A_Space, "")
				addLog("宝藏3："+treasure3)
				score1 := getScoreOfTreasure(treasure1)
				score2 := getScoreOfTreasure(treasure2)
				score3 := getScoreOfTreasure(treasure3)
				choosePos:=2
				if(score1>score2){
					singleClick(395,432)
					choosePos:=1
					if(score3>score1){
						singleClick(875, 432)
						choosePos:=3
					}
				}else if(score3>score2){
					singleClick(875, 432)
					choosePos:=3
				}
				scoresTip:="分数分别为：" . score1 . "、" . score2 . "、" . score3 . " 最终选择了宝藏" . choosePos 
				addLog(scoresTip)
				singleClick(632,680)
			}
			;点已完成任务
			if(findPic("renwu")=1){
				addLog("已完成任务")
				sleepWithProgress(8000)
			}
			;选择神秘人
			if(findPic("xuanzeyimingfangke",1)=1){				
				addLog("神秘人来到")
				ToolTip 神秘人来到 撒花✿✿ヽ(°▽°)ノ✿ ,0,0	
				; loop
				; {
					; sleep 15000
					; if(findPic("xuanzeyimingfangke",1)=1){				
						; SoundPlay, %A_ScriptDir%\surprise.mp3
					; }
				; }
				noMove:=True
				MouseGetPos x0, y0
				loop 5
				{
					MouseGetPos x1, y1
					if(x0<>x1 || y0<>y1){
						noMove:=False
						break
					}
					SoundPlay, %A_ScriptDir%\surprise.mp3
					sleepWithProgress(6000)
				}
				ToolTip,
				if(noMove){ ;鼠标没动则手动出招点击
					singleClick(287,335)
					sleep 1000
					singleClick(500,555)
					sleep 1000
					singleClick(startBtnX2, startBtnY2)
					sleep 2000
				}
			}
			;营火
			if(findPic("yinghuo",1)=1){
				addLog("查看营火")
				loop 4
				{
					sleep 500
					if(findPic("yiwanchenglanse")=1){   ;yiwanchenglanse
						addLog("领奖励")
						sleep 300
						singleClick(294,610)
						loop 20
						{
							sleep 1000
							if(findPic("jiangli",1)=1||findPic("xinzhuangbei",1)=1){
								singleClick(1008,30) ;961,680
								sleep 1000
							}
							if(findPic("yinghuo",1)=1){
								break
							}
						}
					}else{
						break
					}
				}
				;截图营火任务
				capture()
				sleep 3000
			}
			;点宝箱，宝箱图片容易被识别为其他，这里重复找图以确定是点宝箱页面
			if(findPic("dianbaoxiang",1)=1){
				sleep 1000
				if(findPic("dianbaoxiang",1)=1){
					addLog("点宝箱")
					singleClick(538,217)
					singleClick(370,200)
					singleClick(280,384)
					singleClick(295,557)
					singleClick(323,660)
					singleClick(390,660)
					singleClick(670,670)
					singleClick(764,586)
					singleClick(780,312)
					sleep 800
					singleClick(520,440)
					findUntilGet("xuanshangwancheng", 5000, 1)
				}
			}
			;悬赏完成
			if(findPic("xuanshangwancheng",1)=1){
				singleClick(515,655)
				mCount++
				cCount++
				addLog("悬赏完成 已/总：" . cCount . "/" . mCount)
				setStatisticsText("已/总：" . cCount . "/" . mCount)
				findUntilGet("xuanshang", 3000, 1)
				addLog("*******************************************")
				if(manualBossMode=1 && manualBoss=True){
					manualBoss:=False
				}
			}
			;特殊情况
			handleRoutine()
			if(manual=False && manualBoss=False){
				if(Mod(A_Index, 10)=0){
					singleClick(mWidth-20, mHeight-200)
				}
				MouseMove , startBtnX2, startBtnY2
			}
			; singleClick(2178,558)
		}else{
			WinActivate
		}
	}else{
		IfWinExist, ahk_exe Battle.net.exe
		{
			WinActivate
			if(findPic("jinruyouxi")=1){
				addLog("进入游戏中")
				sleepWithProgress(10000)
			}
			IfWinExist, ahk_exe Hearthstone.exe
			{
				WinGetPos, X, Y, Width, Height, ahk_exe Hearthstone.exe	;判断窗口是否改变
				if(mWidth<>Width || mHeight<>Height || X<>WinXOffset || Y<>WinYOffset){
					addLog("重置窗口属性")
					WinMove,ahk_exe Hearthstone.exe,,%WinXOffset%,%WinYOffset%,%mWidth%,%mHeight%
				}
				if(WinActivate, ahk_exe Hearthstone.exe){
					singleClick(btnX,btnY)
				}
			}
		}
	}
}
return

Button重新开始F6:
XButton2::
F6::
Gui, Submit, NoHide
IniWrite, %mCount%, %A_ScriptDir%\set.ini , 统计, 已通关
IniWrite, %team%, %A_ScriptDir%\set.ini , 设置, 队伍
IniWrite, %debugSet%, %A_ScriptDir%\set.ini , 设置, 调试
IniWrite, %manualSet%, %A_ScriptDir%\set.ini , 设置, 手动出招
IniWrite, %manualBossSet%, %A_ScriptDir%\set.ini , 设置, 手动打首领
reload
return

F5::
Tooltip,
debug:=True
addLog(findWord(0,0,mWidth,mHeight))
; ImageSearch, FoundX, FoundY, 0, 0, 1024, 768, *40 %A_ScriptDir%\jinengshuoming.png
; if (ErrorLevel = 0){
	; ret:=findWord(FoundX-5,FoundY-80,185,100)
	; addLog(ret)
; }
return

F7::
; getShenmixuanxiang()
; send {WheelDown}
getEnemyNum()
return

Button隐藏F8:
F8::
Tooltip 按F9呼出界面。,0,0
Gui, Hide
sleep 1200
tooltip,
return

Button设置出招顺序:
;设置出招顺序窗口
Gui, 2: New
startY:=edge
startX:=edge
Gui, 2: Font, s9, Segoe UI
Gui, 2: Add, Text, x%startX% y%startY% w%setWindowWidth% , `n    自定义出招攻击——比如兽人队（加尔鲁什装备3、萨尔装备3、萨鲁法尔装备1）出招设置为护卫1131，斗士1111，施法者出招随意，如1111。设置好之后，一键出佣兵，从左到右依次出现加尔鲁什、萨尔、萨鲁法尔。第一回合加尔鲁什和萨尔使用技能1，萨鲁法尔也使用技能1。第二回合加尔鲁什使用技能3给全体兽人回血并攻击，萨尔依旧使用技能1，萨鲁法尔使用技能1。
startY:=startY+100
Gui, 2: Add, Text, x%startX% y%startY% w%widgetWidth% h%widgetHeight% +0x200, 护卫出招顺序:
editStartX:=startX+widgetWidth+edge
Gui, 2: Add, Edit, x%editStartX% y%startY% w%widgetWidth% -Multi Number vredSkillsSet, 
startY:=startY+lineHeight
Gui, 2: Add, Text, x%startX% y%startY% w%widgetWidth% h%widgetHeight% +0x200, 斗士出招顺序:
Gui, 2: Add, Edit, x%editStartX% y%startY% w%widgetWidth% -Multi Number vgreenSkillsSet, 
startY:=startY+lineHeight
Gui, 2: Add, Text, x%startX% y%startY% w%widgetWidth% h%widgetHeight% +0x200, 施法者出招顺序:
Gui, 2: Add, Edit, x%editStartX% y%startY% w%widgetWidth% -Multi Number vblueSkillsSet, 
startY:=startY+lineHeight*2
buttonStartX:=setWindowWidth-widgetWidth*2-edge*2
Gui, 2: Add, Button, x%buttonStartX% y%startY% w%widgetWidth% h%widgetHeight%, 保存
buttonStartX:=setWindowWidth-widgetWidth-edge
Gui, 2: Add, Button, x%buttonStartX% y%startY% w%widgetWidth% h%widgetHeight%, 取消
Gui, 2: Show, x200 y200 w%setWindowWidth% h%setWindowHeight% , 设置出招顺序
IniRead, redSkillsGet, %A_ScriptDir%\set.ini , 设置, 红色出招顺序
GuiControl,, redSkillsSet, %redSkillsGet%
IniRead, greenSkillsGet, %A_ScriptDir%\set.ini , 设置, 绿色出招顺序
GuiControl,, greenSkillsSet, %greenSkillsGet%
IniRead, blueSkillsGet, %A_ScriptDir%\set.ini , 设置, 蓝色出招顺序
GuiControl,, blueSkillsSet, %blueSkillsGet%
return

F9::
tooltip,
Gui Show, x0 y%guiY% w%tempW% h%tempY%
return

MButton::
pause
return

XButton1::
capture()
return

GuiClose:
Button关闭:
Gui, Submit, NoHide
IniWrite, %mCount%, %A_ScriptDir%\set.ini , 统计, 已通关
IniWrite, %team%, %A_ScriptDir%\set.ini , 设置, 队伍
IniWrite, %debugSet%, %A_ScriptDir%\set.ini , 设置, 调试
IniWrite, %manualSet%, %A_ScriptDir%\set.ini , 设置, 手动出招
IniWrite, %manualBossSet%, %A_ScriptDir%\set.ini , 设置, 手动打首领
ExitApp
return

2Button保存:
Gui, 2: Submit, NoHide
IniWrite, %redSkillsSet%, %A_ScriptDir%\set.ini , 设置, 红色出招顺序
IniWrite, %greenSkillsSet%, %A_ScriptDir%\set.ini , 设置, 绿色出招顺序
IniWrite, %blueSkillsSet%, %A_ScriptDir%\set.ini , 设置, 蓝色出招顺序
skills1=%blueSkillsSet%
skills2=%redSkillsSet%
skills3=%greenSkillsSet%
;初始化
skills1=%skills1%%skills1%%skills1%321
skills2=%skills2%%skills2%%skills2%321
skills3=%skills3%%skills3%%skills3%321
skillLen1:=StrLen(skills1)
skillLen2:=StrLen(skills2)
skillLen3:=StrLen(skills3)
skillRound1:=1
skillRound2:=1
skillRound3:=1
skillRound4:=1
Gui, 2: Hide
return

2Button取消:
2GuiClose:
Gui, 2: Hide
return

