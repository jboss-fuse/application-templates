
# Instructions for using Prometheus and Grafana on OpenShift 4.3 and above

OpenShift 4 has built-in support for custom application monitoring and this guide explains how to use it in conjunction with Fuse 7.

## Install your Fuse application in a custom namespace

Follow the [guide to Fuse on Openshift](https://access.redhat.com/documentation/en-us/red_hat_fuse/7.7/html/fuse_on_openshift_guide/index) to install Fuse and your Fuse application on OpenShift.

For the purposes of this guide, we'll assume that you used a "fuse7" namespace.

## Enable User Workload Monitoring

Follow the [guide to installing User Workload Monitoring](https://docs.openshift.com/container-platform/4.4/monitoring/monitoring-your-own-services.html) :

```
oc -n openshift-monitoring create configmap cluster-monitoring-config
oc -n openshift-monitoring edit configmap cluster-monitoring-config
```

Set techPreviewUserWorkload setting to true by adding the `data:` section specified below:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    techPreviewUserWorkload:
      enabled: true
```

Save the file to apply the changes.    Saving the changes automatically enables User Workload Monitoring, and you can use the steps specified in the [guide to installing User Workload Monitoring](https://docs.openshift.com/container-platform/4.4/monitoring/monitoring-your-own-services.html) to verify that User Workload Monitoring has been successfully installed.

Use our template to define a ServiceMonitor and to create a service account and binding :

```
oc process -f fuse-servicemonitor.yml -p NAMESPACE=<your-fuse-namespace> FUSE_SERVICE_NAME=<fuse-app-name> | oc apply -f -
```

Once you have done this, you should be able to view metrics for your Fuse application in the Monitoring->Metrics section.     Type "org_apache_camel_ExchangesTotal" or another camel metric into the query box :

![Exchanges Total](https://github.com/jboss-fuse/application-templates/raw/master/prometheus/exchangestotal.png)


## Grafana

In the OpenShift UI, browse to Operators - OperatorHub :

* Choose the Grafana Operator provided by Red Hat
* Click Install

Once installed, go to the Grafana tab :

* Make sure the current project is your namespace
* Click Create Grafana

![Create Grafana](https://github.com/jboss-fuse/application-templates/raw/master/prometheus/creategrafana.png)

* Get the URL of the thanos-querier from your cluster :

```
sh% oc get route -n openshift-monitoring thanos-querier
NAME             HOST/PORT                                                                  PATH   SERVICES         PORT   TERMINATION          WILDCARD
thanos-querier   thanos-querier-openshift-monitoring.apps.tomprom.lab.pnq2.cee.redhat.com          thanos-querier   web    reencrypt/Redirect   None
```

* Get the token from your grafana-serviceaccount : 

```
oc serviceaccounts get-token grafana-serviceaccount -n fuse7
```

* Go to the Grafana Datasource tab in the Grafana Operator
* Create Grafana Datasource

```
apiVersion: 1

datasources:
- name: Prometheus
  type: prometheus
  url: <REPLACE-WITH-THANOS-QUERIER-URL>
  access: proxy
  basicAuth: false
  withCredentials: false
  isDefault: true
  jsonData:
    timeInterval: 5s
    tlsSkipVerify: true
    httpHeaderName1: "Authorization"
  secureJsonData:
    httpHeaderValue1: "Bearer <REPLACE-WITH-TOKEN>"
  editable: true
```


## Installing Fuse Grafana dashboards

```
oc apply -n <namespace> -f dashboards/fuse-grafana-dashboard.yml
oc apply -n <namespace> -f dashboards/fuse-grafana-dashboard-routes.yml
```

If you log into your Grafana instance, you can then view your dashboards or even create your own.  You can find the route for the Grafana instance that you have installed :

```
oc get routes -n <namespace> grafana-route
```
