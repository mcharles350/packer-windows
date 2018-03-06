#!groovy

node {
    def err = null
    currentBuild.result = "SUCCESS"

    try {
        stage 'Checkout'
            checkout scm

        stage 'Validate'
            def packer_file = 'template.json'
            print "Running Packer validate on : ${packer_file}"
            sh "packer -v ; packer validate ${packer_file}"

        stage 'Build'
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            sh "packer build -machine-readable -var 'AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}' -var 'AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}' -var-file='test/variable.json' test/template.json"
        
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