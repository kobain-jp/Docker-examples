
コンテナ全削除
docker ps -aq | xargs docker rm

イメージ全削除
docker images -aq | xargs docker rmi

強制削除
docker rmi -f 

起動時にスクリプトを実行
Dockerfile

COPY startup.sh /startup.sh
RUN chmod 744 /startup.sh
CMD ["/startup.sh"]

Docker-compose
python:
    image: python:3
    container_name: 'python'
    links:
      - selenium-hub:hub
    command: >
      bash -c 'pip install --upgrade pip &&
      pip install selenium &&
      tail -f /dev/null'