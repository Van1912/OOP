-- Tạo Database
CREATE DATABASE QL_SIEUTHI_12345678;
GO
USE QL_SIEUTHI_12345678;
GO

-- QUAYHANG
CREATE TABLE QUAYHANG (
    SOQUAY CHAR(5) PRIMARY KEY,
    TENQUAY NVARCHAR(50),
    VITRI NVARCHAR(100)
);

-- NCC
CREATE TABLE NCC (
    MANCC CHAR(5) PRIMARY KEY,
    TENNCC NVARCHAR(100),
    DIACHI NVARCHAR(100)
);

-- NSX
CREATE TABLE NSX (
    MANSX CHAR(5) PRIMARY KEY,
    TENNSX NVARCHAR(100),
    QUOCGIA NVARCHAR(50)
);

-- MATHANG
CREATE TABLE MATHANG (
    MAHANG CHAR(5) PRIMARY KEY,
    TENHANG NVARCHAR(100),
    DVT NVARCHAR(20),
    SL INT,
    DONGIA INT,
    MANSX CHAR(5),
    SOQUAY CHAR(5),
    FOREIGN KEY (MANSX) REFERENCES NSX(MANSX),
    FOREIGN KEY (SOQUAY) REFERENCES QUAYHANG(SOQUAY)
);

-- KHACHHANG
CREATE TABLE KHACHHANG (
    MAKH CHAR(5) PRIMARY KEY,
    TEN NVARCHAR(100),
    DIACHI NVARCHAR(100)
);

-- PHIEUNHAPHANG
CREATE TABLE PHIEUNHAPHANG (
    MAPHIEU CHAR(5) PRIMARY KEY,
    NGAYNHAP DATE,
    MANCC CHAR(5),
    FOREIGN KEY (MANCC) REFERENCES NCC(MANCC)
);

-- CTPN
CREATE TABLE CTPN (
    MAPHIEU CHAR(5),
    MAHANG CHAR(5),
    SL INT,
    DONGIANHAP INT,
    PRIMARY KEY (MAPHIEU, MAHANG),
    FOREIGN KEY (MAPHIEU) REFERENCES PHIEUNHAPHANG(MAPHIEU),
    FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG)
);

-- HOADON
CREATE TABLE HOADON (
    MAHD CHAR(5) PRIMARY KEY,
    MAKH CHAR(5),
    NGAYMUA DATE,
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH)
);

-- CTHD
CREATE TABLE CTHD (
    MAHD CHAR(5),
    MAHANG CHAR(5),
    SL INT,
    PRIMARY KEY (MAHD, MAHANG),
    FOREIGN KEY (MAHD) REFERENCES HOADON(MAHD),
    FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG)
);

-- DỮ LIỆU MẪU
INSERT INTO QUAYHANG VALUES 
('Q01', N'Gia Dụng', N'Tầng 1'),
('Q02', N'Thực Phẩm', N'Tầng 2');

INSERT INTO NCC VALUES 
('N01', N'Công ty A', N'HCM'),
('N02', N'Công ty B', N'Hà Nội');

INSERT INTO NSX VALUES 
('S01', N'Masan', N'Việt Nam'),
('S02', N'Unilever', N'Anh');

INSERT INTO MATHANG VALUES
('MH01', N'Mì Hảo Hảo', N'Gói', 100, 3000, 'S01', 'Q02'),
('MH02', N'Dầu Clear', N'Chai', 50, 55000, 'S02', 'Q01'),
('MH03', N'Nước mắm', N'Chai', 30, 18000, 'S01', 'Q02'),
('MH04', N'Sữa TH', N'Lốc', 20, 26000, 'S02', 'Q02');

INSERT INTO KHACHHANG VALUES 
('KH01', N'Trần A', N'Quận 1'),
('KH02', N'Lê B', N'Quận 3');

INSERT INTO PHIEUNHAPHANG VALUES 
('PN01', '2024-05-20', 'N01'),
('PN02', '2024-05-21', 'N02');

INSERT INTO CTPN VALUES 
('PN01', 'MH01', 50, 2800),
('PN01', 'MH02', 20, 50000),
('PN02', 'MH04', 30, 25000);

INSERT INTO HOADON VALUES 
('HD01', 'KH01', '2024-05-25'),
('HD02', 'KH02', '2024-05-26');

INSERT INTO CTHD VALUES 
('HD01', 'MH01', 10),
('HD01', 'MH03', 2),
('HD02', 'MH01', 25),
('HD02', 'MH04', 3);


--Cập nhật dữ liệu
/*Tăng đơn giá (DONGIA) cho các mặt hàng có đơn vị tính (DVT) là “Lốc” thêm
5.000 đồng.*/
update MATHANG
set DONGIA=DONGIA+5000
where DVT=N'Lốc' and DONGIA +5000<=30000

--Xóa những CTDH mua mặt hàng hảo hảo và sl > 20
delete from CTHD
where MAHANG =(select m.MAHANG	from MATHANG m
where m.TENHANG=N'Mì Hảo Hảo') and SL>20

SELECT * FROM CTHD WHERE MAHANG IN (SELECT M.MAHANG
FROM MATHANG M  WHERE M.TENHANG =N'Mì tôm Hảo Hảo')

--Cho biết mã mặt hàng (MAHANG), tên mặt hàng (TENHANG) được nhập về trong tháng 1/2022
SELECT m.MAHANG, m.TENHANG 
FROM MATHANG m
JOIN CTPN C ON C.MAHANG = M.MAHANG
JOIN PHIEUNHAPHANG P ON P.MAPHIEU = C.MAPHIEU
WHERE MONTH(p.NGAYNHAP)=1 and YEAR(P.NGAYNHAP)=2022

--cho biết thông tin của quầy hàng (số quầy, tên quầy, vị trí)
--có tổng giá trị mặt hàng cao nhất và tổng giá trị của quầy hàng này
select top 1 q.SOQUAY,q.TENQUAY, q.VITRI, sum(m.SL * m.DONGIA) as [Tổng giá trị mặt hàng cao nhất]
FROM QUAYHANG q
join MATHANG m on m.SOQUAY=q.SOQUAY
group by q.SOQUAY,q.TENQUAY,q.VITRI
order by [Tổng giá trị mặt hàng cao nhất] desc

--cho biết mã phiếu nhập đã nhập tất cả mặt hàng có mã hàng bắt đầu là CC
select p.MAPHIEU
from PHIEUNHAPHANG p
join CTPN c on c.MAPHIEU=p.MAPHIEU
join MATHANG m on m.MAHANG=c.MAHANG
where m.MAHANG like 'CC%'

--số lượng được mua của 1 mặt hàng phải nhỏ hơn hoặc bằng số lượng đang có trên quầy của mặt hàng đó
--nếu sl mua lớn hơn sl tồn thì xuất ra tb
create trigger tr_soluotmua
on CTHD
after insert,update
as
begin
	declare @mahang char(5), @soluongmua int, @soluongcon int
	select @mahang=MAHANG,@soluongmua=SL
	from inserted
	select @soluongcon=SL from MATHANG where @mahang=MAHANG
	if @soluongmua > @soluongcon
begin
print N'Lỗi do sl tồn không đủ'
rollback tran
end 
else
begin 
insert into CTHD(MAHD,MAHANG,SL)
select MAHD,MAHANG, SL from inserted
print N'Thêm CTHD thành công'
end
end

insert into CTHD values ('HD014','XX01',160)