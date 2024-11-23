SELECT p.poster_url, SUM(pl.likecount) AS total_likes
FROM postTable p
JOIN postlikes pl ON p.post_id = pl.postid
GROUP BY p.poster_url
ORDER BY total_likes DESC
LIMIT 10;


CREATE INDEX idx_post_id ON postTable(post_id);
CREATE INDEX idx_postid ON postlikes(postid);

CREATE INDEX idx_poster_url ON postTable(poster_url);

select profileName from AccountProfile where AccountProfileID in 
(select accountid from followFollowers where is_spam = 'true');

CREATE INDEX idx_accountid_is_spam ON followFollowers(accountid, is_spam);
CREATE INDEX idx_accountprofileid ON AccountProfile(AccountProfileID);



SELECT ua."User Name", COUNT(*) AS NumberOfGroups
FROM UserAuthentication ua
JOIN AccountProfile ap ON ua."User ID" = ap.UPID
JOIN UserRole ur ON ap.AccountProfileID = ur.AccountProfileID
WHERE ur.role = 'admin' -- Assuming 'admin' is the role indicating an administrator
GROUP BY ua."User Name"
ORDER BY NumberOfGroups DESC
LIMIT 10;


CREATE INDEX idx_user_id ON UserAuthentication("User ID");
CREATE INDEX idx_accountprofileid ON AccountProfile(AccountProfileID);
CREATE INDEX idx_userrole_accountprofileid ON UserRole(AccountProfileID);
CREATE INDEX idx_userrole_role ON UserRole(role);


ANALYZE followFollowers;
ANALYZE AccountProfile;


SELECT ap.hobbies, COUNT(*) AS hobby_count
FROM AccountProfile ap
JOIN UserProfile up ON ap.UPID = up.UPID
WHERE up.age = (
    SELECT MAX(age) FROM UserProfile
)
GROUP BY ap.hobbies
ORDER BY hobby_count DESC;


CREATE INDEX idx_public.blockuserprofile_upid ON UserProfile(UPID);
CREATE INDEX idx_userprofile_age ON UserProfile(age);
CREATE INDEX idx_accountprofile_hobbies ON AccountProfile(hobbies);

CREATE INDEX idx_user_name ON UserAuthentication("User Name");
CREATE INDEX idx_email ON UserAuthentication(Email);
CREATE INDEX idx_firstname ON UserProfile(FirstName);
CREATE INDEX idx_lastname ON UserProfile(LastName);
CREATE INDEX idx_age ON UserProfile(Age);
CREATE INDEX idx_blockcount ON BLOCK(blockcount);
CREATE INDEX idx_hashtag ON hashtag(hashtag);


SELECT ua."User Name", COUNT(*) AS NumberOfGroups
FROM UserAuthentication ua
JOIN AccountProfile ap ON ua."User ID" = ap.UPID
JOIN UserRole ur ON ap.AccountProfileID = ur.AccountProfileID
WHERE ur.role = 'admin' -- Assuming 'admin' is the role indicating an administrator
GROUP BY ua."User Name"
ORDER BY NumberOfGroups DESC
LIMIT 10;

