## 5. Downstream protocol

### 5.1. Sequence diagram ###

	+---------+                                                    +---------+
	| Gateway |                                                    | Server  |
	+---------+                                                    +---------+
	     | -----------------------------------\                         |
	     |-| Every N seconds (keepalive time) |                         |
	     | ------------------------------------                         |
	     |                                                              |
	     | PULL_DATA (token Y, MAC@)                                    |
	     |------------------------------------------------------------->|
	     |                                                              |
	     |                                           PULL_ACK (token Y) |
	     |<-------------------------------------------------------------|
	     |                                                              |

	+---------+                                                    +---------+
	| Gateway |                                                    | Server  |
	+---------+                                                    +---------+
	     |      ------------------------------------------------------\ |
	     |      | Anytime after first PULL_DATA for each packet to TX |-|
	     |      ------------------------------------------------------- |
	     |                                                              |
	     |                            PULL_RESP (token Z, JSON payload) |
	     |<-------------------------------------------------------------|
	     |                                                              |
	     | TX_ACK (token Z, JSON payload)                               |
	     |------------------------------------------------------------->|

### 5.2. PULL_DATA packet ###
TÜRKÇE ANLATIM : PULL_DATA
BU PAKET-METHOD TİPİ MINERIN SERVERDAN DATA ÇEKMESİ İŞLEMİDİR
BU DATA ÇEKME İŞLEMİ MINER TARAFINDAN TANIMLANIR, EĞER NAT ARKASINDA OLURSA SERVERIN MINERA PAKET GÖNDERMESİ MÜMKÜN OLMAZ

Cihaz, aktarımı başlattığında, sunucuya giden ağ yolu açılacak ve paketlerin her iki yönde de akmasına izin verecektir.
Sunucunun herhangi bir zamanda kullanılabilmesi için ağ yolunun açık kaldığından emin olmak için cihazın periyodik olarak "PULL_DATA" paketleri göndermesi gerekir.

That packet type is used by the gateway to poll data from the server.

This data exchange is initialized by the gateway because it might be
impossible for the server to send packets to the gateway if the gateway is
behind a NAT.

When the gateway initialize the exchange, the network route towards the
server will open and will allow for packets to flow both directions.
The gateway must periodically send PULL_DATA packets to be sure the network
route stays open for the server to be used at any time.

| Bytes | Function                                |
|:-----:|-----------------------------------------|
|   0   | protocol version = 2                    |
|  1-2  | random token                            |
|   3   | PULL_DATA identifier 0x02               |
| 4-11  | Gateway unique identifier (MAC address) |

### 5.3. PULL_ACK packet ###

TÜRKÇE AÇIKLAMA : PULL_ACK
BU PAKET İŞLEMİ, SERVER TARAFINDAN KULLANILIR VE AĞ YOLU AÇIKMI DİYE PULL_RESP PAKETLERİNİ GÖNDERİP GÖNDEREMEYECEĞİNİ KONTROL EDER

That packet type is used by the server to confirm that the network route is
open and that the server can send PULL_RESP packets at any time.

| Bytes | Function                                          |
|:-----:|---------------------------------------------------|
|   0   | protocol version = 2                              |
|  1-2  | same token as the PULL_DATA packet to acknowledge |
|   3   | PULL_ACK identifier 0x04                          |

### 5.4. PULL_RESP packet ###
TÜRKÇE AÇIKLAMA : PULL_RESP
BU PAKET İŞLEMİ, SERVER TARAFINDAN RF PAKETLERİNİ GÖNDERMEK İÇİN KULLANILIR

That packet type is used by the server to send RF packets and associated
metadata that will have to be emitted by the gateway.

| Bytes | Function                                                   |
|:-----:|------------------------------------------------------------|
|   0   | protocol version = 2                                       |
|  1-2  | random token                                               |
|   3   | PULL_RESP identifier 0x03                                  |
| 4-end | JSON object, starting with {, ending with }, see section 6 |

### 5.5. TX_ACK packet ###

That packet type is used by the gateway to send a feedback to the server
to inform if a downlink request has been accepted or rejected by the gateway.
The datagram may optionnaly contain a JSON string to give more details on
acknoledge. If no JSON is present (empty string), this means than no error
occured.

| Bytes  | Function                                                              |
|:------:|-----------------------------------------------------------------------|
|   0    | protocol version = 2                                                  |
|  1-2   | same token as the PULL_RESP packet to acknowledge                     |
|   3    | TX_ACK identifier 0x05                                                |
|  4-11  | Gateway unique identifier (MAC address)                               |
| 12-end | [optional] JSON object, starting with {, ending with }, see section 6 |

## 6. Downstream JSON data structure

The root object of PULL_RESP packet must contain an object named "txpk":

``` json
{
	"txpk": {...}
}
```





That object contain a RF packet to be emitted and associated metadata with the
following fields:

| Name |  Type  | Function                                                         |
|:----:|:------:|------------------------------------------------------------------|
| imme |  bool  | Send packet immediately (will ignore tmst & tmms)                |
| tmst | number | Send packet on a certain timestamp value (will ignore tmms)      |
| tmms | number | Send packet at a certain GPS time (GPS synchronization required) |
| freq | number | TX central frequency in MHz (unsigned float, Hz precision)       |
| rfch | number | Concentrator "RF chain" used for TX (unsigned integer)           |
| powe | number | TX output power in dBm (unsigned integer, dBm precision)         |
| modu | string | Modulation identifier "LORA" or "FSK"                            |
| datr | string | LoRa datarate identifier (eg. SF12BW500)                         |
| datr | number | FSK datarate (unsigned, in bits per second)                      |
| codr | string | LoRa ECC coding rate identifier                                  |
| fdev | number | FSK frequency deviation (unsigned integer, in Hz)                |
| ipol |  bool  | Lora modulation polarization inversion                           |
| prea | number | RF preamble size (unsigned integer)                              |
| size | number | RF packet payload size in bytes (unsigned integer)               |
| data | string | Base64 encoded RF packet payload, padding optional               |
| ncrc |  bool  | If true, disable the CRC of the physical layer (optional)        |


``` json
{"txpk":{
	"imme":true,
	"freq":864.123456,
	"rfch":0,
	"powe":14,
	"modu":"LORA",
	"datr":"SF11BW125",
	"codr":"4/6",
	"ipol":false,
	"size":32,
	"data":"H3P3N2i9qc4yt7rK7ldqoeCVJGBybzPY5h1Dd7P7p8v"
}}