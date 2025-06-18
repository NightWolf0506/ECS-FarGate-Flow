FROM node:22-alpine

# For sharp and other dependencies
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
# Add secret build args
ARG HOST
ARG PORT
ARG APP_KEYS
ARG API_TOKEN_SALT
ARG ADMIN_JWT_SECRET
ARG TRANSFER_TOKEN_SALT
ARG JWT_SECRET
ARG ENCRYPTION_KEY

# Set as ENV
ENV HOST=$HOST
ENV PORT=$PORT
ENV APP_KEYS=$APP_KEYS
ENV API_TOKEN_SALT=$API_TOKEN_SALT
ENV ADMIN_JWT_SECRET=$ADMIN_JWT_SECRET
ENV TRANSFER_TOKEN_SALT=$TRANSFER_TOKEN_SALT
ENV JWT_SECRET=$JWT_SECRET
ENV ENCRYPTION_KEY=$ENCRYPTION_KEY

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm ci --omit=dev

ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .

RUN chown -R node:node /opt/app
USER node

RUN ["npm", "run", "build"]
EXPOSE 1337

CMD ["npm", "run", "start"]
