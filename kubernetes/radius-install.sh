#!/bin/bash

DoNotApply="0"
export KTool=kubectl  #oc
export K8SDOMAIN=dmz-k8.postag.intern
export K8SREPO=private-repository-k8s.default.svc.${K8SDOMAIN}:5000
export AppNS=radius
export DBHOST=hippo-ha.postgres-operator.svc.${K8SDOMAIN}
export DBUSER=radius
export DBPWD=`${KTool} -n postgres-operator get secrets hippo-pguser-zabbix -o jsonpath="{.data.password}" | base64 -d`
export DBNAME=radius
export SCNAME=smb-wnetconfbck01

Help(){
   # Display Help
   echo
   echo "Usage of $0:"
   echo "Syntax: $0 -u username -p *** ..."
   echo "options:"
   echo "-kr --k8srepo    Git-Repository."
   echo "-n --namespace   K8S Namespace."
   echo "-h --dbhost   IP or Name of Database-Server."
   echo "-u --dbuser   Database-User."
   echo "-p --dbpwd    Password for DB-User."
   echo "-db --dbname  Database-Name."
   echo "-s --scname   K8S Storage-Class"
   echo "-kc --ktool   e.g.: kubectl, oc, ..."
   echo "-d --dry      Dry only do not apply changes."
   echo "-h --help     Print this Help."
   echo
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -kd|--k8sdomain) K8SDOMAIN="$2"; shift ;;
        -kr|--k8srepo) K8SREPO="$2"; shift ;;
        -n|--namespace) AppNS="$2"; shift ;;
        -h|--dbhost) DBHOST="$2"; shift ;;
        -u|--dbuser) DBUSER="$2"; shift ;;
        -p|--dbpwd) DBPWD="$2"; shift ;;
        -db|--dbname) DBNAME="$2"; shift ;;
        -s|--scname) SCNAME="$2"; shift ;;
        -kc|--ktool) KTool="$2"; shift ;;
        -d|--dry) DoNotApply=1 ;;
        -h|--help) Help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

export KTool
export K8SDOMAIN
export K8SREPO
export AppNS
export DBHOST
export DBUSER
export DBPWD
export DBNAME
export SCNAME

varNS=`${KTool} get namespace | grep -P "^${AppNS} +.*"`
if [ -z "${varNS}" ]; then
   echo "Creating namespace: ${AppNS}"
   ${KTool} create namespace ${AppNS}
fi

Debug=""
if [ ${DoNotApply} == 1 ]; then
   Debug="-d"
   echo "Only showing templates:"
fi

for fname in ./*.yaml; do
    ./kubectlwithenv.sh -f ${fname} ${Debug}
done

echo ""
echo "To download the initial FreeRadius-Configuration:"
echo "   -) Download it from: https://github.com/FreeRADIUS/freeradius-server/releases"
echo "   -) or do it with a docker build based on:"
echo "          https://github.com/FreeRADIUS/freeradius-server/blob/v3.0.x/scripts/docker/"
echo ""
echo "FreeRadius raddb-Volume:"
echo "   kubectl get pvc pvc-freeradius-raddb"
echo "   //wnetconfbck01.postag.intern/k8s-dmzmon/pvc-..."
echo ""

export KTool=""
export K8SDOMAIN=""
export K8SREPO=""
export AppNS=""
export DBHOST=""
export DBUSER=""
export DBPWD=""
export DBNAME=""
export SCNAME=""
