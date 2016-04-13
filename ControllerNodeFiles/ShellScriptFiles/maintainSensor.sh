user_id=$1
SensorID=$2
Action=$3
Private_IP=$4
Public_IP=$5


pass='dbuser281'
username='dbuser281'
host_name="dbuser281.ce33w8tbbsot.us-west-2.rds.amazonaws.com"
db1="dbuser281"


ProcessID=`mysql --skip-column-names --host=$host_name --user=$username --password=$pass dbuser281 << EOF
select processId from sensor_dtls_tbl where sensorId=$SensorID and userid=$user_id;
EOF`


if [ "$Action" = "Stop" ] || [ "$Action" = "Terminate" ]
then
	if [ "$Action" = "Stop" ]
	then
		kill -9 $ProcessID

#Update Sensor State in Database
mysql --host=$host_name --user=$username --password=$pass dbuser281 << EOF
update sensor_dtls_tbl set sensorstate='Stopped' where sensorId=$SensorID and userid=$user_id;
EOF
fi


        if [ "$Action" = "Terminate" ]
        then
                kill -9 $ProcessID

#Update Sensor State in Database
mysql --host=$host_name --user=$username --password=$pass dbuser281 << EOF
update sensor_dtls_tbl set sensorstate='Terminated' where sensorId=$SensorID and userid=$user_id;
EOF
fi

fi


if [ "$Action" = "Start" ]
then
SensorType=`mysql --skip-column-names --host=$host_name --user=$username --password=$pass dbuser281 << EOF
select sensorType from sensor_dtls_tbl where sensorId=$SensorID and userid=$user_id;
EOF`

SensorName=`mysql --skip-column-names --host=$host_name --user=$username --password=$pass dbuser281 << EOF
select sensorname from sensor_dtls_tbl where sensorId=$SensorID and userid=$user_id;
EOF`

nohup java8 -jar sensor.jar $SensorID $SensorType $SensorName &> /dev/null &
ProcessID=$!


#Update Sensor State in Database
mysql --host=$host_name --user=$username --password=$pass dbuser281 << EOF
update sensor_dtls_tbl set sensorstate='Running', processId=$ProcessID where sensorId=$SensorID and userid=$user_id;
EOF

fi
