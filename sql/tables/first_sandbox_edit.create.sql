CREATE TABLE IF NOT EXISTS staging.events_first_sandbox_edit (
    wiki VARCHAR(50),
    user_id INT,
    user_text VARBINARY(255),
    timestamp VARBINARY(14),
    rev_id INT,
    page_id INT,
    page_namespace INT,
    page_title VARBINARY(255),
    archived TINYINT,
    PRIMARY KEY(wiki, user_id, user_text)
);
SELECT NOW(), COUNT(*) FROM staging.events_first_sandbox_edit;
