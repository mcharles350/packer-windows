#!groovy

node {
    def err = null
    currentBuild.result = "SUCCESS"

    try {
        stage 'Checkout'
            checkout scm

        stage 'Validate'
            def packer_file = 'test/template.json'
            print "Running Packer validate on : ${packer_file}"
            sh "packer -v ; packer validate ${packer_file}"

        stage 'Build'
            def variable_file = 'test/variable.json'
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            sh "packer build -machine-readable -var 'AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}' -var 'AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' -var-file='${variable_file}' ${packer_file}"
        
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