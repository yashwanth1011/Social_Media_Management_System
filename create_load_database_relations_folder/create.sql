CREATE TABLE UserAuthentication (
    "User Name" VARCHAR(250) ,
    "User ID" INT PRIMARY KEY,
    Email VARCHAR(255),
    Password VARCHAR(255)
);


CREATE TABLE UserProfile (
    UPID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Gender VARCHAR(10),
    Phone VARCHAR(20),
	Age INT, 
	FOREIGN KEY (UPID) REFERENCES UserAuthentication("User ID")
	on delete cascade
);

CREATE TABLE AccountProfile (
	UPID BIGINT, 
    AccountProfileID INT PRIMARY KEY,
    profileName VARCHAR(255),
    bio TEXT,
	hobbies TEXT,
    location VARCHAR(255),
    Foreign key (UPID)
    References UserAuthentication("User ID")
    ON DELETE SET NULL
);

create table followFollowers (
	AccountID bigint Primary key,
	followers_count int,
	following_count int,
	is_spam boolean,
	number_of_posts int,
	foreign key (AccountId) references AccountProfile(AccountProfileID)
	on delete cascade
	);
	
	
CREATE TABLE BLOCK (
	accountprofileID bigint,
	blockID int,
	blockcount int,
	
	foreign key (accountprofileID) references  AccountProfile(AccountProfileID)
	on delete cascade
);





create table groupInfo(
	groupId int Primary Key,
	groupName varchar(255) Unique,
	groupDescription TEXT,
	creationDate varchar(255)
);

CREATE TABLE GroupMembership (
    GroupID INT,
    AccountProfileID BIGINT,
    FOREIGN KEY (GroupID) REFERENCES GroupInfo(GroupID) on delete cascade,
    FOREIGN KEY (AccountProfileID) REFERENCES AccountProfile(AccountProfileID) on delete cascade,
    PRIMARY KEY (GroupID, AccountProfileID)
);

create table UserRole(
	GroupId int,
	AccountProfileID bigint,
	role varchar(255),
	FOREIGN KEY (GroupID) REFERENCES GroupInfo(GroupID)  on delete cascade,
	FOREIGN KEY (AccountProfileID) REFERENCES AccountProfile(AccountProfileID)  on delete cascade
	
);


create table postTable(
	post_id real primary key,
	post_time varchar(255),
	poster_id real,
	poster_url varchar(255),
	userid bigint,
	foreign key (userid) references AccountProfile(AccountProfileID)
	on delete cascade
);


create table postlikes(
	postid real,
	likecount int,
	likeid int primary key,
	commentid int unique,
	foreign key(postid) references posttable(post_id) on delete cascade
);

create table hashtag(
	hid int primary key,
	hashtag varchar(255)
	

);

create table commentTable(
	commentid int primary key,
	commentText text,
	natureofComment varchar(255),
	foreign key(commentid) references postlikes(commentid)
	on delete cascade
);


create table posthashtag(
	postid real,
	hid int,
	primary key(postid, hid),
	foreign key (postid) references postTable(post_id) on delete cascade,
	foreign key (hid) references hashtag(hid)
	on delete cascade

);


CREATE INDEX idx_user_name ON UserAuthentication("User Name");
CREATE INDEX idx_email ON UserAuthentication(Email);
CREATE INDEX idx_firstname ON UserProfile(FirstName);
CREATE INDEX idx_lastname ON UserProfile(LastName);
CREATE INDEX idx_age ON UserProfile(Age);
CREATE INDEX idx_blockcount ON BLOCK(blockcount);
CREATE INDEX idx_hashtag ON hashtag(hashtag);


CREATE INDEX idx_post_id ON postTable(post_id);
CREATE INDEX idx_postid ON postlikes(postid);

CREATE INDEX idx_poster_url ON postTable(poster_url);


CREATE INDEX idx_user_id ON UserAuthentication("User ID");
CREATE INDEX idx_accountprofileid ON AccountProfile(AccountProfileID);
CREATE INDEX idx_userrole_accountprofileid ON UserRole(AccountProfileID);
CREATE INDEX idx_userrole_role ON UserRole(role);










