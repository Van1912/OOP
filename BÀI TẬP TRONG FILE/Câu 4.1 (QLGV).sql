--4.1.
--a.Tổng số cán bộ của khoa ‘Công nghệ thông tin’.
SELECT COUNT(gv.makhoa) AS N'Tổng số cán bộ khoa CNTT'
FROM GIANG_VIEN gv
WHERE gv.makhoa=N'CNTT'

SELECT tongsocb
FROM KHOA
WHERE tenkhoa = N'Công nghệ thông tin';

--b.Số tín chỉ, số tiết lý thuyết và số tiết thực hành của môn có tên là ‘Cơ sở dữ liệu’.
SELECT mh.sotinchi, mh.sotietLT,mh.sotietTH 
FROM MON_HOC mh
WHERE mh.tenmh=N'Cơ sở dữ liệu'

/*c.Danh sách mã số của giảng viên được phân công giảng dạy lý thuyết ở học kỳ 1 hay học kỳ 2 năm
học ‘2014-2015’*/
SELECT gv.magv
FROM GIANG_VIEN gv
JOIN GIANG_DAY gd ON gd.magv=gv.magv
WHERE gd.phutrach=N'LT' AND gd.namhoc='2014-2015'

/*d.Danh sách mã số và họ tên của những sinh viên nữ hay sinh viên thuộc tỉnh có mã là ‘56’*/
SELECT sv.masv, sv.hosv+''+sv.tensv AS HotenSV
FROM SINH_VIEN sv
WHERE sv.Nu='True' OR sv.matinhtp='56'

/*e.Danh sách những sinh viên thuộc khoa có mã số là ‘VL’ và nhận học bổng hơn 100 000.*/
SELECT sv.masv,sv.hosv,sv.tensv,sv.hocbong
FROM SINH_VIEN sv
WHERE makhoa='VL' AND hocbong > 100000


/*f.Danh sách mã số và tên của những môn học do giảng viên có tên ‘Thúy’ phụ trách
giảng dạy lý thuyết.*/
SELECT DISTINCT mh.mamh,mh.tenmh
FROM MON_HOC mh
JOIN GIANG_DAY gd ON gd.mamh=mh.mamh
JOIN GIANG_VIEN gv ON gv.magv=gd.magv 
WHERE gv.hogv=N'Nguyễn Ngọc' 
AND gv.tengv=N'Thúy'
AND gd.phutrach=N'LT'

/*g.Danh sách mã số và họ tên của những sinh viên nam có điểm thi lần 1 môn ‘Cơ sở dữ liệu’ là 8
điểm.*/
SELECT sv.masv, sv.hosv+''+sv.tensv AS HotenSV
FROM SINH_VIEN sv
JOIN KET_QUA kq ON kq.masv=sv.masv 
AND (kq.diemLT =8 OR kq.diemTH=8)
WHERE sv.Nu=N'FALSE'

/*h.Danh sách mã số, họ tên sinh viên và tên những môn học mà những sinh viên có đăng ký học và
có kết quả thi*/
SELECT sv.masv, sv.hosv +''+sv.tensv AS HotenSV
FROM  SINH_VIEN sv
JOIN DANG_KY dk ON sv.masv=dk.masv
JOIN KET_QUA kq ON dk.mamh=kq.mamh AND kq.masv=dk.masv
JOIN MON_HOC mh ON mh.mamh=kq.mamh

/*i.Danh sách tên những môn học được tổ chức cùng ngày thi và cùng giờ thi trong học kỳ 1 năm
‘2014-2015’.*/
SELECT DISTINCT mh.mamh,mh.tenmh 
FROM THI t1
JOIN THI t2 ON t1.ngaythi=t2.ngaythi
AND t1.giothi=t2.giothi
AND t1.mamh <>t2.mamh
JOIN MON_HOC mh ON mh.mamh=t1.mamh
WHERE t1.hocky=1

/*j.Danh sách mã số và tên của những giảng viên vừa phụ trách dạy lý thuyết vừa phụ trách dạy thực
hành cho cùng một môn học.*/
SELECT DISTINCT gv.magv,gv.hogv+''+gv.tengv AS HotenGV
FROM GIANG_VIEN gv
JOIN GIANG_DAY gd1 ON gv.magv=gd1.magv
AND gd1.phutrach='LT'
JOIN GIANG_DAY gd2 ON gv.magv=gd2.magv
AND gd2.phutrach='TH'
WHERE gd1.mamh=gd2.mamh

/*k.Danh sách tên của những môn học có số tín chỉ lớn hơn số tín chỉ của môn ‘Cơ sở dữ liệu’.*/
SELECT mh.tenmh,mh.sotinchi
FROM MON_HOC mh
WHERE mh.sotinchi> (SELECT mh.sotinchi
					FROM MON_HOC mh
					WHERE mh.tenmh=N'Cơ sở dữ liệu')


/*l. Danh sách họ tên sinh viên, điểm thi lý thuyết và thực hành lần 1 của môn ‘Cơ sở dữ liệu’ được
sắp theo thứ tự điểm lý thuyết giảm dần, nếu trùng điểm lý thuyết thì sắp theo điểm thực hành
tăng dần.*/
SELECT sv.masv,sv.hosv+''+sv.tensv AS HotenSV,kq.diemLT,kq.diemTH
FROM SINH_VIEN sv
JOIN KET_QUA kq ON sv.masv=kq.masv
JOIN MON_HOC mh ON kq.mamh=mh.mamh
WHERE mh.tenmh=N'Cơ sở dữ liệu'
ORDER BY kq.diemLT DESC,kq.diemTH ASC


/*m.Danh sách tên của tất cả các môn học và tên giảng viên phụ trách lý thuyết tương ứng, nếu có.*/
SELECT DISTINCT mh.tenmh,gv.magv,gv.hogv+''+gv.tengv AS HotenGV
FROM GIANG_VIEN gv
JOIN GIANG_DAY gd ON gv.magv=gd.magv
AND gd.phutrach='LT'
JOIN MON_HOC mh ON mh.mamh=gd.mamh

/*n.Danh sách mã số và họ tên của 3 sinh viên đứng đầu về điểm thi của môn ‘Cấu trúc dữ liệu’ (yêu
cầu tương tự cho đứng cuối)*/
SELECT TOP 3 sv.masv,sv.hosv+''+sv.tensv AS HotenSV,(kq.diemLT+kq.diemTH)/2 AS Diemtrungbinh
FROM SINH_VIEN sv
JOIN KET_QUA kq ON kq.masv=sv.masv
JOIN MON_HOC mh ON mh.mamh=kq.mamh
WHERE mh.tenmh=N'Cấu trúc dữ liệu'
ORDER BY Diemtrungbinh DESC

--ĐỨNG CUỐI
SELECT TOP 3 sv.masv,sv.hosv+''+sv.tensv AS HotenSV,(kq.diemLT+kq.diemTH)/2 AS Diemtrungbinh
FROM SINH_VIEN sv
JOIN KET_QUA kq ON kq.masv=sv.masv
JOIN MON_HOC mh ON mh.mamh=kq.mamh
WHERE mh.tenmh=N'Cấu trúc dữ liệu'
ORDER BY Diemtrungbinh ASC

/*o.Danh sách mã số, họ tên và số lượng thân nhân của mỗi giảng viên.*/
SELECT gv.magv,gv.hogv+''+gv.tengv AS Hotengv,COUNT(tn.magv) AS Soluongthannhan
FROM GIANG_VIEN gv
LEFT JOIN THAN_NHAN tn ON tn.magv=gv.magv
GROUP BY gv.magv,gv.hogv,gv.tengv

/*p.Danh sách mã số và họ tên giảng viên có trên 2 thân nhân*/
SELECT gv.magv,gv.hogv+''+gv.tengv AS Hotengv,COUNT(tn.magv) AS Soluongthannhan
FROM GIANG_VIEN gv
LEFT JOIN THAN_NHAN tn ON tn.magv=gv.magv
GROUP BY gv.magv,gv.hogv,gv.tengv
HAVING COUNT(tn.magv) >2

/*q.Cho biết mã số và họ tên trưởng khoa không có thân nhân nào*/
SELECT gv.magv,gv.hogv+' '+gv.tengv AS HotenGV,COUNT(tn.magv) AS Soluongthannhan
FROM GIANG_VIEN gv
JOIN QLY_KHOA ql ON ql.magv=gv.magv
LEFT JOIN THAN_NHAN tn ON tn.magv=gv.magv
WHERE ql.chucvu='TK'
GROUP BY gv.magv,gv.hogv,gv.tengv
HAVING COUNT(tn.magv)=0

/*r.Cho biết mã số và họ tên trưởng khoa có tối thiểu 1 thân nhân*/
SELECT gv.magv,gv.hogv+' '+gv.tengv AS HotenGV,COUNT(tn.magv) AS Soluongthannhan
FROM GIANG_VIEN gv
JOIN QLY_KHOA ql ON ql.magv=gv.magv
LEFT JOIN THAN_NHAN tn ON tn.magv=gv.magv
WHERE ql.chucvu='TK'
GROUP BY gv.magv,gv.hogv,gv.tengv
HAVING COUNT(tn.magv) >=1

/*s.Danh sách tên của những sinh viên chưa đăng ký môn 'Cấu trúc dữ liệu' trong học kỳ 1 năm '2014-2015'*/
SELECT sv.masv,sv.hosv+''+sv.tensv AS HotenSV
FROM SINH_VIEN sv
WHERE sv.masv NOT IN (SELECT dk.masv
					  FROM DANG_KY dk
					  JOIN MON_HOC mh ON mh.mamh=dk.mamh
					  WHERE mh.tenmh='Cấu trúc dữ liệu'
					  AND dk.hocky =1
					  AND dk.namhoc='2014-2015')

/*t.Danh sách mã số, họ tên những sinh viên đứng đầu về điểm thi lý thuyết môn ‘Cơ sở dữ liệu’ (yêu
cầu tương tự cho đứng cuối)*/
SELECT TOP 1 sv.masv,sv.hosv+''+sv.tensv AS HotenSV,kq.diemLT
FROM SINH_VIEN sv
JOIN KET_QUA kq ON kq.masv=sv.masv
JOIN MON_HOC mh ON mh.mamh=kq.mamh
WHERE mh.tenmh=N'Cơ sở dữ liệu'

--ĐỨNG CUỐI
SELECT TOP 1 sv.masv,sv.hosv+''+sv.tensv AS HotenSV,kq.diemLT
FROM SINH_VIEN sv
JOIN KET_QUA kq ON kq.masv=sv.masv
JOIN MON_HOC mh ON mh.mamh=kq.mamh
WHERE mh.tenmh=N'Cơ sở dữ liệu'
ORDER BY kq.diemLT ASC

/*u.Danh sách những sinh viên và tên những môn học đã đăng ký học nhưng không có kết quả thi của
môn học.*/
SELECT sv.masv,sv.hosv+' '+sv.tensv AS HotenSV
FROM SINH_VIEN sv
JOIN DANG_KY dk ON dk.masv=sv.masv
JOIN MON_HOC mh ON mh.mamh=dk.mamh
LEFT JOIN KET_QUA kq ON dk.masv=kq.masv AND dk.mamh=kq.mamh
WHERE kq.masv IS NULL;

/*v.Danh sách tên của những môn học đã được phân công giảng dạy trong học kỳ 1 năm ‘2014-2015’
nhưng không có sinh viên đăng ký.*/
SELECT DISTINCT mh.tenmh
FROM GIANG_DAY gd
JOIN MON_HOC mh ON mh.mamh=gd.mamh
LEFT JOIN DANG_KY dk
ON dk.mamh=gd.mamh
AND dk.hocky=gd.hocky
AND gd.namhoc=dk.namhoc
WHERE gd.hocky= '1' AND gd.namhoc='2014-2015'
AND dk.masv IS NULL

/*w.Danh sách tên của những môn học đứng đầu về số tín chỉ trong số những môn có số tiết lý thuyết
bằng với số tiết thực hành (yêu cầu tương tự cho đứng cuối).*/
SELECT TOP 1 mh.sotinchi,mh.tenmh
FROM MON_HOC mh
WHERE mh.sotietLT=mh.sotietTH
ORDER BY mh.sotinchi DESC

--ĐỨNG CUỐI
SELECT TOP 1 mh.sotinchi,mh.tenmh
FROM MON_HOC mh
WHERE mh.sotietLT=mh.sotietTH
ORDER BY mh.sotinchi ASC

/*x.Danh sách những sinh viên của khoa Công nghệ thông tin đứng đầu về điểm lý thuyết trung bình
(tương tự cho đứng cuối).*/
SELECT TOP 1 sv.masv,sv.hosv+' '+sv.tensv AS HotenSV,AVG(kq.diemLT) AS DiemLTtrungbinh
FROM SINH_VIEN sv
JOIN KHOA k ON k.makhoa=sv.makhoa
JOIN KET_QUA kq ON kq.masv=sv.masv
WHERE k.tenkhoa=N'Công nghệ thông tin' AND kq.diemLT IS NOT NULL
GROUP BY sv.masv, sv.hosv,sv.tensv
ORDER BY AVG(kq.diemLT) DESC

--ĐỨNG CUỐI
SELECT TOP 1 sv.masv,sv.hosv+' '+sv.tensv AS HotenSV,AVG(kq.diemLT) AS DiemLTtrungbinh
FROM SINH_VIEN sv
JOIN KHOA k ON k.makhoa=sv.makhoa
JOIN KET_QUA kq ON kq.masv=sv.masv
WHERE k.tenkhoa=N'Công nghệ thông tin' AND kq.diemLT IS NOT NULL
GROUP BY sv.masv, sv.hosv,sv.tensv
ORDER BY AVG(kq.diemLT) ASC

/*y.Danh sách mã số môn học và số lượng sinh viên đăng ký theo từng môn học trong năm học
‘2014-2015’.*/
SELECT dk.mamh,COUNT(dk.masv) AS SoluongSV
FROM DANG_KY dk
JOIN MON_HOC mh ON mh.mamh=dk.mamh
WHERE dk.namhoc='2014-2015'
GROUP BY dk.mamh

/*z.Danh sách mã số và tên giảng viên và số môn học mà giảng viên đó được phân công giảng dạy lý
thuyết trong học kỳ 1 năm ‘2014-2015’.*/
SELECT gv.magv,gv.hogv+' '+gv.tengv AS HotenGV,COUNT(gd.mamh) AS SomonLT
FROM GIANG_DAY gd
JOIN GIANG_VIEN gv ON gv.magv=gd.magv
WHERE gd.phutrach='LT'
AND gd.hocky=1
AND gd.namhoc='2014-2015'
GROUP BY gv.magv,gv.hogv,gv.tengv

/*aa.Danh sách mã số và họ tên của những sinh viên có cùng điểm thi lần 1 môn ‘Cấu trúc dữ liệu’*/
SELECT sv.masv, sv.hosv+' '+sv.tensv AS HotenSV,(diemLT+diemTH)/2 AS Diemtrungbinh
FROM SINH_VIEN sv
JOIN KET_QUA kq ON kq.masv=sv.masv
WHERE kq.lanthi=1 AND kq.mamh='CTDL'
AND (kq.diemLT + kq.diemTH) IN (
    SELECT (diemLT + diemTH) AS diemTB
    FROM KET_QUA kq
    WHERE kq.mamh = 'CTDL' AND kq.lanthi = 1
    GROUP BY (diemLT + diemTH) 
    HAVING COUNT(*) > 1
)
ORDER BY Diemtrungbinh, sv.masv;

/*bb.Danh sách mã số và họ tên của những giảng viên đứng đầu về số lượng môn học được phân
công giảng dạy lý thuyết trong học kỳ 1 năm ‘2014-2015’ (yêu cầu tương tự cho đứng cuối).*/
SELECT TOP 1 gv.magv,gv.hogv+''+gv.tengv AS HotenGV, COUNT(gd.mamh) AS SoluongmhLT
FROM GIANG_VIEN gv
JOIN GIANG_DAY gd ON gd.magv=gv.magv
WHERE gd.hocky=1 AND gd.phutrach='LT'
GROUP BY gv.magv,gv.hogv, gv.tengv
ORDER BY COUNT(gd.mamh) DESC

--ĐỨNG CUỐI
SELECT TOP 1 gv.magv,gv.hogv+' '+gv.tengv AS HotenGV, COUNT(gd.mamh) AS SoluongmhLT
FROM GIANG_VIEN gv
JOIN GIANG_DAY gd ON gd.magv=gv.magv
WHERE gd.hocky=1 AND gd.phutrach='LT'
GROUP BY gv.magv,gv.hogv, gv.tengv
ORDER BY COUNT(gd.mamh) ASC

--KIẾM TRA ĐÚNG YÊU CẦU ĐỀ CHƯA
SELECT hocky,mamh,phutrach,magv
FROM GIANG_DAY
where phutrach='LT'AND hocky=1


/*cc.Danh sách mã số và họ tên giảng viên, tên khoa và tổng số lượng sinh viên của khoa mà giảng
viên đang công tác.*/
SELECT  gv.magv,gv.hogv,gv.tengv, k.tenkhoa,COUNT(sv.masv) AS TongsoluongSVkhoa
FROM GIANG_VIEN gv
JOIN KHOA k ON k.makhoa=gv.makhoa
LEFT JOIN SINH_VIEN sv ON sv.makhoa=k.makhoa
GROUP BY gv.magv,gv.hogv,gv.tengv,k.tenkhoa
ORDER BY k.tenkhoa,gv.tengv

