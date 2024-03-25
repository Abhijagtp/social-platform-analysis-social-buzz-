create database social_buzz;
drop database social ;
use  social_buzz;
select* from users;
drop table reactions;
select* from content;
desc  content
;


-- assiging primary key in table users
alter table users modify User_ID varchar(50)primary key; 

-- assiging primary key in table content  
alter table content modify Content_ID varchar(50)primary key; 

-- connecting users to content on user_id
alter table content add constraint contents foreign key (User_ID) references users(User_ID);

-- modify the datatype from text to varchar for table content 
alter table content modify User_ID varchar(50); 

-- modify the datatype from text to varchar for table profile 
alter table profile modify User_ID varchar(50) ; 

 -- modify the datatype from text to varchar for table session 
 alter table session modify User_ID varchar(50) ; 
 
 -- modify the datatype from text to varchar for table reactions 
 alter table reactions modify User_ID varchar(50) ; 
 
 --  modify the datatype from text to varchar for table location 
 alter table location modify User_ID varchar(50) ; 
 

-- modify the datatype from text to varchar for table reactions 
alter table reactions modify Content_ID varchar(50) ; 

-- modify the datatype from text to varchar for table reactiontypes 
alter table reactiontypes modify Type varchar(50)primary key; 

-- modify the datatype from text to varchar for table reactions 
alter table reactions modify Type varchar(50);
 
 -- connecting users to content on user_id
alter table content add constraint contents foreign key (User_ID) references users(User_ID);

 -- connecting users to location on user_id
alter table location add constraint locations foreign key (User_ID) references users(User_ID);

-- connecting users to profile on user_id
alter table profile add constraint profiles foreign key (User_ID) references users(User_ID);

-- connecting users to session on user_id
alter table session add constraint sessions foreign key (User_ID) references users(User_ID);

-- connecting reactions to content on Content_ID
alter table reactions add constraint reactionss foreign key (Content_ID) references content(Content_ID);

-- connecting reactions to reactiontypes on Type
alter table reactions add constraint reactionsss foreign key (Type) references reactiontypes(Type);


select *from content;
desc content;


 



select * from users ;
select * from session ;

select  users.User_ID,users.Name , session.Device from users inner join session on users.User_ID = session.User_ID;
desc reactiontypes;
desc reactions;
alter table reactions add constraint react foreign key (Type) references reactiontypes(Type);
SET FOREIGN_KEY_CHECKS=0;



-- connecting reactions to users on user_ID
alter table reactions add constraint reacts foreign key (User_ID) references users(User_ID);


-- max reaction score for an user
SELECT 
    users.Name,
    reactiontypes.Type AS react_type,
    SUM(reactiontypes.score) AS total_score
FROM
    users
        INNER JOIN
    reactions ON users.User_ID = reactions.User_ID
        INNER JOIN
    reactiontypes ON reactions.Type = reactiontypes.Type
GROUP BY users.Name , reactiontypes.Type
order by total_score desc limit 5;


select* FROM content;
select * from reactions;

-- Indentifying the users location 
SELECT 
    users.Name, users.Email, location.Address
FROM
    users
        LEFT JOIN
    location ON users.User_ID = location.User_ID;

-- Time spent by users
SELECT 
    users.Name, session.Duration
FROM
    users
        INNER JOIN
    session ON users.User_ID = session.User_ID;

-- types of user reactions 
SELECT DISTINCT
    (reactiontypes.Type)
FROM
    reactions
        LEFT JOIN
    reactiontypes ON reactions.Type = reactiontypes.Type;

-- reaction to different content  
 select reactions.Type , content.Category from reactions inner join content on reactions.Content_ID = content.Content_ID;
 
 -- photo count per category 
SELECT 
    Category, COUNT(Type) AS total_photos
FROM
    content
WHERE
    Type IN ('photo')
GROUP BY Category
ORDER BY 2 DESC;
 
 -- video count per category 
SELECT 
    Category, COUNT(Type) AS total_photos
FROM
    content
WHERE
    Type IN ('Video')
GROUP BY Category
ORDER BY 2 DESC;
 
 
  
  -- types and category wise distribution 
  select Type , Category , count(*) as total_count from content group by 2, 1;
  
  SELECT 
    Category,
    SUM(Type = 'photo') AS total_photos,
    SUM(Type = 'video') AS total_videos,
    SUM(Type = 'audio') AS total_audio
FROM
    content
GROUP BY Category
; 


-- max value for each type 


SELECT 
    MAX(total_photos) AS max_photo,
    MAX(total_videos) AS max_video,
    MAX(total_audio) AS max_audio
FROM
    (SELECT 
        Category,
            SUM(Type = 'photo') AS total_photos,
            SUM(Type = 'video') AS total_videos,
            SUM(Type = 'audio') AS total_audio
    FROM
        content
    GROUP BY Category) AS max_value_each;

 
 
 
 -- finding what age group people are on this platform 
 select max(Age) from profile;
 select * from profile;
SELECT 
    COUNT(*),
    CASE
        WHEN age = 0 AND age <= 14 THEN '0-14'
        WHEN age > 14 AND age <= 24 THEN '15-24'
        WHEN age > 24 AND age <= 34 THEN '24-34'
        WHEN age > 34 AND age <= 44 THEN '34-44'
        ELSE '-'
    END AS age_groups
FROM
    profile
GROUP BY 2
ORDER BY 2;
  
  -- Classifying total values of content types for each device 
 
SELECT 
    SUM(Type = 'photo') AS total_photos,
    SUM(Type = 'video') AS total_videos,
    SUM(Type = 'audio') AS total_audio,
    session.device
FROM
    content
        INNER JOIN
    session ON content.User_ID = session.User_ID
GROUP BY session.device;
          

--  device usage in hrs 
SELECT 
    device, SUM(duration) AS total_duration_in_hrs
FROM
    session
GROUP BY 1
ORDER BY total_duration_in_hrs DESC
LIMIT 10;
     
      
      
      -- datetime format 
	select * from reactions;
 alter table reactions modify column Datetime datetime;

     desc reactions;
     
     
     -- trafiic in all
    SELECT 
    YEAR(datetime) AS year_,
    MONTH(datetime) AS month_,
    COUNT(*) AS total
FROM
    reactions
GROUP BY 1 , 2
ORDER BY 3 DESC;
     
     -- monthly traffic in year 2021
      SELECT 
    YEAR(datetime) AS year_,
    MONTH(datetime) AS month_,
    COUNT(*) AS total
FROM
    reactions
WHERE
    YEAR(datetime) = 2021
GROUP BY 1 , 2
ORDER BY 3 DESC;
     
     -- monthly traffic in year 2020
      SELECT 
    YEAR(datetime) AS year_,
    MONTH(datetime) AS month_,
    COUNT(*) AS total
FROM
    reactions
WHERE
    YEAR(datetime) = 2020
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 2;
     
     -- top 5 categories 
     
	select * from reactions ;
    select * from reactiontypes;
    
    SELECT 
    Type, MAX(total_type * score) AS Total_score
FROM
    (SELECT 
        COUNT(*) AS total_type,
            reactions.Type,
            reactiontypes.score AS score
    FROM
        reactions
    INNER JOIN reactiontypes ON reactions.Type = reactiontypes.Type
    GROUP BY reactions.Type) AS total
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
     
     
  
     
     