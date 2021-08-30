!/bin/bash
set -eux

curl -L https://istio.io/downloadIstio | sh -

cd $PWD/istio-1.11.0

export PATH=$PWD/bin:$PATH

kubectl label namespace default istio-injection=enabled
