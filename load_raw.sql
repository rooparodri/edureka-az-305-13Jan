USE DATABASE DB_FIDELITY;
COPY INTO raw_salary
FROM @stg_salary/tb_emp_salary
ON_ERROR = 'CONTINUE';

-- ⭐ Capture the COPY job ID
SET job_id = LAST_QUERY_ID();

-- Check COPY history (optional)
SELECT *
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME => 'RAW_SALARY',
        START_TIME => DATEADD('hour', -24, CURRENT_TIMESTAMP())
    )
);

-- ⭐ Correct VALIDATE usage
CREATE OR REPLACE TABLE load_errors AS
SELECT
    CURRENT_TIMESTAMP() AS LOAD_TIME,
    REJECTED_RECORD AS RAW_ROW,
    ERROR AS ERROR_MESS.AGE
FROM TABLE(
    VALIDATE(
        RAW_SALARY,
        JOB_ID => $job_id
    )
);

CREATE OR REPLACE TABLE stg_salary_clean AS
SELECT
    EMP_ID,
    TRIM(ROLE) AS ROLE,
    TRY_TO_NUMBER(SALARY) AS SALARY
FROM raw_salary;

--remove nulls
CREATE OR REPLACE TABLE stg_salary_valid AS
SELECT *
FROM stg_salary_clean
WHERE EMP_ID IS NOT NULL
  AND ROLE IS NOT NULL
  AND SALARY IS NOT NULL;

--add datetime
  CREATE OR REPLACE TABLE curated_salary (
    EMP_ID STRING,
    ROLE STRING,
    SALARY NUMBER(10,2),
    LOAD_DATE DATE
);

INSERT INTO curated_salary
SELECT
    EMP_ID,
    ROLE,
    SALARY,
    CURRENT_DATE() AS LOAD_DATE
FROM stg_salary_valid;

SELECT * FROM curated_salary;
0SELECT * FROM stg_salary_valid;
