#!/bin/sh

if [ -e ~/.epic/main/bs ]
then
else
	echo "Setting up bootstrap chain_data file..."
	wget https://epiccash.s3.sa-east-1.amazonaws.com/mainnet.zip -P ~/.epic/main
	unzip ~/.epic/main/mainnet.zip -d ~/.epic/main
	rm ~/.epic/main/mainnet.zip
	touch ~/.epic/main/bs
	echo "Done"
fi

exec tini epic-node
