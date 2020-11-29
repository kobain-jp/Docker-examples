### 
https://nodejs.org/ja/docs/guides/nodejs-docker-webapp/

### create node app

create package.json

```
{
  "name": "docker_web_app",
  "version": "1.0.0",
  "description": "Node.js on Docker",
  "author": "First Last <first.last@example.com>",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.16.1"
  }
}
```

`npm install`

`node server.js`

open browser localhost:8080

### create Docker Image

create Dockerfile

```
FROM node:12

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD [ "node", "server.js" ]
```

create .dockerignore

```
node_modules
npm-debug.log
Dockerfile
```

`docker build -t kobainjp/node-example .`

### run Docker Image

`docker run -dp 84:8080 kobainjp/node-example` 

中を確認する。
`docker ps`
`docker exec -it ctnname /bin/bash`





