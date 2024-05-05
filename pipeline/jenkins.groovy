pipeline {
    agent any
    environment {
        PROJECT_ID = credentials('GKE_PROJECT')
        GKE_CLUSTER = 'tf-cluster'
        GKE_ZONE = 'europe-central2-c'
        IMAGE = 'demo_app'
        REPO_IMAGE = '1s_week_build_ship_run'
        DEPLOYMENT_NAME = 'go-service'
        IMAGE_TAG = 'production'
        OS = 'linux'
        ARCH = 'amd64'
        GAR_ZONE = 'europe-central2'
        GAR_REPO = 'dc-docker-repo'
        GK_SA_KEY = credentials('GK_SA_KEY')
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')
    }
    stages {
        stage('Setup') {
            steps {
                script {
                    def userOS = input(id: 'userOS', description: 'Choose the Operating System', parameters: [choice(name: 'OS', choices: ['linux', 'windows', 'macOS'], description: 'Select OS')])
                    def userARCH = input(id: 'userARCH', description: 'Choose the Architecture', parameters: [choice(name: 'ARCH', choices: ['amd64', 'arm64', '386'], description: 'Select Architecture')])
                    env.OS = userOS
                    env.ARCH = userARCH
                }
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Auth') {
            steps {
                script {
                    // Authenticate with Google Cloud
                    sh "echo \$GK_SA_KEY | gcloud auth activate-service-account --key-file=-"
                    sh "gcloud config set project \$PROJECT_ID"
                }
            }
        }
        stage('Setup Docker and GKE') {
            steps {
                script {
                    // Setup Docker to use the gcloud as a credential helper
                    sh "gcloud --quiet auth configure-docker \$GAR_ZONE-docker.pkg.dev"
                    sh "gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://\$GAR_ZONE-docker.pkg.dev"
                    // Get GKE credentials
                    sh "gcloud container clusters get-credentials \$GKE_CLUSTER --zone \$GKE_ZONE --project \$PROJECT_ID"
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    dir('demo') {
                        // Build the Docker image
                        sh "docker build --tag \"\$GAR_ZONE-docker.pkg.dev/\$PROJECT_ID/\$GAR_REPO/\$IMAGE:\$IMAGE_TAG\" --build-arg GITHUB_SHA=\$GIT_COMMIT --build-arg GITHUB_REF=\$GIT_BRANCH ."
                        // Push the Docker image
                        sh "docker push \"\$GAR_ZONE-docker.pkg.dev/\$PROJECT_ID/\$GAR_REPO/\$IMAGE:\$IMAGE_TAG\""
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy to GKE
                    sh "kubectl apply -f ./demo/deploy/go_demo_template.yaml"
                    sh "kubectl get pods"
                    sh "kubectl rollout restart deploy/\$DEPLOYMENT_NAME"
                }
            }
        }
        stage('Login and Push to GitHub Container Registry') {
            steps {
                script {
                    // Login to GitHub Container Registry
                    sh "echo \$GITHUB_TOKEN | docker login ghcr.io -u \$GITHUB_ACTOR --password-stdin"
                    dir('demo') {
                        // Build and push Docker image to GitHub Container Registry
                        sh "docker build --tag \"ghcr.io/diamonce/\$REPO_IMAGE:\$IMAGE_TAG-\$OS-\$ARCH\" --build-arg GITHUB_SHA=\$GIT_COMMIT --build-arg GITHUB_REF=\$GIT_BRANCH ."
                        sh "docker push \"ghcr.io/diamonce/\$REPO_IMAGE:\$IMAGE_TAG-\$OS-\$ARCH\""
                    }
                }
            }
        }
    }
}
