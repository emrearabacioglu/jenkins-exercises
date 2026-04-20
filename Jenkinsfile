pipeline {
    agent any
    triggers {
        githubPush()
    }
    tools {
        nodejs "my-nodejs"
    }
    stages {
        stage('increment version'){
            steps {
                script {
                    dir("app") {
                        sh "npm version minor --no-git-tag-version"
                        def packageJson = readJSON file: 'package.json'
                        def version = packageJson.version
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    dir("app") {

                        sh "npm install"
                        sh "npm run test"
                    }
                }
            }
        }
        stage('Build/Push docker image') {
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "docker build -t emrearabacioglu/mynodeapp:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push emrearabacioglu/mynodeapp:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('Commit version update') {
            steps{
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'
                        sh 'git remote set-url origin https://$USER:$PASS@github.com/emrearabacioglu/jenkins-exercises.git'
                        sh 'git add .'
                        sh 'git commit -m "version bump"'
                        sh 'git pull --rebase origin master'
                        sh 'git push origin HEAD:master'
                    }
                }
            }
        }
    }
}
