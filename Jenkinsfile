pipeline {
    agent any
    environment {
        SNOWSQL_ACCOUNT = "your_account_here"
        SNOWSQL_REGION  = "your_region_here"
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
                    // Windows uses bat, not sh
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
