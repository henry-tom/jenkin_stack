pipeline {
    agent { label 'agent2' }

    environment {
        SSH_HOST = '61.28.229.47'
        SSH_PORT = '234'
        REMOTE_DIR = '/home/stackops/api_public'
        JAR_FILE = 'NWS_APIPublic-0.0.1-SNAPSHOT.jar'
    }

    stages {
        stage('Restart Service') {
            steps {
                sshagent(credentials: ['ssh_agent_node']) {
                    sh '''
                       ls -lah
                    '''
                }
            }
        }
    }
}
