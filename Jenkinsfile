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
                sh 'source env-setup.sh'
            }
        }
        stage('Build Cython') {
            steps {
                sh 'source build-cython.sh'
            }
        }
        stage('Build mpi4py') {
            steps {
                sh 'source build-mpi4py.sh'
            }
        }
        stage('Quick Test') {
            environment { 
                QSTAT_HEADER = 'JobId:User:JobName'
            }
            steps {
                sh 'qsub -A datascience -n 1 -t 10 -q debug-cache-quad testMPI4Py.sh'
                echo "Submitted Job to cobalt; polling on completion..."
                retry(17280) {
                   sleep(5)
                   sh 'qstat -u $USER | grep -q testMPI4Py'
                }
                echo "Job completed; checking output..."
                sh 'grep -q "Success: aprun -n2 gave rank0 and rank1" *.output'
                sh 'grep -q "task completed normally with an exit code of 0" *.cobaltlog'
            }
        }
    }
}
