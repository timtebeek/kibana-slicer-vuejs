#!/bin/bash
set -e

! rm $2/apps-*.txt

function kubectlApps() {
  kubectl get deployments -n $1 -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
  kubectl get statefulsets -n $1 -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
  kubectl get cronjobs -n $1 -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
}

name_regex='"name":\s*"([^"]+)'
while read namespace; do
  if [[ $namespace =~ $name_regex ]]; then
    name=${BASH_REMATCH[1]}
    echo $name
    kubectlApps $name > $2/apps-$name.txt
  else
    echo 'Failed to read name from ' $namespace
  fi
done < $1
