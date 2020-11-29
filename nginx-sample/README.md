
### ファイル構成

```
-nginx-sample
-html
-Dockerfile
-README.md
```

`cd nginx-sample`

### docker　コンテナの実行

nginxイメージからコンテナを実行

`docker run -dp 8081:80 --name nginx-sample nginx`

-dp 　デタッチ --name 　コンテナの名前

https://docs.docker.jp/engine/reference/run.html

起動確認
`docker ps`

コンテナ内のログ確認
`docker logs -f kobain-web`

コンテナ起動/停止/再起動
`docker start / stop / restart`

コンテナ削除
`docker ps -a`

### コンテナ内に入ってhtmlを配置するディレクトリを確認

`docker exec -it kobain-web /bin/bash`
`cd /etc/nginx/conf.d`
`cat conf.d`

```
 location = /50x.html {
        root   /usr/share/nginx/html;
    }

```

HTMLフォルダの置き場所を確認し、exitでコンテナからでる。

### Dockerfile作成

Dockerfile
```
FROM nginx
COPY ./html /usr/share/nginx/html

```

イメージ作成
`docker build --tag hello-docker-nginx .`

イメージ実行
`docker run -dp 81:80 hello-docker-nginx`

### docker hub へのpush

アカウント作成

https://hub.docker.com/ 

`docker login`
`docker tag hello-docker-nginx kobainjp/hello-docker-nginx`

`docker push kobainjp/hello-docker-nginx`


### docker playgroundで実行

https://labs.play-with-docker.com/

docker run -dp 3000:80 kobainjp/hello-docker-nginx

### 開発しながらやる方法

docker run -dp 3000:80 \
  -it \
  --name dev \
  -v "$(pwd)"/html:/usr/share/nginx/html \
  nginx:latest

  $PWDによって実行中のディレクトリの絶対パス
    
## docker compose

```
docker-example
-nginx-sample
--html
--Dockerfile
-docker-compose.yml
```

docker-compose.yml
```
version: "3.7"
services:
  nginx:
    build: ./nginx-sample
    ports:
      - "81:80"
    volumes:
      - ./nginx-sample/html:/usr/share/nginx/html

```

Do


docker imageの削除

docker rmi containerid