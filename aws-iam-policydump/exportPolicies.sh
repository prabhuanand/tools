#!/bin/bash

awsAccountNumber="xx"
basePath="/Users/prabhu/export"
policyOutput="${basePath}/policy"
fileName="policy.txt"

aws iam list-policies |  jq -r '.Policies[]| "\(.Arn) \(.DefaultVersionId)" ' > "${basePath}/${fileName}" 

rm -fr "${policyOutput}"
mkdir -p "${policyOutput}"

echo "Starting to dump the policies"
while read -r line; 
do 
	policyARN=$(echo "${line}" | awk '{print $1}')
	policyName=$(echo "${line}" | awk '{print $1}' | sed -e "s/arn:aws:iam::aws:policy\///g" | sed -e "s/\//_/g" | sed -e "s/ /_/g" | sed -e "s/arn:aws:iam::${awsAccountNumber}:policy_//g" )
	version=$(echo "${line}" | awk '{print $2}')
#	echo "arn=${policyARN} name=${policyName} version=${version}"
	echo "... Dumping ${policyName}"
	aws iam get-policy-version --policy-arn "${policyARN}"  --version-id "${version}" > "${policyOutput}/${policyName}.json"
	#echo "${policyOutput}/${policyName}.json"
done < "${fileName}"
