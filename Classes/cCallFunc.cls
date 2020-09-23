VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCallFunc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'**********************************************************************************
'** cCallFunc.cls
'**
'** Universal function calling class
'**   Automatic CDECL/stdcall function calling.
'**   Call functions by ordinal or name
'**   Module (bas) callbacks for CDECL functions.
'**   Object (cls/frm/ctl) callbacks for CDECL/stdcall.
'**   Support for multiple callbacks.
'**   Support for multiple cCallFunc instances
'**   Support unicode path\module names
'**
'** If you want to do crazy stuff like CallFunc with callbacks inside a callback
'** then the best solution is to make a copy of the class, eg cCallFunc1.cls, and
'** use an instance of that where needed.
'**
'** paul_caton@hotmail.com
'**
'** 20031029 First cut....................................................... v1.00
'** 20071129 Now using virtual memory to fix a DEP issue..................... v1.01
'** 20071130 Hacked from cCDECL, now supports stdcall and ordinals........... v1.02
'** 20071201 Added support for callback objects.............................. v1.03
'** 20071202 Unicode support for paths\modules where available............... v1.04
'**********************************************************************************

Option Explicit
Option Base 0

Private Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
Private Declare Function GetDesktopWindow Lib "user32" () As Long
Private Declare Function GetLastError Lib "kernel32" () As Long
Private Declare Function GetProcByName Lib "kernel32" Alias "GetProcAddress" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function GetProcByOrdinal Lib "kernel32" Alias "GetProcAddress" (ByVal hModule As Long, ByVal nOrdinal As Long) As Long
Private Declare Function IsBadCodePtr Lib "kernel32" (ByVal lpfn As Long) As Long
Private Declare Function IsWindowUnicode Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function LoadLibraryA Lib "kernel32" (ByVal lpLibFileName As String) As Long
Private Declare Function LoadLibraryW Lib "kernel32" (ByVal lpLibFileName As Long) As Long
Private Declare Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As Long
Private Declare Function VirtualFree Lib "kernel32" (ByVal lpAddress As Long, ByVal dwSize As Long, ByVal dwFreeType As Long) As Long

Private Declare Sub GetMem1 Lib "msvbvm60" (ByVal Addr As Long, RetVal As Byte)
Private Declare Sub GetMem4 Lib "msvbvm60" (ByVal Addr As Long, RetVal As Long)
Private Declare Sub PutMem1 Lib "msvbvm60" (ByVal Addr As Long, ByVal NewVal As Byte)
Private Declare Sub PutMem4 Lib "msvbvm60" (ByVal Addr As Long, ByVal NewVal As Long)
Private Declare Sub PutMem8 Lib "msvbvm60" (ByVal Addr As Long, ByVal NewVal As Currency)
Private Declare Sub SetLastError Lib "kernel32" (ByVal dwErrCode As Long)

Public Enum eObjType                                                          'Object type for CallbackObj
  objCls = &H1C                                                               'Class object callback
  objFrm = &H6F8                                                              'Form object callback
  objCtl = &H7A4                                                              'UserControl object callback
End Enum                                                                      '
                                                                              '
Private Const ERR_SRC       As String = "cCallFunc"                           'Error source name
Private Const MAX_ARG       As Long = 16                                      'Maximum number of parameters, this value can altered if needed

Private Type tParamBlock                                                      'Parameter block type
  ParamCount                As Long                                           'Number of parameters to be forwarded
  Params(0 To MAX_ARG - 1)  As Long                                           'Array of parameters to be forwarded
End Type                                                                      '
                                                                              '
Private m_LastError         As Long                                           'Last error code private member
Private vTable              As Long                                           'cCallFunc vTable address
Private vCode               As Long                                           'Pointer to the machine-code thunks
Private hModule             As Long                                           'Module handle
Private bUnicode            As Boolean                                        'Unicode flag
Private strLastFunc         As String                                         'The last-called function name
Private strLastMod          As String                                         'The last-used module

'CallFunc: universal function caller, both CDECL and stdcall
'
' strMod      - Name of the executable module, can include path, defaults to .dll if not specified eg. "user32"
' strFunction - Name of the function or it's ordinal value preceded by a '#' eg. "#2"
' ParamLongs  - Any number of parameters As Long, or none.
'                 To pass the address (ByRef) of a string use StrPtr, eg. StrPtr(strPath)
'                 To pass the address (ByRef) of a variable or UDT use VarPtr, eg. VarPtr(i)
Public Function CallFunc(ByRef strMod As String, _
                         ByRef strFunction As String, _
                         ParamArray ParamLongs() As Variant) As Long           '
  Dim bNewMod As Boolean                                                      'New module flag
  Dim pb      As tParamBlock                                                  'Parameter block
                                                                              '
  If StrComp(strMod, strLastMod, vbTextCompare) <> 0 Then                     'If the module is new
    Dim hMod As Long                                                          '
                                                                              '
    If bUnicode Then                                                          'If unicode
      hMod = LoadLibraryW(StrPtr(strMod & vbNullChar))                        'Load the module with the unicode version of LoadLibrary
    Else                                                                      '
      hMod = LoadLibraryA(strMod)                                             'Load the module with the ascii version of LoadLibrary
    End If                                                                    '
                                                                              '
    If hMod = 0 Then                                                          'If the load failed
      Debug.Assert False                                                      'Halt if running under the VB IDE
      Err.Raise vbObjectError + 0, ERR_SRC, "Module not loaded"               'Raise an error if running compiled
    End If                                                                    '
                                                                              '
    If hModule <> 0 Then                                                      'If a module is already loaded
      FreeLibrary hModule                                                     'Free the last module
    End If                                                                    '
    
    hModule = hMod                                                            'Save the module handle
    strLastMod = strMod                                                       'Save the new module name
    bNewMod = True                                                            'Indicate that it's a new module
  End If                                                                      '
                                                                              '
  If bNewMod Or StrComp(strFunction, strLastFunc, vbBinaryCompare) <> 0 Then  'If the function or module is new
    Dim nFuncAddr As Long                                                     'Function address
                                                                              '
    If Asc(strFunction) = 35 Then                                             'If "#..." eg "#2", ordinal 2
      nFuncAddr = GetProcByOrdinal(hModule, CLng(Mid$(strFunction, 2)))       'Get the address of the function by ordinal
    Else                                                                      '
      nFuncAddr = GetProcByName(hModule, strFunction)                         'Get the address of the function by name
    End If                                                                    '
                                                                              '
    If nFuncAddr = 0 Then                                                     'If the function wasn't found in the module
      Debug.Assert False                                                      'Halt if running under the VB IDE
      Err.Raise vbObjectError + 1, ERR_SRC, "Function not found"              'Raise an error if running compiled
    End If                                                                    '
                                                                              '
    PutMem4 vCode + &H17, nFuncAddr - vCode - (&H17 + 4)                      'Patch the code to call the relative address to the target function
    strLastFunc = strFunction                                                 'Save the function name
  End If                                                                      '
                                                                              '
  With pb                                                                     '
    Dim i As Long                                                             'Parameter loop vars
    Dim j As Long                                                             'Parameter loop vars
                                                                              '
    j = UBound(ParamLongs)                                                    'Get the upper parameter array bound
                                                                              '
    If j >= MAX_ARG Then                                                      'If the user has passed more parameters than we allow for
      Debug.Assert False                                                      'Halt if running under the VB IDE
      Err.Raise vbObjectError + 2, ERR_SRC, "Too many parameters"             'Raise an error if running compiled
    End If
    
    For i = 0 To j                                                            'For each parameter
      .Params(i) = ParamLongs(i)                                              'Store the parameter in the parameter block
    Next i                                                                    '
                                                                              '
    .ParamCount = i                                                           'Store the parameter count (j + 1)
  End With                                                                    '
                                                                              '
  PutMem4 vTable + &H34, vCode                                                'Patch the vtable entry for z_CallFunc to point to vCode
                                                                              '
  SetLastError 0                                                              'Clear the error code
                                                                              '
  CallFunc = z_CallFunc(VarPtr(pb))                                           'Call the function, return the return value of the function
                                                                              '
  m_LastError = GetLastError()                                                'Get the error code
End Function

'LastError: return the last error code from the last call of CallFunc
Public Function LastError() As Long                                           '
  LastError = m_LastError                                                     '
End Function                                                                  '

'CallbackCdecl: return a wrapper address for a bas module routine to be used as a callback for a CDECL function.
'               Note: stdcall functions don't need a thunk to use a bas module function as a callback, use direct.
'
' nModFuncAddr - The address of the bas module callback function, use AddressOf to get this value
' nParms       - The number of parameters that will be passed to the bas module callback function
' nIndex       - Allow for multiple simultaneous callbacks
Public Function CallbackCdecl(ByVal nModFuncAddr As Long, _
                              ByVal nParams As Long, _
                     Optional ByVal nIndex As Long = 1) As Long
  
  If nIndex < 1 Or nIndex > 63 Or nParams > 63 Then                           'Parameter sanity checks
    Debug.Assert False                                                        'Halt if running under the VB IDE
    Err.Raise vbObjectError + 3, ERR_SRC, "Invalid parameters"                'Raise error if running compiled
  End If                                                                      '
                                                                              '
  CallbackCdecl = vCode + 44 + ((nIndex - 1) * 50)                            'Address of the callback wrapper. Pass this return value as the callback address parameter of the cdecl function
  
  PutMem8 CallbackCdecl + 0, 465203369712025.6232@                            'Put the cdecl callback to .bas wrapper into memory
  PutMem8 CallbackCdecl + 8, -140418483381718.8329@                           '
  PutMem8 CallbackCdecl + 16, -4672484613390.9419@                            '
  PutMem4 CallbackCdecl + 24, &HC30672                                        '

  PutMem4 CallbackCdecl + 10, nModFuncAddr - CallbackCdecl - (10 + 4)         'Patch the code buffer to call the vb bas module callback function
  PutMem1 CallbackCdecl + 16, nParams * 4                                     'Patch the code buffer to apply the necessary stack adjustment
End Function

'CallbackObj: return the address of an object callback for a CDECL or stdcall function
'
' objType     - Callback object type
' objCallback - The callback object
' nParams     - The number of parameters that will be passed to the object callback function
' nOrdinal    - Callback ordinal. 1 = last private function in the callback object, 2 = second last private function in the callback object, etc
' bCDECL      - specifes whether the callback calling function is CDECL or stdcall
' nIndex      - Allow for multiple simultaneous callbacks
Public Function CallbackObj(ByVal objType As eObjType, _
                            ByRef objCallback As Object, _
                            ByVal nParams As Long, _
                   Optional ByVal nOrdinal As Long = 1, _
                   Optional ByVal bCDECL As Boolean = False, _
                   Optional ByVal nIndex As Long = 1) As Long
  Dim o As Long                                                               'Object pointer
  Dim i As Long                                                               'vTable entry counter
  Dim j As Long                                                               'vTable address
  Dim n As Long                                                               'Method pointer
  Dim b As Byte                                                               'First method byte
  Dim m As Byte                                                               'Known good first method byte
                                                                              '
  If nIndex < 1 Or nIndex > 63 Or nParams > 63 Then                           'Parameter sanity checks
    Debug.Assert False                                                        'Halt if running under the VB IDE
    Err.Raise vbObjectError + 4, ERR_SRC, "Invalid parameters"                'Raise error if running compiled
  End If                                                                      '
                                                                              '
  o = ObjPtr(objCallback)                                                     'Get the callback object's oaddress
  GetMem4 o, j                                                                'Get the address of the callback object's vTable
  j = j + objType                                                             'Increment to the the first user entry for this callback object type
  GetMem4 j, n                                                                'Get the method pointer
  GetMem1 n, m                                                                'Get the first method byte... &H33 if pseudo-code, &HE9 if native
  j = j + 4                                                                   'Bump to the next vtable entry
                                                                              '
  For i = 1 To 511                                                            'Loop through a 'sane' number of vtable entries
    GetMem4 j, n                                                              'Get the method pointer
                                                                              '
    If IsBadCodePtr(n) Then                                                   'If the method pointer is an invalid code address
      GoTo vTableEnd                                                          'We've reached the end of the vTable, exit the for loop
    End If                                                                    '
                                                                              '
    GetMem1 n, b                                                              'Get the first method byte
                                                                              '
    If b <> m Then                                                            'If the method byte does match the known good value
      GoTo vTableEnd                                                          'We've reached the end of the vTable, exit the for loop
    End If                                                                    '
                                                                              '
    j = j + 4                                                                 'Bump to the next vTable entry
  Next i                                                                      'Bump counter
  
  Debug.Assert False                                                          'Halt if running under the VB IDE
  Err.Raise vbObjectError + 5, ERR_SRC, "Callback ordinal not found"          'Raise error if running compiled
                                                                              '
vTableEnd:                                                                    'We've hit the end of the vTable
  GetMem4 j - (nOrdinal * 4), n                                               'Get the method pointer for the specified ordinal
                                                                              '
  CallbackObj = vCode + 44 + ((nIndex - 1) * 50)                              'Address of the callback wrapper. Pass this return value as the callback address parameter
                                                                              '
  PutMem8 CallbackObj + 0, 648518346342877.6073@                              'Put the callback to object wrapper into memory
  PutMem8 CallbackObj + 8, 9425443564.8131@                                   '
  PutMem8 CallbackObj + 16, -29652486425477.8624@                             '
  PutMem8 CallbackObj + 24, 614907631944580.0296@                             '
  PutMem8 CallbackObj + 32, 648518346342874.0437@                             '
  PutMem8 CallbackObj + 40, 36832747.5851@                                    '
                                                                              '
  PutMem1 CallbackObj + &HD, nParams                                          'Patch the number of params
  PutMem4 CallbackObj + &H19, o                                               'Patch the callback object
  PutMem4 CallbackObj + &H1E, n - CallbackObj - (&H1E + 4)                    'Patch the callback call address
  PutMem1 CallbackObj + &H2C, IIf(bCDECL, 0, nParams * 4)                     'Patch the stack correction
End Function

'Class_Initialize: initialize the cCallFunc instance
Private Sub Class_Initialize()                                                '
  vCode = VirtualAlloc(0, &H1000&, &H1000&, &H40&)                            'Allocate read/write/executable memory
                                                                              '
  PutMem8 vCode + 0, 695618785647368.6248@                                    'Put the CallFunc machine-code into memory
  PutMem8 vCode + 8, -208726556020175.3833@                                   '
  PutMem8 vCode + 16, 619047463818710.1957@                                   '
  PutMem8 vCode + 24, 614891469296457.0453@                                   '
  PutMem8 vCode + 32, -459789095693108.3125@                                  '
  PutMem4 vCode + 40, &HCC2&                                                  '
                                                                              '
  GetMem4 ObjPtr(Me), vTable                                                  'Get the address of the class vTable
                                                                              '
  If GetProcByName(LoadLibraryA("user32"), "IsWindowUnicode") Then            'Is IsWindowUnicode present
    bUnicode = IsWindowUnicode(GetDesktopWindow())                            'Determine whether we'll use the unicode version of LoadLibrary
  End If                                                                      '
End Sub                                                                       '

'Class_Terminate: cleanup the cCallFunc instance
Private Sub Class_Terminate()                                                 '
                                                                              '
  If hModule <> 0 Then                                                        'If a module is loaded
    FreeLibrary hModule                                                       'Free the loaded module
  End If                                                                      '
                                                                              '
  VirtualFree vCode, 0, &H8000&                                               'Free the allocated memory
End Sub

'z_CallFunc: this function's vTable method pointer is patched to point to vCode by CallFunc. Note: this function
'            cannot be moved within this file, it must be the final routine and it must be private.
'
' nAddrParamBlock - address of the parameter block
Private Function z_CallFunc(ByVal nAddrParamBlock As Long) As Long            '
  Debug.Assert False                                                          'Halt if running under the VB IDE
  Err.Raise vbObjectError + 6, ERR_SRC, "DO NOT CALL"                         'Raise error if running compiled
End Function                                                                  '
