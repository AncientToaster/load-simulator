## Installation ##

The load simulator scripts have a few dependencies:

+ **wget**: To fetch remote network resources
    + To install on Ubuntu, run `sudo apt-get install wget`
    + To install on CentOS 7, run `sudo yum install wget`
+ **stress-ng**: Generates the CPU stress
    + To install on Ubuntu, run `sudo apt-get install stress-ng`
    + To install on CentOS 7, run `wget ftp://ftp.icm.edu.pl/vol/rzm5/linux-opensuse/repositories/server:/monitoring/SLE_11_SP4/x86_64/stress-ng-0.06.02-1.1.x86_64.rpm && sudo rpm -Uvh stress-ng-0.06.02-1.1.x86_64.rpm`

## Invoking the script ##

To run forever, start `initializer.sh` with no arguments:

    bash initializer.sh

To run N times, start `initializer.sh` and specify N as the first argument:

    bash initializer.sh N
    bash initializer.sh 3
    bash initializer.sh 1000

## Program structure ##

Load simulator consists of the following files and folders:

+ **initializer.sh**: A simple shell script that starts the main program loop.
+ **core-loop.sh**: The main program loop, which assigns an ID to the script run and invokes the individual simulation components
    + **cpu.sh**: Starts a few CPU workers.
    + **disk.sh**: Writes a few large files to disk, sleeps, then removes them.
    + **network.sh**: Downloads various web assets, sleeps between each download, then removes all assets.
+ **logs**: Directory to store the log files:
    + **master.log**: Logs when **core-loop.sh**, **cpu.sh**, **disk.sh**, and **network.sh** start or finish their work.
    + **verbose.log**: Logs all activity except storage of individual files from **network.sh**.
    + **cpu.log**: Logs when **cpu.sh** starts or finishes work, and also logs the load percentage and run times.
    + **disk.log**: Logs when **disk.sh** starts or finishes work, and also logs the size and filenames of each created file.
    + **network.log**: Logs when **network.sh** starts or finishes work.
    + **network_files.log**: Logs the storage of individual files downloaded from the web, as defined in the `fetchFromNetwork` function in **network.sh**.

## Feedback and pull requests ##
