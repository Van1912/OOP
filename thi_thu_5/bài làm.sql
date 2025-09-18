--Đề 1
--những khách hàng nào chưa đặt hàng bao giờ mà có email khác ‘ueh.edu.vn’. Thông tin hiển thị mã kh, họ và tên khách hàng, phone, email 
SELECT 
    KH.MaKH, 
    KH.HoKH + ' ' + KH.TenKH AS HoTenKH, 
    KH.Phone, 
    KH.Email
FROM 
    KhachHang KH
WHERE 
    KH.MaKH NOT IN (
        SELECT DISTINCT MaKH FROM DonDatHang WHERE MaKH IS NOT NULL)
    AND KH.Email NOT LIKE '%ueh.edu.vn%'

--Tính tổng thành tiền và tổng tiền giảm giá, tổng thu của từng hóa đơn với tổng thu lớn hơn 200.000 đ. 
SELECT 
    CT.SoDH,
    SUM(CT.SoLuong * CT.GiaTien) AS TongThanhTien,
    SUM(CT.SoLuong * CT.GiaTien * CT.GiamGia) AS TongGiamGia,
    SUM(CT.SoLuong * CT.GiaTien * (1 - CT.GiamGia)) AS TongThu
FROM 
    ChiTietDonHang CT
GROUP BY 
    CT.SoDH
HAVING 
    SUM(CT.SoLuong * CT.GiaTien * (1 - CT.GiamGia)) > 200000;

/*Cho biết những đơn hàng và các mặt hàng tương ứng chưa được xử lý. Thông tin hiển thị gồm 
SoDH, Ngày đặt hàng, Trạng Thái, Tên sách, Thành tiền, Giảm giá*/
select d.SoDH, d.NgayDH, d.TrangThaiDH, s.TenSach,ct.SoLuong * ct.GiaTien AS ThanhTien,
    ct.GiamGia
from DonDatHang d
join ChiTietDonHang ct on d.SoDH=ct.SoDH
join Sach s on s.MaSach=ct.MaSach
where d.TrangThaiDH=0

--Cho biết những tác giả nào viết nhiều hơn 1 cuốn, thông tin hiển thị gồm tên tác giả, số lượng sách tác giả viết 
select t.TenTG, count(stg.MaSach) AS Soluongsach 
from TacGia t
join Sach_TacGia stg on stg.MaTG=t.MaTG
group by t.TenTG
Having count(stg.MaSach) > 1

/*Liệt kê danh sách tác giả đã viết sách hoặc chưa có viết sách, thông tin gồm có MatG, TenTg, TenSach, SoTrang, NgayXB*/
select tg.MaTG,tg.TenTG, TenSach, SoTrang, NgayXB
from TacGia tg
left join Sach_TacGia stg on stg.MaTG=tg.MaTG
left join Sach s on s.MaSach=stg.MaSach

/*Liệt kê danh sách sách mà đã mà có tác giả  hoặc chưa có tác giả, thông tin gồm có MatG, TenTg,Masach, TenSach,SoTrang,NgayXB */
select tg.MaTG,tg.TenTG,s.MaSach,s.TenSach,s.SoTrang,s.NgayXB
from Sach s
left join Sach_TacGia stg on stg.MaSach=s.MaSach
left join TacGia tg on tg.MaTG=stg.MaTG

--Lập bảng dữ liệu tổng số lượng của sách trong mỗi hóa đơn
select ct.SoDH , s.MaSach, s.TenSach,sum(ct.SoLuong) AS tongsoluong
from ChiTietDonHang ct
join Sach s on s.MaSach=ct.MaSach
group by ct.SoDH, s.MaSach,s.TenSach

/*Viết 1 hàm dạng trả về table đặt tên là TongDoanhThuHDGiamGia(@sodh nvarchar(10)) (1.5 đ)
Cho biết tổng doanh thu của tất cả hóa đơn được đưa vào và công thức tính là doanhthu= số lượng * giá tiền - số lượng* giá tiền*giamgia
*/
create function TongDoanhThuHDGiamGia(@sodh nvarchar(10))
returns table
as
return
(select ct.SoDH, sum(ct.SoLuong * ct.GiaTien * (1 - CT.GiamGia)) AS TongDoanhThu
from ChiTietDonHang ct
where ct.SoDH=@sodh
group by ct.SoDH)//9+

--Kiểm tra function
SELECT * 
FROM dbo.TongDoanhThuHDGiamGia('001');

/*2.Viết 1 thủ tục xóa 1 dòng dữ liệu tacgia với dữ liệu đầu vào phù hợp, có kiểm tra sự tồn tại trong bảng khác*/
create procedure sp_XoaTGantoan @MaTG nchar(20)
as
begin
--KT tác giả có tồn tại không
if not exists (select *
			   from TacGia where MaTG=@MaTG)
begin
print N'Tác giả không tồn tại'
return
end
--KT nếu tác giả đang được liên kết với bảng Sach_TacGia
if exists (select *
from Sach_TacGia where MaTG=@MaTG)
BEGIN
print N'Không được xóa.TG đang được lk với bảng khác'
return
end
--Xóa nếu an toàn
delete from TacGia where MaTG=@MaTG
print N'Xóa thành công'
end

EXEC sp_XoaTGantoan @MaTG = N'002';

--ĐỀ 2
--Cập nhật các nhân viên có năm sinh 1978 và năm 1990 có manvql là ‘0000000001’ 
UPDATE NhanVien 
set MaNVQL='0000000001'
WHERE YEAR(NS) IN (1978, 1990);

select nv.MaNV,nv.HotenNV,nv.NS,nv.MaNVQL
from NhanVien nv

--Cho biết thông tin nhân viên gồm: manv, tennv, tuoi, giới tính, họ và tên nhân viên quản lý, dữ liệu dược sắp xếp theo tuổi tăng dần và mã nhân viên giảm dần
select distinct nv.MaNV,nv.HotenNV,YEAR(GETDATE())-YEAR(nv.NS) as Tuoi,nv.GT,nv.HotenNV as HotenNVQL
from NhanVien nv
LEFT JOIN NhanVien nvql on nvql.MaNVQL=nv.MaNVQL

order by YEAR(GETDATE())-YEAR(nv.NS) asc, nv.MaNV desc

/*Cho biết những nhân viên nào chưa thực hiện xử lý đơn hàng bao giờ mà có tuổi không quá 32*/
select nv.MaNV,nv.HotenNV,YEAR(GETDATE())-YEAR(nv.NS) as Tuoi, nv.GT
from NhanVien nv
where nv.MaNV not in(select distinct d.MaNV
from DonDatHang d
where d.MaKH is not null)  
and YEAR(GETDATE())-YEAR(nv.NS) <=32

/*Cho biết những khách hàng nào chưa đặt hàng bao giờ mà có email là ‘ueh.edu.vn’ hoặc tlu.edu.vn. Thông tin hiển thị mã kh, họ và tên khách hàng, phone, email*/
SELECT 
    kh.MaKH,
    kh.HoKH + ' ' + kh.TenKH AS [Họ và Tên KH],
    kh.Phone,
    kh.Email
FROM 
    KhachHang kh
WHERE 
    kh.MaKH NOT IN (
        SELECT DISTINCT MaKH
        FROM DonDatHang
        WHERE MaKH IS NOT NULL
    )
    AND (
        kh.Email LIKE '%ueh.edu.vn%' OR
        kh.Email LIKE '%tlu.edu.vn%'
    );

/*Cập nhật lại đơn hàng có SODH=’001’ có trạng thái đơn hàng thành ‘2’ và ngày thực tế giao là ngày 21-10-2022 09:30:20*/
update DonDatHang
set TrangThaiDH=2,
NgayThucTeGiao='2022-10-21 09:30:20'
where SoDH=001;

select *
from DonDatHang

/*Cho biết những đơn hàng và các mặt hàng tương ứng đã được giao và đang xử lý. Thông tin hiển thị gồm 
SoDH, Ngày đặt hàng, Trạng Thái, Tên sách, Thành tiền, Giảm giá.*/
select d.SoDH,d.NgayDH, d.TrangThaiDH, s.TenSach,ct.SoLuong *ct.GiaTien as Thanhtien,ct.GiamGia
from DonDatHang d 
join ChiTietDonHang ct on ct.SoDH=d.SoDH
join Sach s on s.MaSach=ct.MaSach
where d.TrangThaiDH=1 or d.TrangThaiDH=2

--Tính tổng thành tiền và tổng tiền giảm giá, tổng thu của từng hóa đơn
select ct.SoDH,sum(ct.SoLuong * ct.GiaTien) as Tongthanhtien,
sum(ct.SoLuong*ct.GiaTien * ct.GiamGia) as TongGiamGia,
sum(ct.SoLuong*ct.GiaTien *(1-ct.GiamGia)) as TongThu
from ChiTietDonHang ct
GROUP BY CT.SoDH


--Cho biết những tác giả nào viết nhiều hơn 2 cuốn, thông tin hiển thị gồm tên tác giả, số lượng sách tác giả viết 
select tg.TenTG,count(stg.MaTG) as SoluongSach
from TacGia tg
join Sach_TacGia stg on stg.MaTG=tg.MaTG
group by tg.TenTG having count(stg.MaTG)>2

--ĐỀ 3
--Cho biết thông tin nhân viên gồm: manv, tennv, tuoi, giới tính, họ và tên nhân viên quản lý, dữ liệu dược sắp xếp theo tuổi tăng dần và mã nhân viên giảm dần
/*Cho biết những đơn hàng và các mặt hàng tương ứng đang được xử lý. Thông tin hiển thị gồm 
SoDH, Ngày đặt hàng, Trạng Thái, Tên sách, Thành tiền, Giảm giá.*/
SELECT 
    dh.SoDH,
    dh.NgayDH,
    dh.TrangThaiDH,
    s.TenSach,
    ctdh.SoLuong * ctdh.GiaTien AS Thanhtien,
    ctdh.GiamGia
FROM 
    DonDatHang dh
JOIN 
    ChiTietDonHang ctdh ON dh.SoDH = ctdh.SoDH
JOIN 
    Sach s ON ctdh.MaSach = s.MaSach
WHERE 
    dh.TrangThaiDH = 1;

/*Cho biết danh sách các cuốn sách mà đã được cập nhật nhà xuất bản mà số trang <90 trang, Thông tin hiển thị gồm có masach, tensach, sotrang, ngayxb, tennxb */
select s.MaSach,s.TenSach, s.SoTrang,s.NgayXB,xb.TenXB
from Sach s
join NhaXB xb on xb.MaXB=s.MaXB
where s.SoTrang < 90

/*Cho biết những tác giả viết sách có địa chỉ ‘HCM’, thông tin hiển thị gồm tên tác giả, số lượng sách tác giả viết*/
select tg.TenTG,count(stg.MaSach) as SachTacgiaviet
from TacGia tg
join Sach_TacGia stg on stg.MaTG=tg.MaTG
where tg.DiaChi='HCM'
group by tg.TenTG

insert into TacGia values(N'005',N'Nguyễn Phúc Hào',N'BT',N'0234567798','hao@gmail.com')
--những tác giả nào chưa tham gia viết sách bao giờ.Thông tin hiển thị gồm có matg, tentg, sdt, diachi.
select tg.MaTG, tg.TenTG,tg.SDT,tg.DiaChi
from TacGia tg
where tg.MaTG not in (select stg.MaTG
from Sach_TacGia stg
where stg.MaTG is not null)

--Liệt kê danh sách tác giả đã viết sách hoặc chưa có viết sách, thông tin gồm có MatG, TenTg, TenSach, SoTrang, NgayXB.
select tg.MaTG,tg.TenTG,s.TenSach,s.SoTrang,s.NgayXB
from TacGia tg
left join Sach_TacGia stg on stg.MaTG=tg.MaTG
left join Sach s on s.MaSach=stg.MaSach

--Lập bảng dữ liệu tổng số lượng của sách trong mỗi hóa đơn 
select ct.SoDH,ct.MaSach,s.TenSach,count(ct.SoLuong) as [Số lượng sách]
from ChiTietDonHang ct
join Sach s on s.MaSach=ct.MaSach
group by ct.SoDH, ct.MaSach,s.TenSach,ct.SoLuong

