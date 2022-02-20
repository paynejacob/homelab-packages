FROM --platform=$BUILDPLATFORM node:14-alpine3.12 as base

ARG RELEASE_IMAGE=koenkk/zigbee2mqtt:1.23.0

WORKDIR /app
RUN apk add --no-cache tzdata eudev tini

COPY package.json ./

# Dependencies and build
FROM base as dependencies_and_build

COPY npm-shrinkwrap.json tsconfig.json index.js ./
COPY lib ./lib

RUN apk add --no-cache --virtual .buildtools make gcc g++ python3 linux-headers git && \
   npm ci --no-audit --no-optional --no-update-notifier && \
   npm run build && \
   rm -rf node_modules && \
   npm ci --production --no-audit --no-optional --no-update-notifier && \
   apk del .buildtools

COPY --from=$RELEASE_IMAGE /app /app

COPY --from=$RELEASE_IMAGE /usr/local/bin/docker-entrypoint.sh /usr/local/bin/

RUN mkdir /app/data

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "/sbin/tini", "--", "node", "index.js"]



