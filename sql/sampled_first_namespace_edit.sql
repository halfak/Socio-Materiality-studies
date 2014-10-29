SELECT
    DATABASE() AS wiki,
    firsts.rev_user AS user_id,
    IFNULL(rev_user_text, ar_user_text) AS user_text,
    IFNULL(rev_timestamp, ar_timestamp) AS timestamp,
    IFNULL(revision.rev_id, archive.ar_rev_id) AS rev_id,
    IFNULL(page_id, ar_page_id) AS page_id,
    IFNULL(page_namespace, ar_namespace) AS page_namespace,
    IFNULL(page_title, ar_title) AS page_title,
    revision.rev_id IS NULL AS archived
FROM (
    SELECT
        rev_user,
        MIN(rev_id) AS rev_id
    FROM
    (
        SELECT
            rev_user,
            page_namespace,
            MIN(rev_id) AS rev_id
        FROM revision
        INNER JOIN page ON
            rev_page = page_id
        WHERE
            rev_user IN (SELECT user_id FROM staging.events_sampled_user
                         WHERE wiki = DATABASE())
        GROUP BY rev_user, page_namespace
        UNION ALL
        SELECT
            ar_user AS rev_user,
            ar_namespace AS page_namespace,
            MIN(ar_rev_id) AS rev_id
        FROM archive
        WHERE
            ar_user IN (SELECT user_id FROM staging.events_sampled_user
                         WHERE wiki = DATABASE())
        GROUP BY ar_user, ar_namespace
    ) AS split_firsts
    GROUP BY rev_user, page_namespace
) AS firsts
LEFT JOIN revision USING (rev_id)
LEFT JOIN page ON revision.rev_page = page_id
LEFT JOIN archive ON firsts.rev_id = ar_rev_id;
