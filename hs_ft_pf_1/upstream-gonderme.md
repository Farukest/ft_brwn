## 3. Upstream protocol

### 3.1. Sequence diagram ###

	+---------+                                                    +---------+
	| Gateway |                                                    | Server  |
	+---------+                                                    +---------+
	     | -----------------------------------\                         |
	     |-| When 1-N RF packets are received |                         |
	     | ------------------------------------                         |
	     |                                                              |
	     | PUSH_DATA (token X, GW MAC, JSON payload)                    |
	     |------------------------------------------------------------->|
	     |                                                              |
	     |                                           PUSH_ACK (token X) |
	     |<-------------------------------------------------------------|
	     |                              ------------------------------\ |
	     |                              | process packets *after* ack |-|
	     |                              ------------------------------- |
	     |                                                              |


### 3.2. PUSH_DATA packet ###

That packet type is used by the gateway mainly to forward the RF packets
received, and associated metadata, to the server.

| Bytes  | Function                                                   |
|:------:|------------------------------------------------------------|
|   0    | protocol version = 2                                       |
|  1-2   | random token                                               |
|   3    | PUSH_DATA identifier 0x00                                  |
|  4-11  | Gateway unique identifier (MAC address)                    |
| 12-end | JSON object, starting with {, ending with }, see section 4 |

### 3.3. PUSH_ACK packet ###

That packet type is used by the server to acknowledge immediately all the
PUSH_DATA packets received.

| Bytes | Function                                          |
|:-----:|---------------------------------------------------|
|   0   | protocol version = 2                              |
|  1-2  | same token as the PUSH_DATA packet to acknowledge |
|   3   | PUSH_ACK identifier 0x01                          |

## 4. Upstream JSON data structure

The root object can contain an array named "rxpk":

``` json
{
	"rxpk":[ {...}, ...]
}
```

That object contains the status of the gateway, with the following fields:

| Name |  Type  | Function                                                     |
|:----:|:------:|--------------------------------------------------------------|
| time | string | UTC 'system' time of the gateway, ISO 8601 'expanded' format |
| tacc | number | GPS time accuracy in nanoseconds                             |
| lati | number | GPS latitude of the gateway in degree (float, N is +)        |
| long | number | GPS latitude of the gateway in degree (float, E is +)        |
| alti | number | GPS altitude of the gateway in meter RX (integer)            |
| rxnb | number | Number of radio packets received (unsigned integer)          |
| eha  | number | GPS horizontal accuracy in meters                            |
| eva  | number | GPS vertical accuracy in meters                              |
| sats | number | GPS satellites used for position and time (quantity)         |
| rxok | number | Number of radio packets received with a valid PHY CRC        |
| rxfw | number | Number of radio packets forwarded (unsigned integer)         |
| ackr | number | Percentage of upstream datagrams that were acknowledged      |
| dwnb | number | Number of downlink datagrams received (unsigned integer)     |
| txnb | number | Number of packets emitted (unsigned integer)                 |
| temp | number | Current temperature in degree celcius (float)                |

``` json
{"rxpk":[
	{
		"time":"2013-03-31T16:21:17.528002Z",
		"tmst":3512348611,
		"chan":2,
		"rfch":0,
		"freq":866.349812,
		"stat":1,
		"modu":"LORA",
		"datr":"SF7BW125",
		"codr":"4/6",
		"rssi":-35,
		"lsnr":5.1,
		"size":32,
		"data":"-DS4CGaDCdG+48eJNM3Vai-zDpsR71Pn9CPA9uCON84"
	},{
		"time":"2013-03-31T16:21:17.530974Z",
		"tmst":3512348514,
		"chan":9,
		"rfch":1,
		"freq":869.1,
		"stat":1,
		"modu":"FSK",
		"datr":50000,
		"rssi":-75,
		"size":16,
		"data":"VEVTVF9QQUNLRVRfMTIzNA=="
	},{
		"time":"2013-03-31T16:21:17.532038Z",
		"tmst":3316387610,
		"chan":0,
		"rfch":0,
		"freq":863.00981,
		"stat":1,
		"modu":"LORA",
		"datr":"SF10BW125",
		"codr":"4/7",
		"rssi":-38,
		"lsnr":5.5,
		"size":32,
		"data":"ysgRl452xNLep9S1NTIg2lomKDxUgn3DJ7DE+b00Ass"
	}
]}