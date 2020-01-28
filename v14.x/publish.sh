#!/bin/bash
set -e 
. ./config.sh

DESCRIPTION="Node.js v${NODE_VERSION} custom runtime"
FILENAME=${LAYER_NAME}-${NODE_VERSION}.zip

REGIONS="us-east-1"

aws s3api put-object --bucket nodejs-lambda-builds --key layers/${FILENAME} --body layer.zip

for region in $REGIONS; do
  aws lambda add-layer-version-permission --region $region --layer-name $LAYER_NAME \
    --statement-id sid1 --action lambda:GetLayerVersion --principal '454070313920' \
    --version-number $(aws lambda publish-layer-version --region $region --layer-name $LAYER_NAME \
      --content S3Bucket=nodejs-lambda-builds,S3Key=layers/${FILENAME} \
      --compatible-runtimes provided \
      --description "$DESCRIPTION" --query Version --output text) &
done

for job in $(jobs -p); do
  wait $job
done
