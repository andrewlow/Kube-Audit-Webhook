# Capture IBM Cloud Kubernetes Service (IKS) audit logs

Kubernetes Auditing is part of the [kube-apiserver](https://kubernetes.io/docs/reference/generated/kube-apiserver/), and will log all requests that the API Server processes for audit purposes. When using [IBM Cloud Kubernetes Service (IKS)](https://www.ibm.com/cloud/container-service) the API Server and Master node are managed for the user. The API Server provides a webhook which can be used to send all audit events to a remote backend.

We'll setup our own container along side our other pods to serve as a target for the webhook and capture the audit logs. Since the webhook doesn't provide any authentication, we want to ensure we don't expose the container http endpoint beyond our private network. 

![Diagram](doc/images/kube-audit-log.png)

The problem can be broken into two parts
1) The simple HTTP server that processes the data
2) The deployment of the container and configuration of the webhook

## Step 1 - simple HTTP server

The audit log webhook pay load comes in the following format

```
{
  "kind": "EventList",
  "apiVersion": "audit.k8s.io/v1",
  "metadata": {},
  "items": [ ... ]
}
```

There are 1 or more items, each a JSON audit record. We will create a simple node.js web server which can parse the payload and emit each item as a unique line into the logging system. Since we are creating a container, we can make use of the cloud native approach of simply dumping our logs onto stdout.

To handle the incoming webhook, a simple node.js application [app.js](app.js) was created.

The application runs on port 3000, making it easy to test locally. There is obviously much more we could do to enhance this simple application, but this will work as a starting point.

[MIT License](https://github.com/andrewlow/Kube-Audit-Webhook/blob/master/LICENSE)
