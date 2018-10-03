# Application Templates

This project contains OpenShift v3 application templates which support
applications based on Red Hat Fuse.

## Article on how to get started with this OpenShift template

See http://www.opensourcerers.org/first-fuse-application-on-openshift-v3-1/

## Configure Authentication to the Red Hat Container Registry

Before you can import and use the Red Hat Fuse OpenShift Image Streams, you must first configure authentication to the Red Hat container registry.
This may have already been set up for you by your cluster administrator. If not, follow the instructions bellow.

Within the OpenShift project where you'll be installing the Red Hat Fuse Image Streams, create a docker-registry secret using credentials for either a
Red Hat Developer Program account or Red Hat Customer Portal account. For example:

```
oc create secret docker-registry imagestreamsecret \
  --docker-server=registry.redhat.io \
  --docker-username=CUSTOMER_PORTAL_USERNAME \
  --docker-password=CUSTOMER_PORTAL_PASSWORD \
  --docker-email=EMAIL_ADDRESS
```

If you don’t want to use your Red Hat account’s username and password to create the secret, it is recommended to [create an authentication token](https://access.redhat.com/RegistryAuthentication#registry-service-accounts-for-shared-environments-4) using a [registry service account](https://access.redhat.com/terms-based-registry/).

For further information see:

* [Red Hat Container Registry Authentication](https://access.redhat.com/RegistryAuthentication)
* [Accessing and Configuring the Red Hat Registry](https://docs.openshift.com/container-platform/3.11/install_config/configuring_red_hat_registry.html)

## Install Image Streams

The `fis-image-streams.json` file contains __ImageStream__ definitions for Red Hat Fuse on OpenShift. This will need to be installed within
the `openshift` namespace (`oc create -f fis-image-streams.json -n openshift`) before using any of the quickstart templates.

## Example

The easiest way to use the quickstart templates is to install them in your project

```
$ oc create -n openshift -f fis-image-streams.json
$ oc create -n myproject -f quickstart-template.json
```

After installing templates, you should see the quickstarts in the OpenShift catalog. Select one, and you will be prompted to
provide template parameters.

Alternatively, you can install the template and create a new application  from the command line:
```
$ oc create -n openshift -f fis-image-streams.json
$ oc process -n yourproject -f quickstart-template.json -v <template parameters> | oc create -n yourproject -f -
```

To make templates available to all users, install them into the `openshift` namespace:
```
$ oc create -n openshift -f quickstart-template.json
```

## Fuse Console

The Red Hat Fuse console eases the discovery and management of Fuse applications deployed on OpenShift.

You can run the following instructions to deploy the Fuse console on your OpenShift cluster.
There exist two OpenShift templates to choose from, depending on the following characteristics:

| Template | Descripton |
| -------- | ---------- |
| [fis-console-cluster-template.json](https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-console-cluster-template.json) | Use an OAuth client that requires the `cluster-admin` role to be created. The Fuse console can discover and connect to Fuse applications deployed across multiple namespaces / projects. |
| [fis-console-namespace-template.json](https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-console-namespace-template.json) | Use a service account as OAuth client, which only requires `admin` role in a project to be created. This restricts the Fuse console access to this single project, and as such acts as a single tenant deployment. |

To install the Fuse console template, execute the following command:

```sh
$ oc create -n myproject -f fis-console-namespace-template.json
```

Then, you should be able to see the template after navigating to _Add to Project > Select from Project_ in your project.

Or, if you prefer the command line:

```sh
$ oc new-app -n myproject -f fis-console-namespace-template.json \
  -p ROUTE_HOSTNAME=<HOST>
```

Note that the `ROUTE_HOSTNAME` parameter can be omitted when using the `fis-console-namespace-template` template.
In that case, OpenShift automatically generates one for you.

You can obtain more information about the template parameters, by executing the following command:

```
$ oc process --parameters -f fis-console-namespace-template.json
NAME                     DESCRIPTION                                                                    VALUE
APP_NAME                 The name assigned to the application.                                          fuse70-console
APP_VERSION              The application version.                                                       1.0
IMAGE_STREAM_NAMESPACE   Namespace in which the Fuse ImageStreams are installed. These ImageStreams
                         are normally installed in the openshift namespace. You should only need to
                         modify this if you've installed the ImageStreams in a different
                         namespace/project.                                                             openshift
ROUTE_HOSTNAME           The externally-reachable host name that routes to the Red Hat Fuse console
                         service
CPU_REQUEST              The amount of CPU to request.                                                  0.2
MEMORY_REQUEST           The amount of memory required for the container to run.                        32Mi
CPU_LIMIT                The amount of CPU the container is limited to use.                             1.0
MEMORY_LIMIT             The amount of memory the container is limited to use.                          32Mi
```

You can obtain the status of your deployment, by running:

```sh
$ oc status
In project myproject on server https://192.168.64.12:8443

https://fuse-console.192.168.64.12.nip.io (redirects) (svc/fuse70-console-service)
  dc/fuse70-console deploys openshift/jboss-fuse70-console:1.0
    deployment #1 deployed 2 minutes ago - 1 pod
```

Open the route URL displayed above from your Web browser to access the Fuse console.

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




