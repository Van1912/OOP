--5.13
/*a.Trước khi xóa một công trình thì kiểm tra công trình đó đã có nhân viên tham gia chưa, nếu có thì
sẽ xóa hết dữ liệu liên quan đến công trình đó.*/
create trigger tr_deletecongtrinh
on CONG_TRINH
after delete,update
as 
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

CREATE TRIGGER tr_deletecongtrinh
ON CONG_TRINH
AFTER DELETE
AS
BEGIN
    -- Xóa dữ liệu liên quan trong PHAN_CONG nếu có
    DELETE FROM PHAN_CONG
    WHERE MaCT IN (
        SELECT MaCT
        FROM DELETED
    )
END

/*b. Kiểm tra việc sửa thông tin của nhân viên, nếu sửa mã nhân viên thì báo lỗi không cho phép sửa mã
nhân viên. Nếu sửa mức lương nhân viên thì mức lương mới phải lớn hơn mức lương cũ.*/
CREATE TRIGGER tr_suathongtin
on NHAN_VIEN
AFTER UPDATE
AS
declare @manvmoi char(4), @manvcu char(4)
declare @mucluongcu real, @mucluongmoi real
select @manvcu=manv from deleted
select @manvmoi=manv from inserted
if (@manvcu<>@manvmoi)
	begin
	print N'Không cho phép sửa mã nhân viên'
	rollback tran
	end
else 
begin
select @mucluongcu=mucluong from deleted
select @mucluongmoi=mucluong from inserted
if (@mucluongmoi<=@mucluongcu)
begin 
print N'Không cho phép sửa mức lương'
rollback tran
end
end

UPDATE NHAN_VIEN SET manv = 'N99' WHERE manv = 'N01';
-- Kết quả: Báo lỗi "Không cho phép sửa mã nhân viên"

UPDATE NHAN_VIEN SET mucluong = 1000000 WHERE manv = 'N02';
-- Kết quả: Báo lỗi "Không cho phép sửa mức lương nhỏ hơn hoặc bằng mức cũ"

