# niu-info

Easy Bash-Script to get Live-Informations about you NIU E-scooter using the NIU API.
I ride a NIU N1S 2019 Special Blue (gloss) version.

## How it works
Simply by requesting the NIU API using curl its possible to gain a lot of information about your NIU Scooter. You only need [cURL][curl], [jq][jq], your API-Token (check "How to get your Token" for that) and the Serial-Number of you Scooter.

## Here are some examples using the NIU-API in combination with jq:

##### Request motor_data:
```sh
curl -X GET -H "token: YOURTOKEN" https://app-api-fk.niu.com/v3/motor_data/index_info\?sn=YOURSERIALNUMBER | jq
```

##### Response:
```json
{
  "data": {
    "isCharging": 0,
    "lockStatus": 0,
    "isAccOn": 0,
    "isFortificationOn": "",
    "isConnected": true,
    "postion": {
      "lat": 52.512615,
      "lng": 13.419838333333333
    },
    "hdop": 0,
    "time": 1567101176297,
    "batteries": {
      "compartmentA": {
        "bmsId": "BN1GPC2BXXXXXXXX",
        "isConnected": true,
        "batteryCharging": 68,
        "gradeBattery": "99.2"
      }
    },
    "leftTime": "17.0",
    "estimatedMileage": 39,
    "gpsTimestamp": 1567101176297,
    "infoTimestamp": 1567101176297,
    "nowSpeed": 0,
    "batteryDetail": true,
    "centreCtrlBattery": 100,
    "ss_protocol_ver": 3,
    "ss_online_sta": "1",
    "gps": 3,
    "gsm": 20,
    "lastTrack": {
      "ridingTime": 689,
      "distance": 4235,
      "time": 1567092471296
    }
  },
  "desc": "成功",
  "trace": "成功",
  "status": 0
}
```


##### Request battery_info:
```sh
curl -X GET -H "token: YOURTOKEN" https://app-api-fk.niu.com/v3/motor_data/battery_info\?sn\=YOURSERIALNUMBER
```

##### Response:
```
{
  "data": {
    "batteries": {
      "compartmentA": {
        "items": [
          {
            "x": 0,
            "y": 0,
            "z": 0
          },
          {
            "x": 1,
            "y": 0,
            "z": 0
          },
          ...->
          (cutted for better overview)
          <-...
          {
            "x": 485,
            "y": 0,
            "z": 0
          },
          {
            "x": 486,
            "y": 0,
            "z": 0
          }
        ],
        "totalPoint": 487,
        "bmsId": "BN1GPC2BXXXXXXXX",
        "isConnected": true,
        "batteryCharging": 68,
        "chargedTimes": "8",
        "temperature": 36,
        "temperatureDesc": "normal",
        "energyConsumedTody": 85,
        "gradeBattery": "99.2"
      }
    },
    "isCharging": 0,
    "centreCtrlBattery": "100",
    "batteryDetail": true,
    "estimatedMileage": 39
  },
  "desc": "成功",
  "trace": "成功",
  "status": 0
}
```

##### If you messed something up with the token, this is the response:
```
{
  "data": "",
  "desc": "登录信息错误",
  "trace": "Fail!TOKEN ERROR",
  "status": 1131
}
```


## How to get your Token

In order to log in the NIU cloud to retrieve any data using the API you need the serial number of your niu-scooter and an authentication token. The easiest way to obtain the token (and serial number too) is by capturing the packets from the NIU App (using [Wireshark][wireshark], [mitmproxy][mitmproxy] or any other packet capture software) and extracting the token field from the HTTP header.

I my case i use [mitmproxy][mitmproxy] on Linux together with an Android Device so this tutorial is for that setup:
1. start [mitmproxy][mitmproxy] on your computer, note ip and port (10.0.0.245:8080 in my case)
2. setup proxy on android device in wifi settings ![][proxy-wifi-settings.jpg]
3. open niu app to force a api-get request ![][niu-app-home.jpg]
4. check [mitmproxy][mitmproxy] and search for the request.. ![][mitmproxy-01.jpg]
..and hit return
5. there's your token and serial number (yay \o/) ![][mitmproxy-02.jpg]

6. dont forget to undo your proxy wifi settings :)


[curl]: https://curl.haxx.se
[jq]: https://stedolan.github.io/jq
[wireshark]: https://www.wireshark.org
[mitmproxy]: https://mitmproxy.org

[proxy-wifi-settings.jpg]: https://raw.githubusercontent.com/cascha42/niu-info/master/images/proxy-wifi-setting.jpg
[niu-app-home.jpg]: https://raw.githubusercontent.com/cascha42/niu-info/master/images/niu-app-home.jpg
[mitmproxy-01.jpg]: https://raw.githubusercontent.com/cascha42/niu-info/master/images/mitmproxy-01.jpg
[mitmproxy-02.jpg]: https://raw.githubusercontent.com/cascha42/niu-info/master/images/mitmproxy-02.jpg


# Any questions? Need help?
Feel free to contact me on [Telegram](https://t.me/cascha42) if you need any help or have any questions!
