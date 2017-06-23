oc new-project jb-dev --display-name="Tasks - Dev"
oc new-project jb-prod --display-name="Tasks - Prod"
oc new-project jb-cicd --display-name="CI/CD"
oc process -f jenkins-ephemeral.yaml | oc create -f -  -n jb-cicd
oc process -f cicd-template.yaml -p DEV_PROJECT=jb-dev -p PROD_PROJECT=jb-prod | oc create -f - -n jb-cicd
oc policy add-role-to-user edit system:serviceaccount:jb-cicd:jenkins -n jb-dev
oc policy add-role-to-user edit system:serviceaccount:jb-cicd:jenkins -n jb-prod
oc policy add-role-to-user view system:serviceaccount:jb-dev:default -n jb-dev
oc policy add-role-to-user view system:serviceaccount:jb-prod:default -n jb-prod
