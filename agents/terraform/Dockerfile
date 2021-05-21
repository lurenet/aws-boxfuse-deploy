FROM ubuntu:20.04

ENV TZ=Europe/Kiev
ENV AppPath=/root/build
ENV TerraformPath=$AppPath/terraform
ENV TerraformSourceUrl=https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip
ENV TerraformSourcePack=terraform_0.15.3_linux_amd64.zip

RUN ln -snf /usr/share/zoneinfo/$TZ etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install git wget unzip -y

RUN mkdir -p $TerraformPath
WORKDIR $TerraformPath
RUN wget $TerraformSourceUrl
RUN unzip $TerraformSourcePack && rm $TerraformSourcePack  && mv terraform /usr/bin/

