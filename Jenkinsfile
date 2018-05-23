#!groovy

node {

    def err = null
    currentBuild.result = "SUCCESS"

    try {
        stage 'Checkout'
        checkout scm 

        stage 'Validate'
        def packer_file = 'template.json'
        print "Running packer validate on : ${packer_file}"
        sh "packer -v ; packer validate ${packer_file}"

        stage 'Build'
        sh "packer build ${packer_file}"
    }

    catch (caughtError) {
        err = caughtError
        currentBuild.result = "FAILURE"
    }
}