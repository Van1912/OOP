--Trigger
--5.13
/*a. Trước khi xóa một công trình thì kiểm tra công trình đó đã có nhân viên tham gia chưa, nếu có thì
sẽ xóa hết dữ liệu liên quan đến công trình đó.*/
CREATE TRIGGER xoacongtrinh ON CONG_TRINH
AFTER DELETE /*XÁC ĐỊNH THỜI ĐIỂM TRIGGER CHẠY*/, UPDATE
AS
DECLARE @mact CHAR(4)
SELECT @mact =mact FROM DELETED
IF EXISTS (
			SELECT* 
			FROM phan_cong 
			WHERE mact = @mact
		  )
BEGIN
DELETE FROM CONG_TRINH WHERE mact =@mact
delete from phan_cong where mact=@mact
END

/*b.Kiểm tra việc sửa thông tin của nhân viên, nếu sửa mã nhân viên thì báo lỗi không cho phép sửa mã
nhân viên. Nếu sửa mức lương nhân viên thì mức lương mới phải lớn hơn mức lương cũ.*/
CREATE TRIGGER thongtincuanv ON NHAN_VIEN
AFTER UPDATE
AS
DECLARE @mucluongcu real, @mucluongmoi real
DECLARE @manvcu char(4), @manvmoi char(4)
SELECT @manvcu = manv FROM DELETED
SELECT @manvmoi =manv FROM INSERTED
if (@manvcu <> @manvmoi)
begin
print N'KHÔNG CHO PHÉP SỬA MÃ NHÂN VIÊN'
rollback transaction;
end
ELSE
BEGIN
SELECT @mucluongcu = mucluong FROM deleted;
SELECT @mucluongmoi =mucluong FROM INSERTED;
if (@mucluongmoi <= @mucluongcu)
BEGIN 
PRINT N'KHÔNG CHO PHÉP SỬA MÃ NHÂN VIÊN'
END
END

/*c.Tạo một bảng ảo có tên vw_TRUONG_CN bao gồm mã số và tên chi nhánh, mã số và tên trưởng
chi nhánh. Khi thêm một dòng mới vào trong vw_TRUONG_CN thì thêm tương ứng mã chi nhánh
và tên chi nhánh mới vào bảng CHI_NHANH. Nếu mã số và tên của trưởng chi nhánh chưa có
trong danh sách nhân viên thì thêm vào bảng NHAN_VIEN*/
--Tạo View
CREATE VIEW vw_TRUONG_CN
AS
SELECT
CN.macn, CN.tencn,NV.manv as manvptr, NV.honv+' '+NV.tennv as tennvptr
FROM CHI_NHANH CN
JOIN NHAN_VIEN NV ON CN.manvptr=NV.manv

--Tạo TRIGGER INSTEAD OF INSERT để xử lý thêm mới
CREATE TRIGGER trg_Insert_vw_TRUONG_CN
ON vw_TRUONG_CN
INSTED OF INSERT
AS
BEGIN
SET NOCOUNT ON