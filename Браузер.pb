Enumeration
  #MAIN_WINDOW
EndEnumeration

Enumeration
  #MENU_BAR
EndEnumeration

Enumeration
  #ACTION_EXIT
  #ACTION_ABOUT
EndEnumeration

Enumeration
  #BACK_BUTTON
  #FORWARD_BUTTON
  #URL_STRING
  #GO_BUTTON
  #STOP_BUTTON
  #WEB
EndEnumeration

Procedure SuppressWebGadgetErrors()
  SetGadgetAttribute(#WEB, #PB_Web_BlockPopups, #True)
  id.IWebBrowser2 = GetWindowLongPtr_(GadgetID(#WEB), #GWL_USERDATA)
  id\put_Silent(#True)
EndProcedure

Procedure Callback(gadget, url$)
  If GetGadgetAttribute(#WEB, #PB_Web_Busy) = #False
    SetGadgetText(#URL_STRING, GetGadgetText(#WEB))
  EndIf
  ProcedureReturn #True
EndProcedure

Procedure OpenMainWindow()
  
  If OpenWindow(#MAIN_WINDOW, #PB_Ignore, #PB_Ignore, 600, 400, "Браузер", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    If CreateMenu(#MENU_BAR, WindowID(#MAIN_WINDOW)) 
      MenuTitle("&Файл")
      MenuItem(#ACTION_EXIT, "В&ыход")
      
      MenuTitle("&Справка")
      MenuItem(#ACTION_ABOUT, "&О программе")
    EndIf
    
    ButtonGadget(#BACK_BUTTON, 5, 4, 60, 22, "Назад")
    ButtonGadget(#FORWARD_BUTTON, 65, 4, 60, 22, "Вперед")
    StringGadget(#URL_STRING, 125, 5, 340, 20, "")
    ButtonGadget(#GO_BUTTON, 465, 4, 60, 22, "Перейти")
    ButtonGadget(#STOP_BUTTON, 525, 4, 70, 22, "Остановить")
    WebGadget(#WEB, 0, 30, 600, 340, "")
    
    SetGadgetAttribute(#WEB, #PB_Web_NavigationCallback, @Callback())
  EndIf
EndProcedure


OpenMainWindow()
SuppressWebGadgetErrors()
SmartWindowRefresh(#MAIN_WINDOW, #True)

Repeat
  
  event       = WaitWindowEvent()
  eventMenu   = EventMenu()
  eventGadget = EventGadget()
  eventWindow = EventWindow()
  eventType   = EventType()
  
  If eventWindow = #MAIN_WINDOW
    If event = #PB_Event_Menu
      If eventMenu = #ACTION_EXIT
        Break
      ElseIf eventMenu = #ACTION_ABOUT
        MessageRequester("О программе", "Браузер. Версия 1.0" + #CR$ + #CR$ + "Автор: Салават Даутов" + #CR$ + #CR$ + "Дата создания: июль 2012 года", #MB_ICONINFORMATION)
      EndIf
    EndIf
    
    If Event = #PB_Event_SizeWindow
      ResizeGadget(#URL_STRING, #PB_Ignore, #PB_Ignore, WindowWidth(#MAIN_WINDOW) - 260, #PB_Ignore)
      ResizeGadget(#GO_BUTTON, WindowWidth(#MAIN_WINDOW) - 135, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ResizeGadget(#STOP_BUTTON, WindowWidth(#MAIN_WINDOW) - 75, #PB_Ignore, #PB_Ignore, #PB_Ignore)
      ResizeGadget(#WEB, #PB_Ignore, #PB_Ignore, WindowWidth(#MAIN_WINDOW), WindowHeight(#MAIN_WINDOW) - 50)
    EndIf
    
    If event = #PB_Event_Gadget
      If eventGadget = #GO_BUTTON
        SetGadgetText(#WEB, GetGadgetText(#URL_STRING))
      ElseIf eventGadget = #FORWARD_BUTTON
        SetGadgetState(#WEB, #PB_Web_Forward)
      ElseIf eventGadget = #BACK_BUTTON
        SetGadgetState(#WEB, #PB_Web_Back)
      ElseIf eventGadget = #STOP_BUTTON
        SetGadgetState(#WEB, #PB_Web_Stop)
      EndIf
    EndIf
  EndIf
Until event = #PB_Event_CloseWindow And eventWindow = #MAIN_WINDOW
