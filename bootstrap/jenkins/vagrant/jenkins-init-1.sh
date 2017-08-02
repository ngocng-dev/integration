#!/bin/bash
#
# Copyright 2017 Huawei Technologies Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#

git config --global user.email "jenkins@localhost"
git config --global user.name "jenkins"

cd ~jenkins

cp /etc/skel/.profile .
cat > .bashrc <<EOF
alias ls='ls --color -F'
EOF

git init

git add -A
git commit -m 'Initial installation config' > /dev/null

mkdir -p ~/.m2
cp /vagrant/settings.xml ~/.m2
rm -f secrets/initialAdminPassword
rm -rf users/admin
rsync -avP /vagrant/jenkins/ .

git add -A
git commit -m 'Set up jenkins user' > /dev/null

