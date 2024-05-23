FROM node:16-alpine as builder
ARG ENV
RUN NODE_ENV=$ENV
RUN mkdir /working
WORKDIR /working
COPY . .
# COPY package.json .
# COPY yarn.lock .
RUN . .env.${ENV} && echo $ENV && echo $VUE_APP_BASE_URL && yarn install && yarn build --mode=${ENV}

FROM nginx:alpine
COPY --from=builder /working/vhost.nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /working/dist /usr/share/nginx/html
RUN ls /usr/share/nginx/html
EXPOSE 80
