--Đối với mỗi công trình, ngày bắt đầu luôn luôn nằm trước (nhỏ hơn) ngày kết thúc.
CREATE TRIGGER tr_date
ON CONG_TRINH
AFTER INSERT,UPDATE
AS
DECLARE @ngaybd date, @ngaykt date;
SELECT @ngaybd=ngaybd, @ngaykt=ngaykt
	FROM inserted
IF @ngaybd>@ngaykt
BEGIN
	PRINT (N'Ngày tháng không hợp lệ')
	ROLLBACK TRAN
END

--Mức lương tối thiểu của nhân viên là 650 000
CREATE TRIGGER tr_luong 
ON NHAN_VIEN
AFTER INSERT,UPDATE
AS
DECLARE @mucluong REAL;
SELECT @mucluong=mucluong
	FROM inserted
IF @mucluong <=650000
	BEGIN
		PRINT (N'Mức lương không hợp lệ')
		ROLLBACK TRAN
	END

--Công trình đã phân công rồi, không được xóa hay thay đổi
CREATE TRIGGER tr_xoacongtrinh
ON CONG_TRINH
AFTER DELETE,UPDATE
AS
DECLARE @mact char(4);
SELECT @mact=mact FROM deleted
IF EXISTS (SELECT *
		   FROM phan_cong
		   WHERE mact=@mact)
	BEGIN 
		PRINT (N'Công trình đã phân công rồi, không được xóa hay thay đổi')
		ROLLBACK TRAN
	END

--Mỗi công trình không được phân công quá bốn người làm việc
CREATE TRIGGER tr_phancong 
ON phan_cong
AFTER INSERT, UPDATE
AS
	DECLARE @songuoi int;
	DECLARE @mact char(4);

	SELECT @mact=mact
	FROM inserted;

	SELECT @songuoi=COUNT(*)
	FROM phan_cong
	WHERE mact=@mact;

	PRINT (@songuoi);
	IF @songuoi > 4 
		BEGIN 
			PRINT (N'Phân công quá số lượng cho phép')
			ROLLBACK TRAN
		END

--Trưởng phòng phải làm việc tại chi nhánh mình đang phụ trách
CREATE TRIGGER tr_nvphutrach 
ON CHI_NHANH
AFTER INSERT,UPDATE
AS
DECLARE @manvptr CHAR(3), @macn char(3)
SELECT @manvptr=manvptr,@macn=macn FROM inserted
IF EXISTS (SELECT * 
		   FROM NHAN_VIEN nv 
		   WHERE nv.manv=@manvptr AND nv.macn <> @macn
		   AND nv.macn IS NOT NULL)
BEGIN
PRINT (N'Thay đổi không hợp lệ')
ROLLBACK TRAN
END

/**/
CREATE TRIGGER tr_chinhanh 
ON NHAN_VIEN
AFTER UPDATE
AS
DECLARE @macn char(3), @manv char(3)
SELECT @macn=macn,@manv=manv
FROM inserted
IF EXISTS (SELECT *
           FROM CHI_NHANH cn 
		   WHERE cn.macn <>@macn
		   AND cn.manvptr=@manv)
BEGIN
PRINT (N'Thay đổi không hợp lệ')
ROLLBACK TRAN
END


--Viết trigger không cho xóa giá trị của khóa chính trong bảng
CREATE TRIGGER tr_xoakhoachinh_NV
ON NHAN_VIEN
AFTER UPDATE
AS
	DECLARE @manv char(3)
	SELECT @manv=manv 
	FROM inserted
	IF @manv=''
	BEGIN 
		PRINT (N'Không được xóa khóa chính')
		ROLLBACK TRAN
	END