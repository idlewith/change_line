
#include <FindText>

#SingleInstance Force


#HotIf WinActive("ahk_class UnrealWindow")

CoordMode "Pixel", "Window"


F1::
{
    MouseGetPos &xpos, &ypos
    color := PixelGetColor(xpos, ypos)
    position_color := Format("X: {1}, Y: {2}, color: {3}", xpos, ypos, color)
    ToolTip position_color
    A_Clipboard := position_color
    SetTimer () => ToolTip(), -5000
    return
}

SelectInit()
{
    Sleep 200
    
    ; 让切换频道可见
    Send "{Esc}"
    Sleep 500

    ; 点击切换频道
    ; X: 2439, Y: 1919, color: 0xD2C9B6
    MouseClick "left", 2439, 1919
    Sleep 200

    ; 点击可以下拉频道
    ; X: 1911, Y: 1076, color: 0x5E7D87
    MouseClick "left", 1911, 1076
    Sleep 200

    ; 移动到频道选择区域，方便滚动
    ; X: 1956, Y: 1214, color: 0x37658E
    MouseMove 1956, 1214
    Sleep 100

    ; 滚动到最上面
    Loop 30 {
        MouseClick "WheelUp",,, 2
        Sleep 10
    }

}



ScrollFindAndClick(num)
{

    ; 第一个点
    ; X: 1861, Y: 1143, color: 0x446F95
    FirstX := 1861
    FirstY := 1143
    DeltaY := 66

    SelectInit()
    
    if ( num <= 7)
    {
        MouseClick "left", FirstX, FirstY + DeltaY * (num - 1)
    }
    else
    {
        Loop num - 7 {
            MouseClick "WheelDown",,, 1
            Sleep 100
        }

        Sleep 200
        MouseClick "left", FirstX, FirstY + DeltaY * 6
    }

    Sleep 200
    Loop 2 {
        Send "{y}"
    }
}




Numpad1::ScrollFindAndClick(1)
Numpad2::ScrollFindAndClick(2)
Numpad3::ScrollFindAndClick(3)
Numpad4::ScrollFindAndClick(4)
Numpad5::ScrollFindAndClick(5)
Numpad6::ScrollFindAndClick(6)
Numpad7::ScrollFindAndClick(7)
Numpad8::ScrollFindAndClick(8)
Numpad9::ScrollFindAndClick(9)
Numpad1 & Numpad0::ScrollFindAndClick(10)
Numpad1 & Numpad1::ScrollFindAndClick(11)
Numpad1 & Numpad2::ScrollFindAndClick(12)
Numpad1 & Numpad3::ScrollFindAndClick(13)
Numpad1 & Numpad4::ScrollFindAndClick(14)
Numpad1 & Numpad5::ScrollFindAndClick(15)
Numpad1 & Numpad6::ScrollFindAndClick(16)
Numpad1 & Numpad7::ScrollFindAndClick(17)
Numpad1 & Numpad8::ScrollFindAndClick(18)
Numpad1 & Numpad9::ScrollFindAndClick(19)
Numpad2 & Numpad0::ScrollFindAndClick(20)


