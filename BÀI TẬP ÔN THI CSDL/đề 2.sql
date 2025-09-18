--Tạo khóa chính cho bảng Flight_Schedule (0.5đ) 
--/gợi ý: sv cân nhắc xem có cần thay đổi thuộc tính của bảng trước khi tạo khóa chính hay không
-- Đảm bảo các cột dùng trong khóa chính là NOT NULL
ALTER TABLE Flight_Schedule
ALTER COLUMN Pilot_ID INT NOT NULL;

ALTER TABLE Flight_Schedule
ALTER COLUMN Plane_ID INT NOT NULL;

-- Tạo khóa chính
ALTER TABLE Flight_Schedule
ADD CONSTRAINT PK_FlightSchedule PRIMARY KEY (Pilot_ID, Plane_ID);

--Thêm thuộc tính Sex vào bảng Pilots, thuộc tính này có kiểu dữ liệu Char(1) để lưu thông tin giới tính của phi công 
alter table Pilots
add Sex Char(1)

--Cập nhật giới tính cho phi công tên Jane và Joane là F. 
update Pilots
set Sex='F'
where Pilot_name in ('Jane','Joane')
--where Pilot_name=Jane and Pilot_name=Joane

--c. Cho biết tên những phi công  có lịch bay vào buổi chiều trong tháng 12 năm 2024 
select Pilot_name
from Pilots p
join Flight_Schedule fs on fs.Pilot_ID=p.Pilot_ID
where MONTH(fs.Date_flight)=12
and YEAR(fs.Date_flight)=2024
and fs.Date_flight >='12:00:00'
and fs.Date_flight <'18:00:00'
--where time_flight between 12:00:00 and 18:00:00 
--and month(time_flight)=12 and year(time_flight)=2024


--d.Cho biết số lượng lịch bay của Jane trong tháng 12 năm 2024 
select count(fs.Date_flight) as Soluonglichbay
from Flight_Schedule fs
join Pilots pi on pi.Pilot_ID=fs.Pilot_ID
where pi.Pilot_name='Jane'
and MONTH(fs.Date_flight)=12
and YEAR (fs.Date_flight)=2024


/*Viết trigger để đảm bảo ràng buộc toàn vẹn sau:
Chỉ có thể lập lịch bay cho phi công theo đúng loại máy bay mà họ có thể lái
Nếu vi phạm điều này thì hệ thống sẽ hiện ra câu thông báo
‘Phi công không có khả năng lái loại máy bay này’*/
create trigger tr_laplichbay
on Flight_Schedule
after insert, update
as 
begin 
if exists (select *
		   from inserted i
		   join Pilots pi on pi.Pilot_ID=i.Pilot_ID
		   join Planes pl on pl.Plane_ID=i.Plane_ID
		   where pl.Plane_type<>pi.Pilot_ID)
begin
print(N'Phi công không có khả năng lái loại máy bay này')
end
end

INSERT INTO Flight_Schedule VALUES (‘P03’, ‘PL03’,’P01’,’2025-01-12’,’8:00:00’) 
alter table Flight_Schedule
drop column Flight_Status

create trigger tr_lichbay
on Pilots pi
after insert, update
as 
begin
if not exists (select *
			   from inserted i
			   join Pilots pi on pi.Pilot_ID
			   

		begin
		print(N'phi công có thể lái loại máy bay')
		end
end