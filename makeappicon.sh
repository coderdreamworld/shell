#!bin/bash

echo "输入png源文件，输出AppIcon.appiconset文件夹"

#输入参数
if [ $# -lt 1 ];then
  echo  'Error!输入png源文件名'
  exit 2
fi

echo $1

extension="${1##*.}"
echo $extension

if [ "$extension" == "png" ]; then
  echo "输入为png"
else
  echo "输入源文件不正确"
fi

##############################

Pho='iphone'
Pd='ipad'
path='./AppIcon.appiconset'

sizes=(20 20)
idoms=($Pho $Pho)
scales=(2 3)

sizes=(29 29 29)
idoms=($Pho $Pho $Pho)
scales=(1 2 3)

sizes+=(40 40 40)
idoms+=($Pho $Pho $Pho)
scales+=(1 2 3)

sizes+=(57 57)
idoms+=($Pho $Pho)
scales+=(1 2)

sizes+=(60 60 60)
idoms+=($Pho $Pho $Pho)
scales+=(1 2 3)

sizes+=(76)
idoms+=($Pho)
scales+=(1)

sizes+=(20 20)
idoms+=($Pd $Pd)
scales+=(1 2)

sizes+=(29 29)
idoms+=($Pd $Pd)
scales+=(1 2)

sizes+=(40 40)
idoms+=($Pd $Pd)
scales+=(1 2)

sizes+=(76 76 76)
idoms+=($Pd $Pd $Pd)
scales+=(1 2 3)

sizes+=(83.5)
idoms+=($Pd)
scales+=(2)

#json文件
jsonoutput="{\n \"images\" : [\n"


##############################

#创建文件夹
if [ ! -d $path ]; then
  mkdir -p $path
fi


len=${#sizes[@]}
echo $len

#循环
for ((i=0;i<$len;i++));
do
echo ${sizes[$i]}
echo ${idoms[$i]}
echo ${scales[$i]}


#expr decimal number
realSize=$(echo "${sizes[$i]} * ${scales[$i]}" | bc)

echo $realSize

#拼接图片名
filename='Icon-App-'${sizes[$i]}'x'${sizes[$i]}'@'${scales[$i]}'x.png'

echo $filename

#拷贝源图片
cp $1 ./$path/$filename

#图片尺寸压缩
sips -Z $realSize ./$path/$filename

jsonoutput=$jsonoutput"\t\t{\n\t\t\t\"size\" : \"${sizes[$i]}x${sizes[$i]}\",\n"
jsonoutput=$jsonoutput"\t\t\t\"idiom\" : \"${idoms[$i]}\",\n"
jsonoutput=$jsonoutput"\t\t\t\"filename\" : \"$filename\",\n"


if [ $i -eq `expr $len - 1` ];then
  jsonoutput=$jsonoutput"\t\t\t\"scale\" : \"${scales[$i]}x\"\n\t\t}\n"
else
  jsonoutput=$jsonoutput"\t\t\t\"scale\" : \"${scales[$i]}x\"\n\t\t},\n"
fi

done #循环结束

jsonoutput=$jsonoutput"\t],\n"

jsonoutput=$jsonoutput"\t\"info\" : {\n"
jsonoutput=$jsonoutput"\t\t\"version\" : 1,\n"
jsonoutput=$jsonoutput"\t\t\"author\" : \"xcode\"\n"
jsonoutput=$jsonoutput"\t}\n"
jsonoutput=$jsonoutput"}"


echo $jsonoutput > ./$path/Contents.json
