FROM node:20-alpine

WORKDIR /home/app

EXPOSE 3000

COPY ./app/package.json .

RUN npm install

COPY ./app .

CMD ["node", "server.js"]