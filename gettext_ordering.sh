#!/usr/bin/bash

cat empty.po | while read -r line
do  
  if [[ ${line:0:1} == "#" ]]
  then
#    echo "${line}" | sed -e 's/\\/\//g' # 118.54 secs
    echo "${line}" | tr '\\' '/' # 118.69 secs
  else
    echo -E "${line}"
  fi
done  > empty_new.po;

