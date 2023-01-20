# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# TODO: minimize the docker image size, now 524MB !!!

FROM golang:1.18-alpine AS build

WORKDIR /dep-eye

COPY . .

RUN apk add --no-cache make curl && make linux

FROM alpine:3 AS bin

COPY --from=build /dep-eye/bin/linux/dep-eye /bin/dep-eye

# Go
COPY --from=build /usr/local/go/bin/go /usr/local/go/bin/go
ENV PATH="/usr/local/go/bin:$PATH"
RUN apk add --no-cache bash gcc musl-dev npm cargo
# Go

WORKDIR /github/workspace/

ENTRYPOINT ["/bin/dep-eye"]