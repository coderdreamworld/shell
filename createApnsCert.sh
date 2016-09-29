#!/bin/bash
#================================================================== 
#* 
#* Copyleft, dinner3000 
#* All rights give up. 
#* 
#* 文件名称：createApnsCert.sh 
#* 文件标识： 
#* 摘    要：自动生成推送证书 
#* 作    者：zhulin 
#* 修 改 者：PudgeZhang
#* 修改内容：修改三个中间文件的名字的复杂度 
#* 修改时间：2012-03-21 
#* 版    本：2012-02-01
#* $Id$ 
#* 
#================================================================== 

#依次输入的参数为KeyChain中推送证书生成的p12文件，证书私钥生成的p12文件，最终生成的pem证书文件。若生成的证书有密码，请输入密码（两个p12证书密码必须相同），无密码则不需要输入

NeedEcho=0  #若为1，代表允许打印命令执行过程

if [ $# -lt 3 ]; then
		echo "请分别输入参数：";
		echo "依次输入的参数为KeyChain中推送证书生成的p12文件，证书私钥生成的p12文件，最终生成的pem证书文件。若生成的证书有密码，请输入密码（两个p12证书密码必须相同），无密码则不需要输入";
		exit;
fi

function myEcho		#控制打印Log
{
		if [ $NeedEcho -eq 1 ]; then
				echo $* 
		fi
}

echo $0
echo "$#"
echo "$*"
certPemName="`basename $1 .p12`distinct@#$%.pem"  	#证书的中间文件的名字
keyPemName="`basename $2 .p12`distinct@#$%.pem"		#带密码的私钥的中间文件的名字
keyPemNoencName="`basename $2 .p12`-noencdistinct@#$%.pem"		#生成的无密码的私钥的中间文件名字
password=1234		#私钥中间文件的密码

myEcho "start..."

myEcho "openssl pkcs12 -clcerts -nokeys -out $certPemName -in $1"
res="`openssl pkcs12 -passin pass:$4 -clcerts -nokeys -out $certPemName -in $1 2>&1`"

if [ "$res" != "MAC verified OK" ]; then
		echo $res
		exit;
else
		myEcho $res 
fi

myEcho "openssl pkcs12 -nocerts -out $keyPemName -in $2"
res="`openssl pkcs12 -passin pass:$4 -passout pass:$password -nocerts -out $keyPemName -in $2 2>&1`"

if [ "$res" != "MAC verified OK" ]; then
		echo $res
		exit;
else
		myEcho $res 
fi

myEcho "openssl rsa -in $keyPemName -out $keyPemNoencName"
res="`openssl rsa -passin pass:$password -in $keyPemName -out $keyPemNoencName 2>&1`"
myEcho $res
myEcho "cat $certPemName $keyPemName > $3"
cat $certPemName $keyPemNoencName > $3

echo "create "$3" OK!"
