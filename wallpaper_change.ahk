^+w:: ; 按下[ctrl]+[shift]+w 啟動程式

; |第一部分：前置設定|

Satisfied := false ; 預設為不滿意桌布
ChangeTopic := true ; 預設要更換主題(配合迴圈條件)
FileLocation := "C:\Users\s1010\Downloads\ahk_images" ; 檔案儲存位置
TrashBin := "explorer.exe shell:RecycleBinFolder" ; 資源回收桶路徑
site := "https://www.pixiv.net/" ; 使用的網站(不可更換，簡化字串用)
account := "s11030099@zlsh.tp.edu.tw" ; 帳號
password := "********" ; 密碼
Topic := "流れ星" ; 預設桌布主題

Send,{ALT up} ; 防止卡鍵
Sleep 500

ImageSearch x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,*5 chinese.png ; 切換英文輸入
If (ErrorLevel = 0)
{
    Send,#{SPACE}
    Sleep 500
}

; 美化檢視(關閉桌面圖示顯示)
Click RIGHT 1414,619
Sleep 500
Send,{RIGHT}
Sleep 500
Send,{down 5}
Sleep 500
Send,{ENTER}
Sleep 500

; |第二部分：取得桌布|
Run https://www.google.com.tw/ ; 打開 Google
Sleep 1500
Send,{ALT down}{SPACE} ; 將視窗最大化
Sleep 500
Send,{ALT up}
Sleep 500
Send,x
Sleep 500
Send,^+n ; 開啟無痕視窗
Sleep 1000
Send,%site%{ENTER} ; 進入 Pixiv
Sleep 4000
Send,{TAB 9}{ENTER} ; 登入帳號
Sleep 3000
Send,{TAB 11}{ENTER}
Sleep 3000
Send,%account%{ENTER}
Sleep 1500
Send,%password%{ENTER}
Sleep 5000

; #主程式開始
While (Satisfied = false)
{
    If (ChangeTopic = true)
    {
        Send,{TAB 3}%Topic%{ENTER} ; 輸入主題
        Sleep 5000
        ImageSearch x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,illustration.png ; 點擊"插畫"
        If ErrorLevel = 0
            Click %x%,%y%
        Sleep 1500
        Send,{WheelDown 2}
        Sleep 500

        ; 大部分搜尋結果都會出現以下的會員廣告，影響需要按下的[tab]次數：
        ImageSearch, x, y, 0, 0, A_ScreenWidth, A_ScreenHeight,hot.png
        If ErrorLevel = 0
        {
            Send,{TAB 12}{ENTER} ; 出現該廣告就按 12 下[tab]
            Sleep 5000
        }
        Else
        {
            Send,{TAB 7}{ENTER} ; 否則按 7 下
            Sleep 1000
        }
    }

    ; 若欲將自動選擇搜尋結果第一張圖的模式改為手動，可把上方 ImageSearch 取代為以下程式區塊：
    /*
    ^+c:: (找到喜歡的桌布後按下[ctrl]+[shift]+[c]繼續程式)
    Click RIGHT,723,681 ; 下載圖片(另存新檔)
    Sleep 500
    Click 818,443
    Sleep 500
    Send,{TAB 6}{ENTER} ; 存檔
    Sleep 500
    Send,%FileLocation%{ENTER} ; 輸入檔案位置
    Sleep 500
    Send,{TAB 8}{ENTER}
    Sleep 500
    Send,#d ; 至設定更換
    Sleep 500
    Click 1397,498 ; (確保桌面為視窗最上層)
    Sleep 500
    Send,+{F10}
    Sleep 500
    Send,r
    Sleep 1500
    Send,{TAB 4}{ENTER}
    Sleep 1000
    Send,{TAB 3}{ENTER} ; 選擇剛才下載的圖片
    Sleep 1000
    Send,{TAB 5}{ENTER}
    Sleep 500
    Send,%FileLocation%{ENTER}
    Sleep 500
    Send,{TAB 4}
    Sleep 500
    Send,{RIGHT}{LEFT}
    Sleep 500
    Send,{ENTER}
    Sleep 500
    Send,!{F4} ; 回到主畫面(關閉設定介面)
    Sleep 5000
    */

    ; |第三部分：結果選擇|

    Msgbox, 36, , Are you satisfied?, 20 ; <訊息視窗>是否滿意?
    IfMsgBox Yes ; #是(滿意，結束程式)
    {
        Satisfied := true
        Sleep 1000
    }
    Else IfMsgBox No ; #否(不滿意，換下一張圖)
    {
        Sleep 1000
        Msgbox, , , Delete the image,1.5 ; 刪除該圖片

        Sleep 500
        Send,#e
        Sleep 500
        Send,{TAB 4}{ENTER}
        Sleep 500
        Send,%FileLocation%
        Sleep 500
        Send,{ENTER}
        Sleep 500
        Send,{RIGHT}{LEFT}{APPSKEY}d
        Sleep 500
        Send,!{F4} ; 關閉檔案管理介面
        Sleep 1000
        Send,#r ; 開啟資源回收桶
        Sleep 500
        Send,%TrashBin%{ENTER}
        Sleep 500
        Send,{DOWN}{UP}
        Sleep 500
        Send,{APPSKEY}d
        Sleep 500
        Send,{ENTER}
        Sleep 500
        Send,!{F4} ; 關閉資源回收桶介面
        Sleep 1000

        Msgbox, 36, , Change the topic?, 10 ; <訊息視窗>更換桌布主題?
        IfMsgBox Yes ; #是(更換主題)
        {
            InputBox,NewTopic, ,Enter a new topic, ,300,150, , , ,30 ; <輸入視窗>輸入新主題
            If ErrorLevel ; #取消更換/超時(Timeout)
            {
                ChangeTopic := false
                Sleep 1000
            }
            Else
            {
                ChangeTopic := true
                Topic := NewTopic
                Sleep 1000
            }
        }
        Else ; #否(不更換桌布主題)
        {
            ChangeTopic := false
            Sleep 1000
        }

        Send,{ALT down}{TAB} ; 回到網頁
        Sleep 500
        Send,{ALT up}
        Sleep 500
        Send,{F5} ; (重置[tab]的起始點)
        Sleep 1000

        If (ChangeTopic = false) ; #換圖但不換主題
        {
            Send,{RIGHT} ; 下一張圖
            Sleep 2000
        }
    }
    Else
    {
        Satisfied := true
        Msgbox, Timeout! ; <訊息視窗>超時
        Sleep 1000
    }
    Sleep 500
}

; #主程式結束
Click RIGHT 1414,619 ; 還原檢視(顯示桌面圖示)
Sleep 500
Send,{RIGHT}
Sleep,500
Send,{down 3}{ENTER}
Sleep 500

Loop 2 ; 關閉視窗(網頁)
{
    Send,{ALT down}{TAB}{ALT up}
    Sleep 500
    Send,^w
    Sleep 500
    Send,#d
    Sleep 500
}

Sleep 1000
Msgbox, , , Program Will Exit,2 ; <訊息視窗>程式結束
Return