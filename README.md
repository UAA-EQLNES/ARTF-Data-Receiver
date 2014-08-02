# ARTF Data Receiver

The ARTF data receiver parses text messages from remote sensors and stores the
data in a sqlite3 database. A lightweight web frontend provides visualizations
in the form of line charts. The software is designed to work on a pcDuino2 with
Linksprite Sim900 GSM Shield.

The software is also designed to operate without an Internet connection. In this
 scenario updates must be applied manually.

## 1. Installation instructions

There are two ways the software can be installed on a pcDuino2.

### 1.1 Install from Github repository

This approach requires an Internet connection to download the repository and
third party dependencies.

**Step 1**

Open LXTerminal by double clicking on the desktop icon. Alternatively,
`CTRL+ALT+T` will also open a terminal.

**Step 2**

Download and run the script by running the following command:

    wget –quiet https://raw.githubusercontent.com/UAA-EQLNES/ARTF-Data-Receiver/master/install-scripts/pcduino-install.sh -O - | bash

**Step 3**

Test if the installation was successful by opening Chromium and navigating to
`http://localhost:5000`. You should see a demo of the dashboard with dummy data.


**Step 4**

The next few steps assume that the LinkSprite Sim900 GSM shield is using the
default baudrate of 19200.

The data receiver expects the GSM shield to listen at a baudrate of 115200. Any
slower and incoming text messages may become garbled.

Make sure the jumpers on the shield are set to hardware serial and that the
red light is on. In addition, the shield will need a SIM card with text message
plan.

**Step 5**

In the terminal, run the following commands:

    cd ~/ARTF-Data-Receiver
    python cmd_tester.py -b 19200

**Step 6**

Once the program starts, type:

    AT+IPR=115200

If you get an `OK`, type:

    exit

**Step 7**

Turn on the `artf-data-receiver` service:

    sudo start artf-data-receiver

You can test that the receiver is working by sending a text message to the
receiver. All incoming messages are logged to a text file. For your convenience
the file can be viewed from the web frontend.

**Step 8**

The latest versions of the pcDuino2 have 4GB of on-board storage, however only
2GB are usable initially. The good news is that this can be fixed by running
a simple script.

[Click here for instructions on how to expand the NAND flash.](http://www.pcduino.com/how-to-enable-full-4gb-nand-flash-memory-on-new-batch-of-pcduino/)

## 2. Configuration

The default settings used by the data receiver and viewer application are
located in the file `default_settings.py`. The default settings are for the d
emo application that uses dummy data. Do not edit the file directly.

Instead create a file called `settings.cfg` in the same directory to override
the defaults.

The following is a quick overview of the settings:

**HOST**

This is the IP address that the server will bind to. `127.0.0.1` configures the
server to be accessible only through pcDuino2 web browser.

Change the the IP address to the one assigned by your DHCP server to make it
viewable by machines on the local network.

Alternatively, you using `0.0.0.0` should also do the trick.

**PORT**

This is the port number that the server will bind to. `5000` is used by default
 since it does not require admin privileges.

You can this to use port `80`, but the start up configuration file will need to
adjusted. This file can be found at `/etc/init/artf-data-viewer.conf`.
You will need to remove the following lines:

    setuid ubuntu
    setgid ubuntu

The settings will not take effect until the pcDuino2 is restarted or you
manually restart the service. This can be using this command:

    sudo restart artf-data-viewer


**SITE_TITLE**

This is displayed on the top of the browser


**REFRESH_INTERVAL**

The interval that the browser polls the server for new data. Default is
`20` minutes.

**SQLITE3\_DB\_PATH**

This is the path to the SQLite database file. By default this points to the
demo database. Change this to the following or something similar:

    SQLITE3_DB_PATH = 'data/artf_sensors.sqlite3'

This will create the database in the `data` directory found the in
`ARTF-Data-Receiver` folder.

**SENSOR_TYPES**

Sensor types provides a description of the data that your sensors will send to
the data receiver application. This information is used to process messages
and label data correctly.

The demo application uses the following sensor types:

    SENSOR_TYPES = (
        ("d", "Water", "distance meters; temperature celsius"),
        ("g", "Gate", "distance meters"),
        ("s", "Soil", "moisture percent; temperature celsius"),
    )

The first parameter is the short identifier sent by your remote sensors. The
 second parameter is human-readable label that is stored in the database. The
 third parameter is a semi-colon separated list that contains the type of
 measurement and the unit of measure for each sensor reading captured and
 sent back.

Each sensor type is wrapped in its own set of parenthesis.

This is a very important setting. If done incorrectly, the data logger will
reject incoming data or label it incorrectly.

**SENSOR_NAMES**

This is an optional field. It's only purpose is to provide human-readable names
to better identify remote sensors

    SENSOR_NAMES = {
        'sensor_0': 'Machu Picchu Sensor',
        'sensor_1': 'Yellowstone Sensor',
        'sensor_2': 'Sagarmatha National Park Sensor',
        'sensor_3': 'Banff Sensor',
    }

In the demo configuration file, the values on the right side will typically be
the phone number associated with the remote sensor, and the value on the left
side is th human readable name.

Make sure to double check that the syntax is correct. Otherwise the server will
not start.

**DATA\_LOGGER\_ERROR\_FILE**

This parameter specifies the location of the log file generated by the data
receiver application. By default it writes to a demo log file located in the
`log` directory of the PcDuino folder.  This should be changed to something
like the following:

    DATA_LOGGER_ERROR_FILE = 'log/artf_sensors.log'

This file is useful for making the sure the data logger is correctly
communicating with the remote sensors.

## 3. Commands to manage services

These services will start on boot, so there is no need to start them yourself.

**Start the data viewer server**

`sudo start artf-data-viewer`

**Restart the data viewer server**

`sudo restart artf-data-viewer`

**Stop the data viewer server**

`sudo stop artf-data-viewer`

**Show the status of the data viewer server**

`sudo status artf-data-viewer`

**Start the data receiver**

`sudo start artf-data-receiver`

**Restart the visualization server**

`sudo restart artf-data-receiver`

**Stop the data receiver**

`sudo stop artf-data-receiver`

**Show the status of the data receiver**

`sudo status artf-data-receiver`

## Appendix A: Create a bootable SD card

This [tutorial](http://www.pcduino.com/for-image-20130513-how-to-backup-nand-to-sd-and-make-sd-bootable/)
describes how to create a bootable SD card image from the pcDuino2.

From there, you may want to save time and reuse image with other pcDuino2s.

One option is to copy the disc image to a computer so that it can be downloaded
and burned to new SD cards later.

The following instructions are for OSX.

**Step 1**

Insert the microSD card that contains the disc image to be copied.

**Step 2**

Open the OSX Terminal app.

**Step 3**

Type the following to get list of disks on your system:

    diskutil list

**Step 4**

Find the path to the microSD. It should be `/dev/disk1` if you aren't using any
other USB/SD drives.

There should also be a path to your hard drive. It should be `/dev/disk0`. Make
sure you do not select the hard drive disk or you could corrupt your operating
system. Be very careful here.

**Step 5**

For step 6, replace `/dev/rdiskX` with the disk you located in step 4.
For example `/dev/rdisk1`.

**Step 6**

    sudo dd if=/dev/rdiskX of=~/Desktop/artf-data-receiver.img bs=1m

## Appendix B: Install from SD card

The pcDuino2 has the option to boot from an SD card.

These instruction are for OSX since the procedure has not been tested on Windows
or Linux yet. The process is similar to what you'd do with a Raspberry Pi disc
image.

These instructions use [Keka](http://www.kekaosx.com/en/) to unzip the disc image.

**Step 1**

Download the `artf-receiver.img.xz` to your Desktop.

**Step 2**

Unzip the file with Keka. Right click on the `artf-receiver.img.xz` file. Select
`Open With` and find Keka.

The image is 4GB uncompressed, so it will take a while to complete.

**Step 3**

Insert a new microSD card. If it is not new you may want to erase it using the
Disk Utility application

**Step 4**

Open the OSX Terminal app.

**Step 5**

Type the following to get list of disks on your system:

    diskutil list

**Step 6**

Find the path to the microSD. It should be `/dev/disk1` if you aren't using any
other USB/SD drives.

There should also be a path to your hard drive. It should be `/dev/disk0`. Make
sure you do not select the hard drive disk or you could corrupt your operating
system. Be very careful here.

A good hint is to look for the disk that is 4GB and not 200+GB

**Step 7**

For step 8, replace `/dev/diskX` with the disk you located in step 6.
For example `/dev/disk1`.

**Step 8**

To unmount the microSD card, type:

    diskutil unmountDisk /dev/diskX

**Step 9**

For step 10, replace `/dev/rdisk1` with the disk you located in step 6. Make sure
you add the "r". For example `/dev/rdisk1`

Also replace `~/Desktop/artf-receiver.img` with the location where you put the
pcduino2 SD card image. This step assumes you moved the file to the Desktop.


**Step 10**

To burn the disc to the microSD card, type:

    sudo dd bs=1m if=~/Desktop/artf-receiver.img of=/dev/rdiskX

**Step 11**

Step 10 should take 10 - 30 minutes

**Step 12**

Once the command finishes, you will probably seen an error message pop up.
Click "Eject".

**Step 13**

The pcDuino2 should now boot from the image on the SD card instead of from
the on-board NAND flash.

**Step 14**

Test if the installation was successful by opening Chromium and navigating to
`http://localhost:5000`. You should see a demo of the dashboard with dummy data.
