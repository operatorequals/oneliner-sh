#!/bin/bash


mkdir ~/bin 2>/dev/null

printf "#!/bin/bash\n$(pwd)/oneliner.sh " > /home/$(whoami)/bin/oneliner
echo -n '$*' >> /home/$(whoami)/bin/oneliner
chmod +x ~/bin/oneliner

echo
echo "Done! '/home/$(whoami)/bin/oneliner' bash link created"
echo "Now add the '/home/$(whoami)/bin/' in your PATH variable. Sometimes .bashrc does that automatically."
echo
echo "If not you can run:"
echo -e "->\t 'export PATH=$/home/$(whoami)/bin/:\$PATH', just for this session, or"
echo -e "->\t 'echo export \"PATH=$/home/$(whoami)/bin/:\$PATH\"  >> /home/$(whoami)/.bashrc', for permanent installation"
echo
source ~/.bashrc

