user_id=$1
Private_IP=$2
SensorType=$3
Public_IP=$4
SensorName=$5


sudo ssh -o "StrictHostKeyChecking no" -i /home/ec2-user/MobileSensorKey1.pem ec2-user@$2 ~/servernode.sh $user_id $Private_IP $SensorType $Public_IP $SensorName
