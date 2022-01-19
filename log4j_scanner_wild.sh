#!/bin/bash

# https://github.com/logpresso/CVE-2021-44228-Scanner
# option parameter for java location? future

COMMON_DIRS=("/var" "/opt" "/swdata" "/swpkg" "/usr")

# find java, if cant, fail
java_path=$(find /usr -type f -name "java" | grep -v 'bash-completion' |  head -n 1)

if [[ -z "$java_path" ]]; then
  java_path=$(find / -not -fstype nfs  -type f -name "java" | grep -v 'bash-completion' |  head -n 1)

fi

if [[ -z "$java_path" ]]; then
    echo "Cannot find java. Pass in location or install openjdk."
    exit 1
fi

if [[ ! -x "$java_path" ]]; then
  echo "Java found in $java_path is not executable. Please pass in a location or install openjdk on the server."
  exit 2
fi

wget -q http://artifactory.company.com/binaries/logpresso/logpresso-log4j2-scan-1.5.0.jar -P /tmp


# skip over nfs or auto mounts from DD
cat /proc/mounts | grep nfs | awk '{print $2}' > /tmp/log4j_avoid.txt
cat /proc/mounts | grep tmpfs | awk '{print $2}' >> /tmp/log4j_avoid.txt

echo "Starting log4j scan..."

timeout 15m nice -n 19 $java_path -jar /tmp/logpresso-log4j2-scan-1.5.0.jar --exclude-config /tmp/log4j_avoid.txt /

rm -rf /tmp/logpresso-log4j2-scan-1.5.0.jar
rm -rf /tmp/log4j_avoid.txt
