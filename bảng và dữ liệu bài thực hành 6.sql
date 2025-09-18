CREATE DATABASE QLBV_BTH_6

--BẢNG BỆNH NHÂN
CREATE TABLE BENH_NHAN (
    MaBenhNhan INT PRIMARY KEY,
    Ten NVARCHAR(100),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    DiaChi NVARCHAR(255)
);

--BẢNG BÁC SĨ
CREATE TABLE BAC_SI (
    MaBacSi INT PRIMARY KEY,
    Ten NVARCHAR(100),
    ChuyenKhoa NVARCHAR(100)
);

--BẢNG SỐ LẦN KHÁM
CREATE TABLE LAN_KHAM (
    MaKham INT PRIMARY KEY,
    MaBenhNhan INT,
    MaBacSi INT,
    NgayKham DATE,
    ChanDoan NVARCHAR(255),
    DonThuoc NVARCHAR(255),
    FOREIGN KEY (MaBenhNhan) REFERENCES BENH_NHAN(MaBenhNhan),
    FOREIGN KEY (MaBacSi) REFERENCES BAC_SI(MaBacSi)
);

-- Dữ liệu mẫu cho bảng BENH_NHAN
INSERT INTO BENH_NHAN (MaBenhNhan, Ten, NgaySinh, GioiTinh, DiaChi)
VALUES 
(1, N'Nguyễn Văn A', '1990-05-15', N'Nam', N'Hà Nội'),
(2, N'Trần Thị B', '1985-08-20', N'Nữ', N'TP.HCM'),
(3, N'Lê Văn C', '1978-03-10', N'Nam', N'Đà Nẵng');

-- Dữ liệu mẫu cho bảng BAC_SI
INSERT INTO BAC_SI (MaBacSi, Ten, ChuyenKhoa)
VALUES 
(1, N'Bác sĩ Nguyễn D', N'Nội khoa'),
(2, N'Bác sĩ Trần M', N'Ngoại khoa'),
(3, N'Bác sĩ Lê P', N'Nhi khoa');

-- Dữ liệu mẫu cho bảng LAN_KHAM
INSERT INTO LAN_KHAM (MaKham, MaBenhNhan, MaBacSi, NgayKham, ChanDoan, DonThuoc)
VALUES 
(1, 1, 1, '2025-05-20', N'Viêm phổi', N'Thuốc kháng sinh'),
(2, 2, 2, '2025-05-21', N'Gãy xương', N'Băng bó và thuốc giảm đau'),
(3, 3, 3, '2025-05-22', N'Sốt cao', N'Thuốc hạ sốt');