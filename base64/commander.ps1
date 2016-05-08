$username = "emailaddress@gmail.com" 
$password = "password goes here" 

$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$to = $username
$from = $username
$subject = $args[0]


$Bytes = [System.Text.Encoding]::Unicode.GetBytes($subject)
$EncodedText =[Convert]::ToBase64String($Bytes)
$subject = $EncodedText

$body = $message|out-string

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password);
$smtp.send($from, $to, $subject, $body)