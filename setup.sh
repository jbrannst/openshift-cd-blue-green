oc new-project jb-dev --display-name="Tasks - Dev"
oc new-project jb-stage --display-name="Tasks - Stage"
oc new-project jb-cicd --display-name="CI/CD"
oc create -f jenkins-ephemeral.yaml -n jb-cicd
oc process -f cicd-template.yaml -p DEV_PROJECT=jb-dev -p STAGE_PROJECT=jb-stage | oc create -f - -n jb-cicd
