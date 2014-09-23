CREATE TABLE staging.events_first_sandbox_edit (
    wiki VARCHAR(50),
    user_id INT,
    user_text VARBINARY(255),
    timestamp VARBINARY(14),
    rev_id INT,
    page_id INT,
    page_namespace INT,
    page_title VARBINARY(255),
    archived TINYINT,
    PRIMARY KEY(wiki, user_id, page_namespace)
);
INSERT INTO staging.events_first_sandbox_edit
SELECT
    events_sandbox_edit.*
FROM (
    SELECT wiki, MIN(IF(rev_id > 0, rev_id, NULL)) AS rev_id
    FROM staging.events_sandbox_edit
    WHERE rev_user > 0
    GROUP BY wiki, rev_user
    UNION ALL
    SELECT wiki, MIN(IF(rev_id > 0, rev_id, NULL)) AS rev_id
    FROM staging.events_sandbox_edit
    WHERE rev_user = 0
    GROUP BY wiki, rev_user, rev_user_text
) AS first_sandbox_edits
INNER JOIN staging.events_sandbox_edit USING(wiki, rev_id);
SELECT NOW(), COUNT(*) FROM staging.events_first_sandbox_edit;
