
https://hub.docker.com/_/jenkins

docker-compose.yml

```
  jenkins-example-master:
    image: jenkins/jenkins:lts
    container_name: jenkins-master-example
    volumes:
      - ./jenkins-example/jenkins_home:/var/jenkins_home 
    ports:
      - 18080:8080
      - 50000:50000
    

```

localhost:8080

docker exec -it jenkins-master-example /bin/bash
cat /var/jenkins_home/secrets/initialAdminPassword

7db3fa42079442809398643aafec45cd

admin
admin
admin
admin


docker-compose.yml

```
  jenkins-slave-example:
    container_name: jenkins-slave-example
    image: jenkinsci/ssh-slave
    environment:
      - JENKINS_SLAVE_SSH_PUBKEY=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCNfhUNWJFFTf3H3zESmcAnPaMZfDVbdKPJF0u0ZwP6dBa6oxnIwFnLQ7M7ERoZN0jLKJkApnYc17k1J1j3K2Z/pNhYEGtXsVy5Mxqlta0lYqbU2xyrOd6UEixs2+WtYKTi/5VtYenE3mrusIaGLiO1eCvfuQ1XFhlvqWZIK9nUp/3BMMhYVEgzrQ5DHX6KlrkHLwM+ajK87dALM79JjnqwFr0QCzZVP9CX6886qk1YhOAw4XD8x66RanHuwTTaDnTv56fJxyUnZt5DXuW1SkFpvSTzcIgBOSIgf4MrIqosKy24GNFfDMNZOY0OOyaPd89/X1IAUJptu229MSO/OOL 

    
```

### add slave

New Node

	
Remote root directory : /home/jenkins
Host : jenkins-slave-example
private key : id_rsaをコピペ
Non verifing...

Advanced
/usr/local/openjdk-8/bin/java







