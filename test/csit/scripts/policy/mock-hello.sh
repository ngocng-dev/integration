#!/bin/bash
#
# Copyright 2017 AT&T Intellectual Property. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# $1 ip address of the mock server

curl -v -X PUT -d @- http://$1:1080/expectation <<EOF
{
    "httpRequest": {
        "method": "GET",
        "path": "/hello"
    },
    "httpResponse": {
        "body": "Hello world!",
        "statusCode": 200
    }
}
EOF

