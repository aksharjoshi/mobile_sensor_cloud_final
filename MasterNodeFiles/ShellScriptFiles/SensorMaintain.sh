user_id=$1
SensorID=$2
Action=$3
Private_IP=$4
Public_IP=$5

sudo ssh -o "StrictHostKeyChecking no" -i /home/ec2-user/MobileSensorKey1.pem ec2-user@$4 ~/maintainSensor.sh $user_id $SensorID $Action $Private_IP $Public_IP
