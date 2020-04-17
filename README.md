# kubeadm-simple
Simple Kubeadm deploiment with Vagrant and VirtualBox

## How to Run

```
vagrant up
```

Once vagrant up finish

```
vagrant ssh master-1
kubeadm token create --print-join-command
```

Something like this will appear :

```
 kubeadm join 192.168.6.11:6443 --token 341cpa.8d10mh28lo9p4an4 --discovery-token-ca-cert-hash sha256:161f260e5e781d854c8ba2d101cd55d7fd5b4ded52d3e9c53476a0ec806fcd33
```

Copy this command and : 

- Open Another terminal or exit this one :

```
vagrant ssh worker-1
kubeadm join 192.168.6.11:6443 --token 341cpa.8d10mh28lo9p4an4 --discovery-token-ca-cert-hash sha256:161f260e5e781d854c8ba2d101cd55d7fd5b4ded52d3e9c53476a0ec806fcd33
```

So in the master node, we can do :

```
kubectl get nodes
```

And master-1 & worker-1 will be appear in 'Ready' status.

## How to clean up

```
vagrant destroy -f
```

## Errors

Il during installation fatal error occur : 

```
vagrant destroy -f
vagrant up
```