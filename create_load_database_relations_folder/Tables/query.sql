CREATE TABLE UserAuthentication 
(
    "User Name" VARCHAR(250) ,
    "User ID" INT PRIMARY KEY,
    Email VARCHAR(255),
    Password VARCHAR(255)
);

select * from UserAuthentication;

insert into UserAuthentication values ('watson_stranger_8899', 268368, 'watsonstrangergoat@gmail.com', 'male*7&&98/>898989');

select * from UserAuthentication where "User Name" = 'Brandy_Davis_9569';

CREATE TABLE UserProfile (
    UPID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Gender VARCHAR(10),
    Phone VARCHAR(20),
	Age INT, 
	FOREIGN KEY (UPID) REFERENCES UserAuthentication("User ID")

);


select * from UserProfile;

insert into UserProfile values (268368, 'watson', 'stranger', 'male', '898989898989', 34);


select * from UserProfile where Age = 24;

select * from UserProfile where Age = 24 and firstname = 'Diana';

select "User Name" from UserAuthentication where "User ID" in (select UPID from UserProfile where age = 24);

SELECT ua."User Name"
FROM UserAuthentication ua
JOIN UserProfile up ON ua."User ID" = up.UPID
ORDER BY up.Age ASC, ua."User Name" ASC;

CREATE TABLE AccountProfile (
	UPID INT, 
    AccountProfileID INT PRIMARY KEY,
    profileName VARCHAR(255),
    bio TEXT,
	hobbies TEXT,
    location VARCHAR(255),
    Foreign key (UPID)
    References UserAuthentication("User ID")
    ON DELETE SET NULL
);

ALTER TABLE AccountProfile
ALTER COLUMN AccountProfileID TYPE bigint USING AccountProfileID::bigint;

select * from AccountProfile;


select profilename from AccountProfile groupby count(location), order by profile name ASC;


SELECT location, COUNT(*) AS location_count 
FROM AccountProfile 
GROUP BY location 
ORDER BY location_count ASC;

select firstname, lastname from userprofile where UPID in (
	select "User ID" from UserAuthentication where "User ID" in (
		select UPID from AccountProfile where hobbies = 'Traveling'));

SELECT ap.hobbies, COUNT(*) AS hobby_count
FROM AccountProfile ap
JOIN UserProfile up ON ap.UPID = up.UPID
WHERE up.age = (
    SELECT MAX(age) FROM UserProfile
)
GROUP BY ap.hobbies
ORDER BY hobby_count DESC;


create table followFollowers (
	AccountID bigint Primary key,
	followers_count int,
	following_count int,
	is_spam boolean,
	number_of_posts int,
	foreign key (AccountId) references AccountProfile(AccountProfileID)

	);
	
	
select * from followFollowers;



select profileName from AccountProfile where AccountProfileID in (select accountid from followFollowers where is_spam = 'true');


	
	
CREATE TABLE BLOCK (
	accountprofileID bigint,
	blockID int,
	blockcount int,
	
	foreign key (accountprofileID) references  AccountProfile(AccountProfileID)
);

select * from block;


SELECT ap.profileName, SUM(b.blockcount) AS total_blocks
FROM AccountProfile ap
JOIN BLOCK b ON ap.AccountProfileID = b.accountprofileID
GROUP BY ap.profileName
ORDER BY total_blocks DESC
LIMIT 10;


create table groupInfo(
	groupId int Primary Key,
	groupName varchar(255) Unique,
	groupDescription TEXT,
	creationDate varchar(255)
);


select groupName, groupDescription from groupInfo;


CREATE TABLE GroupMembership (
    GroupID INT,
    AccountProfileID BIGINT,
    FOREIGN KEY (GroupID) REFERENCES GroupInfo(GroupID),
    FOREIGN KEY (AccountProfileID) REFERENCES AccountProfile(AccountProfileID),
    PRIMARY KEY (GroupID, AccountProfileID)
);


select * from GroupMembership;


create table UserRole(
	GroupId int,
	AccountProfileID bigint,
	role varchar(255),
	FOREIGN KEY (GroupID) REFERENCES GroupInfo(GroupID),
	FOREIGN KEY (AccountProfileID) REFERENCES AccountProfile(AccountProfileID)
	
);

select * from UserRole;


SELECT ua."User Name", COUNT(*) AS NumberOfGroups
FROM UserAuthentication ua
JOIN AccountProfile ap ON ua."User ID" = ap.UPID
JOIN UserRole ur ON ap.AccountProfileID = ur.AccountProfileID
WHERE ur.role = 'admin' -- Assuming 'admin' is the role indicating an administrator
GROUP BY ua."User Name"
ORDER BY NumberOfGroups DESC
LIMIT 10;


create table postTable(
	post_id real primary key,
	post_time varchar(255),
	poster_id real,
	poster_url varchar(255),
	userid bigint,
	foreign key (userid) references AccountProfile(AccountProfileID)
	
);


select * from postTable;

create table postlikes(
	postid real,
	likecount int,
	likeid int primary key,
	commentid int unique,
	foreign key(postid) references posttable(post_id)
);

select * from postlikes;


SELECT p.poster_url, SUM(pl.likecount) AS total_likes
FROM postTable p
JOIN postlikes pl ON p.post_id = pl.postid
GROUP BY p.poster_url
ORDER BY total_likes DESC
LIMIT 10;


create table hashtag(
	hid int primary key,
	hashtag varchar(255)
	

);

select * from Hashtag;

create table commentTable(
	commentid int,
	commentText text,
	natureofComment varchar(255),
	foreign key(commentid) references postlikes(commentid)
	
);

select * from commentTable;


SELECT natureofComment, string_agg(commentText, '; ') AS groupedComments
FROM commentTable
GROUP BY natureofComment;


create table posthashtag(
	postid real,
	hid int,
	primary key(postid, hid),
	foreign key (postid) references postTable(post_id),
	foreign key (hid) references hashtag(hid)

);


SELECT p.poster_url, COUNT(ph.hid) AS hashtag_count
FROM postTable p
JOIN posthashtag ph ON p.post_id = ph.postid
GROUP BY p.poster_url
ORDER BY hashtag_count DESC
LIMIT 10;


pg_dump dbname=dmql_project > dmql_project.sql


