--------------------------------------------------
-- 1. Dữ liệu KHÁCH HÀNG
--------------------------------------------------
INSERT INTO KHACH_HANG (Makh, Tenkh, Diachi, Sodtkh, Emailkh)
VALUES 
('KH1', N'Công ty ABC', N'123 Lê Lợi, Q1, TP.HCM', '0909123456', 'abc@congtyabc.vn'),
('KH2', N'Công ty XYZ', N'456 Nguyễn Huệ, Q1, TP.HCM', '0911222333', 'xyz@congtyxyz.vn'),
('KH3', N'Cá nhân Nguyễn Văn A', N'789 Pasteur, Q3, TP.HCM', '0988777666', 'nva@gmail.com');

--------------------------------------------------
-- 2. Dữ liệu NHÂN VIÊN
--------------------------------------------------
INSERT INTO NHAN_VIEN (Manv, Tennv, Chucvu, Sodtnv, emailnv)
VALUES 
('NV1', N'Nguyễn Thị B', N'Nhân viên kinh doanh', '0933444555', 'ntb@vanchuyen.vn'),
('NV2', N'Trần Văn C', N'Quản lý kho', '0944555666', 'tvc@vanchuyen.vn'),
('NV3', N'Lê Minh D', N'Nhân viên giao hàng', '0966778899', 'lmd@vanchuyen.vn');

--------------------------------------------------
-- 3. Dữ liệu PHƯƠNG TIỆN
--------------------------------------------------
INSERT INTO PHUONG_TIEN (Mapt, Loaipt, Bienso)
VALUES 
('PT1', N'Xe tải nhỏ', '51C-12345'),
('PT2', N'Xe tải lớn', '51D-67890'),
('PT3', N'Xe máy giao hàng', '59X1-11223');

--------------------------------------------------
-- 4. Dữ liệu KHU VỰC
--------------------------------------------------
INSERT INTO KHU_VUC (Makv, Tenkv, Diachikv)
VALUES 
('KV1', N'TP.HCM - Quận 1', N'Quận 1, TP.HCM'),
('KV2', N'TP.HCM - Quận 3', N'Quận 3, TP.HCM'),
('KV3', N'Bình Dương - Thủ Dầu Một', N'Thủ Dầu Một, Bình Dương');

--------------------------------------------------
-- 5. Dữ liệu LOẠI HÀNG
--------------------------------------------------
INSERT INTO LOAI_HANG (Malh, Tenlh, Note)
VALUES 
('LH1', N'Hàng nhẹ', N'Ví dụ: tài liệu, giấy tờ'),
('LH2', N'Hàng cồng kềnh', N'Ví dụ: nội thất, máy móc'),
('LH3', N'Hàng dễ vỡ', N'Ví dụ: gốm sứ, đồ thủy tinh');

--------------------------------------------------
-- 6. Dữ liệu ĐƠN HÀNG
--------------------------------------------------
INSERT INTO DON_HANG (Madh, Makh, Manv, Mapt, Makvg, Makvn, Ngaygui, Ngaynhandukien, Trangthai)
VALUES 
('DH1', 'KH1', 'NV1', 'PT1', 'KV1', 'KV2', '2025-04-26', '2025-04-27', N'Đang vận chuyển'),
('DH2', 'KH2', 'NV2', 'PT2', 'KV1', 'KV3', '2025-04-25', '2025-04-28', N'Đã giao'),
('DH3', 'KH3', 'NV3', 'PT3', 'KV2', 'KV1', '2025-04-24', '2025-04-24', N'Đã giao');

--------------------------------------------------
-- 7. Dữ liệu CHI TIẾT GIAO HÀNG
--------------------------------------------------
INSERT INTO CHI_TIET_GIAO_HANG (Mact, Madh, Malh, Khoiluong, Note)
VALUES 
('CT1', 'DH1', 'LH1', 5.5, N'Tài liệu hợp đồng'),
('CT2', 'DH2', 'LH2', 250.0, N'Bàn ghế văn phòng'),
('CT3', 'DH3', 'LH3', 2.0, N'Bộ ly thủy tinh cao cấp');

--------------------------------------------------
-- 8. Dữ liệu HÓA ĐƠN
--------------------------------------------------
INSERT INTO HOA_DON (Mahd, MaDh, Ngaylap, Tongtien, Hinhthucthanhtoan)
VALUES 
('HD1', 'DH1', '2025-04-26', 1500000, N'Tiền mặt'),
('HD2', 'DH2', '2025-04-25', 7500000, N'Chuyển khoản'),
('HD3', 'DH3', '2025-04-24', 500000, N'Tiền mặt');

--------------------------------------------------
-- 9. Dữ liệu TÀI XẾ
--------------------------------------------------
INSERT INTO TAI_XE (Matx, Tentx, Sodttx, BangLai)
VALUES 
('TX1', N'Phạm Văn E', '0909111222', N'B2'),
('TX2', N'Đỗ Thị F', '0911333444', N'C'),
('TX3', N'Lý Minh G', '0933555666', N'A1');

--------------------------------------------------
-- 10. Dữ liệu PHÂN CÔNG
--------------------------------------------------
INSERT INTO PHAN_CONG (Mapc, Matx, Mapt, Madh, Ngayphancong)
VALUES 
('PC1', 'TX1', 'PT1', 'DH1', '2025-04-26'),
('PC2', 'TX2', 'PT2', 'DH2', '2025-04-25'),
('PC3', 'TX3', 'PT3', 'DH3', '2025-04-24');

