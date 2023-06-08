#!/bin/bash
yum update -y
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
yum install -y nodejs
yum install git -y
git clone https://github.com/alfalfita/aws-cli.git
cd aws-cli/nodejs
node helloworld.js
