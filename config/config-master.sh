echo "This is master"
# ip of this box
IP_ADDR=`ifconfig eth1 | grep inet | awk '{print $2}'| cut -f2 -d: | tr -d '\n'`

# install k8s master
HOST_NAME=$(hostname -s)

kubeadm init --apiserver-advertise-address=$IP_ADDR --apiserver-cert-extra-sans=$IP_ADDR  --node-name $HOST_NAME --pod-network-cidr=192.168.0.0/16