------------------------------ 1answer --------------------------
SELECT * from users
order by created_at asc limit 5;

------------------------------ 2answer --------------------------
select dayname(created_at) as registration_day,
count(*) as registered_day
from users
group by registration_day
order by registered_day desc 
limit 1;

------------------------------ 3answer --------------------------
select u.id, u.username
from users u
left join photos p on u.id = p.user_id
where p.user_id is null;

------------------------------ 4answer --------------------------
select user_id, photo_id 
from likes
order by user_id desc
limit 1;

------------------------ 5answer -----------------------------
select avg(user_id) as averagepost
from
( select user_id, count(*) as postcount
from photos
group by id)
as userpostcounts;

------------------------------ 6answer --------------------------

select count(distinct user_id) as total
from photos
where user_id is not null;

------------------------- 7answer -----------------------------------
select tag_name, count(*) as hashtags
from tags
group by tag_name
order by hashtags desc
limit 5;

------------------------------ 8answer --------------------------
select user_id from likes
group by user_id
having count(photo_id) = (select count(*) from photos);

------------------------------ 9answer --------------------------
select u.id, u.username from users u
left join comments c on u.id = c.user_id
where c.user_id is null;

------------------------------ 10answer --------------------------

---------- USER WHO NEVER COMMENTED ON A PHOTO --------------
SELECT id FROM users 
WHERE id NOT IN (SELECT DISTINCT user_id FROM comments);

--------------- USER WHO COMMENTED ON PHOTO ------------------
SELECT user_id FROM comments 
GROUP BY user_id HAVING COUNT(DISTINCT photo_id) = (SELECT COUNT(*) FROM photos);

-------------- percentage calculation -------------------------
WITH never_commented AS 
(SELECT id FROM users 
WHERE id NOT IN (SELECT DISTINCT user_id FROM comments) ), 
commented_every_photo AS ( 
SELECT user_id 
FROM comments 
GROUP BY user_id HAVING COUNT(DISTINCT photo_id) = (SELECT COUNT(*) FROM photos)),
combined AS ( 
SELECT id fROM never_commented 
UNION SELECT user_id FROM commented_every_photo ) 
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users)) AS percentage_users FROM combined;

---------------------- 11 answer -----------------------
SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NOT NULL;


SELECT COUNT(*) FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NOT NULL) AS total_number_users_with_comments;
    
-------------------------------- 12 answer -----------------------------
SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who commented on photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB