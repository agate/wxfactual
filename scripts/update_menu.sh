#!/bin/bash

DIR=`dirname $0`

APPID=`cat $DIR/../config/app.yml | grep appid | sed "s/appid: *//"`
SECRET=`cat $DIR/../config/app.yml | grep secret | sed "s/secret: *//"`
GET_TOKEN_URL=https://api.weixin.qq.com/cgi-bin/token
CREATE_MENU_URL=https://api.weixin.qq.com/cgi-bin/menu/create

ACCESS_TOKEN=`curl -s "$GET_TOKEN_URL?grant_type=client_credential&appid=$APPID&secret=$SECRET" | jq .access_token -r`

curl -d @$DIR/../config/menu.json -X POST "$CREATE_MENU_URL?access_token=$ACCESS_TOKEN"
