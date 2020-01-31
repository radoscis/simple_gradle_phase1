@Library(value="github.com/tomtom-international/jsl@master", changelog=false) _

pipeline {

    agent {
        label 'master'
    }

    parameters {
        string(name: 'git_repo_http', defaultValue: 'https://github.com/radoscis/simple_gradle_phase1', description: 'Repo containing pipeline-yaml')
        string(name: 'git_repo_branch', defaultValue: 'multiple_pipes', description: 'Working Branch')
        string(name: 'ado_project_name', defaultValue: 'Nav-Pipeline', description: 'Project in ADO')
        string(name: 'ado_endpoint_id', defaultValue: 'fa5ffb04-951b-40d7-8dbf-89301a2c7550', description: 'Service Connection Endpoint ID')
    }

     stages {
        stage('Find all yaml files'){
            agent {
                docker {
                    image 'artifactory-staging.navkit-pipeline.tt3.com/navcd-1494/az-cli:3.1'
                    registryUrl 'https://artifactory-staging.navkit-pipeline.tt3.com'
                    reuseNode true
                    registryCredentialsId 'docker-staging'
                }
            }
            steps {
                withCredentials([string(credentialsId: 'ADO_PAT', variable: 'ADO_PAT')]) {
                    withEnv(["AZURE_DEVOPS_EXT_PAT=$ADO_PAT"]) {
                        sh 'az devops configure --defaults organization=https://dev.azure.com/tomtomweb project="Nav-Pipeline" --use-git-aliases true'
                        sh '''for fn in $(find . -regextype posix-egrep -regex "./.*\\w*-\\w*-*[0-9]*.yml"); do
                        pipeline_name=$(basename $fn | tr -d '.yml');
                        echo $pipeline_name;
                        az pipelines create --name $pipeline_name --description 'Test of multiple yaml in one repo' --service-connection "\${ado_endpoint_id}" \
                        --repository "\${git_repo_http}" --branch multiple_pipes --yml-path $fn
                        done'''
                    }
                }
            }
        }
     }
    post {
        success {
                cleanWs()
        }
    }
}