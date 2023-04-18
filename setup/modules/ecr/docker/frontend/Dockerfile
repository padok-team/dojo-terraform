FROM nginx:1.24.0-alpine-slim

COPY . /usr/share/nginx/html/

CMD envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html && nginx -g "daemon off;"
