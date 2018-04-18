#!groovy

node {
    def err = null
    currentBuild.result = "SUCCESS"

    def env = System.getenv()
    aws_access_key_id = env['AWS_ACCESS_KEY_ID']
    aws_secret_access_key = env['AWS_SECRET_KEY_ID']

    try {
        stage 'Checkout'
            checkout scm

        stage 'Validate'
            def packer_file = 'test/template.json'
            print "Running Packer validate on : ${packer_file}"
            sh "packer -v ; packer validate ${packer_file}"

        stage 'Build'
            steps {
                withCredentials([usernamePassword(credentialsId: '2475f567-22c6-4328-94ce-de37902a0d55', passwordVariable: 'AWS_SECRET',
                usernameVariable: 'AWS_KEY')
                ]) {
                    def variable_file = 'test/variable.json'
                    sh "packer build -machine-readable -var 'AWS_ACCESS_KEY_ID=${AWS_KEY}' -var 'AWS_SECRET_ACCESS_KEY=${AWS_SECRET}' -var-file='${variable_file}' test/${packer_file}"
                }
            }

        stage 'Test'
            print "Testing goes here."
    }

    catch (caughtError) {
        err = caughtError
        currentBuild = "FAILURE"
    }

    finally {
        if (err) {
            throw err
        }
    }
}