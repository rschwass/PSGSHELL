$username = "emailaddres@gmail.com" 
$password = "password goes here" 

$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$to = $username
$from = $username
$subject = $args[0]
$body = $message|out-string

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password);
$smtp.send($from, $to, $subject, $body)