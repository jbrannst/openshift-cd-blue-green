cicd=cicd
test=test
prod=prod
git_repo=https://github.com/jbrannst/appdev-foundations-kitchensink
date
echo "Creating namespaces."
oc new-project ${test} --display-name="Kitchensink - Test" > /dev/null
oc new-project ${prod} --display-name="Kitchensink - Prod" > /dev/null
oc new-project ${cicd} --display-name="CI/CD" > /dev/null
echo "Creating components."
oc process -f cicd-template.yaml -p TEST_PROJECT=${test} -p PROD_PROJECT=${prod} -p GIT_REPO=${git_repo} | oc create -f - -n ${cicd}
oc set resources dc/jenkins --limits=memory=1Gi
oc policy add-role-to-user edit system:serviceaccount:${cicd}:jenkins -n ${test}
oc policy add-role-to-user edit system:serviceaccount:${cicd}:jenkins -n ${prod}
oc policy add-role-to-user view system:serviceaccount:${test}:default -n ${test}
oc policy add-role-to-user view system:serviceaccount:${prod}:default -n ${prod}
echo "Waiting for Jenkins to start."
oc logs -f dc/jenkins > /dev/null
echo "Waiting for Gogs installation."
oc logs -f install-gogs > /dev/null
date
echo "Running cicd pipeline"
oc start-build -F cicd-pipeline > /dev/null
date
echo "Now go to ${cicd} project and update the app in gogs. Username=gogs & Password=password"
