ca=$(kubectl get -n kube-system secret/argo-cd-manager-token -o jsonpath='{.data.ca\.crt}')

token=$(kubectl get -n kube-system secret/argo-cd-manager-token -o jsonpath='{.data.token}' | base64 --decode)
