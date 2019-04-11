pipeline {
    agent {
        label 'Datascience-Theta'
    }
    environment {
        BUILD_ROOT = '/projects/datascience/jenkins-test/mpi4py-demo'
    }
    stages {
        stage('Virtualenv Setup') {
            steps {
                sh 'pwd'
                sh 'ls'
                sh '. ./env-setup.sh'
            }
        }
        stage('Build Cython') {
            steps {
                sh '. ./build-cython.sh'
            }
        }
        stage('Build mpi4py') {
            steps {
                sh '. ./build-mpi4py.sh'
            }
        }
        stage('Quick Test') {
            environment { 
                QSTAT_HEADER = 'JobId:User:JobName'
            }
            steps {
                script {
                    cobalt_id = sh(returnStdout: true, script: 'qsub -A datascience -n 1 -t 10 -q debug-cache-quad ./testMPI4Py.sh | tail -n 1').trim()
                }
                echo "Submitted Job to cobalt (ID ${cobalt_id}). Polling on completion..."
                retry(17280) {
                   sleep(5)
                   sh "qstat ${cobalt_id}"
                }
                echo "Job completed; checking output..."
                sh 'cat *.output'
                sh 'grep -q "Success: aprun -n2 gave rank0 and rank1" *.output'
                sh 'grep -q "task completed normally with an exit code of 0" *.cobaltlog'
            }
        }
    }
    post {
        always {
            sh 'rm -rf $BUILD_ROOT'
            sh 'rm -rf ./cython'
            sh 'rm -rf ./mpi4py'
            sh '''
            rm printRank.out
            rm *.output
            rm *.error
            rm *.cobaltlog
            '''
        }
        success {
            slackSend channel: '#datascience_team',
                color: 'good',
                message: "The pipeline ${currentBuild.fullDisplayName} completed successfully"
        }
        failure {
            slackSend channel: '#datascience_team',
                color: 'bad',
                message: "The pipeline ${currentBuild.fullDisplayName} failed"
        }
    }
}
