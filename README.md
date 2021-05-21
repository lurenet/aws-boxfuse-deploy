This pipeline create ec2 instances for build and push to stage boxfuse artifact using terraform and ansible tools.

You need to setup your credentials for dockerhud account in Jenkinsfile:
  DHUB_USERNAME  = "username"
  DHUB_PASSWORD  = "password"
  DHUB_EMAIL     = "user@gmail.com"

You will have oppotunity to control building through the choice of action: "create" or "destroy".

When boxfuse install you will see invent url in the end of Jenkins logs like:
  Visit Boxfuse: http://${ip}/hello-1.0

Try and enjoy it!
