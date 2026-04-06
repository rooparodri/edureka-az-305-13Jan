pipeline {
    agent any
    environment {
        SNOWSQL_ACCOUNT = "dalzfbs"
        SNOWSQL_USER = credentials('snowflake-creds')
        SNOWSQL_WAREHOUSE = "COMPUTE_WH"
        SNOWSQL_DB = "MYDB"
        SNOWSQL_SCHEMA = "PUBLIC"
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
                // Run RAW load
                sh """
                snowsql -a $SNOWSQL_ACCOUNT -u $SNOWSQL_USER_USR -p $SNOWSQL_USER_PSW \
                -w $SNOWSQL_WAREHOUSE -d $SNOWSQL_DB -s $SNOWSQL_SCHEMA \
                -f sql/load_raw.sql
                """
                // Run STAGE transform
                sh """
                snowsql -a $SNOWSQL_ACCOUNT -u $SNOWSQL_USER_USR -p $SNOWSQL_USER_PSW \
                -w $SNOWSQL_WAREHOUSE -d $SNOWSQL_DB -s $SNOWSQL_SCHEMA \
                -f sql/transform_stage.sql
                """
                // Run SCD2 merge
                sh """
                snowsql -a $SNOWSQL_ACCOUNT -u $SNOWSQL_USER_USR -p $SNOWSQL_USER_PSW \
                -w $SNOWSQL_WAREHOUSE -d $SNOWSQL_DB -s $SNOWSQL_SCHEMA \
                -f sql/scd2_merge.sql
                """
            }
        }
    }
}
