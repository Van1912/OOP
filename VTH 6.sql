--Hiển thị danh sách tất cả bệnh nhân, bác sĩ có trong bệnh viện
select *
from BENH_NHAN,BAC_SI

--Hiển thị tất cả lượt khám bệnh
select *
from LAN_KHAM

--Liệt kê các lượt khám bệnh kèm tên bệnh nhân và tên bác sĩ
select bv.Ten AS TenBN, bs.Ten AS TenBS, lk.MaKham
from LAN_KHAM lk
join BENH_NHAN bv on bv.MaBenhNhan=lk.MaBenhNhan
join BAC_SI bs on bs.MaBacSi=lk.MaBacSi

--Liệt kê các lượt khám diễn ra sau ngày 01/04/2025
select bv.Ten AS TenBN, bs.Ten AS TenBS, lk.MaKham
from LAN_KHAM lk
join BENH_NHAN bv on bv.MaBenhNhan=lk.MaBenhNhan
join BAC_SI bs on bs.MaBacSi=lk.MaBacSi
where lk.NgayKham >'2025-05-20'

--Liệt kê tất cả bệnh nhân mà mỗi bác sĩ đã khám
