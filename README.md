# ARTF Data Receiver

The ARTF data receiver parses text messages from remote sensors and stores the
data in a sqlite3 database. A lightweight web frontend provides visualizations
in the form of line charts. The software is designed to work on a pcDuino2 with
Linksprite Sim900 GSM Shield.

The software is also designed to operate without an Internet connection. In this
 scenario updates must be applied manually.

## 1. Installation instructions

There are two ways the software can be installed on a pcDuino2.

## 1.1 Install from Github repository

This approach requires an Internet connection to download the repository and
third party dependencies.

**1.**

Open LXTerminal by double clicking on the desktop icon. Alternatively,
`CTRL+ALT+T` will also open a terminal.

**2.**

Download and run the script by running the following command:

    wget –quiet https://raw.githubusercontent.com/UAA-EQLNES/ARTF-Data-Receiver/master/install-scripts/pcduino-install.sh -O - | bash

**3.**

Test if the installation was successful by opening Chromium and navigating to
`http://localhost:5000`. You should see a demo of the dashboard with dummy data.


**4.**

The next few steps assume that the LinkSprite Sim900 GSM shield is using the
default baudrate of 19200.

The data receiver expects the GSM shield to listen at a baudrate of 115200. Any
slower and incoming text messages may become garbled.

Make sure the jumpers on the shield are set to hardware serial and that the
red light is on. In addition, the shield will need a SIM card with text message
plan.

**5.**

In the terminal, run the following commands:

    cd ~/ARTF-Data-Receiver
    python cmd_tester.py -b 19200

**6.**

Once the program starts, type:

    AT+IPR=1115200

If you get an `OK`, type:

    exit

**7.**

Turn on the `artf-data-receiver` service:

    sudo start artf-data-receiver

You can test that the receiver is working by sending a text message to the
receiver. All incoming messages are logged to a text file. For your convenience
the file can be viewed from the web frontend.

**8.**

The latest versions of the pcDuino2 have 4GB of on-board storage, however only
2GB are usable initially. The good news is that this can be fixed by running
a simple script.

[Click here for instructions on how to expand the NAND flash.](http://www.pcduino.com/how-to-enable-full-4gb-nand-flash-memory-on-new-batch-of-pcduino/)

## Appendix A: Install from SD card

The pcDuino2 has the option to boot from an SD card. A disc image with the
installed software is available, but is out of date.

These instruction are for OSX since the procedure has not been tested on Windows
or Linux yet. The process is similar to what you'd do with a Raspberry Pi image.

These instructions use [Keka](http://www.kekaosx.com/en/) to unzip the disc image.

**1.**

Download the `artf-receiver.img.xz` to your Desktop.

**2.**

Unzip the file with Keka. Right click on the `artf-receiver.img.xz` file. Select
"Open With" and find Keka.

The image is 4GB uncompressed, so it will take a while to complete.

**3.**

Insert a new microSD card. If it is not new you may want to erase it using the
Disk Utility application

**4.**

Open the OSX Terminal app

**5.**

Type the following to get list of disks on your system:

    diskutil list

**6.**

Find the path to the microSD. It should be `/dev/disk1` if you aren't using any
other USB/SD drives.

There should also be a path to your hard drive. It should be `/dev/disk0`. Make
sure you do not select the hard drive disk or you could corrupt your operating
system. Be very careful here.

A good hint is to look for the disk that is 4GB and not 200+GB

**7.**

For step 8, replace `/dev/diskX` with the disk you located in step 6.
For example `/dev/disk1`.

**8.**

To unmount the microSD card disk, type:

    diskutil unmountDisk /dev/diskX

**9.**

For step 10, replace `/dev/rdisk1` with the disk you located in step 6. Make sure
you add the "r". For example `/dev/rdisk1`

Also replace `~/Desktop/artf-receiver.img` with the location where you put the
pcduino2 SD card image. This step assumes you moved the file to the Desktop.


**10.**

To burn the disc to the microSD card, type:

    sudo dd bs=1m if=~/Desktop/artf-receiver.img of=/dev/rdiskX

**11.**

Step 10 should take 10 - 30 minutes

**12.**

Once the command finishes, you will probably seen an error message pop up.
Click "Eject".

**13.**

The pcDuino2 should now boot from the image on the SD card instead of from
the on-board NAND flash.

**14.**

Test if the installation was successful by opening Chromium and navigating to
`http://localhost:5000`. You should see a demo of the dashboard with dummy data.


**15.**

Next, the LinkSprite Sim900 GSM shield needs to be configured to listen 115200.
Before that can be done, the `artf-data-receiver` service must be turned off.

Open a LXTerminal (CTRL+ALT+T) and run the command:

    sudo stop artf-data-receiver


**16.**

Make sure the jumpers on the shield are set to hardware serial and that the
red light is on. In addition, the shield will need a SIM card with text message
plan.

**17.**

In the terminal, run the following commands:

    cd ~/ARTF-Data-Receiver
    python cmd_tester.py -b 19200

**18.**

Once the program starts, type:

    AT+IPR=1115200

If you get an `OK`, type:

    exit

**19.**

Turn on the `artf-data-receiver` service:

    sudo start artf-data-receiver

You can test that the receiver is working by sending a text message to the
receiver. All incoming messages are logged to a text file. For your convenience
the file can be viewed from the web frontend.