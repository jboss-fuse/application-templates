## Prometheus support for Fuse on Openshift 4

Please follow the [monitoring guide](../monitoring/prometheus.md] guide for information on using Fuse with Prometheus and Grafana.

## Prometheus Operator for Fuse on Openshift 3

Monitor your Fuse applications and take advantage of the built-in instrumentation with the prometheus-operator.

You can run the following instructions to deploy the prometheus-operator in your Fuse namespace:

First, install the CustomResourceDefinitions necessary for running the prometheus-operator.   Note that you will need to be logged in as a user with cluster admin permissions.  

```
$ oc login -u system:admin
$ oc create -f fuse-prometheus-crd.yml
```

Then, install the prometheus-operator to your namespace:

```
$ oc process -f fuse-prometheus-operator.yml  -p NAMESPACE=<YOUR NAMESPACE> | oc create -f -
```

Finally, tell it to monitor your fuse application:

```
$ oc process -f fuse-servicemonitor.yml -p NAMESPACE=<YOUR NAMESPACE> -p FUSE_SERVICE_NAME=<YOUR FUSE SERVICE> | oc create -f -
```

Note that the `NAMESPACE` and `FUSE_SERVICE_NAME` parameters must be specified.


## Fuse Apicurito

Design beautiful, functional APIs with zero coding, using a visual designer for OpenAPI documents.

You can run the following instructions to deploy Fuse Apicurito on your OpenShift cluster.
To install the Fuse Apicurito template, execute the following command:

```sh
$ oc create -n myproject -f fuse-apicurito.yml
```

Then, you should be able to see the template after navigating to _Add to Project > Select from Project_ in your project.

Or, if you prefer the command line:

```sh
$ oc new-app --template apicurito -p ROUTE_HOSTNAME=<HOST>
```

Note that the `ROUTE_HOSTNAME` parameter must be specified and set to a hostname that will resolve to your openshift cluster.



