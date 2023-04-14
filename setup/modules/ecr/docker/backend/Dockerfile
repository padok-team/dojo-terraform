FROM node:18

ENV PORT=3000
WORKDIR /usr/src/app

COPY . .

RUN yarn install

EXPOSE $PORT
ENTRYPOINT [ "node", "main.js" ]
