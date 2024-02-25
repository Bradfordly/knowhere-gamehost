#!/bin/bash -xe

ec2Host=$(curl -sL http://169.254.169.254/latest/meta-data/public-hostname)
r53HostedZone=$(aws ssm get-parameter --name "coreHostedZone" --region us-east-1 | jq -r '.Parameter.Value')
record=$(jq -n \
  --arg r53hz "${r53HostedZone}" \
  --arg ec2h "${ec2Host}" \
  '{
  "Comment": "knowhere dynamic dns service",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "gamehost.bradfordly.com",
        "Type": "CNAME",
        "TTL": 60,
        "ResourceRecords": [
          {
            "Value": $ec2h
          }
        ]
      }
    }
  ]
}'
)
echo $record > record.json
aws route53 change-resource-record-sets --hosted-zone-id $r53HostedZone --change-batch file://record.json --region us-east-1
