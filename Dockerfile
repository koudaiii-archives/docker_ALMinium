# DOCKER-SSH-NGINX-MYSQL-CENTOS6.4
#
# VERSION       1

FROM centos:6.4

MAINTAINER koudaiii "cs006061@gmail.com"

ENV PATH $PATH:/usr/bin
RUN yum -y update

#Dev tools for all Docker
RUN yum -y install git vim

RUN yum -y install passwd openssh openssh-server openssh-clients sudo


# useradd user,name to koudaiii

RUN useradd koudaiii
RUN passwd -f -u koudaiii
RUN mkdir -p /home/koudaiii/.ssh;chown koudaiii /home/koudaiii/.ssh; chmod 700 /home/koudaiii/.ssh
ADD ./authorized_keys /home/koudaiii/.ssh/authorized_keys
RUN chown koudaiii /home/koudaiii/.ssh/authorized_keys;chmod 600 /home/koudaiii/.ssh/authorized_keys

# setup sudoers
RUN echo "koudaiii ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/koudaiii
RUN chmod 440 /etc/sudoers.d/koudaiii

# setup sshd
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN rpm -i http://dl.fedoraproject.org/pub/epel/6/x86_64/pwgen-2.06-5.el6.x86_64.rpm

# setup TimeZone
RUN mv /etc/localtime /etc/localtime.org
RUN cp /usr/share/zoneinfo/Japan /etc/localtime

# expose for sshd
EXPOSE 22

#######################################  Supervisord  ########################################

RUN wget http://peak.telecommunity.com/dist/ez_setup.py;python ez_setup.py;easy_install distribute;
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py;python get-pip.py;
RUN pip install supervisor

ADD ./supervisord.conf /etc/supervisord.conf

RUN git clone git://github.com/Supervisor/initscripts.git ;cd initscripts/; chmod +x ./redhat* ;  cp redhat-init-jkoppe /etc/init.d/supervisord; cp redhat-sysconfig-jkoppe /etc/sysconfig/supervisord; chkconfig --add supervisord


#######################################  Mysql  ########################################

RUN yum -y install mysql-server mysql mysql-devel mysql-client

ADD my.cnf /etc/my.cnf
RUN chmod 664 /etc/my.cnf

#Mysql run
ADD run /usr/local/bin/run
ADD setup_mysql.sh /root/setup_mysql.sh
RUN chmod +x /usr/local/bin/run; chmod +x /root/setup_mysql.sh

RUN touch /etc/sysconfig/network #This file is needed in /etc/init.d/mysqld


CMD ["/usr/local/bin/run"]
RUN /bin/sh /root/setup_mysql.sh


# expose for mysqld
EXPOSE 3306

########## ALMinium ###############
RUN  service supervisord start & 

RUN  git clone https://github.com/alminium/alminium.git
RUN  cd alminium; export ALM_HOSTNAME="localhost" ; export SSL="N" ; export ENABLE_JENKINS="y" ; bash -l -c ./smelt

# expose for http 
EXPOSE 80

##################################



CMD ["/usr/bin/supervisord"]


