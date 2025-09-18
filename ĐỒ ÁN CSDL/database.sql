--Tạo DATABASE DO_AN_CSDL
create database DO_AN_CSDL
go
use DO_AN_CSDL
go

--TẠO CÁC BẢNG 

-- 1. Bảng Khách Hàng
CREATE TABLE KHACH_HANG (
    Makh nchar(5) primary key,
    Tenkh NVARCHAR(100) NOT NULL,
    Diachi NVARCHAR(255),
    Sodtkh VARCHAR(15),
    Emailkh VARCHAR(100)
);

-- 2. Bảng Nhân Viên
CREATE TABLE NHAN_VIEN (
    Manv nchar(3) PRIMARY KEY,
    Tennv NVARCHAR(100) NOT NULL,
    Chucvu NVARCHAR(50),
    Sodtnv VARCHAR(15),
    emailnv VARCHAR(100)
);

-- 3. Bảng Phương Tiện
CREATE TABLE PHUONG_TIEN (
    Mapt nchar(3) PRIMARY KEY,
    Loaipt NVARCHAR(50),
    Bienso VARCHAR(20) UNIQUE
);

-- 4. Bảng Khu Vực
CREATE TABLE KHU_VUC (
    Makv nchar(3) PRIMARY KEY,
    Tenkv  NVARCHAR(100),
    Diachikv NVARCHAR(255)
);

-- 5. Bảng Loại Hàng
CREATE TABLE LOAI_HANG (
    Malh nchar(3) PRIMARY KEY,
    Tenlh NVARCHAR(100),
    Note NVARCHAR(255)
);

-- 6. Bảng Đơn Hàng
CREATE TABLE DON_HANG (
    Madh nchar(3) PRIMARY KEY,
    Makh nchar(5) NOT NULL,
    Manv nchar(3) NOT NULL,
    Mapt nchar(3),
    Makvg nchar(3),
    Makvn nchar(3),
    Ngaygui DATE,
    Ngaynhandukien DATE,
    Trangthai NVARCHAR(50),
    FOREIGN KEY (Makh) REFERENCES KHACH_HANG(MaKh),
    FOREIGN KEY (Manv) REFERENCES NHAN_VIEN(Manv),
    FOREIGN KEY (Mapt) REFERENCES PHUONG_TIEN(Mapt),
    FOREIGN KEY (Makvg) REFERENCES KHU_VUC(Makv),
    FOREIGN KEY (Makvn) REFERENCES KHU_VUC(Makv)
);

-- 7. Bảng Chi Tiết Giao Hàng
CREATE TABLE CHI_TIET_GIAO_HANG (
    Mact nchar(3) PRIMARY KEY,
    Madh nchar(3) NOT NULL,
    Malh nchar(3),
    Khoiluong DECIMAL(10,2), --10 là giới hạn, 2 là 
    Note NVARCHAR(255),
    FOREIGN KEY (Madh) REFERENCES DON_HANG(Madh),
    FOREIGN KEY (Malh) REFERENCES LOAI_HANG(Malh)
);

-- 8. Bảng Hóa Đơn
CREATE TABLE HOA_DON (
    Mahd nchar(3) PRIMARY KEY,
    Madh nchar(3) NOT NULL,
    Ngaylap DATE,
    Tongtien DECIMAL(18,2),
    Hinhthucthanhtoan NVARCHAR(50),
    FOREIGN KEY (Madh) REFERENCES DON_HANG(Madh)
);

-- 9. Bảng Tài Xế
CREATE TABLE TAI_XE (
    Matx nchar(3) PRIMARY KEY,
    Tentx NVARCHAR(100) NOT NULL,
    Sodttx VARCHAR(15),
    BangLai NVARCHAR(50) -- Loại bằng lái: B2, C, D, E...
);

-- 10. Bảng Phân Công
CREATE TABLE PHAN_CONG (
    Mapc nchar(3) PRIMARY KEY,
    Matx nchar(3) NOT NULL,
    Mapt nchar(3) NOT NULL,
    Madh nchar(3) NOT NULL,
    Ngayphancong DATE,
    FOREIGN KEY (Matx) REFERENCES TAI_XE(Matx),
    FOREIGN KEY (Mapt) REFERENCES PHUONG_TIEN(Mapt),
    FOREIGN KEY (Madh) REFERENCES DON_HANG(Madh)
);
