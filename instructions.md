# Instructions for EPIC Node Server

On first run the installer will download the Epic chain_data bootstrap file (2.5Gb) into the /root/.epic/main folder, unzip to chain_data, then delete the .zip file. This takes approx 10 minutes depending on your internet connection. You can follow the install process by selecting the Service Logs on the Service Dashboard right after first Start. The Service Logs screen will not show the current status when the node server is running (see below).

Access to the EPIC Node Server is done through ssh. Setup and run ssh, login as user:start9

start9@{hostname}:\~$ sudo docker exec -it epic-node.embassy bash (to enter Docker)

root@epic-node:/# screen -r server-node (attach to screen running EPIC node)

\<ctrl>A then D to detach from screen and back to root@epic-node:/#

root@epic-node:/# exit (to leave Docker)

start9@{hostname}:\~$ exit (to end ssh session)

If the Server is stuck 'Waiting For Peers' then login via ssh and enter Docker. run 'rm -R /root/.epic/main/peer' and restart the Service.

If the blockchain files become corrupted, then login via ssh and enter Docker. run 'rm /root/.epic/main/bs' to download the latest bootstrap again when you restart the Service.


