cicd=jb-cicd
test=jb-test
prod=jb-prod
oc new-project ${test} --display-name="Kitchensink - Test"
oc new-project ${prod} --display-name="Kitchensink - Prod"
oc new-project ${cicd} --display-name="CI/CD"
oc process -f cicd-template.yaml -p TEST_PROJECT=${test} -p PROD_PROJECT=${prod} | oc create -f - -n ${cicd}
oc set resources dc/jenkins --limits=memory=1Gi
oc policy add-role-to-user edit system:serviceaccount:${cicd}:jenkins -n ${test}
oc policy add-role-to-user edit system:serviceaccount:${cicd}:jenkins -n ${prod}
oc policy add-role-to-user view system:serviceaccount:${test}:default -n ${test}
oc policy add-role-to-user view system:serviceaccount:${prod}:default -n ${prod}
