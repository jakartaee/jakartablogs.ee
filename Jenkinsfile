@Library('common-shared') _

def environmentFromBranch(branch) {
  if (branch == 'master') {
    return 'production'
  } else if (branch == 'staging') {
    return 'staging'
  } else {
   return ''
  }
}

pipeline {
  agent any

  environment {
    APP_NAME = 'jakartablogs-ee'
    NAMESPACE = 'foundation-internal-webdev-apps'
    IMAGE_NAME = 'eclipsefdn/jakartablogs.ee'
    ENVIRONMENT = environmentFromBranch(env.BRANCH_NAME)
    GIT_COMMIT_SHORT = sh(
      script: "printf \$(git rev-parse --short ${GIT_COMMIT})",
      returnStdout: true
    )
    IMAGE_TAG = sh(
      script: "printf ${ENVIRONMENT:+${ENVIRONMENT}-}${GIT_COMMIT_SHORT}-${BUILD_NUMBER}",
      returnStdout: true
    )
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  tools {
    oc 'oc-for-c1-ci.eclipse.org'
  }

  stages {
    stage('Build and push image') {
      agent {
        label 'docker-build'
      }
      steps {
        sh '''
          THEME_PATH="$(awk -F "=" '/output_theme/ {print $2}' planet/planet.ini | sed -e 's/^ *//' -e 's/ *$//')"
          WWW_PATH="$(awk -F "=" '/output_dir/ {print $2}' planet/planet.ini | sed -e 's/^ *//' -e 's/ *$//')"
          CACHE_PATH="$(awk -F "=" '/cache_directory/ {print $2}' planet/planet.ini | sed -e 's/^ *//' -e 's/ *$//')"
          docker build --pull \
            --build-arg THEME_PATH="${THEME_PATH}" \
            --build-arg WWW_PATH="${WWW_PATH}" \
            --build-arg CACHE_PATH="${CACHE_PATH}" \
            -t ${IMAGE_NAME}:${IMAGE_TAG} \
            -t ${IMAGE_NAME}:latest .
        '''
        withDockerRegistry([credentialsId: '04264967-fea0-40c2-bf60-09af5aeba60f', url: 'https://index.docker.io/v1/']) {
          sh '''
            docker push ${IMAGE_NAME}:${IMAGE_TAG}
            docker push ${IMAGE_NAME}:latest
          '''
        }
      }
    }

    stage('Deploy to cluster') {
      when {
        anyOf {
          environment name: 'ENVIRONMENT', value: 'production'
          environment name: 'ENVIRONMENT', value: 'staging'
        }
        expression {
          openshift.withCluster('c1-ci.eclipse.org') {
            openshift.withProject("${NAMESPACE}") {
              return openshift.selector('deployments', [app: "${APP_NAME}", environment: "${ENVIRONMENT}"]).exists();
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster('c1-ci.eclipse.org') {
            openshift.withProject("${NAMESPACE}") {
              def appSelector = openshift.selector('deployments', [app: "${APP_NAME}", environment: "${ENVIRONMENT}"])
              appSelector.describe()
              def app = appSelector.object()
              app.spec.template.spec.containers[1].image = "${IMAGE_NAME}"+':'+"${IMAGE_TAG}"
              openshift.apply(app)
              timeout(5) {
                appSelector.rollout().status()
              }
            }
          }
        }
      }
    }
  }

  post {
    always {
      deleteDir() /* clean up workspace */
    }
    unsuccessful { // either unstable or failed
      sendNotifications currentBuild.result
    }
    fixed { // back to normal
      sendNotifications 'FIXED'
    }
  }
}
