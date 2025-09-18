--Tạo khóa ngoại từ bảng Flight_Schedule tham chiếu đến bảng Planes
alter table Flight_Schedule
add foreign key (Plane_ID) references Planes (Plane_ID)

/*Tạo khóa chính cho bảng Planes (0.5đ) /gợi ý: sv cân nhắc xem có cần thay đổi thuộc tính của bảng trước khi tạo khóa chính hay không*/
alter table Planes
add primary key (Plane_ID)

--Thêm/Xóa/Sửa dữ liệu
--a.	Cập nhật dữ liệu 
--John không vượt qua bài kiểm tra cuối khóa, nên số giờ bay bị giảm 50%.
update Pilots
set Flight_hours=Flight_hours *0.5
where Pilot_name='John'   

/*Thực thi câu lệnh liệt kê tất cả thông tin của John sau khi cập nhật số giờ bay và dán ảnh chụp kết quả vào ô bên dưới*/
select *
from Pilots

--b.Thêm thuộc tính
--Thêm thuộc tính Year vào bảng Planes để lưu trữ thông tin năm sản xuất cho từng loại máy bay. Thuộc tính này có kiểu Int  
alter table Planes
add Year int

--Thực thi câu lệnh liệt kê tất cả các thuộc tính của bảng Planes sau khi thêm thuộc tính và dán ảnh chụp kết quả vào ô bên dưới 
select *
from Planes

--Câu 2: Truy vấn
--a. Cho biết mã số của những chiếc máy bay mà John không thể lái
select Plane_ID
from Planes
where Plane_type not in (select Plane_type
		                 from Pilots
			             where Pilot_name='John')

--Cách 2: dùng NOT EXISTS
select Plane_ID
from Planes pl
where NOT EXISTS (select *
				  from Pilots pi
				  where Pilot_name='John'
				  and pl.Plane_type=pi.Plane_type)

--b. Cho biết tên phi công không giám sát lịch bay của John
SELECT p.Pilot_name --John đc giám sát bởi Pilot_ID=2 (Trần Thị B)
FROM Pilots p
WHERE p.Pilot_ID NOT IN (
    SELECT fs.Pilot_ID_Supervisor
    FROM Flight_Schedule fs
    JOIN Pilots pj ON fs.Pilot_ID = pj.Pilot_ID
    WHERE pj.Pilot_name = 'John'
)
AND p.Pilot_name <> 'John';

--c. Cho biết tên những phi công không có lịch bay vào buổi sáng trong tháng 12 năm 2024 
select Pilot_name
from Pilots p
where p.Pilot_ID not in (select fs.Pilot_ID
						 from Flight_Schedule fs
						 where MONTH(fs.Date_Flight)=12
						 and YEAR(fs.Date_Flight)=2024
						 and fs.Time_flight <'12:00:00');
--d. Cho biết số loại máy bay mà mỗi phi công có thể lái 
select Pilot_name, Count(distinct Plane_type) AS Soloaimaybay
from Pilots
group by Pilot_name


--Câu 3: Store Procedure/Function/Trigger 
--Trigger
/*Viết trigger để đảm bảo ràng buộc toàn vẹn sau
Dán code tạo trigger vào khung bên dưới:
Mỗi phi công không thể giám sát lịch bay của chính mình
Nếu vi phạm ràng buộc này hệ thống sẽ hiện câu thông báo
‘You can supvervise your filght’*/
create trigger tr_Khonggiamsatlichbaychinhminh
on Flight_Schedule
after insert,update
as 
begin	
	if exists(select*
			  from inserted
			  where Pilot_ID=Pilot_ID_Supervisor)
			  begin
			  print('You can supvervise your filght')
			  rollback tran;
			  end
end


INSERT INTO Flight_Schedule
VALUES ('3', '103', '3', '2025-01-12', '08:00:00');





