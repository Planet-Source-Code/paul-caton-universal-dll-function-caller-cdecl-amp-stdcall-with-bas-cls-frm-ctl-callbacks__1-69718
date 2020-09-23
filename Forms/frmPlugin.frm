VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frmPlugin 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Plugin demo"
   ClientHeight    =   9060
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   6555
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   9060
   ScaleWidth      =   6555
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtOrdinal 
      Enabled         =   0   'False
      Height          =   315
      Left            =   1380
      Locked          =   -1  'True
      TabIndex        =   24
      Text            =   "#1"
      Top             =   3195
      Width           =   555
   End
   Begin VB.PictureBox picCtrl 
      AutoRedraw      =   -1  'True
      Height          =   2085
      Index           =   4
      Left            =   180
      ScaleHeight     =   2025
      ScaleWidth      =   2955
      TabIndex        =   14
      TabStop         =   0   'False
      Top             =   6780
      Width           =   3015
      Begin VB.Label lblCtrls 
         Alignment       =   2  'Center
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         BackStyle       =   0  'Transparent
         Caption         =   "Call MyShape in the selected plugin. MyShape will paint a plugin dependant shape in the picture box"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00800000&
         Height          =   675
         Index           =   4
         Left            =   180
         TabIndex        =   23
         Top             =   1260
         Width           =   2595
      End
   End
   Begin VB.PictureBox picCtrl 
      Height          =   2085
      Index           =   3
      Left            =   3330
      ScaleHeight     =   2025
      ScaleWidth      =   2955
      TabIndex        =   13
      TabStop         =   0   'False
      Top             =   4560
      Width           =   3015
      Begin VB.CommandButton cmdCancel 
         Cancel          =   -1  'True
         Caption         =   "Cancel"
         Enabled         =   0   'False
         Height          =   375
         Left            =   540
         TabIndex        =   20
         Top             =   690
         Width           =   1095
      End
      Begin MSComctlLib.ProgressBar pbCallback 
         Height          =   255
         Left            =   240
         TabIndex        =   19
         Top             =   240
         Width           =   2490
         _ExtentX        =   4392
         _ExtentY        =   450
         _Version        =   393216
         BorderStyle     =   1
         Appearance      =   0
         Min             =   1
         Scrolling       =   1
      End
      Begin VB.Label lblCtrls 
         Alignment       =   2  'Center
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         Caption         =   "Call MyCallback in the selected plugin. MyCallback will callback every 100mS for 10 seconds."
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00800000&
         Height          =   675
         Index           =   3
         Left            =   180
         TabIndex        =   22
         Top             =   1260
         Width           =   2595
      End
   End
   Begin VB.PictureBox picCtrl 
      Height          =   2085
      Index           =   1
      Left            =   180
      ScaleHeight     =   2025
      ScaleWidth      =   2955
      TabIndex        =   12
      TabStop         =   0   'False
      Top             =   4560
      Width           =   3015
      Begin VB.TextBox txtParam 
         Height          =   315
         Index           =   2
         Left            =   1680
         MaxLength       =   9
         TabIndex        =   16
         Text            =   "102"
         Top             =   750
         Width           =   975
      End
      Begin VB.TextBox txtParam 
         Height          =   315
         Index           =   1
         Left            =   1680
         MaxLength       =   9
         TabIndex        =   15
         Text            =   "101"
         Top             =   240
         Width           =   975
      End
      Begin VB.Label lblCtrls 
         Alignment       =   2  'Center
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         Caption         =   "Mary had a little lamb"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   -1  'True
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00800000&
         Height          =   675
         Index           =   1
         Left            =   180
         TabIndex        =   21
         Top             =   1260
         Width           =   2595
      End
      Begin VB.Label lblStatic 
         AutoSize        =   -1  'True
         Caption         =   "Parameter #1:"
         Height          =   210
         Index           =   1
         Left            =   300
         TabIndex        =   18
         Top             =   285
         Width           =   1200
      End
      Begin VB.Label lblStatic 
         AutoSize        =   -1  'True
         Caption         =   "Parameter #2:"
         Height          =   210
         Index           =   3
         Left            =   300
         TabIndex        =   17
         Top             =   802
         Width           =   1200
      End
   End
   Begin VB.OptionButton optFunc 
      Caption         =   "Call by ordinal"
      Height          =   210
      Index           =   5
      Left            =   1110
      TabIndex        =   11
      Top             =   2715
      Width           =   1470
   End
   Begin VB.TextBox txtPlugin 
      Height          =   315
      Left            =   840
      Locked          =   -1  'True
      TabIndex        =   10
      TabStop         =   0   'False
      Top             =   240
      Width           =   5055
   End
   Begin VB.CommandButton cmdCall 
      Caption         =   "cCallFunc.CallFunc"
      Enabled         =   0   'False
      Height          =   315
      Left            =   4125
      TabIndex        =   9
      Top             =   3195
      Width           =   2220
   End
   Begin VB.TextBox txtReturn 
      Height          =   315
      Left            =   5370
      Locked          =   -1  'True
      TabIndex        =   8
      TabStop         =   0   'False
      Top             =   3780
      Width           =   975
   End
   Begin VB.OptionButton optFunc 
      Caption         =   "MyCallback"
      Height          =   210
      Index           =   3
      Left            =   1110
      TabIndex        =   7
      Top             =   1755
      Width           =   1185
   End
   Begin VB.OptionButton optFunc 
      Caption         =   "MyFunc2"
      Height          =   210
      Index           =   2
      Left            =   1110
      TabIndex        =   6
      Top             =   1275
      Width           =   1080
   End
   Begin VB.OptionButton optFunc 
      Caption         =   "MyFunc1"
      Height          =   210
      Index           =   1
      Left            =   1110
      TabIndex        =   5
      Top             =   795
      Value           =   -1  'True
      Width           =   1080
   End
   Begin VB.OptionButton optFunc 
      Caption         =   "MyShape"
      Height          =   210
      Index           =   4
      Left            =   1110
      TabIndex        =   4
      Top             =   2235
      Width           =   1110
   End
   Begin VB.CommandButton cmdPlugin 
      Caption         =   "..."
      Height          =   285
      Left            =   5970
      TabIndex        =   0
      Top             =   240
      Width           =   375
   End
   Begin MSComDlg.CommonDialog cdPlugin 
      Left            =   7800
      Top             =   120
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComCtl2.UpDown udOrdinal 
      Height          =   315
      Left            =   1980
      TabIndex        =   25
      Top             =   3195
      Width           =   255
      _ExtentX        =   450
      _ExtentY        =   556
      _Version        =   393216
      Value           =   1
      OrigLeft        =   2340
      OrigTop         =   300
      OrigRight       =   2595
      OrigBottom      =   555
      Max             =   4
      Min             =   1
      Enabled         =   0   'False
   End
   Begin VB.Label lblStatic 
      AutoSize        =   -1  'True
      Caption         =   "Function:"
      Height          =   210
      Index           =   4
      Left            =   180
      TabIndex        =   3
      Top             =   900
      Width           =   765
   End
   Begin VB.Label lblStatic 
      AutoSize        =   -1  'True
      Caption         =   "Return Value:"
      Height          =   210
      Index           =   2
      Left            =   3945
      TabIndex        =   2
      Top             =   3825
      Width           =   1125
   End
   Begin VB.Label lblStatic 
      AutoSize        =   -1  'True
      Caption         =   "Plugin:"
      Height          =   210
      Index           =   0
      Left            =   180
      TabIndex        =   1
      Top             =   285
      Width           =   540
   End
End
Attribute VB_Name = "frmPlugin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'**********************************************************************************
'** Demonstrate the basic principles of a plugin system using cCallFunc.cls
'**
'** Bloomin' PSC and their restrictions on binary content. So, rather than fall
'** foul of the submission scanner: on form load I check for the presence of the
'** plugin dlls, if not found they're extracted from the resource section and
'** written to disk. Dll modules can have pretty much any kind of extension, in
'** this demo they're named...
'**
'**   Plugin_1.plugin
'**   Plugin_2.plugin
'**
'** See Plugin.cpp & Plugin.def in the 'Plugin Source' directory for the code
'** that was used to produce the plugin dll's -- the source should be fairly
'** self-explanatory even to non-C programmers
'**
'** Also, note the FileExists function for an example of how to pass a UDT and
'** a NULL terminated ASCII string
'**********************************************************************************

Option Explicit

Private Type FILETIME
  dwLowDateTime     As Long
  dwHighDateTime    As Long
End Type

Private Type WIN32_FIND_DATA
  dwFileAttributes  As Long
  ftCreationTime    As FILETIME
  ftLastAccessTime  As FILETIME
  ftLastWriteTime   As FILETIME
  nFileSizeHigh     As Long
  nFileSizeLow      As Long
  dwReserved0       As Long
  dwReserved1       As Long
  cFileName         As String * 260
  cAlternate        As String * 14
End Type

Private bCancel     As Boolean
Private nVisible    As Long
Private p           As cCallFunc

Private Sub Form_Load()
  Dim sPlugin As String
  
  Set p = New cCallFunc 'Create a cCallFunc instance
  
  ChDrive App.Path      'Ensure the app is running on its own drive
  ChDir App.Path        'Ensure the app is running in its own directory
  
'If the plugin modules aren't present, extract them from the resource section and save to the app's directory
  sPlugin = "Plugin_1.plugin"
  If Not FileExists(sPlugin) Then ExtractPlugin 101, sPlugin
  
  sPlugin = "Plugin_2.plugin"
  If Not FileExists(sPlugin) Then ExtractPlugin 102, sPlugin
  
  Me.Height = Me.Height - (Me.ScaleHeight - 4305)
  picCtrl(1).Left = 3330
  picCtrl(1).Top = 795
  picCtrl(1).Visible = True
  
  picCtrl(3).Left = picCtrl(1).Left
  picCtrl(3).Top = picCtrl(1).Top
  picCtrl(3).Visible = False
  
  picCtrl(4).Left = picCtrl(1).Left
  picCtrl(4).Top = picCtrl(1).Top
  picCtrl(4).Visible = False
  
  nVisible = 3
  optFunc_Click 1
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If cmdCancel.Enabled Then
    Cancel = True       'Cancel unload whilst MyCallback is active
  End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set p = Nothing       'Destroy the cCallFunc instance
End Sub

'Call the selected plugin
Private Sub cmdCall_Click()
  Dim nIndex As Long
  
  Select Case True
  Case optFunc(1).Value: nIndex = 1
  Case optFunc(2).Value: nIndex = 2
  Case optFunc(3).Value: nIndex = 3
  Case optFunc(4).Value: nIndex = 4
  Case optFunc(5).Value: nIndex = udOrdinal.Value
  End Select
  
  'Get the chosen function
  Select Case nIndex
  Case 1
    txtReturn.Text = p.CallFunc(txtPlugin.Text, "MyFunc1", CLng(txtParam(1).Text), CLng(txtParam(2).Text), Me.hWnd)
      
  Case 2
    txtReturn.Text = p.CallFunc(txtPlugin.Text, "MyFunc2", CLng(txtParam(1).Text), CLng(txtParam(2).Text), Me.hWnd)
      
  Case 3
    bCancel = False
    optFunc(1).Enabled = False
    optFunc(2).Enabled = False
    optFunc(3).Enabled = False
    optFunc(4).Enabled = False
    optFunc(5).Enabled = False
    udOrdinal.Enabled = False
    cmdCall.Enabled = False
    cmdCancel.Enabled = True
    
    txtReturn.Text = p.CallFunc(txtPlugin.Text, "MyCallback", p.CallbackObj(objFrm, Me, 1, 1, False, 1))
    
    optFunc(1).Enabled = True
    optFunc(2).Enabled = True
    optFunc(3).Enabled = True
    optFunc(4).Enabled = True
    optFunc(5).Enabled = True
    udOrdinal.Enabled = True
    cmdCall.Enabled = True
    cmdCancel.Enabled = False
    
  Case 4
    Set picCtrl(4).Picture = Nothing
    txtReturn.Text = p.CallFunc(txtPlugin.Text, "MyShape", picCtrl(4).hWnd, picCtrl(4).hDC)
    Set picCtrl(4).Picture = picCtrl(4).Image
  
  End Select
End Sub

'Cancel MyCallback
Private Sub cmdCancel_Click()
  bCancel = True
End Sub

'Choose the plugin module
Private Sub cmdPlugin_Click()
  On Error GoTo Err
  
  With cdPlugin
    .CancelError = True
    .Filter = "Plugins|*.plugin"
    .DialogTitle = "Choose plugin"
    .InitDir = App.Path
    .ShowOpen
    
    txtPlugin.Text = .FileName
    cmdCall.Enabled = True
  End With
  
Err:
End Sub

Private Sub optFunc_Click(Index As Integer)
  Dim nIndex As Long
  
  txtOrdinal.Enabled = optFunc(5).Value
  udOrdinal.Enabled = optFunc(5).Value
  
  If nVisible Then
    picCtrl(nVisible).Visible = False
  End If
  
  nIndex = Index
  
  Select Case Index
  Case 1
    lblCtrls(nIndex).Caption = "Call MyFunc1 in the selected plugin, passing parameters 1 & 2, returning the ID of the button clicked."
    
  Case 2
    nIndex = 1
    lblCtrls(nIndex).Caption = "Call MyFunc2 in the selected plugin, passing parameters 1 & 2, returning the ID of the button clicked."
    
  Case 3
    nIndex = Index
  
  Case 4
    nIndex = Index
    Set picCtrl(4).Picture = Nothing
    
  Case 5
    Select Case udOrdinal.Value
    Case 1
      nIndex = 1
      lblCtrls(nIndex).Caption = "Call MyFunc1 in the selected plugin, passing parameters 1 & 2, returning the ID of the button clicked."
        
    Case 2
      nIndex = 1
      lblCtrls(nIndex).Caption = "Call MyFunc2 in the selected plugin, passing parameters 1 & 2, returning the ID of the button clicked."
      
    Case 3, 4
      nIndex = udOrdinal.Value
      
    End Select
  End Select
  
  picCtrl(nIndex).Visible = True
  nVisible = nIndex
End Sub

'Disallow alpha characters
Private Sub txtParam_KeyPress(Index As Integer, KeyAscii As Integer)
  If KeyAscii < 32 Or (KeyAscii >= 48 And KeyAscii <= 57) Then
  Else
    KeyAscii = 0
  End If
End Sub

Private Sub udOrdinal_Change()
  txtOrdinal.Text = "#" & udOrdinal.Value
  optFunc_Click udOrdinal.Value
End Sub

'Extract the specified resource and save to disk
Private Sub ExtractPlugin(ByVal nIndex As Long, ByRef strPlugin As String)
  Dim FileNum     As Integer
  Dim DataArray() As Byte
  
  DataArray = LoadResData(nIndex, "CUSTOM")
  
  FileNum = FreeFile
  Open strPlugin For Binary As #FileNum
  Put #FileNum, 1, DataArray()
  Close #FileNum
  
  Erase DataArray
End Sub

'Return whether the passed file exists
'Also demonstrates how to pass strings and UDT parameters
Private Function FileExists(ByRef strSource As String) As Boolean
  Dim WFD     As WIN32_FIND_DATA
  Dim hFile   As Long
  Dim sSrcAsc As String
  
  sSrcAsc = StrConv(strSource, vbFromUnicode) & vbNullChar
  hFile = p.CallFunc("kernel32", "FindFirstFileA", StrPtr(sSrcAsc), VarPtr(WFD))
  
  FileExists = hFile <> -1
  
  p.CallFunc "kernel32", "FindClose", hFile
End Function

Private Function Ordinal_1(ByVal nPos As Long) As Long
  pbCallback.Value = nPos
  DoEvents
  Ordinal_1 = Not bCancel
End Function
