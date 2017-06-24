pre=jb
oc new-project ${pre}-test --display-name="Tasks - Test"
oc new-project ${pre}-prod --display-name="Tasks - Prod"
oc new-project ${pre}-cicd --display-name="CI/CD"
#oc process -f jenkins-ephemeral.yaml | oc create -f -  -n ${pre}-cicd
oc process -f cicd-template.yaml -p TEST_PROJECT=${pre}-test -p PROD_PROJECT=${pre}-prod | oc create -f - -n ${pre}-cicd
oc set resources dc/jenkins --limits=memory=1Gi
oc policy add-role-to-user edit system:serviceaccount:${pre}-cicd:jenkins -n ${pre}-test
oc policy add-role-to-user edit system:serviceaccount:${pre}-cicd:jenkins -n ${pre}-prod
oc policy add-role-to-user view system:serviceaccount:${pre}-test:default -n ${pre}-test
oc policy add-role-to-user view system:serviceaccount:${pre}-prod:default -n ${pre}-prod
