#
# Set up not intended to work out of the box, but documents the dependencies
#
setup:
	ibmcloud login
	ibmcloud cr region-set us-south
	ibmcloud cr login
	ibmcloud cr namespaces
	@echo "**IMPORTANT** Set env var NAMESPACE to one of the available namespaces"
	@echo "**IMPORTANT** If there are no namespaces, use namespace-add to create one"
	ibmcloud ks clusters
	@echo "**IMPORTANT** Use 'ibmcloud ks cluster-config <cluster name>' to setup KUBECONFIG export"

#
# Build and push the docker container
#
build:
	docker build . --tag us.icr.io/$(NAMESPACE)/kube-audit
	docker push us.icr.io/$(NAMESPACE)/kube-audit

#
# Deploy
#
deploy:
	kubectl create -f kube-audit.yaml
	kubectl get services
	@echo "**IMPORTANT** Make note of the IP address of the 'kube-audit' service"
	@echo "**IMPORTANT** We will use that IP (WW.XX.YY.ZZ) to setup the webhook, as per below"
	@echo "**IMPORTANT** 'ibmcloud ks apiserver-config-set audit-webhook <clustername or id> --remoteServer http://WW.XX.YY.ZZ'"
