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
  agent {
    kubernetes {
      label 'kubedeploy-agent'
      yaml '''
      apiVersion: v1
      kind: Pod
      spec:
        containers:
        - name: kubectl
          image: eclipsefdn/kubectl:1.9-alpine
          command:
          - cat
          tty: true
      '''
    }
  }

  environment {
    APP_NAME = 'jakartablogs-ee'
    NAMESPACE = 'foundation-internal-webdev-apps'
    IMAGE_NAME = 'eclipsefdn/jakartablogs.ee'
    CONTAINER_NAME = 'planet-venus'
    ENVIRONMENT = environmentFromBranch(env.BRANCH_NAME)
    GIT_COMMIT_SHORT = sh(
      script: "printf \$(git rev-parse --short ${GIT_COMMIT})",
      returnStdout: true
    )
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
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
            -t ${IMAGE_NAME}:${ENVIRONMENT:+"${ENVIRONMENT}-"}${GIT_COMMIT_SHORT}-${BUILD_NUMBER} \
            -t ${IMAGE_NAME}:latest .
        '''
      }
    }

    stage('Push docker image') {
      agent {
        label 'docker-build'
      }
      when {
        anyOf {
          environment name: 'ENVIRONMENT', value: 'production'
          environment name: 'ENVIRONMENT', value: 'staging'
        }
      }
      steps {
        withDockerRegistry([credentialsId: '04264967-fea0-40c2-bf60-09af5aeba60f', url: 'https://index.docker.io/v1/']) {
          sh '''
            docker push ${IMAGE_NAME}:${ENVIRONMENT:+"${ENVIRONMENT}-"}${GIT_COMMIT_SHORT}-${BUILD_NUMBER}
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
      }
      steps {
        container('kubectl') {
          withKubeConfig([credentialsId: '1d8095ea-7e9d-4e94-b799-6dadddfdd18a', serverUrl: 'https://console-int.c1-ci.eclipse.org']) {
            sh '''
              DEPLOYMENT=$(k8s getFirst deployment "${NAMESPACE}" "app=${APP_NAME},environment=${ENVIRONMENT}")
              if [[ $(echo "${resource}" | jq -r 'length') -eq 0 ]]; then
                echo "ERROR: Unable to find a deployment to patch matching '${selector}' in namespace ${namespace}"
                exit 1
              else 
                DEPLOYMENT_NAME=$(echo "${DEPLOYMENT}" | jq -r '.metadata.name')
                kubectl set image deployment.v1.apps/"${DEPLOYMENT_NAME}" -n "${NAMESPACE}" "${CONTAINER_NAME}="${IMAGE_NAME}:${ENVIRONMENT:+"${ENVIRONMENT}-"}${GIT_COMMIT_SHORT}-${BUILD_NUMBER}" --record=true
                if ! kubectl rollout status "deployment.v1.apps/${DEPLOYMENT_NAME}" -n "${NAMESPACE}"; then
                  # will fail if rollout does not succeed in less than .spec.progressDeadlineSeconds
                  kubectl rollout undo "deployment.v1.apps/${DEPLOYMENT_NAME}" -n "${NAMESPACE}"
                fi
              fi
            '''
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
