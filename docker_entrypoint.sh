#!/bin/bash

if [ -e ~/.epic/main/bs ]
then
	echo "chain_data exists - no bootstrap needed..."
else
	echo "Setting up bootstrap chain_data file..."
	mkdir -p ~/.epic
	mkdir -p ~/.epic/main
	wget https://bootstrap.epiccash.com/bootstrap.zip -P ~/.epic/main
	rm -R ~/.epic/main/chain_data
	unzip ~/.epic/main/bootstrap.zip -d ~/.epic/main
	rm ~/.epic/main/bootstrap.zip
	touch ~/.epic/main/bs
	echo "Done"
fi
echo "Setting locale and Starting Node Server..."
cp /epic/* ~/.epic/main
locale-gen en_US.UTF-8
/bin/screen -dmS node-server /usr/local/bin/epic-node
tail -f /dev/null


