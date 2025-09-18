alter table CONG_TRINH
add trangthai VARCHAR(20)
check (trangthai IN ('Opened','Processing','Finished','Canceled'))

create trigger tr_Kiemtratrangthai
on CONG_TRINH
after insert,update
as
declare @trangthai varchar(20), @macn char(4)

select @trangthai=trangthai, @macn=mact from inserted
if exists (select *
           from CONG_TRINH 
		   where mact=@macn and trangthai is not null)
begin
print (N'Công trình này đã có trạng thái')
rollback tran
end
