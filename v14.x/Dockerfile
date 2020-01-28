FROM lambci/lambda-base:build

COPY bootstrap.c bootstrap.js /opt/

ARG NODE_VERSION
RUN mkdir /opt/bin/
COPY node /opt/bin/
RUN strip /opt/bin/node

RUN cd /opt && \
  export NODE_MAJOR="\"14\"" && \
  clang -Wall -Werror -s -O2 -D NODE_MAJOR="$NODE_MAJOR" -o bootstrap bootstrap.c && \
  rm bootstrap.c && \
  zip -yr /tmp/layer.zip .
