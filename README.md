# MyLab

## Overview
The aim of this project is to make it easy to stand up an lab enbironment that can be used for multiple purposes.
The key features will be a fully configured domain with multiple clients and users.
The lab will be setup and configures view the AutomatedLab module.

## Systems
1x Windows Server 2019 (Domain Controller)
1x Windows Server 2019 (Router to internet)
2x Windows 10

### System Details
- Domain users will be able to RDP on to Clients
- Domain users will have local admin proveliges
- All systems will be left at their default hardening configuratin

## Installation
1. Clone the repo and run setup.ps1
```
git clone https://github.com/Status-418/HomeLab.git
cd HomeLab
./setup.ps1
```
- If Hyper-V was not installed a reboot is required now.
```
Restart-Comput
```
2. After restarting opne Hyper-V and create a virtual switch named 'Internet' and assigne it an adapter that can communicate with the internet
3. If you do not habe an ISO for Windows 10 and Windows Server 2019 you can run `New-MyLabISO` to get details on how to obtain the required ISOs.
    Once downloaded pace them in the folder `C:\LabSources\ISOs\` and name them `Windows 10.iso` and `Windows Server 2019.iso` respectivly.
```
Import-Module -name MyLab
Invoke-MyLab
```

## First Run
Before starting up the lab ensure there is ISO files for Windows 10 (tiral) and Windows Server 2019 (trial) located in the C:\LabResources\ISOs\ folder. If you don't have them handy use the New-MyLabISO from the MyLab module to download them.
Also a Office 2013 iso file needs to be located in the C:\LabResouces\Software folder. Please downlod this manually.

## Overview
```
+--Host Computer----------------------------------------------------------------------+
|                                                                                     |
| +--Hyper-V------------------------------------------------------------------------+ |
| |                                                                                 | |
| | +--Hyper-V Internal Only Network--------------+  +--Hyper-V External Network--+ | |
| | |                                             |  |                            | | |     +-Internet-+
| | | +--DC1----------------------+  +--Router1---+--+-----------+                | | |     |          |
| | | |                           |  |                           |            +------------>+          |
| | | | 172.16.100.1              |  | 172.16.100.254       DHCP |                | | |     |          |
| | | |                           |  |                           |                | | |     +----------+
| | | |                           |  |                           |                | | |
| | | |                           |  |                           |                | | |
| | | |                           |  |                           |                | | |
| | | +---------------------------+  +------------+--+-----------+                | | |
| | |                                             |  |                            | | |
| | | +--Client1------------------+               |  |                            | | |
| | | |                           |               |  |                            | | |
| | | | 172.16.100.101            |               |  |                            | | |
| | | |                           |               |  |                            | | |
| | | |                           |               |  |                            | | |
| | | |                           |               |  |                            | | |
| | | |                           |               |  |                            | | |
| | | +---------------------------+               |  |                            | | |
| | |                                             |  |                            | | |
| | +---------------------------------------------+  +----------------------------+ | |
| +---------------------------------------------------------------------------------+ |
+-------------------------------------------------------------------------------------+
