SELECT
    DATABASE() AS wiki,
    rev_user AS user_id,
    rev_user_text AS user_text,
    rev_timestamp AS timestamp,
    rev_id,
    page_id,
    page_namespace,
    page_title,
    FALSE AS archived
FROM (
    SELECT
        MIN(rev_id) AS rev_id
    FROM revision
    INNER JOIN page ON rev_page = page_id
    WHERE rev_user > 0
    GROUP BY rev_user, page_namespace
    UNION ALL
    SELECT
        MIN(rev_id) AS rev_id
    FROM revision
    INNER JOIN page ON rev_page = page_id
    WHERE rev_user = 0
    GROUP BY rev_user_text, page_namespace
) AS firsts
INNER JOIN revision USING (rev_id)
INNER JOIN page ON rev_page = page_id
UNION ALL
SELECT
    DATABASE() AS wiki,
    ar_user AS user_id,
    ar_user_text AS user_text,
    ar_timestamp AS timestamp,
    ar_rev_id AS rev_id,
    ar_page_id AS page_id,
    ar_namespace AS page_namespace,
    ar_title AS page_title,
    TRUE AS archived
FROM (
    SELECT
        MIN(IF(ar_rev_id > 0, ar_rev_id, NULL)) AS ar_rev_id
    FROM archive
    WHERE ar_user > 0
    GROUP BY ar_user, ar_namespace
    UNION ALL
    SELECT
        MIN(IF(ar_rev_id > 0, ar_rev_id, NULL)) AS ar_rev_id
    FROM archive
    WHERE ar_user = 0
    GROUP BY ar_user_text, ar_namespace
) AS archived_firsts
INNER JOIN archive USING (ar_rev_id);
