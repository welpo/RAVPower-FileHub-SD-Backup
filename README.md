RAVPower FileHub SD Card backup
===============================

This collection of scripts automate functionality for copying and backing up files using a [RAVPower Filehub](http://amzn.to/2kPs6y7). Made for the WD01 Version of the Filehub but seems to work on WD02 and WD03 models as well.


This version is a variant of the [original scripts](https://github.com/digidem/filehub-config) which suits better my requirements and is intended for traveling photographers that want to backup their SD cards to a portable harddrive. This particular fork adds the ability to backup audio recordings from a Tascam DR-05 and other recorders that use the same folder structure.

This guide is bare of many of the technical descriptions, so if you are interested in these checkout the original page.

## Features

- Change the default password of the FileHub
- Block external network access
- Copy files from SD Card to USB drive automatically
- Backup / sync to a secondary USB drives
- Custom SD card folder names (advanced)

## Caveats

- This script is only tested with the WD01 Version of the Filehub - now discontinued. If you have a newer version use at your own discretion - let me know if it works
- Filehub's is buggy in relation to timestamps - see manual fix below

---

## How to hack the Filehub embedded Linux

The easiest way to "hack" / modify the configuration of the RAVPower Filehub is to create a script `EnterRouterMode.sh` on an SD card and put the card in the Filehub. The current firmware (2.000.004) will execute a script with this name when the Filehub starts.

These are the steps to add the backup functionality to your Filehub.


#### Step 1 - Copy Scripts to your computer

If you are familiar with Git/Github you can skig to the next section 😄

If you don't know what Git/Github is and you came to this page by other means, just look for the **Clone or download** button and download the ZIP and unpack it in a folder.

You will most likely only need the folder `changepassword` and `sdbackup`, so forget about the rest for now.

#### Step 2 - Security Fix the FileHub

The default root password on RAVPower Filehub devices is 20080826. This is available on several online forums. Best change it.

* Modify the script `EnterRouterMode.sh` in the Folder `changepassword` with your presonal password
* Copy the script it to the top-level folder of an SD card, and insert it into the filehub device
* Turn the FileHub on.

The FileHub will flash the leds for a while and when you see everything is still turn off the device.

#### Step 3 - Add SD Card Backup functionality to FileHub

Even easier than step 2

* Copy the the script `EnterRouterMode.sh` in the Folder `sdbackup` to the top-level folder of an SD card, and insert it into the filehub device
* Turn the FileHub on.

The FileHub will flash the leds for a while and when you see everything is still turn off the device.


#### Step 4 - Prepare primary backup drive

Make sure your backup drive is formated in a way that makes it easy for the FileHub and your computer to read it. I use exFAT as I am platform agnostic.

Once your ready, just copy the folder `sdcopies` as a top-level folder on your drive.


Alternatively, you can do this manually:

* create a folder in the top-level folder of the drive called `sdcopies`
* create two folders inside `sdcopies` called `config` and `photos`
* copy the file `rsync` (which you can find in the project folder `tools`) to `sdcopies/config`

Your structure should look like this:

```sh
sdcopies
  |__config
  |   |rsync
  |
  |__photos

```

#### Step 5 - Prepare your secondary backup drive (optional)

If you are paranoid like me, you want to make a second copy to another drive.

* create a folder in the top-lever folder of the drive called `PhotoBackup`


---

## How to use it

Your FileHub is now ready - here are some guides how to use it and what to look out for.

#### Backup SD to usb drive

1. Make sure your filehub is charged and/or connected to a USB power plug (not a computer)
2. Make sure your SD card is **not write protected**
3. Insert your SD card into the FileHub
4. Plug in USB drive and wait a couple of seconds
5. Turn on FileHub
6. FileHub copies the sd card ... wait until none of the leds flashes for 1 minute
7. Turn off FileHub

You can now continue to use the SD card and the FileHub will only copy the new files the next time you backup your SD card.

You are free to format the sd card If you did not choose to create custom sd card names. The Filehub will recognize the card as a new one and create a new folder for it.

#### Backup usb drive to secondary backup drive

You will need a powered USB Hub for this functionality. There are plenty out there, but I recommend the **[Anker Ultra Slim 4 Port - Including Power Adapter](http://amzn.to/2kttmG8)**. It's very compact and it can be powered via Micro-USB, which means you can power it with a brick or a batterypack.

PS: You will need to buy the version with the power brick to get the Micro-USB port - the solo version doesn't include it.

1. Make sure your filehub is charged and/or connected to a USB power plug (not a computer)
2. Connect the powered USB Hub to the FileHub
3. Connect both USB Drives to the Hub
5. Turn on FileHub
6. FileHub syncs the two USB Drives ... wait until none of the leds flashes for 1 minute
7. Turn off FileHub

Tip: You can backup and sync to a second drive in one go if you want - the FileHub will copy the files to the first drive first and then make the second copy.

#### Some Tips

* Make sure you give the Filehub enough time - even though it's reasonably fast, it can take hours for a full 32gig card
* Always turn off the FileHub before unplugging the drives and SD cards
* Get yourself a small puch to store the Filehub, the drives, the USB-Hub and the cables - I use an old toilet bag.


#### Fixing timestamps of your backups

If you want to import from the backups itself into Lightroom you will run into the problem that the dates of the files on the backup are wrong. Filehub doesn't allow rsync to transfer the original dates. This is not really a problem for Lightroom as the capture date is inside the file, but you will not know see before you import what date you are importing.

You can fix that problem easily with a tool called "[Exiftool](https://sno.phy.queensu.ca/~phil/exiftool/index.html)" which is available for free for Mac and Windows.

It's a command line tool with many options - but I will give you a shortcut here :)

* Open the terminal / command prompt in the folder sdcopies/photos
* Enter `exiftool "-FileModifyDate<DateTimeOriginal” ./* -rv`

Exiftool will read the original capture time from the files and modify the timestamp for you in all folders.

---

## Advanced - Customize your SD cards (optional)

The script will automatically creates folders for each sd card with a random name. This works great, but if you want to recognize immediately what is in the folders on your drive you can customize the folder names quite easily.

* create a textfile on each SD card called `sdname.txt`
* enter the name of the folder in the first line - e.g. `sandisk32gig01`
* repeat for every sd card, but make sure that **every name is unique**

That's it. Just make sure that you don't format the sd card. But I guess you want to keep the files on the card until you are safe at home, right? 😄

---

## Addendum - What is with the other files in the main folder?

The files in the folder are the modules that can be made into the combined script you find in the folder `sdcopies` - they are separated to make them easier to read.

If you know what you are doing, you can change the folder names and add some functionality ... but on your own risk - and I guess if you know was a makefile is than you are knowledgeable enough and I wish you good luck.

---

## What about the log folder?

I included logging what is actually copied. You will find that information in the file rsync_log and the stdout file in the log folder. You can delete the file if it gets too big or send it too me if you run into problems.

--

## Changelog

20180215
* Better logging
* include Sony Files and other changes - Thank you @dreamnid

20171205
* Added logging to rsync
* Updated documentation with instructions on how to fix the date issue manually

20170201
* First updated version with better documentation
