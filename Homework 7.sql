-- --------------------------------------------------------------------------------
-- Name: kyle brown
-- Class: IT-112
-- Abstract: Homework 7 - Functions
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
-- Drop Tables
-- --------------------------------------------------------------------------------

IF OBJECT_ID( 'TUserFavoriteSongs' )				IS NOT NULL DROP TABLE		TUserFavoriteSongs
IF OBJECT_ID( 'TSongs' )							IS NOT NULL DROP TABLE		TSongs
IF OBJECT_ID( 'TUsers' )							IS NOT NULL DROP TABLE		TUsers


IF OBJECT_ID( 'TCourseBooks' )						IS NOT NULL DROP TABLE		TCourseBooks
IF OBJECT_ID( 'TBooks' )							IS NOT NULL DROP TABLE		TBooks
IF OBJECT_ID( 'TCourseStudents' )					IS NOT NULL DROP TABLE		TCourseStudents
IF OBJECT_ID( 'TStudents' )							IS NOT NULL DROP TABLE		TStudents
IF OBJECT_ID( 'TCourseRooms' )						IS NOT NULL DROP TABLE		TCourseRooms
IF OBJECT_ID( 'TRooms' )							IS NOT NULL DROP TABLE		TRooms
IF OBJECT_ID( 'TCourses' )							IS NOT NULL DROP TABLE		TCourses
IF OBJECT_ID( 'TInstructors' )						IS NOT NULL DROP TABLE		TInstructors

-- --------------------------------------------------------------------------------
-- Drop functions and views
-- --------------------------------------------------------------------------------
IF OBJECT_ID( 'fn_GetUserName' )						IS NOT NULL DROP function		fn_GetUserName
IF OBJECT_ID( 'fn_GetSongs' )							IS NOT NULL DROP function		fn_GetSongs

IF OBJECT_ID( 'vUserSongs' )							IS NOT NULL DROP view			vUserSongs
IF OBJECT_ID( 'fn_GetCourse' )							IS NOT NULL DROP function		fn_GetCourse
IF OBJECT_ID( 'fn_GetStudents' )						IS NOT NULL DROP function		fn_GetStudents
IF OBJECT_ID( 'fn_GetBook' )							IS NOT NULL DROP function		fn_GetBook
IF OBJECT_ID( 'fn_GetInstructor' )						IS NOT NULL DROP function		fn_GetInstructor
IF OBJECT_ID( 'vCourseStudents' )						IS NOT NULL DROP view			vCourseStudents
IF OBJECT_ID( 'vCourseBooks' )							IS NOT NULL DROP view			vCourseBooks
IF OBJECT_ID( 'vCourseInstructors' )					IS NOT NULL DROP view			vCourseInstructors

-- --------------------------------------------------------------------------------
-- Step #1.1: Create Tables
-- --------------------------------------------------------------------------------

CREATE TABLE TUsers
(
	 intUserID			INTEGER			NOT NULL
	,strUserName		VARCHAR(50)		NOT NULL
	,strEmailAddress	VARCHAR(50)		NOT NULL
	,CONSTRAINT TUsers_PK PRIMARY KEY ( intUserID )
)

CREATE TABLE TSongs
(
	 intSongID			INTEGER			NOT NULL
	,strSongName		VARCHAR(50)		NOT NULL
	,strArtist			VARCHAR(50)		NOT NULL
	,CONSTRAINT TSongs_PK PRIMARY KEY ( intSongID )
)

CREATE TABLE TUserFavoriteSongs
(
	 intUserFavoriteSongID	INTEGER			NOT NULL
	,intUserID				INTEGER			NOT NULL
	,intSongID				INTEGER			NOT NULL
	,CONSTRAINT	TUserSongs_UQ	UNIQUE	(intUserID, intSongID	)
	,CONSTRAINT TUserSongs_PK PRIMARY KEY ( intUserFavoriteSongID )
)

-- --------------------------------------------------------------------------------
-- Step #1.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child								Parent						Column(s)
-- -	-----								------						---------
-- 1	TUserFavoriteSongs					TUsers						intUserID
-- 2	TUserFavoriteSongs					TSongs						intSongID

-- 1
ALTER TABLE TUserFavoriteSongs ADD CONSTRAINT TUserFavoriteSongs_TUsers_FK
FOREIGN KEY ( intUserID ) REFERENCES TUsers ( intUserID )

-- 2
ALTER TABLE TUserFavoriteSongs ADD CONSTRAINT TUserFavoriteSongs_TSongs_FK
FOREIGN KEY ( intSongID ) REFERENCES TSongs ( intSongID )



-- --------------------------------------------------------------------------------
-- Step #1.3: Add at least 3 users
-- --------------------------------------------------------------------------------
INSERT INTO TUsers ( intUserID, strUserName, strEmailAddress )
VALUES	 ( 1, 'JoeJoe1998', 'jj1998@gmail.com' )
		,( 2, 'FreeNClear21', 'FreeNClear21@gmail.com' )
		,( 3, 'IamHere321', 'IamHere321@gmail.com' )
		
		
-- --------------------------------------------------------------------------------
-- Step #1.4: Add at least 3 Songs
-- --------------------------------------------------------------------------------
INSERT INTO TSongs ( intSongID, strSongName, strArtist )
VALUES	 ( 1, 'Hysteria', 'Def Leppard' )
		,( 2, 'Hotel California', 'Eagles' )
		,( 3, 'Shake Me', 'Cinderella' )
		
-- --------------------------------------------------------------------------------
-- Step #1.5: Add at at least 6 User/Song assignments
-- --------------------------------------------------------------------------------
INSERT INTO TUserFavoriteSongs ( intUserFavoriteSongID, intUserID, intSongID )
VALUES	 ( 1, 1, 1 )
		,( 2, 1, 2 )
		,( 3, 2, 1 )
		,( 4, 2, 3 )
		,( 5, 3, 2 )
		,( 6, 3, 3 )


-- --------------------------------------------------------------------------------
-- Step #2.1: Create Tables
-- --------------------------------------------------------------------------------
CREATE TABLE TCourses
(
	 intCourseID 					INTEGER			NOT NULL
	,strCourseName						VARCHAR(50)		NOT NULL
	,strDescription					VARCHAR(50)		NOT NULL
	,intInstructorID				INTEGER			NOT NULL
	,CONSTRAINT TCourses_PK PRIMARY KEY( intCourseID )
)

CREATE TABLE TInstructors
(
	 intInstructorID				INTEGER			NOT NULL
	,strFirstName					VARCHAR(50)		NOT NULL
	,strLastName					VARCHAR(50)		NOT NULL
	,strPhoneNumber					VARCHAR(50)		NOT NULL
	,CONSTRAINT TInstructors_PK PRIMARY KEY ( intInstructorID )
)

CREATE TABLE TCourseRooms
(
	 intCourseRoomID				INTEGER			NOT NULL
	,intCourseID 					INTEGER			NOT NULL
	,intRoomID	 					INTEGER			NOT NULL
	,strMeetingTimes				VARCHAR(50)		NOT NULL
	,CONSTRAINT TCourseRooms_UQ	UNIQUE	(intCourseID, intRoomID	)
	,CONSTRAINT TCourseRooms_PK PRIMARY KEY( intCourseRoomID )
)

CREATE TABLE TRooms
(
	 intRoomID						INTEGER			NOT NULL
	,strRoomNumber					VARCHAR(50)		NOT NULL
	,intRoomCapacity				INTEGER			NOT NULL
	,CONSTRAINT TRooms_PK PRIMARY KEY ( intRoomID )
)

CREATE TABLE TCourseStudents
(
	 intCourseStudentID				INTEGER			NOT NULL
	,intCourseID 					INTEGER			NOT NULL
	,intStudentID	 				INTEGER			NOT NULL
	,CONSTRAINT TCourseStudent_UQ	UNIQUE	(intCourseID, intStudentID	)
	,CONSTRAINT TCourseStudents_PK PRIMARY KEY( intCourseStudentID )
)

CREATE TABLE TStudents
(
	 intStudentID					INTEGER			NOT NULL
	,strFirstName					VARCHAR(50)		NOT NULL
	,strLastName					VARCHAR(50)		NOT NULL
	,strStudentNumber				VARCHAR(50)		NOT NULL
	,strPhoneNumber					VARCHAR(50)		NOT NULL
	,CONSTRAINT TStudents_PK PRIMARY KEY ( intStudentID )
)

CREATE TABLE TCourseBooks
(	
	 intCourseBookID				INTEGER			NOT NULL
	,intCourseID 					INTEGER			NOT NULL
	,intBookID	 					INTEGER			NOT NULL
	,CONSTRAINT TCourseBooks_UQ	UNIQUE	(intCourseID, intBookID	)
	,CONSTRAINT TCourseBooks_PK PRIMARY KEY( intCourseBookID )
)

CREATE TABLE TBooks
(
	 intBookID	 					INTEGER			NOT NULL
	,strBookName					VARCHAR(50)		NOT NULL
	,strBookAuthor					VARCHAR(50)		NOT NULL
	,strBookISBN					VARCHAR(50)		NOT NULL
	,CONSTRAINT TBooks_PK PRIMARY KEY( intBookID )
)

-- --------------------------------------------------------------------------------
-- Step #2.2: Identify and Create Foreign Keys
-- --------------------------------------------------------------------------------
--
-- #	Child					Parent					Column(s)
-- -	-----					------					---------
-- 1	TCourses				TInstructors			intInstructorID
-- 2	TCourseRooms			TCourses				intCourseID
-- 3	TCourseRooms			TRooms					intRoomID
-- 4	TCourseStudents			TCourses				intCourseID
-- 5	TCourseStudents			TStudents				intStudentID
-- 6	TCourseBooks			TCourses				intCourseID
-- 7	TCourseBooks			TBooks					intBookID

-- 1
ALTER TABLE TCourses ADD CONSTRAINT TCourses_TInstructors_FK
FOREIGN KEY ( intInstructorID ) REFERENCES TInstructors ( intInstructorID )

-- 2
ALTER TABLE TCourseRooms ADD CONSTRAINT TCourseRooms_TCourses_FK
FOREIGN KEY ( intCourseID ) REFERENCES TCourses ( intCourseID )

-- 3
ALTER TABLE TCourseRooms ADD CONSTRAINT TCourseRooms_TRooms_FK
FOREIGN KEY ( intRoomID ) REFERENCES TRooms ( intRoomID )

-- 4
ALTER TABLE TCourseStudents ADD CONSTRAINT TCourseStudents_TCourses_FK
FOREIGN KEY ( intCourseID ) REFERENCES TCourses ( intCourseID )

-- 5
ALTER TABLE TCourseStudents ADD CONSTRAINT TCourseStudents_TStudents_FK
FOREIGN KEY ( intStudentID ) REFERENCES TStudents ( intStudentID )

-- 6
ALTER TABLE TCourseBooks ADD CONSTRAINT TCourseBooks_TCourses_FK
FOREIGN KEY ( intCourseID ) REFERENCES TCourses ( intCourseID )

-- 7
ALTER TABLE TCourseBooks ADD CONSTRAINT TCourseBooks_TBooks_FK
FOREIGN KEY ( intBookID ) REFERENCES TBooks ( intBookID )

-- --------------------------------------------------------------------------------
-- Step #2.3: Add at least 3 coures (must add instructors first)
-- --------------------------------------------------------------------------------
INSERT INTO TInstructors( intInstructorID, strFirstName, strLastName, strPhoneNumber )
VALUES	 ( 1, 'Tomie', 'Gartland', 'x1751' )
		,( 2, 'Bob', 'Nields', 'x1752' )
		,( 3, 'Ray', 'Harmon', 'x1753' )

INSERT INTO TCourses ( intCourseID, strCourseName, strDescription, intInstructorID )
VALUES	 ( 1, 'IT-101', '.Net Programming #1', 2 )
		,( 2, 'IT-110', 'HTML, CSS and JavaScript', 3 )
		,( 3, 'IT-111', 'Database Design and SQL #1', 1 )
			
-- --------------------------------------------------------------------------------
-- Step #2.4: Add at least 3 rooms and assign at least one room to each course
-- --------------------------------------------------------------------------------
INSERT INTO TRooms( intRoomID, strRoomNumber, intRoomCapacity )
VALUES	 ( 1, 'ATLC 410', 20 )
		,( 2, 'ATLC 414', 20 )
		,( 3, 'Virtual Classrooom', 20 )
		
INSERT INTO TCourseRooms( intCourseRoomID, intCourseID, intRoomID, strMeetingTimes )
VALUES	 ( 1, 1, 1, 'M/W 8am - 9:50am' )
		,( 2, 1, 2, 'T/R 8am - 9:50am' )
		,( 3, 2, 3, 'N/A - Online' )
		,( 4, 3, 1, 'M/W 8am - 9:50am' )
		,( 5, 3, 2, 'T/R 8am - 9:50am' )

-- --------------------------------------------------------------------------------
-- Step #2.5: Add at least 3 books and assign at least one book to each course
-- --------------------------------------------------------------------------------
INSERT INTO TBooks ( intBookID, strBookName, strBookAuthor, strBookISBN )
VALUES	 ( 1, 'I Love VB.Net', 'Martin Schmitz', 'ABC-123' )
		,( 2, 'I Really Love VB.Net', 'Eric Furniss', 'DEF-456' )
		,( 3, 'CSS Styles Rock it', 'Jeremy Rogers', 'GHI-789' )
		,( 4, 'JavaScript Can Save Your Life', 'Justin Lee', 'JKL-246' )
		,( 5, 'SQL Server For Programmers', 'Jim Oracle', 'JO0-12845' )
		,( 6, 'Advanced SQL', 'Austin Mockabee', 'HIJ-5694/2' )

INSERT INTO TCourseBooks ( intCourseBookID, intCourseID, intBookID )
VALUES	 ( 1, 1, 1 )
		,( 2, 1, 2 )
		,( 3, 2, 3 )
		,( 4, 2, 4 )
		,( 5, 3, 5 )
		,( 6, 3, 6 )

-- --------------------------------------------------------------------------------
-- Step #2.6: Add at least 3 students and assign at least two students to each course
-- --------------------------------------------------------------------------------
INSERT INTO TStudents( intStudentID, strFirstName, strLastName, strStudentNumber, strPhoneNumber )
VALUES	 ( 1, 'Eric', 'James', 'SN-0001', '555-0001' )
		,( 2, 'Susan', 'Little', 'SN-0002', '555-0002' )
		,( 3, 'Stan', 'Hoening', 'SN-0001', '555-0001' )
		,( 4, 'Jill', 'Waters', 'SN-0002', '555-0002' )
		,( 5, 'Fred', 'Smith', 'SN-0001', '555-0001' )
		,( 6, 'Angie', 'Mason', 'SN-0002', '555-0002' )

INSERT INTO TCourseStudents( intCourseStudentID, intCourseID, intStudentID )
VALUES	 ( 1, 1, 1 )
		,( 2, 1, 2 )
		,( 3, 2, 3 )
		,( 4, 2, 4 )
		,( 5, 3, 5 )
		,( 6, 3, 6 )


-- --------------------------------------------------------------------------------
-- 1.	Create a function called fn_GetUserName which will return the user name from the TUsers table.
-- --------------------------------------------------------------------------------
GO

CREATE FUNCTION fn_GetUserName
	(@intUserID	integer)
Returns varchar(255)
as 

BEGIN 
	declare @UserName varchar(255)

	select @UserName = strUserName From TUsers where intUserID = @intUserID

	return @UserName
end 

go

select dbo.fn_GetUserName(intUserID) as "User Name" from TUsers
-- --------------------------------------------------------------------------------
-- 	2.	Create a function called fn_GetSongs which will return the song title and artist from the TSongs table.
-- --------------------------------------------------------------------------------

GO

CREATE FUNCTION fn_GetSongs 
	(@intSongID	integer)
Returns varchar(255)
as 

BEGIN 
	declare @SongNameAndArtist varchar(255)

	select @SongNameAndArtist = strSongName + ', ' + strArtist From TSongs where intSongID = @intSongID

	return @SongNameAndArtist
end 

go

select dbo.fn_GetSongs(intSongID) as "Song Title & Artist Name" from TSongs

-- --------------------------------------------------------------------------------
-- 	3.	Write a Select statement, using the functions, that will pull the user ID, the user name, the song ID and the song and artist from TUserFavoriteSongs table.
-- --------------------------------------------------------------------------------

select
	TUFS.intUserID
	,dbo.fn_GetUserName (TUFS.intUserID) as "User name"
	,TUFS.intSongID
	,dbo.fn_GetSongs(intSongID) as "Song and artist"
from
	TUserFavoriteSongs as TUFS



-- --------------------------------------------------------------------------------
-- 	4.	Create a view from this select statement
-- --------------------------------------------------------------------------------
go
create view vUserSongs (UserID, UserName, SongID, Artist)
as

select
	TUFS.intUserID
	,dbo.fn_GetUserName (TUFS.intUserID) as "User name"
	,TUFS.intSongID
	,dbo.fn_GetSongs(intSongID) as "Song and artist"
from
	TUserFavoriteSongs as TUFS

go

select * from vUserSongs

-- --------------------------------------------------------------------------------
-- 	1.	Create a function called fn_GetCourse which will return the course name and description from the TCourses 
-- --------------------------------------------------------------------------------
GO

CREATE FUNCTION fn_GetCourse
	(@inCourseID integer)
Returns varchar(255)
as 

BEGIN 
	declare @CourseName varchar(255)

	select @CourseName = strCourseName + ', ' + strDescription From TCourses where intCourseID = @inCourseID

	return @CourseName
end 

go

select dbo.fn_GetCourse(intCourseID) as "Course Name" from TCourses

-- --------------------------------------------------------------------------------
-- 	2.	Create a function called fn_GetStudents which will return the last name, first name from the TStudents table. Name should be in format of LastName, FirstName.
-- --------------------------------------------------------------------------------
GO

CREATE FUNCTION fn_GetStudents
	(@inStudentID integer)
Returns varchar(255)
as 

BEGIN 
	declare @StudentName varchar(255)

	select @StudentName = strLastName + ', ' + strFirstName From TStudents where intStudentID = @inStudentID

	return @StudentName
end 

go

select dbo.fn_GetStudents(intStudentID) as "Student Name" from TStudents

-- --------------------------------------------------------------------------------
-- 	3.	Create a function called fn_GetBook which will return the book name and author from the TBooks table.
-- --------------------------------------------------------------------------------
GO

CREATE FUNCTION fn_GetBook
	(@inBookID integer)
Returns varchar(255)
as 

BEGIN 
	declare @BookName varchar(255)

	select @BookName = strBookName + ', ' + strBookAuthor From TBooks where intBookID = @inBookID

	return @BookName
end 

go

select dbo.fn_GetBook(intBookID) as "Book Name" from TBooks

-- --------------------------------------------------------------------------------
-- 	4.	Create a function called fn_GetInstructor which will return the last name, first name from the TInstructors table. Name should be in format of LastName, FirstName.
-- --------------------------------------------------------------------------------
GO

CREATE FUNCTION fn_GetInstructor
	(@intInstructorID integer)
Returns varchar(255)
as 

BEGIN 
	declare @InstructorName varchar(255)

	select @InstructorName = strLastName + ', ' + strFirstName From TInstructors where intInstructorID = @intInstructorID

	return @InstructorName
end 

go

select dbo.fn_GetInstructor(intInstructorID) as "Instructor Name" from TInstructors


-- --------------------------------------------------------------------------------
-- 5.	Write a Select statement, using the functions, that will pull the student ID, the student name, the course ID, name and description from TCourseStudents table.
-- --------------------------------------------------------------------------------
select
	TCS.intStudentID
	,dbo.fn_GetStudents (TCS.intStudentID) as "Student Name"
	,TCS.intCourseID
	,dbo.fn_GetCourse(intCourseID) as "Course Name"
from
	TCourseStudents as TCS

-- --------------------------------------------------------------------------------
-- 6.	Write a Select statement, using the functions, that will pull the book ID, name, author, the course ID, name and description from TCourseBooks table.
-- --------------------------------------------------------------------------------
select
	TCB.intBookID
	,dbo.fn_GetBook(TCB.intBookID) as "Book_&_Athour"
	,TCB.intCourseID
	,dbo.fn_GetCourse(intCourseID) as "Course_&_Description"
from
	TCourseBooks as TCB

-- --------------------------------------------------------------------------------
-- 7.	Write a Select statement, using the functions, that will pull the instructor ID, name, the course ID, name and description from TCourses table.
-- --------------------------------------------------------------------------------
select
	TC.intInstructorID
	,dbo.fn_GetInstructor(TC.intInstructorID) as "Instructor Name"
	,TC.intCourseID
	,dbo.fn_GetCourse(intCourseID) as "Course Name"
from
	TCourses as TC

-- --------------------------------------------------------------------------------
-- 8.	Create a view from this each of select statements in steps 5, 6 & 7
-- --------------------------------------------------------------------------------
go
create view vCourseStudents (StudentID, StudentName, CourseID, CourseName)
as

select
	TCS.intStudentID
	,dbo.fn_GetStudents (TCS.intStudentID) as "Student Name"
	,TCS.intCourseID
	,dbo.fn_GetCourse(intCourseID) as "Course Name"
from
	TCourseStudents as TCS

go

select * from vCourseStudents

-----------------------------------------------------------------------------------------------

go
create view vCourseBooks (BookID, BookName, CourseID, CourseName)
as

select
	TCB.intBookID
	,dbo.fn_GetBook(TCB.intBookID) as "Book Name"
	,TCB.intCourseID
	,dbo.fn_GetCourse(intCourseID) as "Course Name"
from
	TCourseBooks as TCB

go

select * from vCourseStudents

---------------------------------------------------------------------------------------------------

go
create view vCourseInstructors (InstructorID, InstructorName, CourseID, CourseName)
as

select
	TC.intInstructorID
	,dbo.fn_GetInstructor(TC.intInstructorID) as "Instructor Name"
	,TC.intCourseID
	,dbo.fn_GetCourse(intCourseID) as "Course Name"
from
	TCourses as TC

go

select * from vCourseInstructors
