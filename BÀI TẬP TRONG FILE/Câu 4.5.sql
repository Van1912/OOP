--4.5
/*a.Danh sách họ tên nhân viên và tên chi nhánh của những nhân viên có mức lương từ 4 000 000 đến 5
000 000*/
SELECT NV.honv + ' ' + NV.tennv AS HoVaTenNV,
		CN.tencn
FROM NHAN_VIEN NV
JOIN CHI_NHANH CN ON NV.macn = CN.macn
WHERE NV.mucluong BETWEEN 4000000 AND 5000000

/*b.Danh sách tất cả những nhân viên nữ trên 40 tuổi*/
SELECT manv , honv + ' ' + tennv AS HoVaTenNV,  DATEDIFF(YEAR, ngaysinh, GETDATE()) AS Tuoi
FROM NHAN_VIEN
WHERE phai = N'Nữ' AND DATEDIFF(YEAR, ngaysinh, GETDATE()) > 40 

/*c.Danh sách tên những công trình đang phụ trách thi công của mỗi chi nhánh*/
SELECT CN.macn, CN.tencn ,CT.tenct
FROM  CONG_TRINH CT --,CHI_NHANH CN
JOIN CHI_NHANH CN  ON CN.macn = CT.macn
--WHERE CN.macn = CT.macn

/*d.Danh sách mã số, họ tên và ngày nhậm chức của người phụ trách của từng chi nhánh*/
SELECT NV.manv, NV.honv + ' ' + NV.tennv AS HoVaTenNV, CN.ngaynhamchuc, CN.tencn AS TenCNPT		
FROM CHI_NHANH CN, NHAN_VIEN NV
WHERE CN.manvptr = NV.manv

/*e.Danh sách mã số, họ tên nhân viên, mã công trình và tên công trình mà trong đó nhân viên tham gia
công trình với thời gian làm việc hơn 25 giờ/tuần.*/
SELECT  NV.manv, NV.honv + ' ' + NV.tennv AS HoVaTenNV, PC.mact, CT.tenct,
		PC.sogiotuan AS SoGioLam
FROM phan_cong PC
JOIN CONG_TRINH CT ON CT.mact = PC.mact
JOIN NHAN_VIEN NV ON NV.manv = PC.manv
WHERE PC.sogiotuan > 25

/*f.Danh sách mã số và tên của những công trình do các chi nhánh khác nhau thi công nhưng lại ở
cùng thành phố. Mỗi cặp chỉ liệt kê 1 lần, ví dụ đã liệt kê (i, j) thì không liệt kê lại (j, i)*/
SELECT ct1.mact AS Mact1, ct1.tenct AS Tenct1,
       ct2.mact AS Mact2, ct2.tenct AS Tenct2,
	   ct1.matp AS Matp1, ct2.matp AS Matp2
FROM CONG_TRINH ct1
	JOIN CONG_TRINH ct2 
		ON ct1.matp=ct2.matp
		AND ct1.macn <> ct2.macn
		AND ct1.macn < ct2.macn
--Cách khác
SELECT CT1.mact AS MaCT1, CT1.tenct AS TenCT1,
		CT2.mact AS MaCT2, CT2.tenct AS TenCT2,
		CT1.matp AS MaTP1, CT2.matp AS MaTP2
FROM CONG_TRINH CT1 
JOIN CONG_TRINH CT2 ON CT1.mact < CT2.mact
JOIN CHI_NHANH CN1 ON CT1.macn = CN1.macn
JOIN CHI_NHANH CN2 ON CT2.macn = CN2.macn
WHERE CT1.macn <> CT2.macn AND CT1.matp = CT2.matp

/*g.Danh sách những mã số và tên công trình có địa điểm (thành phố) trùng với thành phố của chi
nhánh phụ trách thi công.*/
SELECT ct.mact, ct.tenct, ct.matp AS MatpCongtrinh, vp.matp AS MatpChinhanh
FROM CONG_TRINH ct
JOIN CHI_NHANH cn ON ct.macn=cn.macn
JOIN VPHONG_CN vp ON vp.macn=cn.macn
WHERE ct.matp=vp.matp;

--Cách khác
SELECT DISTINCT CT.mact, CT.tenct, 
			CT.matp AS TPCongTrinh, 
			VP.matp AS TPChiNhanh
			
FROM CONG_TRINH CT, CHI_NHANH CN
JOIN VPHONG_CN VP ON CN.macn = VP.macn
WHERE CT.matp = VP.matp 

/*h.Danh sách họ tên nhân viên và họ tên người phụ trách chi nhánh của mỗi nhân viên.*/
SELECT nv.honv+''+nv.tennv AS HotenNhanvien,cn.tencn,pt.honv+''+pt.tennv AS HotenNhanvienphutrach
FROM NHAN_VIEN nv
JOIN CHI_NHANH cn ON cn.macn=nv.macn
JOIN NHAN_VIEN pt ON pt.manv=cn.manvptr

/*i.Danh sách họ tên nhân viên và tên các công trình mà nhân viên có tham gia, nếu có*/
SELECT nv.honv+''+nv.tennv AS HotenNV, ct.tenct
FROM NHAN_VIEN nv
JOIN phan_cong pc ON pc.manv=nv.manv
JOIN CONG_TRINH ct ON ct.mact=pc.mact

--Dùng left join cũng ra
SELECT honv + ' ' + tennv AS 'Họ và Tên', CT.tenct 'Tên Công Trình'
FROM NHAN_VIEN NV
LEFT JOIN phan_cong PC ON PC.manv = NV.manv
LEFT JOIN CONG_TRINH CT ON CT.mact = PC.mact

/*j.Danh sách tên công trình và tổng số giờ làm việc một tuần của tất cả các nhân viên tham gia từng
công trình.*/
SELECT ct.tenct, SUM(pc.sogiotuan) AS Tonggiolam
FROM CONG_TRINH ct
JOIN phan_cong pc ON pc.mact=ct.mact
GROUP BY ct.tenct

/*k.Danh sách tên chi nhánh và lương trung bình của những nhân viên làm việc của mỗi chi nhánh*/
SELECT cn.tencn, AVG(nv.mucluong) AS MucluongTB
FROM CHI_NHANH cn
JOIN NHAN_VIEN nv ON nv.macn=cn.macn
GROUP BY cn.tencn

/*l.Mức lương trung bình của tất cả những nhân viên nữ*/
SELECT AVG(mucluong) AS MucluongTBNhanvienNu
FROM NHAN_VIEN
WHERE phai=N'Nữ' 

/*m. Danh sách tên chi nhánh và số lượng nhân viên tương ứng của chi nhánh mà có mức lương trung
bình trên 4 500 000.*/
SELECT tencn, COUNT(NV.manv) AS SoLuongNhanVien
FROM CHI_NHANH CN
JOIN NHAN_VIEN NV ON CN.macn=NV.macn
GROUP BY CN.tencn
HAVING AVG(NV.mucluong) >4500000;

/*n.Danh sách mã số công trình mà trong đó tên nhân viên tham gia công trình hay tên người trưởng
chi nhánh phụ trách công trình đó có 4 ký tự trở lên*/
SELECT DISTINCT ct.mact
FROM CONG_TRINH ct
JOIN phan_cong pc ON pc.mact=ct.mact
JOIN CHI_NHANH cn ON cn.macn=ct.macn
JOIN NHAN_VIEN nv ON nv.manv=pc.manv
JOIN NHAN_VIEN nvpt ON nvpt.manv=cn.manvptr
WHERE LEN(nv.tennv) >=4 OR LEN(nvpt.tennv) >=4

/*o.Danh sách mã số và họ tên nhân viên có mức lương trên mức lương trung bình của chi nhánh có
tên ‘Chi nhánh 2’*/
SELECT manv,honv+''+tennv AS HotenNV
FROM NHAN_VIEN 
WHERE mucluong > (SELECT AVG(nv.mucluong) AS MucluongTB
					  FROM NHAN_VIEN nv
					  JOIN CHI_NHANH cn ON cn.macn=nv.macn
					  WHERE cn.tencn=N'Chi nhánh 2'
					  )

/*p.Danh sách tên chi nhánh và họ tên trưởng chi nhánh đứng đầu về số lượng nhân viên (yêu cầu
tương tự cho đứng cuối)*/ --XEM LẠI
SELECT TOP 1 cn.tencn, nv.honv+''+nv.tennv AS HotenNVtruongCN
FROM CHI_NHANH cn
JOIN NHAN_VIEN nv ON nv.manv=cn.manvptr
JOIN NHAN_VIEN nv2 ON nv.macn=cn.macn
GROUP BY cn.tencn,nv.honv,nv.tennv
ORDER BY COUNT (nv2.manv) DESC

--ĐỨNG CUỐI
SELECT TOP 1 cn.tencn, nv.honv+''+nv.tennv AS HotenNVtruongCN
FROM CHI_NHANH cn
JOIN NHAN_VIEN nv ON nv.manv=cn.manvptr
JOIN NHAN_VIEN nv2 ON nv.macn=cn.macn
GROUP BY cn.tencn,nv.honv,nv.tennv
ORDER BY COUNT (nv2.manv) ASC

/*q.Danh sách mã số, họ tên nhân viên trùng tên với nhau. Mỗi cặp chỉ liệt kê 1 lần, ví dụ đã liệt kê (i,
j) thì không liệt kê lại (j, i).*/
SELECT nv1.manv AS manv1, nv1.honv AS Honv1,nv1.tennv AS Tennv1
FROM NHAN_VIEN nv1
JOIN NHAN_VIEN nv2 ON nv1.honv=nv2.honv
AND nv1.tennv=nv2.tennv
WHERE nv1.manv<nv2.manv

/*r.Danh sách họ tên nhân viên chỉ làm việc cho các công trình mà chi nhánh phụ trách công trình
không phải là chi nhánh mà mình trực thuộc.*/  --XEM LẠI
SELECT DISTINCT NV.honv,NV.tennv
FROM NHAN_VIEN NV
JOIN phan_cong pc ON NV.manv=pc.manv
JOIN CONG_TRINH CT ON pc.mact=ct.mact
JOIN CHI_NHANH CN1 ON NV.macn=CN1.macn --Chi nhánh mà NV phụ trách
JOIN CHI_NHANH CN2 ON CT.macn=CN2.macn --Chi nhánh phụ trách công trình
WHERE CN1.macn <> CN2.macn; 

--CÁCH KHÁC
SELECT NV.manv,
	   NV.honv + ' ' + NV.tennv AS 'Họ và Tên',
	   CT.tenct AS 'Tên Chi Nhánh',
	   NV.macn
FROM phan_cong PC
JOIN NHAN_VIEN NV ON PC.manv = NV.manv
JOIN CONG_TRINH CT ON PC.mact = CT.mact
WHERE NV.macn <> CT.macn

/*s.Danh sách những nhân viên làm việc trong mọi công trình của công ty.*/
SELECT nv.honv+''+nv.tennv AS HotenNV
FROM NHAN_VIEN nv
JOIN phan_cong pc ON pc.manv=nv.manv
JOIN CONG_TRINH ct ON pc.mact=ct.mact


/*t.Danh sách những nhân viên được phân công tất cả công trình do chi nhánh ‘Chi nhánh 2’ phụ
trách.*/

/*u.Danh sách họ tên của những nhân viên tham gia tất cả các công trình do chi nhánh của nhân viên đó
phụ trách.*/

/*v. Danh sách tên những chi nhánh đứng đầu về số lượng công trình phụ trách thi công (yêu cầu tương
tự cho đứng cuối).*/

/*w.Danh sách mã số và họ tên của những nhân viên đứng đầu về tổng số giờ làm việc/tuần trong các
công trình (yêu cầu tương tự cho đứng cuối).*/
