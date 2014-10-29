SELECT
    DATABASE() AS wiki,
    firsts.rev_user AS user_id,
    firsts.wikiproject,
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
        wikiproject,
        MIN(rev_id) AS rev_id
    FROM
    (
        SELECT
            rev_user,
            LOWER(SUBSTRING(SUBSTRING_INDEX(page_title ,"/",1), 13))
                    AS wikiproject,
            MIN(rev_id) AS rev_id
        FROM revision
        INNER JOIN page ON
            rev_page = page_id
        WHERE
            rev_user IN (SELECT user_id FROM staging.events_sampled_user
                         WHERE wiki = DATABASE()) AND
            page_namespace IN (4,5) AND
            page_title LIKE "WikiProject_%"
        GROUP BY
            rev_user,
            wikiproject
        UNION ALL
        SELECT
            ar_user AS rev_user,
            LOWER(SUBSTRING(SUBSTRING_INDEX(ar_title ,"/",1), 13))
                    AS wikiproject,
            MIN(ar_rev_id) AS rev_id
        FROM archive
        WHERE
            ar_user IN (SELECT user_id FROM staging.events_sampled_user
                         WHERE wiki = DATABASE()) AND
            ar_namespace IN (4,5) AND
            ar_title LIKE "WikiProject_%"
        GROUP BY
            ar_user,
            wikiproject
    ) AS split_firsts
    GROUP BY rev_user, wikiproject
) AS firsts
LEFT JOIN revision USING (rev_id)
LEFT JOIN page ON revision.rev_page = page_id
LEFT JOIN archive ON firsts.rev_id = ar_rev_id;
