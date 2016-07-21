## Install the Script ##

To install, you need to clone this repo from GitHub, install a few dependencies, and provide a list of network files to download. This script requires Bash 4 or higher.

1. Clone the script from GitHub:

        git clone https://github.com/AncientToaster/load-simulator

    To install the dev branch instead, clone the main repo and then check out the dev branch:

        git clone https://github.com/AncientToaster/load-simulator && cd load-simulator && git checkout dev

1. Install **wget**, which fetches network resources:
    + On Ubuntu, run:

            sudo apt-get install wget -y

    + On CentOS 7, run:

            sudo yum install wget -y

2. Install **stress-ng**, which generates the artificial CPU load:
    + On Ubuntu 14+, run:

            sudo apt-get install stress-ng -y
        
    + On Ubuntu 12, run:

            wget http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.06.07.tar.gz && tar -xzf stress-ng-0.06.07.tar.gz && cd stress-ng-0.06.07 && make && sudo make install

    + On CentOS 7, run:

            wget ftp://ftp.icm.edu.pl/vol/rzm5/linux-opensuse/repositories/server:/monitoring/SLE_11_SP4/x86_64/stress-ng-0.06.02-1.1.x86_64.rpm && sudo rpm -Uvh stress-ng-0.06.02-1.1.x86_64.rpm

3. Customize the array of network resources listed in **network.config**.

## Invoke the Script ##

To run forever, start `initializer.sh` with no arguments:

    bash initializer.sh

To run N times, start `initializer.sh` and specify N as the first argument:

    bash initializer.sh N
    bash initializer.sh 10
    bash initializer.sh 180

If you're connected to your host over SSH, you may need to do something more elaborate to keep the script running even if your SSH session terminates:

    nohup bash initializer.sh </dev/null >/dev/null 2>&1 &

## Configure the Simulator ##

## Program Structure ##

Load simulator consists of the following files and folders:

+ **initializer.sh**: A simple shell script that starts the main program loop.
+ **core-loop.sh**: The main program loop, which assigns an ID to the script run and invokes the individual simulation components (located in `/scripts`):
    + **cpu.sh**: Starts two CPU workers, each of which generates variable amounts of load. The run time for CPUJ1 (480 to 720 seconds) determines the overall run time for the iteration
    + **disk.sh**: Writes a few large files to disk, sleeps, then removes them.
    + **network.sh**: Downloads various web assets, sleeps between each download, then removes all assets.
    + **ram.sh**: Occupies 75 to 275 MB of RAM for a variable amount of time, in two stages.
+ **logs**: Directory to store the log files:
    + **master.log**: Logs when **core-loop.sh**, **cpu.sh**, **disk.sh**, and **network.sh** start or finish their work.
    + **verbose.log**: Logs all activity except storage of individual files from **network.sh**.
    + **cpu.log**: Logs when **cpu.sh** starts or finishes work, and also logs the load percentage and run times.
    + **disk.log**: Logs when **disk.sh** starts or finishes work, and also logs the size and filenames of each created file.
    + **ram.log**: Logs when **ram.sh** starts or finishes work, and also logs the amount of RAM loaded and run times.
    + **network.log**: Logs when **network.sh** starts or finishes work.
    + **network_files.log**: Logs the storage of individual files downloaded from the web, as defined in the `fetchFromNetwork` function in **network.sh**.
+ **primary.config**: Control the behavior of the load simulator script.
+ **network.config**: Define a list of web resources for the network simulator script to download.
+ **network-files**: Directory where **network.sh** stores its temporary files
+ **disk-files**: Directory where **disk.sh** stores its temporary files

## Watching the Logs ##

There are a number of logs, but the best one to watch to get everything is verbose.log:

    cd load-simulator/logs/ && watch tail -25 verbose.log 

## Cleanup and Leftover Files ##

When set to run forever, the simulator often leaves behind extra files when terminated. 

To remove these extra files, use **cleanup.sh**:

    bash cleanup.sh

## Feedback and pull requests ##
