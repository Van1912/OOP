-- ============================
-- TẠO CƠ SỞ DỮ LIỆU
-- ============================
CREATE DATABASE QL_NHANVIEN;
GO

USE QL_NHANVIEN;
GO

-- ============================
-- TẠO BẢNG PHONGBAN
-- ============================
CREATE TABLE PHONGBAN (
    MaPB VARCHAR(10) PRIMARY KEY,
    TenPB NVARCHAR(100),
    TruongPhong VARCHAR(10) -- Là MaNV, có thể thêm FK sau
);
GO

-- ============================
-- TẠO BẢNG NHANVIEN
-- ============================
CREATE TABLE NHANVIEN (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(200),
    MaPB VARCHAR(10),
    FOREIGN KEY (MaPB) REFERENCES PHONGBAN(MaPB)
);
GO

-- (Gán khóa ngoại Trưởng phòng sau khi có dữ liệu, hoặc dùng ALTER TABLE nếu cần FK tới NHANVIEN)

-- ============================
-- TẠO BẢNG LUONG
-- ============================
CREATE TABLE LUONG (
    MaNV VARCHAR(10),
    Thang INT,
    Nam INT,
    LuongCB MONEY,
    PhuCap MONEY,
    TongLuong AS (LuongCB + PhuCap) PERSISTED,
    PRIMARY KEY (MaNV, Thang, Nam),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);
GO
-- Chèn dữ liệu
INSERT INTO PHONGBAN (MaPB, TenPB, TruongPhong) 
VALUES
('PB01', N'Kế Toán', 'NV01'),
('PB02', N'Nhân Sự', 'NV03'),
('PB03', N'IT', 'NV05');
go
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, DiaChi, MaPB) 
VALUES
('NV01', N'Nguyễn Văn A', '1990-05-20', N'Nam', N'Hà Nội', 'PB01'),
('NV02', N'Lê Thị B', '1992-08-10', N'Nữ', N'Hồ Chí Minh', 'PB01'),
('NV03', N'Trần Văn C', '1988-03-15', N'Nam', N'Đà Nẵng', 'PB02'),
('NV04', N'Phạm Thị D', '1995-12-01', N'Nữ', N'Cần Thơ', 'PB02'),
('NV05', N'Võ Minh E', '1991-07-25', N'Nam', N'Hà Nội', 'PB03'),
('NV06', N'Đỗ Thị F', '1996-04-18', N'Nữ', N'Huế', 'PB03');
go
-- Tháng 3/2025
INSERT INTO LUONG (MaNV, Thang, Nam, LuongCB, PhuCap) 
VALUES
('NV01', 3, 2025, 10000000, 2000000),
('NV02', 3, 2025, 9500000, 1500000),
('NV03', 3, 2025, 11000000, 2200000),
('NV04', 3, 2025, 9200000, 1800000),
('NV05', 3, 2025, 12000000, 2500000),
('NV06', 3, 2025, 8800000, 1700000);

-- Tháng 4/2025
INSERT INTO LUONG (MaNV, Thang, Nam, LuongCB, PhuCap) 
VALUES
('NV01', 4, 2025, 10200000, 2100000),
('NV02', 4, 2025, 9600000, 1600000),
('NV03', 4, 2025, 11200000, 2300000),
('NV04', 4, 2025, 9300000, 1850000),
('NV05', 4, 2025, 12100000, 2550000),
('NV06', 4, 2025, 8900000, 1750000);

