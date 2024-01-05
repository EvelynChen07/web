-- migrate:up
INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathOne'
    WHERE
        upchieve.certifications.name = 'algebraOne') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathOne'
    WHERE
        upchieve.certifications.name = 'geometry') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathOne'
    WHERE
        upchieve.certifications.name = 'statistics') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

-- integrated math two
INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathTwo'
    WHERE
        upchieve.certifications.name = 'algebraOne') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathTwo'
    WHERE
        upchieve.certifications.name = 'geometry') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathTwo'
    WHERE
        upchieve.certifications.name = 'trigonometry') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathTwo'
    WHERE
        upchieve.certifications.name = 'statistics') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

-- integrated math 3
INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathThree'
    WHERE
        upchieve.certifications.name = 'statistics') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathThree'
    WHERE
        upchieve.certifications.name = 'precalculus') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

-- integrated math four
INSERT INTO upchieve.computed_subject_unlocks (subject_id, certification_id, created_at, updated_at)
SELECT
    subquery.subject_id,
    subquery.certification_id,
    NOW(),
    NOW()
FROM (
    SELECT
        upchieve.certifications.id AS certification_id,
        upchieve.subjects.id AS subject_id
    FROM
        upchieve.certifications
        JOIN upchieve.subjects ON upchieve.subjects.name = 'integratedMathFour'
    WHERE
        upchieve.certifications.name = 'precalculus') AS subquery
ON CONFLICT (subject_id,
    certification_id)
    DO NOTHING
RETURNING
    subject_id AS ok;

-- migrate:down
DELETE FROM upchieve.computed_subject_unlocks;

