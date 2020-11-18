# Update Fuse version in application templates
#
# Usage: ./update-fuse-version FUSE_VERSION
#
# Example: 
# > ./update-fuse-version 7.8
#

function main {
  FUSE_VERSION=$1
  FUSE_NAME="fuse${FUSE_VERSION//.}"

  if [[ $# -eq 0 ]] ; then
    echo Fuse version must be specified
    exit 0
  fi

  for file in quickstarts/*.json *.json
  do
    if [ "$file" = "fis-image-streams.json" ] ; then
      # Add new Fuse image streams
      IFS='.'; read -ra VERSIONING <<< "${FUSE_VERSION}"; IFS=" "
      FUSE_MAJOR_VERSION=${VERSIONING[0]}
      FUSE_MINOR_VERSION=${VERSIONING[1]}

      PREVIOUS_MINOR_VERSION=$((${FUSE_MINOR_VERSION} - 1))

      FUSE_JAVA_OPENSHIFT=$(generate_json "Java S2I images" "Java" "builder,jboss-fuse,java,xpaas,hidden" "fuse-java-openshift")
      FUSE_KARAF_OPENSHIFT=$(generate_json "Karaf S2I images" "Karaf" "builder,jboss-fuse,java,karaf,xpaas,hidden" "fuse-karaf-openshift")
      FUSE_EAP_OPENSHIFT=$(generate_json "EAP S2I images" "EAP" "builder,jboss-fuse,java,eap,xpaas,hidden" "fuse-eap-openshift")
      FUSE_CONSOLE=$(generate_json "Console image" "Console" "jboss-fuse,hawtio,java,xpaas,hidden" "fuse-console")
      FUSE_APICURITO="\
                        }\n\
                    },\n\
                    {\n\
                        \"name\": \"1.${FUSE_MINOR_VERSION}\",\n\
                        \"annotations\": {\n\
                            \"description\": \"Red Hat Apicurito UI image.\",\n\
                            \"openshift.io\/display-name\": \"Red Hat Apicurito UI\",\n\
                            \"tags\": \"apicurio,hidden\",\n\
                        },\n\
                        \"referencePolicy\": {\n\
                            \"type\": \"Local\"\n\
                        },\n\
                        \"from\": {\n\
                            \"kind\": \"DockerImage\",\n\
                            \"name\": \"registry.redhat.io\/fuse7\/fuse-apicurito:1.${FUSE_MINOR_VERSION}\"\
                        "
      FUSE_APICURITO_GENERATOR="\
                        }\n\
                    },\n\
                    {\n\
                        \"name\": \"1.${FUSE_MINOR_VERSION}\",\n\
                        \"annotations\": {\n\
                            \"description\": \"Red Hat Apicurito Generator image.\",\n\
                            \"openshift.io\/display-name\": \"Red Hat Apicurito Generator\",\n\
                            \"tags\": \"apicurio,fuse,hidden\",\n\
                        },\n\
                        \"referencePolicy\": {\n\
                            \"type\": \"Local\"\n\
                        },\n\
                        \"from\": {\n\
                            \"kind\": \"DockerImage\",\n\
                            \"name\": \"registry.redhat.io\/fuse7\/fuse-apicurito-generator:1.${FUSE_MINOR_VERSION}\"\
                        "
      sed -i -E "s/\"registry.redhat.io\/fuse7\/fuse-java-openshift:1.${PREVIOUS_MINOR_VERSION}\"/\"registry.redhat.io\/fuse7\/fuse-java-openshift:1.${PREVIOUS_MINOR_VERSION}\"\n${FUSE_JAVA_OPENSHIFT}/" $file
      sed -i -E "s/\"registry.redhat.io\/fuse7\/fuse-karaf-openshift:1.${PREVIOUS_MINOR_VERSION}\"/\"registry.redhat.io\/fuse7\/fuse-karaf-openshift:1.${PREVIOUS_MINOR_VERSION}\"\n${FUSE_KARAF_OPENSHIFT}/" $file
      sed -i -E "s/\"registry.redhat.io\/fuse7\/fuse-eap-openshift:1.${PREVIOUS_MINOR_VERSION}\"/\"registry.redhat.io\/fuse7\/fuse-eap-openshift:1.${PREVIOUS_MINOR_VERSION}\"\n${FUSE_EAP_OPENSHIFT}/" $file
      sed -i -E "s/\"registry.redhat.io\/fuse7\/fuse-console:1.${PREVIOUS_MINOR_VERSION}\"/\"registry.redhat.io\/fuse7\/fuse-console:1.${PREVIOUS_MINOR_VERSION}\"\n${FUSE_CONSOLE}/" $file
      sed -i -E "s/\"registry.redhat.io\/fuse7\/fuse-apicurito:1.${PREVIOUS_MINOR_VERSION}\"/\"registry.redhat.io\/fuse7\/fuse-apicurito:1.${PREVIOUS_MINOR_VERSION}\"\n${FUSE_APICURITO}/" $file
      sed -i -E "s/\"registry.redhat.io\/fuse7\/fuse-apicurito-generator:1.${PREVIOUS_MINOR_VERSION}\"/\"registry.redhat.io\/fuse7\/fuse-apicurito-generator:1.${PREVIOUS_MINOR_VERSION}\"\n${FUSE_APICURITO_GENERATOR}/" $file
    fi
    # Replace version in metadata.annotation.openshift.io/display-name
    sed -i -E "s/Fuse [0-9]+\.[0-9]+\.?[0-9]*/Fuse ${FUSE_VERSION}/" $file

    # Replace version in rht.prod_ver label value in DeploymentConfig
    sed -i -E "s/\"rht.prod_ver\": \"[0-9]+\.[0-9]+\"/\"rht.prod_ver\": \"${FUSE_VERSION}\"/" $file

    # Replace version in image names
    sed -i -E "s/fuse[0-9][0-9]+/${FUSE_NAME}/" $file
  done

  for file in *.yml
  do
    # Replace version in rht.prod_ver label value in DeploymentConfig
    sed -i -E "s/rht.prod_ver: [0-9]+\.[0-9]+/rht.prod_ver: ${FUSE_VERSION}/" $file
  done
}

function generate_json {
  local description=$1
  local display_name=$2
  local tags=$3
  local image_name=$4
  local json="\
                        }\n\
                    },\n\
                    {\n\
                        \"name\": \"1.${FUSE_MINOR_VERSION}\",\n\
                        \"annotations\": {\n\
                            \"description\": \"Red Hat Fuse ${FUSE_VERSION} ${description}.\",\n\
                            \"openshift.io\/display-name\": \"Red Hat Fuse ${FUSE_VERSION} ${display_name}\",\n\
                            \"iconClass\": \"icon-rh-integration\",\n\
                            \"tags\": \"${tags}\",\n\
                            \"supports\":\"jboss-fuse:${FUSE_VERSION}.0,java:8,xpaas:1.2\",\n\
                            \"version\": \"1.${FUSE_MINOR_VERSION}\"\n\
                        },\n\
                        \"referencePolicy\": {\n\
                            \"type\": \"Local\"\n\
                        },\n\
                        \"from\": {\n\
                            \"kind\": \"DockerImage\",\n\
                            \"name\": \"registry.redhat.io\/fuse7\/${image_name}:1.${FUSE_MINOR_VERSION}\"\
                        "
  echo "$json"
}

main "$@"
