#!/bin/bash

if [ -e ~/.epic/main/bs ]
then
	echo "Skipping"
else
	echo "Setting up bootstrap chain_data file..."
	mkdir -p ~/.epic
	mkdir -p ~/.epic/main
	wget https://bootstrap.epic.tech/bootstrap.zip -P ~/.epic/main
	unzip ~/.epic/main/bootstrap.zip -d ~/.epic/main
	rm ~/.epic/main/bootstrap.zip
	touch ~/.epic/main/bs
	cp /epic/* ~/.epic/main
	echo "Done"
fi

exec epic-node
