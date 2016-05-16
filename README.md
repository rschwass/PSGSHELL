# PSGSHELL
I would like to give special thanks to John Strand, Black Hills Information Security (http://www.blackhillsinfosec.com/) and byt3bl33d3r (https://github.com/byt3bl33d3r)
Version .0 Release

This version and all future versions will only support the base64 encoded messages.

PSGSHELL is now a full Powershell Module, that includes the following CMDLETS. 

#Setup and Installation
All you need to download is the PSGSHELL.psm1 file to start having fun.

You will need gmail account with insecure apps allowed.

Send-PSGCommand -EmailAddress <test@gmail.com> -Password <password> -CLIENTLIST <11111:232245:432243:> -Command <Powershell V2 Command> 


Notes: All paramaters required. Client list should be separated by colons


New-PSGPayload -EmailAddress <test@gmail.com> -Password <password> -ClientID <ID For Client> -Type <macro or batch> -OutFile <full path to output>

Notes: ClientID should be a unique 6 character string. Macro will need to be copied from output file into excel. Batch script can also be powershell.



#How it Works
PSGShell communicates using GMAIL. The Client parses the GMAIL RSS feed of the account and runs the commands in the subject line on the remote systems.
The client then sends back the results of that command.
The Default beacon time is 15 seconds, but can easily be changed by editing the "Start-Sleep -s 15" value to some other length.
I plan on making this an option to specify when making payloads in the future.

#Payloads
The payloads all consist of a powershell single line commands removing the need to override execution policy.