CREATE TABLE staging.events_sandbox_edit (
    wiki VARCHAR(50),
    rev_id INT,
    rev_timestamp VARBINARY(14),
    rev_user INT,
    rev_user_text VARBINARY(255),
    page_namespace INT,
    page_title VARBINARY(255),
    PRIMARY KEY (wiki, rev_id),
    KEY(wiki, rev_user, rev_user_text)
);
SELECT NOW(), COUNT(*) FROM staging.events_sandbox_edit;
