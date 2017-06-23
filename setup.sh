pre=jb
oc new-project ${pre}-dev --display-name="Tasks - Dev"
oc new-project ${pre}-prod --display-name="Tasks - Prod"
oc new-project ${pre}-cicd --display-name="CI/CD"
oc process -f jenkins-ephemeral.yaml | oc create -f -  -n ${pre}-cicd
oc process -f cicd-template.yaml -p DEV_PROJECT=${pre}-dev -p PROD_PROJECT=${pre}-prod | oc create -f - -n ${pre}-cicd
oc policy add-role-to-user edit system:serviceaccount:${pre}-cicd:jenkins -n ${pre}-dev
oc policy add-role-to-user edit system:serviceaccount:${pre}-cicd:jenkins -n ${pre}-prod
oc policy add-role-to-user view system:serviceaccount:${pre}-dev:default -n ${pre}-dev
oc policy add-role-to-user view system:serviceaccount:${pre}-prod:default -n ${pre}-prod