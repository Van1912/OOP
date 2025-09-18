--Dữ liệu cho bảng HANG_HOA

INSERT INTO HANG_HOA (mahh, tenhh, dvthh) VALUES
('MDM001', N'Modem', N'Cái'),
('HD0500', N'Đĩa cứng 500 Gb', N'Cái'),
('HD1000', N'Đĩa cứng 1T', N'Cái'),
('KBMS01', N'Bàn phím', N'Cái'),
('LPHP4L', N'Máy in laser', N'Cái'),
('MNT017', N'Màn hình 17', N'Cái'),
('LOA065', N'Loa ngoài', N'Cặp'),
('MOU001', N'Con chuột', N'Con'),
('DSK001', N'Máy desktop', N'Bộ');

--Dữ liệu cho bảng KHACH_HANG
INSERT INTO KHACH_HANG (makh, tenkh, diachikh, dthoaiKH) VALUES
('K001', N'Cty Ngọc An', N'596 Ngô Quyền', '83 291 777'),
('K002', N'Trường CĐTH', N'272 Nguyễn Văn Cừ', '83 351 056'),
('K003', N'Cty Chánh Nghĩa', N'48/50 Đỗ Quang Đẩu', '83 360 676'),
('K004', N'Cty Phú Sỹ', N'167 Bà Hạt', '83 421 414'),
('K005', N'Cty Vinatec', N'187 Nguyễn Trãi', '83 311 873'),
('K006', N'Cty Hương Việt', N'20 Trần Xuân Soạn', '83 729 112');

-- Dữ liệu cho bảng PHIEU_NHAP
INSERT INTO PHIEU_NHAP (sopn, ngaypn, makh) VALUES
('PN001', '2011-11-07', 'K001'),
('PN002', '2011-12-10', 'K002'),
('PN003', '2012-01-16', 'K002'),
('PN004', '2012-02-18', 'K003');

-- Dữ liệu cho bảng CHITIET_PN
INSERT INTO CHITIET_PN (sopn, mahh, solghhpn, thanhtienhhpn) VALUES
('PN001', 'MDM001',  50,  40000000),
('PN001', 'HD0500', 200, 360000000),
('PN002', 'HD1000', 100, 200000000),
('PN002', 'LOA065',  60,  36500000),
('PN003', 'KBMS01', 100, 100000000),
('PN003', 'LPHP4L',  50, 150000000),
('PN003', 'MNT017', 100, 100000000),
('PN004', 'MOU001', 250, 20000000),
('PN004', 'DSK001',  50, 35000000);

-- Dữ liệu cho bảng DON_DH
INSERT INTO DON_DH (sodh, ngaydh, ngaygiaodk, makh) VALUES
('DH001', '2012-01-05', '2012-01-08', 'K001'),
('DH002', '2012-01-05', '2012-01-05', 'K005'),
('DH003', '2012-01-08', '2012-01-10', 'K004'),
('DH004', '2012-01-11', '2012-01-14', 'K006'),
('DH005', '2012-01-15', '2012-01-16', 'K005'),
('DH006', '2012-01-20', '2012-01-23', 'K001');

--Dữ liệu cho bảng CHITIET_DH:
INSERT INTO CHITIET_DH (sodh, mahh, solghhdh, sotienhhdh) VALUES
('DH001', 'DSK001', 3, 24000000),
('DH002', 'HD0500', 5, 10000000),
('DH002', 'HD1000', 2, 4500000),
('DH002', 'KBMS01', 5, 600000),
('DH003', 'LPHP4L', 1, 4000000),
('DH003', 'DSK001', 1, 8000000),
('DH003', 'MOU001', 10, 10000000),
('DH004', 'DSK001', 5, 40000000),
('DH004', 'MOU001', 10, 10000000),
('DH005', 'MDM001', 4, 4000000),
('DH005', 'MOU001', 5, 500000),
('DH005', 'MNT017', 2, 3000000),
('DH006', 'LPHP4L', 2, 8000000);

--Dữ liệu cho bảng PHIEU_GH:
INSERT INTO PHIEU_GH (sogh, ngaygh, sodh) VALUES
('GH011', '2012-01-07', 'DH001'),
('GH012', '2012-01-07', 'DH002'),
('GH013', '2012-01-09', 'DH003'),
('GH014', '2012-01-13', 'DH004'),
('GH015', '2012-01-15', 'DH005'),
('GH016', '2012-01-17', 'DH005'),
('GH017', '2012-01-22', 'DH006');

--Dữ liệu bảng CHITIET_GH
INSERT INTO CHITIET_GH (sogh, mahh, solghhgh)
VALUES
    ('GH011', 'DSK001', 3),
    ('GH012', 'HD0500', 5),
    ('GH012', 'HD1000', 2),
    ('GH013', 'LPHP4L', 1),
    ('GH013', 'DSK001', 1),
    ('GH014', 'MOU001', 8),
    ('GH014', 'DSK001', 5),
    ('GH015', 'MDM001', 4),
    ('GH015', 'MOU001', 5),
    ('GH016', 'MNT017', 2),
    ('GH017', 'LPHP4L', 1);

--Dữ liệu bảng HOA_DON
INSERT INTO HOA_DON (sohd, ngayhd, tenkhachhang, trigiahd) VALUES
('HD001', '2012-01-05', N'Khách vãng lai', 270000000),
('HD002', '2012-01-05', N'Nguyễn Văn Bình', 555000000),
('HD003', '2012-01-06', N'Nguyễn Văn An', 209500000),
('HD004', '2012-01-10', N'Khách vãng lai', 1500000),
('HD005', '2012-01-11', N'Khách vãng lai', 125000000),
('HD006', '2012-02-12', N'Khách vãng lai', 458000000),
('HD007', '2012-02-15', N'Trần Thanh Ngọc', 25000),
('HD008', '2012-02-16', N'Lý Thái An', 35000000),
('HD009', '2012-03-14', N'Võ Minh Hòa', 770000000),
('HD010', '2012-03-14', N'Võ Minh Hòa', 59000000);

--Dữ liệu bảng CHITIET_HD
INSERT INTO CHITIET_HD (sohd, mahh, solghhhd, thanhtienhhhd) VALUES
('HD001', 'DSK001', 3, 270000000),
('HD002', 'HD0500', 1, 20000000),
('HD002', 'LPHF4L', 1, 355000000),
('HD003', 'HD0500', 4, 80000000),
('HD003', 'HD1000', 5, 125000000),
('HD003', 'KBMS01', 3, 450000),
('HD004', 'MNT017', 1, 15000000),
('HD005', 'LPHF4L', 1, 355000000),
('HD005', 'DSK001', 1, 90000000),
('HD006', 'MOU001', 8, 8000000),
('HD006', 'DSK001', 5, 450000000),
('HD007', 'MOU001', 1, 1000000),
('HD007', 'KBMS01', 1, 1500000),
('HD008', 'LPHF4L', 1, 35500000),
('HD009', 'MDM001', 1, 12000000),
('HD009', 'HD1000', 1, 25500000),
('HD009', 'LPHF4L', 1, 40000000),
('HD010', 'MDM001', 3, 3000000),
('HD010', 'MNT017', 1, 15000000);

SELECT * FROM HANG_HOA;
