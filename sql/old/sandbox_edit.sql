SELECT
    DATABASE() AS wiki,
    rev_id,
    rev_timestamp,
    rev_user,
    rev_user_text,
    page_namespace,
    page_title
FROM revision
INNER JOIN page ON
    rev_page = page_id
WHERE page_title RLIKE "(/|^)[Ss]andbox"
UNION ALL
SELECT
    DATABASE() AS wiki,
    ar_rev_id AS rev_id,
    ar_timestamp AS rev_timestamp,
    ar_user AS rev_user,
    ar_user_text AS rev_user_text,
    ar_namespace AS page_namespace,
    ar_title AS page_title
FROM archive
WHERE ar_title RLIKE "(/|^)[Ss]andbox";
