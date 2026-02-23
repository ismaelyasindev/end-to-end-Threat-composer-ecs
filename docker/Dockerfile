ARG NODE_VERSION=24-alpine
ARG NGINX_VERSION=alpine3.23

FROM node:${NODE_VERSION} AS builder
WORKDIR /app
COPY app/package.json app/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY app/ .
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN yarn build

FROM nginxinc/nginx-unprivileged:${NGINX_VERSION} AS runner
USER nginx
COPY app/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx --from=builder /app/build /usr/share/nginx/html
EXPOSE 8080
ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf"]
CMD ["-g", "daemon off;"]
