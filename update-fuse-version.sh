# Update Fuse version in application templates
#
# Usage: ./update-fuse-version FUSE_VERSION
#
# Example: 
# > ./update-fuse-version 7.7
#

FUSE_VERSION=$1
FUSE_NAME="fuse${FUSE_VERSION//.}"

if [[ $# -eq 0 ]] ; then
  echo Fuse version must be specified
  exit 0
fi

for file in quickstarts/*.json *.json
do
  if [ "$file" = "fis-image-streams.json" ] ; then
    # ignore fis-image-streams.json as it contains older Fuse versions
    continue
  fi
  sed -i -E "s/Fuse [0-9]+\.[0-9]+\.?[0-9]*/Fuse ${FUSE_VERSION}/" $file
  sed -i -E "s/fuse[0-9][0-9]+/${FUSE_NAME}/" $file
done
