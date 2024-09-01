#!/bin/sh

# Configure
henu_account="your_account"
henu_password="your_password"
henu_isp="henulocal" # henudx henult henuyd henulocal
delay="10s"
enable_logging=true  # Log enable switch

# Set secure umask for logs
umask 077

# Get IP address
ip=$(ip addr show dev wlan0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)

# Create log directory if it doesn't exist
mkdir -p log

# Function to log messages
log_message() {
    local message="$1"
    if [ "$enable_logging" = true ]; then
        echo "$message" >> ./log/Network_Log_$(date +%Y_%m_%d).log
    fi
}

# Continuously Checking Network
while true
do
    ping 119.29.29.29 -c 4 # Use 119 DNS as A Server
    status=$?
    Ex_Time=$(date)
    if [ $status = 0 ]
    then
        echo "Connected at $Ex_Time"
        log_message "Connected at $Ex_Time"
        delay="10s"
    else
        echo "-!-!-!- Lost Connect at $Ex_Time"
        log_message "-!-!-!- Lost Connect at $Ex_Time"
        delay="1s"
        echo "-!-!-!- Try Reconnect at $Ex_Time"
        log_message "-!-!-!- Try Reconnect at $Ex_Time"

        # Connect Network by Using cURL
        curl 'http://172.29.35.25:9999/portalAuthAction.do' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
        -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
        -H 'Cache-Control: max-age=0' \
        -H 'Connection: keep-alive' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H "Cookie: userName=$henu_account; $henu_account=$henu_password; useridtemp=$henu_account@$henu_isp; JSESSIONID=8A7BB21A72DA22A74742EF5AC257D10D.worker1" \
        -H 'DNT: 1' \
        -H 'Origin: http://172.29.35.25:9999' \
        -H "Referer: http://172.29.35.25:9999/portalReceiveAction.do?wlanuserip=$ip&wlanacname=HD-SuShe-ME60" \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36' \
        --data-raw "wlanuserip=$ip&wlanacname=HD-SuShe-ME60&chal_id=&chal_vector=&auth_type=PAP&seq_id=&req_id=&wlanacIp=172.22.254.253&ssid=&vlan=&mac=&message=&bank_acct=&isCookies=&version=0&authkey=88----89&url=&usertime=0&listpasscode=0&listgetpass=0&getpasstype=0&randstr=7581&domain=&isRadiusProxy=true&usertype=0&isHaveNotice=0&times=12&weizhi=0&smsid=&freeuser=&freepasswd=&listwxauth=0&templatetype=1&tname=henandaxue_pc_portal_V2.1&logintype=0&act=&is189=false&terminalType=&checkterminal=true&portalpageid=161&listfreeauth=0&viewlogin=1&userid=$henu_account%40$henu_isp&authGroupId=&smsoperatorsflat=&useridtemp=$henu_account%40$henu_isp&passwd=$henu_password" \
        --insecure
        
        Exe_Re=$?
        echo "-!-!-!- cURL Execute Result = $Exe_Re"
        log_message "-!-!-!- cURL Execute Result = $Exe_Re"
    fi
    sleep $delay
done
