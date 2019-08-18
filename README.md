# niu-info

Script to get Infos from you NIU e-scooter.


## How to get Token

In order to log in the NIU cloud to check the SoC of the battery, the serial number of the scooter and an authentication token are required. Currently this project doesn't include a login page, so the easiest way to obtain the token is by capturing the packets from the NIU App (using Wireshark or some mobile packet capture app) and extracting the token field from the HTTP header.
