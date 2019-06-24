#!/usr/bin/env python
## SET COMPUTER NAMES
import subprocess

config = {
    "C02M7WG0FH00": {
        "ComputerName": "MBP-1313-C07WH0",
        "HostName": "MBP-1313-C07WH0",
        "LocalHostName": "MBP-1313-C07WH0"
    }
}

def scn():
    # Get the serial number
    serialNumber = subprocess.check_output("system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'", shell=True).strip("\n")
    
    # Validate serial number
    if serialNumber and len(serialNumber) == 12:
        print("Status: Valid Serial Number")

        # Check to see if serial number in config
        if serialNumber in config.keys():
            cnset = config[serialNumber]
            print("Status: Config Found")
            print("Status: Setting Computer Name to {}").format(cnset['ComputerName'])

            # Now set the computer name, output displayed to JamfAgent or jumpcloud-agent
            for toSet in cnset:
                subprocess.call(["/usr/sbin/scutil", "--set", toSet, cnset[toSet]])
        else:
            print("Status: Config Not Found, computer name left unchanged")
            exit(1)
    else:
        print("Error: Could not validate serial number")
        exit(2)
            # Set the Computer Name

if __name__ == "__main__":
    # Attempt to set the computer name
    scn()
