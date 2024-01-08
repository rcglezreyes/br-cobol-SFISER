@Library('devops-pipeline-lib@feature/scan-cobol') _
def remote_dev = [:]
    remote_dev.name = ""
    remote_dev.host = ""
    remote_dev.allowAnyHosts = true
    remote_dev.user = ""
    remote_dev.password = ""
    remote_dev.indbd = ""

def remote_test = [:]
    remote_test.name = ""
    remote_test.host = ""
    remote_test.allowAnyHosts = true
    remote_test.user = ""
    remote_test.password = ""
    remote_test.indbd = ""

def remote_pp = [:]
    remote_pp.name = ""
    remote_pp.host = ""
    remote_pp.allowAnyHosts = true
    remote_pp.user = ""
    remote_pp.password = ""
    remote_pp.indbd = ""

def remote_pro = [:]
    remote_pro.name = ""
    remote_pro.host = ""
    remote_pro.allowAnyHosts = true
    remote_pro.user = ""
    remote_pro.password = ""
    remote_pro.indbd = ""

pipeline {
    options {
        disableConcurrentBuilds()
    }
    agent {
        kubernetes {
            inheritFrom 'standard-agent' 
        }
    }
    stages {
        stage("Init Source") {
            steps {
                container ('runner') {
                    withCredentials([string(credentialsId: 'PASS_COBOL_PILOT_DEV', variable: 'SECRET')]) 
                    { 
                          sh '''
                          set +x
                          echo " " >> JenkinsParams
                          echo "PASS_DEV=${SECRET}" >> JenkinsParams
                          '''
                    }
                    withCredentials([string(credentialsId: 'PASS_COBOL_PILOT_TEST', variable: 'SECRET')]) 
                    { 
                          sh '''
                          set +x
                          echo " " >> JenkinsParams
                          echo "PASS_TEST=${SECRET}" >> JenkinsParams
                          '''
                    }
                    withCredentials([string(credentialsId: 'PASS_COBOL_PILOT_PP', variable: 'SECRET')]) 
                    { 
                          sh '''
                          set +x
                          echo " " >> JenkinsParams
                          echo "PASS_PP=${SECRET}" >> JenkinsParams
                          '''
                    }                    
                    script {
                        def props = readProperties file: 'JenkinsParams'
                        remote_dev.name = props['NAME_DEV']
                        remote_dev.host = props['HOST_DEV']
                        remote_dev.user = props['USER_DEV']
                        remote_dev.password = props['PASS_DEV']
                        remote_dev.indbd = props['INDICADOR_BD']
                        remote_test.name = props['NAME_TEST']
                        remote_test.host = props['HOST_TEST']
                        remote_test.user = props['USER_TEST']
                        remote_test.password = props['PASS_TEST']
                        remote_test.indbd = props['INDICADOR_BD']
                        remote_pp.name = props['NAME_PP']
                        remote_pp.host = props['HOST_PP']
                        remote_pp.user = props['USER_PP']
                        remote_pp.password = props['PASS_PP']
                        remote_pp.indbd = props['INDICADOR_BD']
                        remote_pro.name = props['NAME_PRO']
                        remote_pro.host = props['HOST_PRO']
                        remote_pro.user = props['USER_PRO']
                        remote_pro.password = props['PASS_PRO']
                        remote_pro.indbd = props['INDICADOR_BD']
                        env.NAME_SCRIPT = props['COMPONENTE_SIN_EXTENSION']
                        env.SLACK_CHANNEL="ci-cd-cobol"
                        env.SHORT_COMMIT = env.GIT_COMMIT.substring(0,8)
                        env.GIT_REPO_URL = env.GIT_URL_1 ?: env.GIT_URL
                        env.GIT_REPO_NAME = env.GIT_REPO_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
                        env.S3_NAME_DEV = props['S3_NAME_DEV']
                        env.PROJECT_NAME = props['PROJECT_NAME']
                        env.PROJECT_KEY = props['PROJECT_KEY']
                        env.VERSION = props['VERSION']
                        env.SCAN_SOURCE = "."
                        env.AUDITING_URL = props['AUDITING_URL']
                        env.PATH_TEST_EJE = props['PATH_TEST_EJE']
                        env.PATH_TEST_CAD = props['PATH_TEST_CAD']
                        env.PATH_TEST_SRC = props['PATH_TEST_SRC']
                        env.PATH_PP_EJE = props['PATH_PP_EJE']
                        env.PATH_PP_CAD = props['PATH_PP_CAD']
                        env.PATH_PP_SRC = props['PATH_PP_SRC']
                        env.PATH_PRO_EJE = props['PATH_PRO_EJE']
                        env.PATH_PRO_CAD = props['PATH_PRO_CAD']
                        env.PATH_PRO_SRC = props['PATH_PRO_SRC']
                        env.FECHA_INICIO = props['FECHA_INICIO']
                        env.FECHA_FIN = props['FECHA_FIN']
                        env.FORTIFY_OTHER_OPTIONS = '-noextension-type COBOL -copydirs cpy -copy-extensions cpy;cob'
                        sh "mv src/SFISERB811C.pco src/SFISERB811C"
                        sh "mv src/SFISERS300C.pco src/SFISERS300C"
                    }

                    // STASH SOURCE CODE FOR SCANS                    
                    dir('src'){
                        stash name: 'source_code', includes: "**/*", excludes: "${env.SCAN_EXCLUDE_FILES}"
                    }
                    
                    slackSend channel: "#${env.SLACK_CHANNEL}", message: 
                    """ _PIPELINE - STARTED_...
                        |*JOB_NAME:* ${env.JOB_NAME}
                        |*REPOSITORY_NAME:* ${env.GIT_REPO_NAME} 
                        |*BRANCH_NAME:* ${env.BRANCH_NAME}
                        |*BUILD_NUMBER:* ${env.BUILD_NUMBER}
                        |*RUN_URL:* ${env.RUN_DISPLAY_URL}
                    """.stripMargin()
                }
            }
        }
        stage('Security Scan') {
          when {
            expression { env.BRANCH_NAME != null && env.BRANCH_NAME ==~ /(development)/ } }
          steps {
            script {
              securityScan()                   //Security Scans
            }
          }
        }
        stage("Upload Source") {
            when { expression { env.BRANCH_NAME ==~ /(development)/ }}
            steps {
                container ('runner') {
         //           sshPut remote: remote_dev, from: "src/${env.NAME_SCRIPT}", into: "/u02/users/${remote_dev.user}/src/${env.NAME_SCRIPT}.pco"
                }
            }
        }                                            
        stage("Compile Source") {
            when { expression { env.BRANCH_NAME ==~ /(development)/ }}
            steps {
                container ('runner') {
//                    script {
//                       sshCommand remote: remote_dev, command: ". /u02/users/${remote_dev.user}/.profile \
//                                                            && cd /u02/users/${remote_dev.user}/src/ \
//                                                            && ksh rcompila.sh ${env.NAME_SCRIPT} ${remote_dev.indbd} \
//                                                            && ls -la /u02/users/${remote_dev.user}/des/${env.NAME_SCRIPT}.gnt \
//                                                            && ls -la /u02/users/${remote_dev.user}/src/${env.NAME_SCRIPT}.pco"
//                    }
                }
            }
        }
        stage("Donwload Compiled") {
            when { expression { env.BRANCH_NAME ==~ /(development)/ }}
            steps {
                container ('runner') {
                    script {
                        sh '''
                            RUTA=$(pwd)
                            mkdir -p $RUTA/eje/
                            chmod -R 777 $RUTA/eje/
                            ls -la $RUTA/eje/
                            '''
//                        sshGet remote: remote_dev, from: "/u02/users/${remote_dev.user}/src/${env.NAME_SCRIPT}.gnt", into: "eje/${env.NAME_SCRIPT}.gnt", override: true
                    }
                }
            }
        }
        stage("Upload Artifact") {
            when { expression { env.BRANCH_NAME ==~ /(development)/ }}
            steps {
                container ('runner') {
                    withAWS(credentials:'BR-AWS-APP-DEV-CL Terraform', region: 'us-east-1') {
//                    s3Upload(bucket: "${env.S3_NAME_DEV}/${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}", workingDir: "eje", includePathPattern: "**/*")
//                    s3Upload(bucket: "${env.S3_NAME_DEV}/${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}", workingDir: "cad", includePathPattern: "**/*")
                   }
                }
            }      
        }
        stage("Deploy") {
            when { expression { BRANCH_NAME ==~ /(development|release|master)/ } }
            parallel {
                stage('Deploy to Development') {
                    when { expression { env.BRANCH_NAME ==~ /(development)/ }}
                    steps{
                        container('runner') {
                            withAWS(credentials:'BR-AWS-APP-DEV-CL Terraform', region: 'us-east-1') {
                                // s3Download(file:"eje/${env.NAME_SCRIPT}.gnt", bucket:"${env.S3_NAME_DEV}", path:"${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}/${env.NAME_SCRIPT}.gnt", force:true)
                                // s3Download(file:"cad/${env.NAME_SCRIPT}.sh", bucket:"${env.S3_NAME_DEV}", path:"${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}/${env.NAME_SCRIPT}.sh", force:true)
                            }
                            // sshPut remote: remote_test, from: "src/${env.NAME_SCRIPT}", into: "${env.PATH_TEST_SRC}/${env.NAME_SCRIPT}.pco"
                            // sshPut remote: remote_test, from: "eje/${env.NAME_SCRIPT}.gnt", into: "${env.PATH_TEST_EJE}/"
                            // sshPut remote: remote_test, from: "cad/${env.NAME_SCRIPT}.sh", into: "${env.PATH_TEST_CAD}/"
                            // sshCommand remote: remote_test, command: ". /itf_migra/migrasat2/.profile \
                            //                                 && ls -la ${env.PATH_TEST_SRC}/${env.NAME_SCRIPT}.pco \
                            //                                 && ls -la ${env.PATH_TEST_EJE}/${env.NAME_SCRIPT}.gnt \
                            //                                 && ls -la ${env.PATH_TEST_CAD}/${env.NAME_SCRIPT}.sh \
                            //                                 && ksh ${env.PATH_TEST_CAD}/${env.NAME_SCRIPT}.sh ${env.FECHA_INICIO} ${env.FECHA_FIN}"
                            script {
                                //Enviar Notificacion a Slack
                                slackSend channel: "#${env.SLACK_CHANNEL}", color: '#FFFF00', message: 
                                """ _PIPELINE - DEPLOYING, WAITING ..._
                                    |*JOB_NAME:* ${env.JOB_NAME}
                                    |*REPOSITORY_NAME:* ${env.GIT_REPO_NAME} 
                                    |*BRANCH_NAME:* ${env.BRANCH_NAME}
                                    |*ENVIRONMENT:* TEST
                                    |*VERSION:* ${env.VERSION}
                                    |*BUILD_NUMBER:* ${env.BUILD_NUMBER}
                                    |*RUN_URL:* ${env.RUN_DISPLAY_URL}
                                """.stripMargin()
                            }
                        }
                    
                    }
                }
                stage('Deploy to PP') {
                    when { expression { BRANCH_NAME ==~ /(release)/ } }
                    steps{
                        container('runner') {
                            withAWS(credentials:'BR-AWS-APP-DEV-CL Terraform', region: 'us-east-1') {
                                // s3Download(file:"eje/${env.NAME_SCRIPT}.gnt", bucket:"${env.S3_NAME_DEV}", path:"${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}/${env.NAME_SCRIPT}.gnt", force:true)
                                // s3Download(file:"cad/${env.NAME_SCRIPT}.sh", bucket:"${env.S3_NAME_DEV}", path:"${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}/${env.NAME_SCRIPT}.sh", force:true)
                            }
                            // sshPut remote: remote_pp, from: "src/${env.NAME_SCRIPT}", into: "${env.PATH_PP_SRC}/${env.NAME_SCRIPT}.pco"
                            // sshPut remote: remote_pp, from: "eje/${env.NAME_SCRIPT}.gnt", into: "${env.PATH_PP_EJE}/"
                            // sshPut remote: remote_pp, from: "cad/${env.NAME_SCRIPT}.sh", into: "${env.PATH_PP_CAD}/"
                            script {
                                //Enviar Notificacion a Slack
                                slackSend channel: "#${env.SLACK_CHANNEL}", color: '#FFFF00', message: 
                                """ _PIPELINE - DEPLOYING, WAITING ..._
                                    |*JOB_NAME:* ${env.JOB_NAME}
                                    |*REPOSITORY_NAME:* ${env.GIT_REPO_NAME} 
                                    |*BRANCH_NAME:* ${env.BRANCH_NAME}
                                    |*ENVIRONMENT:* PREPRODUCTION
                                    |*VERSION:* ${env.VERSION}
                                    |*BUILD_NUMBER:* ${env.BUILD_NUMBER}
                                    |*RUN_URL:* ${env.RUN_DISPLAY_URL}
                                """.stripMargin()
                            }
                        }
                    
                    }
                }
                stage('Deploy to Production') {
                    when { expression { BRANCH_NAME ==~ /(master)/ }}
                    steps{
                        container('runner') {
                            withAWS(credentials:'BR-AWS-APP-DEV-CL Terraform', region: 'us-east-1') {
                                // s3Download(file:"eje/${env.NAME_SCRIPT}.gnt", bucket:"${env.S3_NAME_DEV}", path:"${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}/${env.NAME_SCRIPT}.gnt", force:true)
                                // s3Download(file:"cad/${env.NAME_SCRIPT}.sh", bucket:"${env.S3_NAME_DEV}", path:"${env.PROJECT_NAME}/${env.NAME_SCRIPT}.v${env.VERSION}/${env.NAME_SCRIPT}.sh", force:true)
                            }
                            // sshPut remote: remote_pro, from: "src/${env.NAME_SCRIPT}", into: "${env.PATH_PRO_SRC}/${env.NAME_SCRIPT}.pco"
                            // sshPut remote: remote_pro, from: "eje/${env.NAME_SCRIPT}.gnt", into: "${env.PATH_PRO_EJE}/"
                            // sshPut remote: remote_pro, from: "cad/${env.NAME_SCRIPT}.sh", into: "${env.PATH_PRO_CAD}/"
                            
                            script {
                                //Enviar Notificacion a Slack
                                slackSend channel: "#${env.SLACK_CHANNEL}", color: '#FFFF00', message: 
                                """ _PIPELINE - DEPLOYING, WAITING ..._
                                    |*JOB_NAME:* ${env.JOB_NAME}
                                    |*REPOSITORY_NAME:* ${env.GIT_REPO_NAME} 
                                    |*BRANCH_NAME:* ${env.BRANCH_NAME}
                                    |*ENVIRONMENT:* PRODUCTION
                                    |*VERSION:* ${env.VERSION}
                                    |*BUILD_NUMBER:* ${env.BUILD_NUMBER}
                                    |*RUN_URL:* ${env.RUN_DISPLAY_URL}
                                """.stripMargin()
                            }
                        }
                    
                    }
                }
            }            
        }
    }
    post {
        always {
            script {
                //Enviar Notificacion de termino a Slack 
                switch (currentBuild.result) {
                    case 'SUCCESS':
                        env.colorCode = '#00FF00' // Green
                        env.FINAL_STATUS = "SUCCESS"
                        break
                    case 'UNSTABLE':
                        env.colorCode = '#FF9B00' // Yellow
                        env.FINAL_STATUS = "UNSTABLE"
                        break
                    case 'FAILURE':
                        env.colorCode = '#FF0000' // Red
                        env.FINAL_STATUS = "ERROR"
                        break;
                    case 'ABORTED':
                        env.colorCode = '#6B006F' // Purple
                        env.FINAL_STATUS = "ABORTED"
                        break;
                }

                slackSend channel: "#${env.SLACK_CHANNEL}", color: "${env.colorCode}", message: 
                """ _PIPELINE - FINISHED..._
                    |*JOB_NAME:* ${env.JOB_NAME}
                    |*REPOSITORY_NAME:* ${env.GIT_REPO_NAME} 
                    |*BRANCH_NAME:* ${env.BRANCH_NAME}
                    |*BUILD_NUMBER:* ${env.BUILD_NUMBER}
                    |*RUN_URL:* ${env.RUN_DISPLAY_URL}
                    |*STATUS:* ${currentBuild.result}
                    |*DURATION:* ${currentBuild.durationString.minus(' and counting')}
                """.stripMargin()

                httpRequest acceptType: 'APPLICATION_JSON',
                contentType: 'APPLICATION_JSON',
                httpMode: 'POST',
                requestBody: '{"PROJECT_NAME":"'+ env.PROJECT_NAME +'","REPO_NAME":"'+ env.GIT_REPO_NAME +'","BRANCH_NAME":"'+ env.BRANCH_NAME +'","CHANGE_ID":"'+ env.CHANGE_ID +'","CHANGE_TARGET":"'+ env.CHANGE_TARGET + '", "SHORT_COMMIT":"'+ env.SHORT_COMMIT +'", "DURATION":"'+ currentBuild.duration +'", "STATUS":"' + env.FINAL_STATUS + '" }',
                consoleLogResponseBody: true,
                url: "${env.AUDITING_URL}"
            
                cleanWs()
            }
        }
    }
}