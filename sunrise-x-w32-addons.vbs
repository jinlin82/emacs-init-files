Set objArgs = WScript.Arguments
If objArgs.Count = 0 Then
  info()
Else
  If objArgs(0) = "/l" Then
    resolve_lnk(objArgs(1))
  End If
End If

Function info()
  Dim filesys, drv, drvcoll, w32info, shell, folder
  Dim folders(7)
  folders(0) = "Desktop"
  folders(1) = "Programs"
  folders(2) = "MyDocuments"
  folders(3) = "Favorites"
  folders(4) = "PrintHood"
  folders(5) = "NetHood"
  folders(6) = "AllUsersDesktop"
  folders(7) = "AllUsersPrograms"

  Set filesys = CreateObject("Scripting.FileSystemObject")
  Set drvcoll = filesys.Drives

  w32info = "((drives . ("
  For Each drv in drvcoll
    If drv.IsReady Then
      w32info = w32info & """" & drv.DriveLetter & """ "
    End If
  Next
  w32info = w32info & ")) (folders . ("

  Set shell = CreateObject("WScript.Shell")
  For Each folder in folders
    folder = Replace(shell.SpecialFolders(folder), "\", "/")
    w32info = w32info & """" & folder & """ "
  Next
  w32info = w32info & ")))"

  Wscript.Echo w32info
End Function

Function resolve_lnk(linkFile)
  Set link = WScript.CreateObject("WScript.Shell").CreateShortcut(linkFile)
  WScript.Echo link.TargetPath
End Function