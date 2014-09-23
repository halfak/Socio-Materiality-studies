CREATE TABLE IF NOT EXISTS staging.events_sampled_user (
    wiki VARCHAR(50),
    user_id INT,
    user_name VARBINARY(255),
    user_registration VARBINARY(14),
    attached_method VARCHAR(255),
    PRIMARY KEY(wiki, user_id)
);
INSERT INTO staging.events_sampled_user
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2001" AND "2002"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2002" AND "2003"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2003" AND "2004"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2004" AND "2005"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2005" AND "2006"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2006" AND "2007"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2007" AND "2008"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2008" AND "2009"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2009" AND "2010"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2010" AND "2011"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2011" AND "2012"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2012" AND "2013"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000)
UNION ALL
(SELECT
    user.user_id,
    user.user_name,
    user.user_registration,
    lui.attached_method
FROM user
INNER JOIN staging.local_user_info lui ON
    wiki = DATABASE() AND
    lui.user_id = user.user_id
WHERE user.user_registration BETWEEN "2013" AND "2014"
AND user_editcount >= 1
ORDER BY RAND()
LIMIT 10000);
SELECT NOW(), COUNT(*) FROM staging.events_sampled_user;
