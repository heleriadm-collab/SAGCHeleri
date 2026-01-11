Option Explicit

Dim fso, filePath, file, content
Dim rules, rule, re
Dim i

' ===============================
' Validação de parâmetro
' ===============================
If WScript.Arguments.Count = 0 Then
    WScript.Echo "Uso: cscript ajustes.vbs <arquivo>"
    WScript.Quit 1
End If

filePath = WScript.Arguments(0)

Set fso = CreateObject("Scripting.FileSystemObject")

If Not fso.FileExists(filePath) Then
    WScript.Echo "Arquivo não encontrado: " & filePath
    WScript.Quit 1
End If

' ===============================
' Leitura do arquivo (encoding nativo)
' ===============================
Set file = fso.OpenTextFile(filePath, 1)
content = file.ReadAll
file.Close

' ===============================
' DEFINIÇÃO DAS REGRAS DE AJUSTE
' ===============================
' rules = Array( _
'     Array("regex", "<a\s+href=""\.\.\/2026", "<a href=""../diario/2026", True, True), _
'     Array("text", "->-", "#") _
' )
rules = Array( _
    Array("regex", "<a\s+href=""\.\.\/2026", "<a href=""../diario/2026", True, True), _
    Array("text", "->-", "#"), _
    Array( _
        "regex", _
        "<p>\s*<a\s+href=""\.\.\/diario\/", _
        "<p style=""margin-top:10px;padding-top:15px;border-top: solid 1px black;""><a href=""../diario/", _
        True, _
        False _
    ) _
)



' ===============================
' EXECUÇÃO DAS REGRAS
' ===============================
For i = 0 To UBound(rules)

    rule = rules(i)

    If rule(0) = "regex" Then
        Set re = New RegExp
        re.Pattern    = rule(1)
        're.Replacement = rule(2)
        re.Global     = rule(3)
        re.IgnoreCase = rule(4)

        content = re.Replace(content, rule(2))

    ElseIf rule(0) = "text" Then
        content = Replace(content, rule(1), rule(2))
    End If

Next

' ===============================
' Grava arquivo
' ===============================
Set file = fso.OpenTextFile(filePath, 2)
file.Write content
file.Close

WScript.Echo "Ajustes aplicados com sucesso em: " & filePath
