# Application Templates
This project contains OpenShift v3 application templates which support
applications based on JBoss Fuse Integration Services.

## Article on how to get started with this OpenShift template
See http://www.opensourcerers.org/first-fuse-application-on-openshift-v3-1/

## Common Image Repositories
The `fis-image-streams.json` file contains __ImageStream__ definitions for all
Fuse Integration Services.  This will need to be
installed in the common `openshift` namespace (`oc create -f fis-image-streams.json -n openshift`) before using any of the templates generated by Fuse Integration Services archetypes. 

## Example
The easiest way to use the templates is to install them in your project, 
then use the _Create+_ button in the OpenShift console to create your application. 
The console will prompt you for the values for all of the parameters used by the template.  
To set this up for a particular template from a project generated using Fuse Integration Services archetype:
```
$ oc create -n openshift -f fis-image-streams.json
$ oc create -n myproject -f quickstart-template.json
```
After executing the above, you should be able to see the template after pressing _Create+_ in your project.

Or, if you prefer the command line:
```
$ oc create -n openshift -f fis-image-streams.json
$ oc process -n yourproject -f quickstart-template.json -v <template parameters> | oc create -n yourproject -f -
```

You may also install the templates into the `openshift` namespace in order to make them
available to all users:
```
$ oc create -n openshift -f quickstart-template.json
```
