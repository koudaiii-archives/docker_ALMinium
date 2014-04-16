#Docker-ALMinium

SSH HTTP MYSQL accessable docker container recipe.

Install [ALMinium](https://github.com/alminium/alminium)

> ALMinium is easy to set up Redmine, DVCS (Git / VMercurial), Backlogs, and code review plug-in, the environment necessary for the development.

### Docker Installation

Install [Docker](https://gist.github.com/koudaiii/10282062#file-docker_install).

Install [for mac](https://gist.github.com/koudaiii/10224422)



##Usage

In Host Machine

Get this code

    git clone https://github.com/koudaiii/docker_ALMinium.git

Generate ssh key

    ssh-keygen -t rsa
    Enter file in which to save the key (/home/user/.ssh/id_rsa):

    cp ~/.ssh/user/id_rsa.pub ~/docker_ALMinium/authorized_keys

Change username to your own

    vim ~/docker_ALMinium/Dockerfile

Build container

    cd ~/docker_ALMinium
    docker build -t [user_nam]/alminium .

Run container

    docker run -d -p 22 -p 80 -p 3306 koudaiii/alminium

Get Port Number

    docker ps

    CONTAINER ID        IMAGE                      COMMAND                CREATED             STATUS              PORTS                                                                   NAMES
    83db5551b293        koudaiii/alminium:latest   /usr/bin/supervisord   14 hours ago        Up 1 seconds        0.0.0.0:49164->22/tcp, 0.0.0.0:49165->3306/tcp, 0.0.0.0:49166->80/tcp   distracted_archimedes   

SSH access to your container

    ssh localhost -p port_number|49164

HTTP access to your container
   
    http://0.0.0.0:port_number|49166

MySQL access to youe container

    mysql -h 127.0.0.1 -P port_number|49165 -u root


log

    https://gist.github.com/10224422.git

#注意

   ALMiniumのinstallShellが大きすぎてHTTPD[OK]からなかなかConsoleが帰って来ません
