user_id=$1
Privet_IP=$2
SensorType=$3
Public_IP=$4
SensorName=$5

pass='dbuser281'
username='dbuser281'
host_name="dbuser281.ce33w8tbbsot.us-west-2.rds.amazonaws.com"
db1="dbuser281"

echo "here" > output.txt

#get Sensor ID
sensorid=`mysql --skip-column-names --host=$host_name --user=$username --password=$pass dbuser281 << EOF
select sensor_count_id from Sensor_id;
EOF`

nohup java8 -jar sensor.jar $sensorid $SensorType $SensorName &> /dev/null &
ProcessID=$!

#Insert System State in Database
mysql --host=$host_name --user=$username --password=$pass dbuser281 << EOF
update Sensor_id set sensor_count_id = sensor_count_id + 1;
EOF

#Add sensor entry in db
mysql --host=$host_name --user=$username --password=$pass dbuser281 << EOF
insert into sensor_dtls_tbl (sensorId, sensorname, sensorType, sensorstate, userid, processId, Private_IP, Public_IP) values('$sensorid','$SensorName','$SensorType', "Started", '$user_id','$ProcessID','$Privet_IP','$Public_IP');
EOF
