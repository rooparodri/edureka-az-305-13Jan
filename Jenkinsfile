pipeline {
    agent any

    environment {
        SNOWSQL_ACCOUNT = "your_account"
        SNOWSQL_REGION  = "your_region"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Pulling code from GitHub..."
                checkout scm
            }
        }

        stage('Run Snowflake Scripts') {
            steps {
                echo "Executing SQL scripts in Snowflake..."

                withCredentials([usernamePassword(
                    credentialsId: 'snowflake-creds',
                    usernameVariable: 'SNOWSQL_USER',
                    passwordVariable: 'SNOWSQL_USER_PSW'
                )]) {

                    bat """
                        snowsql ^
                          -a %SNOWSQL_ACCOUNT% ^
                          -u %SNOWSQL_USER% ^
                          -p %SNOWSQL_USER_PSW% ^
                          -q "select current_version();"
                    """
                }
            }
        }
    }
}
