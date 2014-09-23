SELECT
    *
FROM events_sampled_user
INNER JOIN events_first_namespace_edit USING (wiki, user_id);
