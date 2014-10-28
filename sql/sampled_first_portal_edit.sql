SELECT
    DATABASE() AS wiki,
    firsts.rev_user AS user_id,
    firsts.portal,
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
        portal,
        MIN(rev_id) AS rev_id
    FROM
    (
        SELECT
            rev_user,
            SUBSTRING_INDEX(page_title,"/",1) AS portal,
            MIN(rev_id) AS rev_id
        FROM revision
        INNER JOIN page ON
            rev_page = page_id
        WHERE
            rev_user IN (SELECT user_id FROM staging.events_sampled_user
                         WHERE wiki = DATABASE()) AND
            page_namespace IN (4,5) AND
            (
                page_title = "Adopt-a-user" OR
                page_title LIKE "Adopt-a-user/%" OR
                page_title = "Articles_for_Creation" OR
                page_title LIKE "Articles_for_Creation/%" OR
                page_title = "Teahouse" OR
                page_title LIKE "Teahouse/%" OR
                page_title = "The_Wikipedia_Adventure" OR
                page_title LIKE "The_Wikipedia_Adventure/%" OR
                page_title = "Help_desk" OR
                page_title LIKE "Help_desk/%" OR
                page_title = "Reference_desk" OR
                page_title LIKE "Reference_desk/%"
            )
        GROUP BY
            rev_user,
            SUBSTRING_INDEX(page_title,"/",1)
        UNION ALL
        SELECT
            ar_user AS rev_user,
            SUBSTRING_INDEX(ar_title,"/",1) AS portal,
            MIN(ar_rev_id) AS rev_id
        FROM archive
        WHERE
            ar_user IN (SELECT user_id FROM staging.events_sampled_user
                         WHERE wiki = DATABASE()) AND
            ar_namespace IN (4,5) AND
            (
                ar_title = "Adopt-a-user" OR
                ar_title LIKE "Adopt-a-user/%" OR
                ar_title = "Articles_for_Creation" OR
                ar_title LIKE "Articles_for_Creation/%" OR
                ar_title = "Teahouse" OR
                ar_title LIKE "Teahouse/%" OR
                ar_title = "The_Wikipedia_Adventure" OR
                ar_title LIKE "The_Wikipedia_Adventure/%" OR
                ar_title = "Help_desk" OR
                ar_title LIKE "Help_desk/%" OR
                ar_title = "Reference_desk" OR
                ar_title LIKE "Reference_desk/%"
            )
        GROUP BY
            ar_user,
            SUBSTRING_INDEX(ar_title,"/",1)
    ) AS split_firsts
    GROUP BY rev_user, portal
) AS firsts
LEFT JOIN revision USING (rev_id)
LEFT JOIN page ON revision.rev_page = page_id
LEFT JOIN archive ON firsts.rev_id = ar_rev_id;
