FROM ubuntu:18.04

ENV TZ=Europe/Kiev
ENV AppPath=/root/build
ENV AnsiblePath=$AppPath/ansible

RUN ln -snf /usr/share/zoneinfo/$TZ etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install ansible -y

RUN sed -i 's/#host_key_checking/host_key_checking/g' /etc/ansible/ansible.cfg

RUN mkdir -p $AnsiblePath
WORKDIR $AnsiblePath
