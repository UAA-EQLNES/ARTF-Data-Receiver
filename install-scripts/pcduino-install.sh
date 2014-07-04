#! /bin/bash

# Settings
HOME_DIR=/home/ubuntu/ARTF-Data-Receiver
DUMMY_DATA_PATH=/tmp/dummy.csv
DUMMY_DB_PATH=$HOME_DIR/data/artf_sensors_demo.sqlite3
INSTALL_FOLDER=$HOME_DIR/install-scripts/pcduino-assets
CHART_DESKTOP_CONF=artf-data-viewer.desktop
LOG_SERVICE=artf-data-receiver
SERVER_SERVICE=artf-data-viewer


echo "Installing ARTF Data Receiver and Viewer..."

echo "Updating system packages..."
sudo apt-get -y update > /dev/null

echo "Installing dependencies: git, sqlite3, and pip..."
sudo apt-get -y install git-core > /dev/null
sudo apt-get -y install sqlite3 > /dev/null
sudo apt-get -y install python-pip > /dev/null

echo "Downloading ARTF Data Receiver and Viewer..."
git clone git://github.com/UAA-EQLNES/ARTF-Data-Receiver $HOME_DIR > /dev/null

echo "Upgrading pip..."
sudo pip install upgrade pip > /dev/null

echo "Install python dependencies from requirements.txt..."
sudo pip install -R $HOME_DIR/requirements.txt > /dev/null

echo "Creating data directory..."
mkdir $HOME_DIR/data > /dev/null

echo "Creating log directory..."
mkdir $HOME_DIR/log > /dev/null

echo "Generating dummy data for demo..."
python $HOME_DIR/dummy_data.py -o $DUMMY_DATA_PATH

echo "Importing dummy data into demo database..."
python $HOME_DIR/csv_importer.py -c $DUMMY_DATA_PATH -d $DUMMY_DB_PATH

echo "Removing dummy data csv file..."
rm $DUMMY_DATA_PATH

echo "Adding configuration for data receiver service..."
sudo cp $INSTALL_FOLDER/$LOG_SERVICE.conf /etc/init/$LOG_SERVICE.conf

echo "Adding configuration for data viewer service..."
sudo cp $INSTALL_FOLDER/$SERVER_SERVICE.conf /etc/init/$SERVER_SERVICE.conf

echo "Creating desktop icon for data viewer web app..."
sudo cp $INSTALL_FOLDER/$CHART_DESKTOP_CONF /usr/share/applications/$CHART_DESKTOP_CONF

echo "Starting data viewer service..."
sudo start $SERVER_SERVICE