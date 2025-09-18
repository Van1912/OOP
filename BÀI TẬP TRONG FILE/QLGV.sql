create database QLGV
GO

CREATE TABLE KHOA (
    makhoa VARCHAR(4) PRIMARY KEY,
    tenkhoa NVARCHAR(30) NOT NULL,
    tongsocb INT NOT NULL
);

CREATE TABLE GIANG_VIEN (
    magv CHAR(4) PRIMARY KEY,
    hogv NVARCHAR(20) NOT NULL,
    tengv NVARCHAR(10) NOT NULL,
    hocvi CHAR(2) NOT NULL,
    hocham VARCHAR(3), -- cho phép NULL
    makhoa VARCHAR(4) NOT NULL,
    FOREIGN KEY (makhoa) REFERENCES KHOA(makhoa)
);

CREATE TABLE THAN_NHAN (
    magv CHAR(4),
    hotentn NCHAR(50),
    ngaysinhtn DATE NOT NULL,
    moiquanhe NVARCHAR(20) NOT NULL,
    PRIMARY KEY (magv, hotentn),
    FOREIGN KEY (magv) REFERENCES GIANG_VIEN(magv)
);


CREATE TABLE QLY_KHOA (
    makhoa VARCHAR(4),
    chucvu CHAR(2) CHECK (chucvu IN ('TK', 'PK')),
    tungay DATE NOT NULL,
    magv CHAR(4),
    denngay DATE, -- cho phép NULL
    PRIMARY KEY (makhoa, chucvu, tungay),
    FOREIGN KEY (makhoa) REFERENCES KHOA(makhoa),
    FOREIGN KEY (magv) REFERENCES GIANG_VIEN(magv)
);

CREATE TABLE MON_HOC (
    mamh VARCHAR(4) PRIMARY KEY,
    tenmh NVARCHAR(50) NOT NULL,
    sotinchi INT NOT NULL,
    sotietLT INT NOT NULL,
    sotietTH INT NOT NULL,
    makhoa VARCHAR(4) NOT NULL,
    FOREIGN KEY (makhoa) REFERENCES KHOA(makhoa)
);


CREATE TABLE GIANG_DAY (
    namhoc CHAR(9),
    hocky INT,
    mamh VARCHAR(4),
    phutrach CHAR(2) CHECK (phutrach IN ('LT', 'TH')),
    magv CHAR(4),
    PRIMARY KEY (namhoc, hocky, mamh, phutrach),
    FOREIGN KEY (mamh) REFERENCES MON_HOC(mamh),
    FOREIGN KEY (magv) REFERENCES GIANG_VIEN(magv)
);


CREATE TABLE THI (
    namhoc CHAR(9),
    hocky INT,
    mamh VARCHAR(4),
    giamthi CHAR(4),
    ngaythi CHAR(10) NOT NULL,
    giothi CHAR(8) NOT NULL,
    phgthi VARCHAR(10),
    PRIMARY KEY (namhoc, hocky, mamh),
    FOREIGN KEY (mamh) REFERENCES MON_HOC(mamh),
    FOREIGN KEY (giamthi) REFERENCES GIANG_VIEN(magv)
);


CREATE TABLE SINH_VIEN (
    masv CHAR(5) PRIMARY KEY,
    hosv NVARCHAR(20) NOT NULL,
    tensv NVARCHAR(10) NOT NULL,
    nu BIT NOT NULL, -- 1: nữ, 0: nam
    ngaysinh DATE NOT NULL,
    matinhtp CHAR(2) NOT NULL,
    tinhtranggd NVARCHAR(2) NOT NULL,
    makhoa VARCHAR(4) NOT NULL,
    nhaphoc CHAR(9) NOT NULL,
    hocbong REAL,
    FOREIGN KEY (makhoa) REFERENCES KHOA(makhoa)
);


CREATE TABLE DANG_KY (
    masv CHAR(5),
    namhoc CHAR(9),
    hocky INT,
    mamh VARCHAR(4),
    PRIMARY KEY (masv, namhoc, hocky, mamh),
    FOREIGN KEY (masv) REFERENCES SINH_VIEN(masv),
    FOREIGN KEY (mamh) REFERENCES MON_HOC(mamh)
);


CREATE TABLE KET_QUA (
    namhoc CHAR(9),
    hocky INT,
    masv CHAR(5),
    mamh VARCHAR(4),
    lanthi SMALLINT,
    diemLT REAL,
    diemTH REAL,
    PRIMARY KEY (namhoc, hocky, masv, mamh, lanthi),
    FOREIGN KEY (masv) REFERENCES SINH_VIEN(masv),
    FOREIGN KEY (mamh) REFERENCES MON_HOC(mamh)
);

INSERT INTO KHOA VALUES 
('CNTT', N'Công nghệ thông tin', 26),
('VL', N'Vật lý', 17),
('CNSH', N'Công nghệ sinh học', 14);


INSERT INTO GIANG_VIEN VALUES 
('G001', N'Nguyễn Văn', N'Sư', 'TS', NULL, 'CNTT'),
('G002', N'Nguyễn Ngọc', N'Thúy', 'TH', NULL, 'CNTT'),
('G003', N'Trần Văn', N'Năm', 'TH', NULL, 'CNTT'),
('G004', N'Trần Đồng', N'Nai', 'TS', 'PGS', 'VL'),
('G005', N'Nguyễn Kim', N'Oanh', 'TH', NULL, 'VL'),
('G006', N'Bùi Mạnh', N'Tử', 'TH', NULL, 'VL'),
('G007', N'Nguyễn Văn', N'Chín', 'TS', 'PGS', 'CNSH'),
('G008', N'Lê Thị Mai', N'Vàng', 'TH', NULL, 'CNSH');


INSERT INTO THAN_NHAN VALUES 
('G001', N'Nguyễn Thị Chín', '1988-12-25', N'Vợ'),
('G005', N'Trần Hữu Thắng', '1970-09-24', N'Chồng'),
('G005', N'Trần Hữu Bình', '1999-11-04', N'Con trai'),
('G005', N'Trần Kiều Oanh', '2002-01-07', N'Con gái'),
('G006', N'Bùi Mạnh Ngọc', '1965-06-02', N'Bố'),
('G007', N'Nguyễn Thị An', '1998-07-14', N'Con gái');


INSERT INTO QLY_KHOA VALUES 
('CNTT', 'TK', '2007-04-29', 'G001', NULL),
('CNTT', 'PK', '2007-04-29', 'G002', NULL),
('VL', 'TK', '2007-04-29', 'G004', NULL),
('VL', 'PK', '2007-04-29', 'G005', NULL),
('CNSH', 'TK', '2007-04-29', 'G007', NULL),
('CNSH', 'PK', '2007-04-29', 'G008', NULL);


INSERT INTO MON_HOC VALUES 
('CTDL', N'Cấu trúc dữ liệu', 4, 45, 15, 'CNTT'),
('CSDL', N'Cơ sở dữ liệu', 3, 30, 15, 'CNTT'),
('VLDC', N'Vật lý đại cương', 3, 45, 0, 'VL'),
('TKMC', N'Thiết kế mạch', 4, 45, 15, 'VL'),
('SHDC', N'Sinh học đại cương', 3, 30, 15, 'CNSH'),
('CNGE', N'Công nghệ gien', 4, 45, 15, 'CNSH'),
('LTWB', N'Lập trình Web', 3, 30, 15, 'CNTT');


INSERT INTO SINH_VIEN VALUES
('91002', N'Nguyễn Ngọc', N'An', 1, '1995-03-07', '02', N'ĐT', 'CNTT', '2013-2014', 80000),
('91007', N'Nguyễn Đồng', N'Nai', 1, '1995-05-12', '41', N'ĐT', 'CNTT', '2013-2014', NULL),
('91023', N'Nguyễn Hùng', N'Sư', 0, '1994-12-10', '56', N'ĐT', 'CNTT', '2013-2014', 120000),
('91024', N'Võ Văn', N'Năm', 0, '1995-07-11', '02', N'ĐT', 'CNTT', '2013-2014', NULL),
('91045', N'Phạm Sĩ', N'Tử', 0, '1994-07-16', '34', N'ĐT', 'VL', '2013-2014', NULL),
('91088', N'Lưu Thu', N'Vàng', 1, '1995-07-05', '02', N'ĐT', 'VL', '2013-2014', 120000),
('91102', N'Lê Thị', N'Chín', 1, '1994-08-23', '46', N'ĐT', 'VL', '2013-2014', NULL),
('91109', N'Nguyễn Văn', N'Bốn', 0, '1992-11-24', '02', N'ĐT', 'CNSH', '2013-2014', 80000),
('91120', N'Tôn Thất', N'Quyền', 0, '1991-12-18', '02', N'ĐT', 'CNSH', '2013-2014', NULL),
('91133', N'Hà Thị Giang', N'Long', 1, '1995-12-25', '02', N'ĐT', 'CNSH', '2013-2014', NULL),
('92001', N'Bùi Mạnh', N'An', 0, '1996-06-09', '02', N'ĐT', 'CNTT', '2014-2015', 120000),
('92013', N'Lê Hữu', N'Chí', 0, '1996-06-10', '02', N'ĐT', 'CNTT', '2014-2015', NULL),
('92024', N'Võ Thành', N'Công', 0, '1996-07-09', '02', N'ĐT', 'CNTT', '2014-2015', NULL),
('92025', N'Trần Quang', N'Cường', 0, '1996-07-18', '02', N'ĐT', 'CNTT', '2014-2015', NULL),
('92027', N'Phan Văn', N'Hải', 0, '1996-07-31', '02', N'ĐT', 'VL', '2014-2015', 80000),
('92031', N'Phan Văn', N'Hoàng', 0, '1996-09-25', '51', N'ĐT', 'VL', '2014-2015', 120000),
('92048', N'Huỳnh Thanh', N'Lâm', 0, '1996-10-15', '50', N'ĐT', 'VL', '2014-2015', NULL),
('92173', N'Trần Minh', N'Sang', 0, '1996-12-17', '02', N'ĐT', 'CNSH', '2014-2015', NULL),
('92188', N'Phạm Văn', N'Hiền', 0, '1996-12-24', '56', N'ĐT', 'CNSH', '2014-2015', 80000),
('92242', N'Phan Thị Anh', N'Thu', 1, '1996-11-30', '02', N'ĐT', 'CNSH', '2014-2015', NULL);

INSERT INTO DANG_KY VALUES
('91002', '2014-2015', 2, 'CSDL'),
('91007', '2014-2015', 2, 'CSDL'),
('91023', '2014-2015', 2, 'CSDL'),
('91024', '2014-2015', 2, 'CSDL'),
('91045', '2014-2015', 2, 'TKMC'),
('91088', '2014-2015', 2, 'TKMC'),
('91102', '2014-2015', 2, 'TKMC'),
('91109', '2014-2015', 2, 'CNGE'),
('91120', '2014-2015', 2, 'CNGE'),
('91133', '2014-2015', 2, 'CNGE'),
('91007', '2014-2015', 1, 'CTDL'),
('91024', '2014-2015', 1, 'CTDL'),
('92001', '2014-2015', 1, 'CTDL'),
('92013', '2014-2015', 1, 'CTDL'),
('92024', '2014-2015', 1, 'CTDL'),
('92025', '2014-2015', 1, 'CTDL'),
('92027', '2014-2015', 1, 'VLDC'),
('92031', '2014-2015', 1, 'VLDC'),
('92048', '2014-2015', 1, 'VLDC'),
('92173', '2014-2015', 1, 'SHDC'),
('92188', '2014-2015', 1, 'SHDC'),
('92242', '2014-2015', 1, 'SHDC'),
('91120', '2014-2015', 1, 'SHDC');


INSERT INTO KET_QUA VALUES
('2014-2015', 1, '91002', 'CSDL', 1, 9, 7.5),
('2014-2015', 2, '91007', 'CSDL', 1, 9, 8),
('2014-2015', 2, '91023', 'CSDL', 1, 8, 7),
('2014-2015', 1, '91024', 'CSDL', 1, 6, 5),
('2014-2015', 2, '91045', 'TKMC', 1, 5, 5),
('2014-2015', 2, '91088', 'TKMC', 1, 4, 5),
('2014-2015', 2, '91088', 'TKMC', 2, 6, 7),
('2014-2015', 2, '91102', 'TKMC', 1, 9, 8),
('2014-2015', 2, '91109', 'CNGE', 1, 6, 6.5),
('2014-2015', 2, '91120', 'CNGE', 1, 9, 8),
('2014-2015', 2, '91133', 'CNGE', 1, 3, 3),
('2014-2015', 2, '91133', 'CNGE', 2, 5, 5.5),
('2014-2015', 1, '92001', 'CTDL', 1, 7, 6),
('2014-2015', 1, '92013', 'CTDL', 1, 8, 8),
('2014-2015', 1, '92024', 'CTDL', 1, 4, 6),
('2014-2015', 1, '92024', 'CTDL', 2, 7, 7),
('2014-2015', 1, '92025', 'CTDL', 1, 8, 7),
('2014-2015', 1, '92027', 'VLDC', 1, 8, NULL),
('2014-2015', 1, '92031', 'VLDC', 1, 7, NULL),
('2014-2015', 1, '92048', 'VLDC', 1, 6, NULL),
('2014-2015', 1, '92173', 'SHDC', 1, 9, 8.5),
('2014-2015', 1, '92188', 'SHDC', 1, 9, 8),
('2014-2015', 1, '92242', 'SHDC', 1, 7, 7),
('2014-2015', 1, '91007', 'CTDL', 1, 8.5, 7.5),
('2014-2015', 1, '91024', 'CTDL', 1, 4.5, 5),
('2014-2015', 2, '91024', 'CTDL', 2, 6, 6.5);


INSERT INTO GIANG_DAY VALUES
('2014-2015', 1, 'CTDL', 'LT', 'G001'),
('2014-2015', 1, 'CTDL', 'TH', 'G002'),
('2014-2015', 1, 'VLDC', 'LT', 'G004'),
('2014-2015', 1, 'SHDC', 'LT', 'G007'),
('2014-2015', 2, 'CSDL', 'LT', 'G002'),
('2014-2015', 2, 'TKMC', 'LT', 'G005'),
('2014-2015', 2, 'TKMC', 'TH', 'G006'),
('2014-2015', 2, 'CNGE', 'LT', 'G007'),
('2014-2015', 2, 'CNGE', 'TH', 'G008'),
('2013-2014', 1, 'CSDL', 'LT', 'G001'),
('2013-2014', 2, 'CSDL', 'LT', 'G002'),
('2014-2015', 1, 'CSDL', 'LT', 'G001'),
('2014-2015', 1, 'CSDL', 'TH', 'G002'),
('2014-2015', 2, 'CSDL', 'TH', 'G002'),
('2014-2015', 2, 'LTWB', 'LT', NULL),
('2014-2015', 2, 'LTWB', 'TH', NULL),
('2014-2015', 1, 'TKMC', 'LT', 'G004'),
('2014-2015', 1, 'TKMC', 'TH', 'G005');


INSERT INTO THI
VALUES
('2014-2015', 1, 'CSDL', 'G001', '2014-12-31', '08:00:00', '103'),
('2014-2015', 1, 'VLDC', 'G004', '2014-12-31', '07:00:00', '205'),
('2014-2015', 1, 'SHDC', 'G007', '2014-12-31', '08:00:00', '307'),
('2014-2015', 2, 'CSDL', 'G002', '2015-05-28', '08:00:00', '105'),
('2014-2015', 2, 'TKMC', 'G005', '2015-05-28', '08:00:00', null),
('2014-2015', 2, 'CNGE', 'G007', '2015-05-28', '08:00:00', '309');

