#!/bin/sh

mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

rm -rf /tmp/v2ray

install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
	"inbounds": [
   {
        "port": 80,
        "listen": "0.0.0.0",
        "protocol": "vmess",
        "settings": {
           "clients": [
            {
              "id": "$UUID",
              "alterId": 64
            }
          ]
        },
        "streamSettings": {
          "network": "tcp",
          "tcpSettings": {
                "connectionReuse": true,
                "header": {
                  "type": "http",
                  "request": {
                        "version": "1.1",
                        "method": "GET",
                        "path": ["/"],
                        "headers": {
                          "Host": ["flv0.bn.netease.com"], 
                          "User-Agent": [
                                "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36",
                                                "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46"
                          ],
                          "Accept-Encoding": ["gzip, deflate"],
                          "Connection": ["keep-alive"],
                          "Pragma": "no-cache"
                        }
                  },
                  "response": {
                        "version": "1.1",
                        "status": "200",
                        "reason": "OK",
                        "headers": {
                          "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash"],
                          "Transfer-Encoding": ["chunked"],
                          "Connection": ["keep-alive"],
                          "Pragma": "no-cache"
                        }
                  ··}
                }
          ··}
        }
    }
],
	"outbounds": [{
		"protocol": "freedom",
		"settings": {
			
		}
	},
	{
		"protocol": "blackhole",
		"settings": {
			
		},
		"tag": "blocked"
	}],
	"routing": {
		"strategy": "rules",
		"settings": {
			"rules": [{
				"type": "field",
				"ip": ["geoip:private"],
				"outboundTag": "blocked"
			}]
		}
	}
}
EOF

/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
