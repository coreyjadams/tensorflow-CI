pipeline {
    agent {
        label 'Datascience-Theta'
    }
    environment {
        BUILD_ROOT = '/projects/datascience/jenkins-test/mpi4py-build'
        RELEASE_ROOT = '/projects/datascience/jenkins-test/mpi4py-release'
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
                   sh "if [ \$(qstat ${cobalt_id} | wc -l) -ne 0 ]; then exit 1; fi"
                }
                echo "Job completed; checking output..."
                sh "cat ${cobalt_id}.output"
                sh "grep -q 'Success: aprun -n2 gave rank0 and rank1' ${cobalt_id}.output"
                sh "grep -q 'task completed normally with an exit code of 0' ${cobalt_id}.cobaltlog"
            }
        }
    }
    post {
        success {
            sh "cp -r $BUILD_ROOT/env $RELEASE_ROOT/"
            mail to: 'msalim@anl.gov',
             subject: "Success!  Pipeline: ${currentBuild.fullDisplayName} completed.",
             body: "The build was a success in ${env.BUILD_URL}"
        }
        failure {
            mail to: 'msalim@anl.gov',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
        }
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
            deleteDir()
        }
    }
}
