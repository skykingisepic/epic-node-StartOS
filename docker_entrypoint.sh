#!/bin/bash

if [ -e ~/.epic/main/bs ]
then
	echo "Starting Epic Node Server..."
else
	echo "Setting up bootstrap chain_data file..."
	mkdir -p ~/.epic
	mkdir -p ~/.epic/main
	wget https://bootstrap.epic.tech/bootstrap.zip -P ~/.epic/main
	unzip ~/.epic/main/bootstrap.zip -d ~/.epic/main
	rm ~/.epic/main/bootstrap.zip
	touch ~/.epic/main/bs
	echo "Done"
fi

cp /epic/* ~/.epic/main
locale-gen en_US.UTF-8
/bin/screen -dmS node-server /usr/local/bin/epic-node
tail -f /dev/null


