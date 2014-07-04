#! /bin/bash

# Settings
HOME_DIR=/home/ubuntu/ARTF-Data-Receiver
RECEIVER_SERVICE=artf-data-receiver
VIEWER_SERVICE=artf-data-viewer

echo "Updating ARTF Data Receiver..."
cd $HOME_DIR
git pull


echo "Resarting ARTF Data Receiver Service..."
sudo stop $RECEIVER_SERVICE
sudo start $RECEIVER_SERVICE

echo "Resarting ARTF Data Viewer Service..."
sudo stop $VIEWER_SERVICE
sudo start $VIEWER_SERVICE

echo "Update completed! Restart data viewer to see latest changes."