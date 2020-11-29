FROM node:12

WORKDIR /node-example

COPY package*.json ./

RUN npm install

COPY . .

CMD [ "node", "server.js" ]