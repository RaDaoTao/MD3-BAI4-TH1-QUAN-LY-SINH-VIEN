-- PHẦN 1 : TẠO CSDL 
-- Bước 1: Tạo CSDL QuanLySinhVien
CREATE DATABASE QuanLySinhVien;
-- Bước 2: Chọn Database QuanLySinhVien để thao tác với cơ sở dữ liệu này:
USE QuanLySinhVien;
-- Bước 3: Tiếp theo sử dụng câu lệnh Create Table để tạo bảng Class với các trường ClassId, ClassName, StartDate, Status như sau:
CREATE TABLE Class
(
    ClassID   INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME    NOT NULL,
    Status    BIT
);
-- Bước 4: Tạo bảng Student với các thuộc tính StudentId, StudentName, Address, Phone, Status, ClassId với rằng buộc như sau:
CREATE TABLE Student
(
    StudentId   INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address     VARCHAR(50),
    Phone       VARCHAR(20),
    Status      BIT,
    ClassId     INT         NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
-- Bước 5: Tạo bảng Subject với các thuộc tính SubId, SubName, Credit, Status với các ràng buộc như sau :
CREATE TABLE Subject
(
    SubId   INT AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit  TINYINT     NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
    Status  BIT                  DEFAULT 1
);
-- Bước 6: Tạo bảng Mark với các thuộc tính MarkId, SubId, StudentId, Mark, ExamTimes với các ràng buộc như sau :
CREATE TABLE Mark
(
    MarkId    INT AUTO_INCREMENT PRIMARY KEY,
    SubId     INT NOT NULL,
    StudentId INT NOT NULL,
    Mark      FLOAT   DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);

-- PHẦN 2: TRUY VẤN CSDL
-- Bước 1: Sử dụng câu lệnh Use QuanLySinhVien để sử dụng cơ sở dữ liệu:
USE QuanLySinhVien;

-- Bước 2: Sử dụng hàm count để hiển thị số lượng sinh viên ở từng nơi
SELECT Address, COUNT(StudentId) AS 'Số lượng học viên'
FROM Student
GROUP BY Address;

-- Bước 3: Tính điểm trung bình các môn học của mỗi học viên bằng cách sử dụng hàm AVG
SELECT S.StudentId,S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;

-- Bước 4: Hiển thị những bạn học viên có điểm trung bình các môn học lớn hơn 15
-- Đầu tiên hiển thị điểm trung bình các môn học của mỗi học viên
SELECT S.StudentId,S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;

-- Sử dụng having để xét điều kiện điểm trung bình các môn học phải lớn hơn 15
SELECT S.StudentId,S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(Mark) > 15;

-- Bước 5: Hiển thị thông tin các học viên có điểm trung bình lớn nhất.
-- Hiển thị danh sách điểm trung bình của các học viên
SELECT S.StudentId, S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;

-- Sử dụng Having và All để tìm học viên có điểm trung bình lớn nhất
SELECT S.StudentId, S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(Mark) >= ALL (SELECT AVG(Mark) FROM Mark GROUP BY Mark.StudentId);

