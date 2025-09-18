--11.Không cho phép xoá KHACH_HANG nếu họ có đơn hàng liên quan
CREATE TRIGGER trg_PreventDeleteKhachHang
ON KHACH_HANG
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM DON_HANG dh
        JOIN DELETED d ON dh.MaKH = d.MaKH
    )
    BEGIN
        PRINT(N'Không thể xoá khách hàng vì đã có đơn hàng liên quan.');
        ROLLBACK TRAN;
    END
end

/*NOTE:DELETE FROM KHACH_HANG WHERE MaKH = 1;*/

--12.Không cho phép thanh toán lại đơn đã có DaThanhToan = 1
CREATE TRIGGER trg_KhongThanhToanLai
ON THANH_TOAN
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN THANH_TOAN T ON I.MaDH = T.MaDH
        WHERE T.DaThanhToan = 1
    )
    BEGIN
        PRINT (N'Đơn hàng đã được thanh toán. Không thể thanh toán lại.');
    END

    -- Nếu không vi phạm, tiếp tục thao tác
    IF EXISTS (SELECT 1 FROM INSERTED)
    BEGIN
        -- Kiểm tra là insert hay update
        IF NOT EXISTS (SELECT 1 FROM THANH_TOAN WHERE MaTT IN (SELECT MaTT FROM INSERTED))
        BEGIN
            INSERT INTO THANH_TOAN (MaTT, MaDH, HinhThuc, DaThanhToan)
            SELECT MaTT, MaDH, HinhThuc, DaThanhToan FROM INSERTED;
        END
        ELSE
        BEGIN
            UPDATE T
            SET T.HinhThuc = I.HinhThuc,
                T.DaThanhToan = I.DaThanhToan
            FROM THANH_TOAN T
            JOIN INSERTED I ON T.MaTT = I.MaTT;
        END
    END
END;

/*NOTE:INSERT INTO THANH_TOAN VALUES (9, 102, N'Ví điện tử khác', 1);*/

--Không cho thêm GIAO_HANG với MaXacNhan trùng lặp
CREATE TRIGGER trg_TrungMAXN
ON GIAO_HANG
AFTER INSERT,UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT * FROM INSERTED i
        JOIN GIAO_HANG gh ON i.MaXacNhan = gh.MaXacNhan
    )
    BEGIN
        PRINT(N'Mã xác nhận giao hàng đã tồn tại.')
		ROLLBACK TRAN;
    END
END;

/*NOTE: INSERT INTO GIAO_HANG (MaGH, MaDH, MaNVGH, NgayGiao, TinhTrang, MaXacNhan, ThoiGianGiaoThanhCong)
VALUES (10, 102, 2, '2025-05-17', N'Đang giao', 'GH7788', NULL);*/


--TRIGGER CHỐNG GIAN LẬN TẠO TÀI KHOẢN:
CREATE TRIGGER trg_ChongGianLanDangKy
 ON KHACH_HANG
 INSTEAD OF INSERT
 AS
 BEGIN
 IF EXISTS (
 SELECT Email
 FROM INSERTED I
 GROUP BY Email
 HAVING EXISTS (
 SELECT 1
 FROM KHACH_HANG KH
 WHERE KH.Email = I.Email
 GROUP BY KH.Email
 HAVING COUNT(*) >= 2)
 )
	BEGIN
	PRINT(N'Email này đã được sử dụng để đăng ký.')
	ROLLBACK TRAN;
	END
END

--Tự động HUỶ đơn hàng nếu bị giao thất bại quá 3 lần
CREATE TRIGGER trg_HuyDonSau3LanThatBai
ON GIAO_HANG
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy danh sách đơn hàng có từ 3 lần giao thất bại trở lên
    WITH ThatBai AS (
        SELECT MaDH, COUNT(*) AS SoLanThatBai
        FROM GIAO_HANG
        WHERE TinhTrang = N'Thất bại'
        GROUP BY MaDH
        HAVING COUNT(*) >= 3
    )

    -- Cập nhật trạng thái đơn hàng thành 'Hủy' nếu chưa bị hủy
    UPDATE DH
    SET TrangThai = N'Hủy'
    FROM DON_HANG DH
    JOIN ThatBai TB ON DH.MaDH = TB.MaDH
    WHERE DH.TrangThai != N'Hủy';
END;

--8. Không cho cập nhật trạng thái đơn hàng thành 'Hủy' nếu đơn đã chuyển sang trạng thái giao
CREATE TRIGGER trg_KhongHuyKhiDangGiao
ON DON_HANG
INSTEAD OF UPDATE
AS
BEGIN
    -- Chặn nếu trạng thái được cập nhật thành 'Hủy' trong khi trạng thái hiện tại là đang giao
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN DON_HANG D ON I.MaDH = D.MaDH
        WHERE I.TrangThai = N'Hủy'
          AND D.TrangThai IN (N'Đã xác nhận', N'Đã lấy hàng', N'Đang giao', N'Xác nhận')
    )
    BEGIN
        PRINT (N'Không thể hủy đơn hàng khi đơn đang trong quá trình giao.');
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Nếu không vi phạm thì thực hiện cập nhật bình thường
    UPDATE D
    SET D.TrangThai = I.TrangThai,
        D.TongTien = I.TongTien,
        D.SoDienThoaiNhan = I.SoDienThoaiNhan,
        D.NguoiNhan = I.NguoiNhan,
        D.DiaChiGiao = I.DiaChiGiao
    FROM DON_HANG D
    JOIN INSERTED I ON D.MaDH = I.MaDH;
END;

/*NOTE: INSERT INTO DON_HANG VALUES
(110, 1, '2025-05-21', 200000, N'Đang giao', '0909000000', N'Nguyễn Văn A', N'50 Nguyễn Trãi, Quận 5');

UPDATE DON_HANG
SET TrangThai = N'Hủy'
WHERE MaDH = 110;*/

--9.Ngăn người bán ngưng hoạt động nếu còn đơn đang xử lý
CREATE TRIGGER trg_KhongDuocNgungHoatDongNeuConDon
ON NGUOI_BAN
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra các dòng cập nhật trạng thái sang "Ngưng hoạt động"
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.TrangThai = N'Ngưng hoạt động'
        AND EXISTS (
            SELECT 1
            FROM SAN_PHAM sp
            JOIN CHI_TIET_DON_HANG ct ON sp.MaSP = ct.MaSP
            JOIN DON_HANG dh ON dh.MaDH = ct.MaDH
            WHERE sp.MaNB = i.MaNB
              AND dh.TrangThai NOT IN (N'Hoàn tất', N'Hủy')
        )
    )
    BEGIN
        PRINT(N'Không thể ngưng hoạt động: Shop vẫn còn đơn hàng chưa xử lý!');
        RETURN;
    END
END

/*NOTE:UPDATE NGUOI_BAN
SET TrangThai = N'Ngưng hoạt động'
WHERE MaNB = 1;*/

--13. Không cho cập nhật đơn hàng đã hoàn tất hoặc đã hủy
CREATE TRIGGER trg_Khongsuadon
ON DON_HANG
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN DON_HANG D ON I.MaDH = D.MaDH
        WHERE D.TrangThai IN (N'Hoàn tất', N'Hủy')
    )
    BEGIN
        PRINT(N'Không thể cập nhật đơn hàng đã hoàn tất hoặc đã hủy.');
        ROLLBACK TRAN
    END

    -- Nếu không vi phạm, tiến hành cập nhật như bình thường
    UPDATE D
    SET
        D.NgayDat = I.NgayDat,
        D.TongTien = I.TongTien,
        D.TrangThai = I.TrangThai,
        D.SoDienThoaiNhan = I.SoDienThoaiNhan,
        D.NguoiNhan = I.NguoiNhan,
        D.DiaChiGiao = I.DiaChiGiao,
        D.MaKH = I.MaKH
    FROM DON_HANG D
    JOIN INSERTED I ON D.MaDH = I.MaDH;
END;

UPDATE DON_HANG
SET NguoiNhan = N'Người nhận mới'
WHERE MaDH = 104;  -- Đơn đã "Hoàn tất"

--Kiểm tra 
CREATE TRIGGER trg_ChuyenDonNeuShipperNghi
ON NHAN_VIEN_GIAO_HANG
AFTER UPDATE
AS
BEGIN
    DECLARE @MaNVGH INT, @MaDVVC INT;
    DECLARE cur CURSOR FOR
    SELECT I.MaNVGH, I.MaDVVC
    FROM INSERTED I
    JOIN DELETED D ON I.MaNVGH = D.MaNVGH
    WHERE I.TrangThai IN (N'Nghỉ việc', N'Tạm ngưng') AND D.TrangThai = N'Đang hoạt động';
    OPEN cur;
    FETCH NEXT FROM cur INTO @MaNVGH, @MaDVVC;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @ShipperMoi INT;

        -- Tìm shipper khác cùng đơn vị và đang hoạt động
        SELECT TOP 1 @ShipperMoi = MaNVGH
        FROM NHAN_VIEN_GIAO_HANG
        WHERE MaDVVC = @MaDVVC AND TrangThai = N'Đang hoạt động' AND MaNVGH <> @MaNVGH
        ORDER BY NEWID();

        -- Nếu có shipper thay thế, cập nhật đơn chưa giao
        IF @ShipperMoi IS NOT NULL
        BEGIN
            UPDATE GIAO_HANG
            SET MaNVGH = @ShipperMoi
            WHERE MaNVGH = @MaNVGH AND ThoiGianGiaoThanhCong IS NULL;
        END

        FETCH NEXT FROM cur INTO @MaNVGH, @MaDVVC;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;

--dùng để kiểm tra trigger 
-- Trước: Xem các đơn đang được giao bởi shipper 2
SELECT * FROM GIAO_HANG WHERE MaNVGH = 2;

-- Cập nhật trạng thái của shipper 2
UPDATE NHAN_VIEN_GIAO_HANG SET TrangThai = N'Nghỉ việc' WHERE MaNVGH = 2;

-- Sau: Xem các đơn có MaDH tương ứng đã được chuyển sang shipper khác chưa
SELECT * FROM GIAO_HANG WHERE MaDH IN (102, 106);  -- ví dụ: các đơn đang được giao bởi shipper 2

CREATE TRIGGER trg_TangDoPhoBien
ON SAN_PHAM
AFTER INSERT
AS
BEGIN
    UPDATE LOAI_HANG
    SET DoPhoBien = DoPhoBien + 1
    FROM LOAI_HANG l
    JOIN INSERTED i ON l.MaLoai = i.MaLoai;
END;


CREATE TRIGGER trg_CapNhatTrangThai
ON TRANG_THAI_DON_HANG
AFTER INSERT
AS
BEGIN
    

    UPDATE DH
    SET TrangThai = I.TrangThai
    FROM DON_HANG DH
    JOIN INSERTED I ON DH.MaDH = I.MaDH;
END;

INSERT INTO TRANG_THAI_DON_HANG
VALUES (27, 107, GETDATE(), N'Đang giao');

SELECT * FROM DON_HANG WHERE MaDH = 201;

--CURSOR
DECLARE @MaKH INT;
DECLARE @HoTen NVARCHAR(100);
DECLARE @TongDoanhThu MONEY;

-- Cursor duyệt từng khách hàng
DECLARE csr_DoanhThuTheoKhachHang CURSOR FOR
SELECT MaKH, HoTen
FROM KHACH_HANG;

-- Mở cursor
OPEN csr_DoanhThuTheoKhachHang;

-- Lấy dòng đầu tiên
FETCH NEXT FROM csr_DoanhThuTheoKhachHang INTO @MaKH, @HoTen;

-- Duyệt từng khách hàng
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Tính tổng doanh thu từ đơn hàng
    SELECT @TongDoanhThu = SUM(TongTien)
    FROM DON_HANG
    WHERE MaKH = @MaKH;

    -- Nếu khách hàng có đơn hàng
    IF @TongDoanhThu IS NOT NULL
    BEGIN
        PRINT N'Khách hàng: ' + @HoTen + 
              N' | Mã KH: ' + CAST(@MaKH AS NVARCHAR) + 
              N' | Tổng doanh thu: ' + CAST(@TongDoanhThu AS NVARCHAR);
    END
    ELSE
    BEGIN
        PRINT N'Khách hàng: ' + @HoTen + 
              N' | Mã KH: ' + CAST(@MaKH AS NVARCHAR) + 
              N' | Tổng doanh thu: 0';
    END

    FETCH NEXT FROM csr_DoanhThuTheoKhachHang INTO @MaKH, @HoTen;
END

-- Đóng cursor
CLOSE csr_DoanhThuTheoKhachHang;
DEALLOCATE csr_DoanhThuTheoKhachHang;