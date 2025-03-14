#!/bin/bash
#!/usr/bin/env bash
# shellcheck disable=SC2283

Buildhost="localhost"
srcRepo="github.com/eherzog76/docker-freeradius.git"
Repo=""
User=""
Password=""
Version="latest"
prjName="freeradius"
subPath=""

Help(){
   # Display Help
  echo
   echo "Usage of $0:"
   echo "Syntax: $0 -v 1.0.3 -u username -p *** -n freeradius -r private-repo.domain.local"
   echo "options:"
   echo "h     Print this Help."
   echo "v     Version-Tag e.g.: 1.2.6."
   echo "u     Username of Container-Registry."
   echo "p     Password of Container-Registry."
   echo "n     Projectname."
   echo "s     Optional subpath in Git-Repository, mußt end with /"
   echo "g     Git-Repository e.g.: github.com/username/docker-${prjName}.git"
   echo "r     Container-Registry e.g.: gitea.git.svc.cluster.local"
   echo "b     Remote build-host."
   echo

}

while getopts "hv:b:u:p:n:s:g:r:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      v) # Enter a Version
         Version=$OPTARG;;
      b) # Enter a Version localhost
         Buildhost=$OPTARG;;
      u) # Enter a User
         User=$OPTARG;;
      p) # Enter a Password
         Password=$OPTARG;;
      n) # Enter a Project-Name
         prjName=$OPTARG;;
      s) # Enter a subpath of your Git-Repository
         subPath=$OPTARG;;
      g) # Enter a git-Repo github.com/eherzog76/docker-freeradius.git
         srcRepo=$OPTARG;;
      r) # Enter a Repo gitea.git.svc.dmz-k8.postag.intern/usrpublic/
         Repo=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo "User: ${User}"
echo "Repo: ${Repo}"
echo "Git:  ${srcRepo}"
echo "Project: ${prjName}:${Version}"
echo ""

#Clone
export GIT_SSL_NO_VERIFY=1
cd ~
if [[ -d ./tempbuild ]]; then
    mkdir tempbuild
fi
pushd ./tempbuild
rm -Rf ./docker-${prjName}
git clone https://${srcRepo}
cd ./${subPath}docker-${prjName}


docker login $Repo -u "$User" -p "$Password"
if [[ "${Repo}" == "" ]]
then
   Repo="${User}/"
else
   Repo="${Repo}/${User}/"
fi
echo ""
echo "Repo: ${Repo}"
echo ""
docker image ls|grep -P "^${prjName}"|awk '{print $1":"$2}'|xargs docker rmi
docker build -t ${prjName} -f Dockerfile .
docker tag ${prjName} ${prjName}:${Version}
docker tag ${prjName}:${Version} ${Repo}${prjName}:${Version}
echo "Uploading to ${Repo}${prjName}:${Version}"
docker push ${Repo}${prjName}:${Version}

popd
