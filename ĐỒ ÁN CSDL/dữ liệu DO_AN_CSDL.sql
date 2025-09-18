CREATE DATABASE DO_AN_CSDL

--BẢNG KHÁCH HÀNG
CREATE TABLE KHACH_HANG (
    MaKH INT PRIMARY KEY,
    HoTen NVARCHAR(100),
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SoDienThoai VARCHAR(15),
    Email NVARCHAR(100),
    CCCD VARCHAR(20),
    NgayTao DATE DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) DEFAULT N'Hoạt động'  -- hoặc 'Khoá'
);

INSERT INTO KHACH_HANG VALUES
(1, N'Nguyễn Văn A', N'Nam', '1998-05-12', '0909123456', 'a@gmail.com', '123456789', DEFAULT, DEFAULT),
(2, N'Trần Thị B', N'Nữ', '2000-11-23', '0911223344', 'b@yahoo.com', '987654321', DEFAULT, DEFAULT),
(3, N'Lê Thị C', N'Nữ', '1995-07-08', '0909333444', 'lethi.c@gmail.com', '111222333', DEFAULT, DEFAULT),
(4, N'Phạm Văn D', N'Nam', '1993-01-15', '0909444555', 'pham.d@gmail.com', '222333444', DEFAULT, N'Khoá'),
(5, N'Huỳnh Ngọc E', N'Nữ', '2001-12-30', '0909555666', 'huynh.e@gmail.com', '333444555', DEFAULT, DEFAULT),
(6, N'Trần Quốc F', N'Nam', '1990-03-22', '0909666777', 'tran.f@gmail.com', '444555666', DEFAULT, N'Hoạt động'),
(7, N'Doãn Hữu G', N'Nam', '1989-11-11', '0909777888', 'doan.g@gmail.com', '555666777', DEFAULT, DEFAULT),
(8, N'Ngô Thị H', N'Nữ', '1997-06-25', '0909888999', 'ngo.h@gmail.com', '666777888', DEFAULT, DEFAULT),
(9, N'Đỗ Minh I', N'Nam', '1996-09-17', '0909999000', 'do.i@gmail.com', '777888999', DEFAULT, N'Khoá'),
(10, N'Võ Hạnh J', N'Nữ', '2002-02-02', '0910001111', 'vo.j@gmail.com', '888999000', DEFAULT, DEFAULT);

--BẢNG NGƯỜI BÁN 
CREATE TABLE NGUOI_BAN (
    MaNB INT PRIMARY KEY,
    TenShop NVARCHAR(100),
    DiaChi NVARCHAR(200),
    Email NVARCHAR(100),
    SoDienThoai VARCHAR(15),
    NgayThamGia DATE DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) DEFAULT N'Hoạt động',  -- Hoạt động / Ngưng hoạt động
    Mota NVARCHAR(255)                            -- Mô tả ngắn về shop
);

INSERT INTO NGUOI_BAN VALUES
(1, N'Shop Thời Trang ABC', N'123 Lê Lợi, Quận 1', 'abcshop@gmail.com', '0909090001', '2023-03-15', N'Hoạt động', N'Chuyên bán quần áo nam nữ'),
(2, N'Shop Điện Tử XYZ', N'456 Nguyễn Trãi, Quận 5', 'xyzstore@gmail.com', '0909090002', '2022-11-20', N'Hoạt động', N'Đồ công nghệ chính hãng'),
(3, N'Shop Gia Dụng HN', N'789 Cách Mạng Tháng 8, Quận 10', 'giadunghn@gmail.com', '0909090003', '2021-08-10', N'Hoạt động', N'Đồ dùng nhà bếp và tiện ích gia đình'),
(4, N'Shop Sách & Văn Phòng Phẩm', N'321 Lý Thường Kiệt, Quận Tân Bình', 'sachvp@gmail.com', '0909090004', '2020-04-25', N'Ngưng hoạt động', N'Sách giáo khoa, truyện tranh, văn phòng phẩm'),
(5, N'Shop Mỹ Phẩm Hana', N'654 Nguyễn Đình Chiểu, Quận 3', 'hana.cosmetic@gmail.com', '0909090005', '2023-07-05', N'Hoạt động', N'Mỹ phẩm nội địa Hàn, Nhật, chăm sóc da');

--BẢNG ĐƠN HÀNG
CREATE TABLE DON_HANG (
    MaDH INT PRIMARY KEY,
    MaKH INT,
    NgayDat DATE,
    TongTien MONEY,
    TrangThai NVARCHAR(50),  -- Đặt hàng, Xác nhận, Đang giao, Hoàn tất, Hủy
    SoDienThoaiNhan VARCHAR(15),
    NguoiNhan NVARCHAR(100),
    DiaChiGiao NVARCHAR(200),
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH)
);

INSERT INTO DON_HANG VALUES
(101, 1, '2025-05-10', 500000, N'Đang xử lý', '0909123456', N'Nguyễn Văn A', N'100 Trần Hưng Đạo, Quận 1'),
(102, 2, '2025-05-11', 1550000, N'Đang giao', '0911223344', N'Trần Thị B', N'200 Nguyễn Huệ, Quận 3'),
(103, 3, '2025-05-12', 350000, N'Xác nhận', '0909333444', N'Lê Thị C', N'12 Đinh Tiên Hoàng, Quận 1'),
(104, 4, '2025-05-13', 870000, N'Hoàn tất', '0909444555', N'Phạm Văn D', N'45 Hai Bà Trưng, Quận 1'),
(105, 5, '2025-05-13', 210000, N'Hủy', '0909555666', N'Huỳnh Ngọc E', N'87 Nguyễn Văn Cừ, Quận 5'),
(106, 6, '2025-05-14', 640000, N'Đang giao', '0909666777', N'Trần Quốc F', N'159 Cộng Hòa, Tân Bình'),
(107, 7, '2025-05-14', 990000, N'Đặt hàng', '0909777888', N'Doãn Hữu G', N'73 Đinh Bộ Lĩnh, Bình Thạnh'),
(108, 8, '2025-05-15', 1280000, N'Xác nhận', '0909888999', N'Ngô Thị H', N'101 Nguyễn Thị Minh Khai, Quận 1');

--BẢNG LOẠI HÀNG
CREATE TABLE LOAI_HANG (
    MaLoai INT PRIMARY KEY,
    TenLoai NVARCHAR(100),
    MoTa NVARCHAR(255),         -- Mô tả về loại hàng
    DoPhoBien INT DEFAULT 0     -- Độ phổ biến: số lượng sản phẩm thuộc loại này (hoặc rating, dùng để trigger cập nhật sau này)
);
INSERT INTO LOAI_HANG VALUES
(1, N'Quần áo', N'Thời trang nam nữ, trẻ em', 0),
(2, N'Điện tử', N'Đồ điện tử, phụ kiện công nghệ', 0),
(3, N'Gia dụng', N'Đồ dùng gia đình, bếp, nhà cửa', 0),
(4, N'Mỹ phẩm', N'Son, kem dưỡng, sản phẩm chăm sóc da, nước hoa', 0),
(5, N'Sách & Văn phòng phẩm', N'Sách giáo khoa, truyện, dụng cụ học tập', 0),
(6, N'Thiết bị thể thao', N'Dụng cụ tập gym, yoga, thể thao ngoài trời', 0),
(7, N'Thực phẩm & đồ uống', N'Đồ ăn nhẹ, thức uống, thực phẩm đóng gói', 0),
(8, N'Phụ kiện thời trang', N'Túi xách, mắt kính, đồng hồ, trang sức', 0),
(9, N'Đồ chơi & mẹ bé', N'Đồ chơi trẻ em, sản phẩm cho mẹ và bé', 0);


--BẢNG SẢN PHẨM 
CREATE TABLE SAN_PHAM (
    MaSP INT PRIMARY KEY,
    TenSP NVARCHAR(100),
    DonGia MONEY,
    MaLoai INT,
    MaNB INT,
    FOREIGN KEY (MaLoai) REFERENCES LOAI_HANG(MaLoai),
    FOREIGN KEY (MaNB) REFERENCES NGUOI_BAN(MaNB)
);

INSERT INTO SAN_PHAM VALUES
(1, N'Áo thun nam', 150000, 1, 1),
(2, N'Tai nghe bluetooth', 350000, 2, 2),
(3, N'Nồi chiên không dầu', 1200000, 3, 2),
(4, N'Son môi dưỡng ẩm Hàn Quốc', 220000, 4, 5), -- Mỹ phẩm Hana
(5, N'Sữa rửa mặt trà xanh', 180000, 4, 5),       -- Mỹ phẩm Hana
(6, N'Sách "Dám bị ghét"', 95000, 5, 4),          -- Shop Sách & VP Phẩm
(7, N'Combo bút bi + vở ô ly', 45000, 5, 4),      -- Shop Sách & VP Phẩm
(8, N'Dây kháng lực tập gym', 160000, 6, 3),      -- Shop Gia Dụng
(9, N'Thảm tập yoga cao su non', 390000, 6, 3),   -- Shop Gia Dụng
(10, N'Hộp bánh quy bơ Đan Mạch', 125000, 7, 3),  -- Shop Gia Dụng
(11, N'Bột cacao nguyên chất', 89000, 7, 3),      -- Shop Gia Dụng
(12, N'Mắt kính chống tia UV', 275000, 8, 1),     -- Shop Thời Trang
(13, N'Túi đeo chéo thời trang nam', 310000, 8, 1),-- Shop Thời Trang
(14, N'Gấu bông Totoro size trung', 145000, 9, 1),-- Shop Thời Trang
(15, N'Ghế ăn dặm gấp gọn', 490000, 9, 3);        -- Shop Gia Dụng


--BẢNG CHI TIẾT ĐƠN HÀNG
CREATE TABLE CHI_TIET_DON_HANG (
    MaDH INT,
    MaSP INT,
    SoLuong INT,
    DonGia MONEY,
    PRIMARY KEY (MaDH, MaSP),
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH),
    FOREIGN KEY (MaSP) REFERENCES SAN_PHAM(MaSP)
);

INSERT INTO CHI_TIET_DON_HANG VALUES
(101, 1, 2, 150000), -- Áo thun nam
(101, 2, 1, 200000), -- Tai nghe bluetooth

(102, 3, 1, 1200000), -- Nồi chiên không dầu
(102, 1, 1, 150000), -- Áo thun nam

(103, 4, 1, 220000),   -- Son môi Hàn Quốc
(103, 5, 1, 180000),   -- Sữa rửa mặt

(104, 6, 2, 95000),    -- Sách "Dám bị ghét"
(104, 7, 3, 45000),    -- Combo bút + vở

(105, 8, 1, 160000),   -- Dây kháng lực
(105, 10, 2, 125000),  -- Bánh quy bơ

(106, 9, 1, 390000),   -- Thảm yoga
(106, 11, 2, 89000),   -- Bột cacao

(107, 12, 1, 275000),  -- Mắt kính
(107, 13, 1, 310000),  -- Túi đeo chéo
(107, 1, 1, 150000),   -- Áo thun nam (lặp lại sản phẩm cũ)

(108, 14, 1, 145000),  -- Gấu bông Totoro
(108, 15, 1, 490000);  -- Ghế ăn dặm

--BẢNG ĐƠN VỊ VẬN CHUYỂN 
CREATE TABLE DON_VI_VAN_CHUYEN (
    MaDVVC INT PRIMARY KEY,
    TenDVVC NVARCHAR(100)
);

INSERT INTO DON_VI_VAN_CHUYEN VALUES
(1, N'Giao Hàng Nhanh'),
(2, N'J&T Express'),
(3, N'VNPost (Bưu điện Việt Nam)'),
(4, N'Ninja Van'),
(5, N'Shopee Express'),
(6, N'Viettel Post');


--BẢNG NHÂN VIÊN GIAO HÀNG 
CREATE TABLE NHAN_VIEN_GIAO_HANG (
    MaNVGH INT PRIMARY KEY,
    TenNV NVARCHAR(100),
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SoDienThoai VARCHAR(15),
    CCCD VARCHAR(20),
    MaDVVC INT,
    NgayVaoLam DATE,
    TrangThai NVARCHAR(20) DEFAULT N'Đang hoạt động',  -- 'Nghỉ việc', 'Tạm ngưng'
    FOREIGN KEY (MaDVVC) REFERENCES DON_VI_VAN_CHUYEN(MaDVVC)
);

INSERT INTO NHAN_VIEN_GIAO_HANG VALUES
(1, N'Lê Văn Giao', N'Nam', '1995-03-20', '0988776655', '111222333', 1, '2023-01-01', DEFAULT),
(2, N'Trần Giao Hàng', N'Nữ', '1996-08-15', '0977665544', '444555666', 2, '2022-05-15', DEFAULT),
(3, N'Nguyễn Minh Vận', N'Nam', '1990-10-10', '0911222333', '777888999', 3, '2021-03-01', DEFAULT),      -- VNPost
(4, N'Huỳnh Giao Linh', N'Nữ', '1998-12-25', '0909888777', '888999000', 4, '2022-07-10', DEFAULT),       -- Ninja Van
(5, N'Tống Hữu Tài', N'Nam', '1994-04-04', '0909777666', '999000111', 5, '2023-09-20', N'Tạm ngưng'),    -- Shopee Express
(6, N'Phạm Quốc Đạt', N'Nam', '1992-06-30', '0909666555', '000111222', 6, '2020-01-15', N'Nghỉ việc');   -- Viettel Post

--BẢNG GIAO HÀNG
CREATE TABLE GIAO_HANG (
    MaGH INT PRIMARY KEY,
    MaDH INT,
    MaNVGH INT,
    NgayGiao DATE,
    TinhTrang NVARCHAR(100),  -- Chờ lấy hàng, Đang giao, Giao thành công, Thất bại
    MaXacNhan VARCHAR(10),     -- Ví dụ: OTP 6 số
    ThoiGianGiaoThanhCong DATETIME NULL,
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH),
    FOREIGN KEY (MaNVGH) REFERENCES NHAN_VIEN_GIAO_HANG(MaNVGH)
);

INSERT INTO GIAO_HANG VALUES
(1, 101, 1, '2025-05-11', N'Đang giao', 'XZ1234', NULL),
(2, 102, 2, '2025-05-12', N'Chờ lấy hàng', 'AA9876', NULL),
(3, 103, 3, '2025-05-12', N'Giao thành công', 'GH1122', '2025-05-13 09:30:00'),  -- Thành công: VNPost
(4, 104, 4, '2025-05-13', N'Đang giao', 'GH3344', NULL),                         -- Đang giao: Ninja Van
(5, 105, 1, '2025-05-14', N'Thất bại', 'GH5566', NULL),                          -- Thất bại: Giao Hàng Nhanh
(6, 106, 2, '2025-05-14', N'Giao thành công', 'GH7788', '2025-05-15 14:20:00'),  -- J&T Express
(7, 107, 3, '2025-05-15', N'Chờ lấy hàng', 'GH9900', NULL),                      -- VNPost
(8, 108, 4, '2025-05-15', N'Đang giao', 'GH6633', NULL);                         -- Ninja Van


--BẢNG ĐƠN HÀNG
CREATE TABLE DIA_CHI (
    MaDC INT PRIMARY KEY,
    MaKH INT,
    DiaChi NVARCHAR(200),
    ThanhPho NVARCHAR(50),
    LoaiDiaChi NVARCHAR(20),  -- Nhà riêng, Công ty, Văn phòng
    MacDinh BIT DEFAULT 0,
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH)
);

-- KHÁCH HÀNG 1: Có 1 địa chỉ mặc định và 1 địa chỉ phụ
INSERT INTO DIA_CHI VALUES
(1, 1, N'100 Trần Hưng Đạo, Quận 1', N'TP.HCM', N'Nhà riêng', 1),
(3, 1, N'15 Nguyễn Thái Học, Quận 1', N'TP.HCM', N'Văn phòng', 0);

-- KHÁCH HÀNG 2: Có 1 địa chỉ mặc định và 1 địa chỉ phụ
INSERT INTO DIA_CHI VALUES
(2, 2, N'200 Nguyễn Huệ, Quận 3', N'TP.HCM', N'Công ty', 1),
(4, 2, N'50 Pasteur, Quận 1', N'TP.HCM', N'Nhà riêng', 0);

-- KHÁCH HÀNG 3 → 10: Mỗi người có 1 địa chỉ mặc định
INSERT INTO DIA_CHI VALUES
(5, 3, N'12 Phan Đình Phùng, TP. Đà Lạt', N'Lâm Đồng', N'Nhà riêng', 1),
(6, 4, N'88 Lê Văn Việt, TP. Thủ Đức', N'TP.HCM', N'Công ty', 1),
(7, 5, N'22 Nguyễn Tất Thành, Quận 4', N'TP.HCM', N'Văn phòng', 1),
(8, 6, N'30 Trần Phú, TP. Nha Trang', N'Khánh Hòa', N'Nhà riêng', 1),
(9, 7, N'59 Nguyễn Tri Phương, TP. Huế', N'Thừa Thiên Huế', N'Công ty', 1),
(10, 8, N'75 Hai Bà Trưng, Quận Hoàn Kiếm', N'Hà Nội', N'Nhà riêng', 1),
(11, 9, N'190 Lạc Long Quân, Quận Thanh Khê', N'Đà Nẵng', N'Nhà riêng', 1),
(12, 10, N'135 Lý Tự Trọng, Quận 1', N'TP.HCM', N'Công ty', 1);

--BẢNG THANH TOÁN
CREATE TABLE THANH_TOAN (
    MaTT INT PRIMARY KEY,
    MaDH INT,
    HinhThuc NVARCHAR(50),
    DaThanhToan BIT,
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH)
);

INSERT INTO THANH_TOAN VALUES
(1, 101, N'Thanh toán khi nhận hàng', 0),
(2, 102, N'Ví ShopeePay', 1),
(3, 103, N'Thanh toán khi nhận hàng', 0),              -- COD, chưa thanh toán
(4, 104, N'ShopeePay', 1),                              -- Đã thanh toán online
(5, 105, N'Thẻ tín dụng/ghi nợ', 1),                    -- Thẻ ngân hàng
(6, 106, N'Chuyển khoản ngân hàng', 0),                -- Chuyển khoản nhưng chưa nhận được
(7, 107, N'ShopeePay', 1),
(8, 108, N'Thanh toán khi nhận hàng', 0);


--BẢNG TRẠNG THÁI GIAO HÀNG
CREATE TABLE TRANG_THAI_DON_HANG (
    MaTT INT PRIMARY KEY,
    MaDH INT,
    NgayCapNhat DATETIME,
    TrangThai NVARCHAR(100),
    FOREIGN KEY (MaDH) REFERENCES DON_HANG(MaDH)
);

INSERT INTO TRANG_THAI_DON_HANG VALUES
(1, 101, '2025-05-10 10:00', N'Đã đặt hàng'),
(2, 101, '2025-05-10 15:00', N'Đã xác nhận'),
(3, 102, '2025-05-11 09:00', N'Đã lấy hàng');

-- Đơn hàng 101: Đã đặt → Đã xác nhận → Đã giao thành công
INSERT INTO TRANG_THAI_DON_HANG VALUES
(4, 101, '2025-05-11 13:00', N'Đã lấy hàng'),
(5, 101, '2025-05-12 09:00', N'Đang giao'),
(6, 101, '2025-05-12 18:30', N'Giao thành công');

-- Đơn hàng 102: Đã lấy hàng → Đang giao (chưa xong)
INSERT INTO TRANG_THAI_DON_HANG VALUES
(7, 102, '2025-05-11 15:30', N'Đang giao');

-- Đơn hàng 103: Đặt → Hủy ngay sau đó
INSERT INTO TRANG_THAI_DON_HANG VALUES
(8, 103, '2025-05-12 10:00', N'Đã đặt hàng'),
(9, 103, '2025-05-12 11:00', N'Đã hủy');

-- Đơn hàng 104: Đang trong quá trình giao
INSERT INTO TRANG_THAI_DON_HANG VALUES
(10, 104, '2025-05-13 08:45', N'Đã đặt hàng'),
(11, 104, '2025-05-13 09:30', N'Đã xác nhận'),
(12, 104, '2025-05-13 13:00', N'Đã lấy hàng'),
(13, 104, '2025-05-13 18:00', N'Đang giao');

-- Đơn hàng 105: Đặt hàng nhưng giao thất bại
INSERT INTO TRANG_THAI_DON_HANG VALUES
(14, 105, '2025-05-14 07:50', N'Đã đặt hàng'),
(15, 105, '2025-05-14 09:00', N'Đã xác nhận'),
(16, 105, '2025-05-14 14:00', N'Đã lấy hàng'),
(17, 105, '2025-05-14 20:00', N'Đang giao'),
(18, 105, '2025-05-15 10:00', N'Giao thất bại');

-- Đơn hàng 106: Đã hoàn thành
INSERT INTO TRANG_THAI_DON_HANG VALUES
(19, 106, '2025-05-14 08:30', N'Đã đặt hàng'),
(20, 106, '2025-05-14 10:00', N'Đã xác nhận'),
(21, 106, '2025-05-14 13:30', N'Đã lấy hàng'),
(22, 106, '2025-05-14 16:00', N'Đang giao'),
(23, 106, '2025-05-15 09:00', N'Giao thành công');

-- Đơn hàng 107: Mới đặt, chưa xử lý
INSERT INTO TRANG_THAI_DON_HANG VALUES
(24, 107, '2025-05-15 08:00', N'Đã đặt hàng');

-- Đơn hàng 108: Đang ở bước xác nhận
INSERT INTO TRANG_THAI_DON_HANG VALUES
(25, 108, '2025-05-15 09:30', N'Đã đặt hàng'),
(26, 108, '2025-05-15 11:00', N'Đã xác nhận');
