--5.11
/*Chỉ những giảng viên có học vị thạc sĩ hay tiến sĩ mới được phân công phụ trách dạy lý thuyết cho
một môn học*/
CREATE TRIGGER tr_phancong_lythuyet
ON GIANG_DAY
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @magv CHAR(4), @phutrach CHAR(2);

    SELECT @magv = magv, @phutrach = phutrach
    FROM inserted;

    IF (@phutrach = N'LT') AND NOT EXISTS (
        SELECT * FROM GIANG_VIEN
        WHERE magv = @magv AND hocvi IN (N'Thạc sĩ', N'Tiến sĩ')
    )
    BEGIN
        PRINT N'Chỉ những giảng viên có học vị Thạc sĩ hoặc Tiến sĩ mới được phân công dạy lý thuyết.';
        ROLLBACK TRANSACTION;
    END
END;
/*b.Giám thị gác thi cho một môn học trong một học kỳ của một năm học không được là giảng viên đã
giảng dạy môn học đó trong học kỳ và năm học tương ứng.*/
CREATE TRIGGER trg_KiemtraGiamthi
ON THI 
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS 
( 
		SELECT *
		FROM INSERTED i
		JOIN GIANG_DAY GD 
		ON i.namhoc=gd.namhoc
		AND i.hocky=gd.hocky
		AND i.mamh= gd.mamh
		AND i.giamthi=gd.magv
)
	BEGIN
		PRINT (N'giám thị không được là giảng viên đã giảng dạy môn học này trong học kỳ và năm học tương ứng')
		ROLLBACK TRANSACTION;
	END
END;
/*c.Sinh viên chỉ được đăng ký môn học khi môn học đó đã được phân công giảng viên.*/
CREATE TRIGGER trg_KiemtraDangkymon
ON DANG_KY
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS 
(
		SELECT *
		FROM INSERTED i
		LEFT JOIN GIANG_DAY gd
		ON i.mamh=gd.mamh
		AND i.hocky=gd.hocky
		AND i.namhoc=gd.namhoc
		WHERE gd.magv IS NULL
)
	BEGIN
	PRINT (N'Môn học chưa có giảng viên giảng dạy, không được phép đăng ký')
	ROLLBACK TRANSACTION;
	END
END;
/*d.Chỉ cho phép những sinh viên đã đạt môn Cấu trúc dữ liệu (tổng điểm thi lý thuyết và thực hành >=
10) mới được đăng ký môn học CSDL*/
CREATE TRIGGER trg_KiemtraDK_CSDL
ON DANG_KY
AFTER INSERT,UPDATE
AS
BEGIN
--Kiểm tra sinh viên đăng ký môn CSDL mà chưa đạt CTDL
	IF EXISTS
(
	SELECT *
	FROM INSERTED i
	WHERE i.mamh ='CSDL' --chỉ kiểm tra khi đăng ký môn CSDL

	AND NOT EXISTS (
		SELECT masv
		FROM KET_QUA kq
		WHERE masv=i.masv
		AND mamh='CTDL'
		GROUP BY masv
		HAVING SUM(COALESCE(diemLT,0) +COALESCE(diemTH,0))>=10
		)
	)
	BEGIN
	PRINT (N'SV chưa đạt môn CTDL nên không được phép đăng ký môn CSDL')
	ROLLBACK TRANSACTION;
	END
END;

--e.Trong một học kỳ của một năm học, sinh viên không được phép đăng ký quá 20 tín chỉ.
CREATE TRIGGER trg_dangkytinchi
ON DANG_KY
AFTER INSERT, UPDATE
AS 
BEGIN
	IF EXISTS
(	
		SELECT *
		FROM INSERTED i
		JOIN MON_HOC mh ON i.mamh=mh.mamh
		GROUP BY i.masv,i.hocky,I.namhoc
		HAVING 
		(
			--Tổng tín chỉ đã đăng ký trước đó
			(SELECT SUM(mh.sotinchi)
			FROM DANG_KY dk
			JOIN MON_HOC mh ON mh.mamh=dk.mamh
			WHERE dk.masv=i.masv
			AND dk.hocky=i.hocky
			AND dk.namhoc=i.namhoc
			)
			+
			(SELECT SUM(mh.sotinchi)
			FROM INSERTED icong
			JOIN MON_HOC mh ON icong.mamh=mh.mamh
			WHERE icong.hocky=i.hocky
			AND icong.masv=i.masv
			AND icong.namhoc=i.namhoc
			)
		)>20
	)
	BEGIN 
	PRINT (N'SV không được phép đăng ký quá 20 tín chỉ trong 1 học kỳ của 1 năm họ')
	ROLLBACK TRANSACTION;
	END
END;
/*f.Chỉ được xóa sinh viên khi sinh viên đó chưa có kết quả môn học nào, ngược lại thông báo lỗi và
không cho xóa*/
CREATE TRIGGER trg_KiemtraXoaSV
ON SINH_VIEN
INSTEAD OF DELETE, UPDATE
AS 
BEGIN
--Kiểm tra xem sinh viên nào trong ds xóa đã có kết quả môn học chưa
IF EXISTS(
		SELECT*
		FROM deleted d
		JOIN KET_QUA kq ON d.masv=kq.masv
		)
		BEGIN
		PRINT (N'SV đã có kết quả môn học, không được phép xóa')
		RETURN;
		END

		DELETE FROM SINH_VIEN
		WHERE masv IN (SELECT masv FROM deleted)
END;
/*g.Thêm cột thuộc tính tổng số lượng sinh viên cho bảng KHOA (tongsosinhvien) và cập nhật cột
này bằng tổng số lượng sinh viên tương ứng đang thuộc về mỗi khoa. Cài đặt RBTV kiểm tra: nếu
thêm một sinh viên thì tổng số lượng sinh viên của khoa mà sinh viên đó thuộc về sẽ tăng lên 1, nếu
xóa một sinh viên thì số lượng sinh viên của khoa tương ứng sẽ giảm đi 1. Tương tự nếu sửa thông
tin mã khoa của một sinh viên thì tổng số lượng sinh viên của khoa mới tăng lên 1 và số lượng sinh
viên của khoa cũ sẽ giảm đi 1.*/