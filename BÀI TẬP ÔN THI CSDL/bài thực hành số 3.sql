--a.Hiển thị danh sách toàn bộ nhân viên
select *
from NHANVIEN

select *
from PHONGBAN

select *
from LUONG

--b.Hiển thị nhân viên và tên phòng ban tương ứng
select nv.TenNV, p.TenPB
from NHANVIEN nv
join PHONGBAN p on nv.MaPB=p.MaPB

--c.Tìm các nhân viên thuộc phòng ban "Kế Toán"
select nv.TenNV
from NHANVIEN nv
join PHONGBAN p on p.MaPB=nv.MaPB
where TenPB=N'Kế Toán'

--d.Hiển thị lương của nhân viên trong tháng 3 năm 2025
select nv.TenNV,l.TongLuong
from LUONG l
join NHANVIEN nv on nv.MaNV=l.MaNV
where l.Thang=3 and l.Nam=2025

--e.Tính lương cho tất cả nhân viên trong năm 2025.
select nv.TenNV,nv.MaNV, SUM(TongLuong) AS Tongluongnam2025
from LUONG l
JOIN NHANVIEN nv on nv.MaNV=l.MaNV
where l.Nam=2025
group by nv.TenNV,nv.MaNV

--f.Tính tổng lương của một nhân viên trong một năm
select nv.TenNV, SUM(TongLuong) AS Tongluong1nam
from NHANVIEN nv
join LUONG l on l.MaNV=nv.MaNV
where nv.MaNV='NV01'
and l.Nam=2025
group by nv.TenNV

--g.Cập nhật phụ cấp lương cho một nhân viên bất kỳ
update LUONG
set PhuCap=3000000
where MaNV='NVO3' and Thang=3 and Nam=2025

--h.Tìm nhân viên có tổng lương cao nhất trong năm 2025
select top 1
nv.MaNV, nv.TenNV, SUM(L.TongLuong) AS TongLuong_2025
from NHANVIEN nv
join LUONG l on l.MaNV=nv.MaNV
where l.Nam=2025
group by nv.MaNV, nv.TenNV
order by TongLuong_2025 DESC

--i.Đếm số lượng nhân viên trong từng phòng ban
select p.TenPB, Count(nv.TenNV) AS SoluongNV
from PHONGBAN p
join NHANVIEN nv on nv.MaPB=p.MaPB
group by p.TenPB

