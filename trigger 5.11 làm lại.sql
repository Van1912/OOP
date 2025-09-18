--5.11
/*a.Chỉ những giảng viên có học vị thạc sĩ hay tiến sĩ mới được phân công phụ trách dạy lý thuyết cho
một môn họ.*/
create trigger tr_phanconglt
ON GIANG_DAY
AFTER INSERT, UPDATE
AS
BEGIN
	declare @magv char(4), @phutrach char(2)

	select @magv=magv, @phutrach=phutrach from inserted
	if (@phutrach='LT') and not exists (select * from GIANG_VIEN	
										where @magv=magv
										and hocvi='TS' or hocvi='TH')
	begin
	print(N'Chỉ những giảng viên có học vị thạc sĩ hay tiến sĩ mới dạy lý thuyết cho 1 môn học')
	rollback tran
	end
END

--Cách 2 (Dùng NOT EXISTS)
create trigger tr_thacsihaytiensi
on GIANG_DAY 
after insert, update
as
begin
	if exists(select *
			  from inserted i
			  join GIANG_VIEN gv on gv.magv=i.magv
			  where i.phutrach='LT'
			  and gv.hocvi not in ('TH','TS'))
	begin
	print(N'Chỉ những giảng viên có học vị thạc sĩ hay tiến sĩ mới dạy lý thuyết cho 1 môn học')
	rollback tran
	end
end

/*b. Giám thị gác thi cho một môn học trong một học kỳ của một năm học không được là giảng viên đã
giảng dạy môn học đó trong học kỳ và năm học tương ứng.*/
create trigger tr_giamthigacthi
on THI
after insert, update
as 
begin
	if exists (select *
			   from inserted i
			   join GIANG_DAY gd on gd.magv=i.giamthi
			   and gd.mamh=i.mamh
			   and gd.namhoc=i.namhoc
			   and gd.hocky=i.hocky)   
	begin
	print(N'giám thị gác thi không được là giảng viên dạy môn học đó')
	rollback tran
	end
end

--c.Sinh viên chỉ được đăng ký môn học khi môn học đó đã được phân công giảng viên.
create trigger tr_SVdangkymon
on DANG_KY 
after insert, update
as 
begin
	if exists(select *
			  from inserted i
			  join GIANG_DAY gd on gd.mamh=i.mamh
			  and i.hocky=gd.hocky
			  and i.namhoc=gd.namhoc
			  where gd.magv is null)
	begin
	print(N'SV chỉ được đăng ký môn khi môn đã được phân công giảng viên')
	rollback tran
	end
end

/*d.Chỉ cho phép những sinh viên đã đạt môn Cấu trúc dữ liệu (tổng điểm thi lý thuyết và thực hành >=
10) mới được đăng ký môn học CSDL.*/
create trigger tr_dkmonCSDL
on DANG_KY
after insert, update
as
begin
	if exists (select *
			   from inserted i
			   where i.mamh='CSDL'
    and not exists (select *
	                from KET_QUA kq
					where kq.masv=i.masv
					and kq.mamh='CTDL'
					and (kq.diemLT + kq.diemTH) >=10))
	begin
	print(N'Những SV đạt môn CTDL (tổng lt và th >=10) mới được đk môn CSDL')
	rollback tran
	end
end

--d.Trong một học kỳ của một năm học, sinh viên không được phép đăng ký quá 20 tín chỉ.
create trigger tr_dktinchi
on DANG_KY
after insert, update
as
begin
	if exists (select *
			   from inserted i
			   join MON_HOC mh on mh.mamh=i.mamh
			   group by i.masv, i.hocky,i.namhoc
			   having
			   (select sum(mh.sotinchi) 
			   from DANG_KY dk
			   join MON_HOC mh on mh.mamh=dk.mamh
			   where dk.masv=max(i.masv)
			   and dk.hocky=max(i.hocky)
			   and dk.namhoc=max(i.namhoc)
			   ) >20
			   )
	begin 
	print(N'SV ko đc phép đăng ký quá 20 tín chỉ trong 1 học kỳ của 1 năm học')
	rollback tran
	end
end

--CÁCH KHÁC
CREATE TRIGGER tr_20tinchi
ON DANG_KY 
AFTER INSERT, UPDATE 
AS
BEGIN 
         IF EXISTS (
        SELECT 1
        FROM (
            SELECT i.masv, i.hocky, i.namhoc, SUM(mh.sotinchi) AS tong_tinchi
            FROM inserted i
            JOIN MON_HOC mh ON i.mamh = mh.mamh
            JOIN DANG_KY dk ON i.masv = dk.masv 
                            AND i.hocky = dk.hocky 
                            AND i.namhoc = dk.namhoc
            JOIN MON_HOC mh2 ON dk.mamh = mh2.mamh
            GROUP BY i.masv, i.hocky, i.namhoc
            HAVING SUM(mh.sotinchi) + SUM(mh2.sotinchi) > 20
        ) AS check_limit
    )
    BEGIN
        RAISERROR(N'Sinh viên không được đăng ký quá 20 tín chỉ trong một học kỳ.', 16, 1)
        ROLLBACK TRANSACTION
    END
END 

/*f.Chỉ được xóa sinh viên khi sinh viên đó chưa có kết quả môn học nào, ngược lại thông báo lỗi và
không cho xóa*/
create trigger tr_XoaSV
on SINH_VIEN
instead of delete,update
as
begin
	if exists(select *
			  from deleted d
			  join KET_QUA kq on kq.masv=d.masv)
	begin
	print(N'SV đã có kq môn học thì không được phép xóa')
	rollback tran
	end
	delete from SINH_VIEN
	where masv in (select masv from deleted)
end
