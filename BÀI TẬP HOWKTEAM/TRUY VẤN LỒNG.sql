--Kiếm tra xem GV 001 có phải là GVQLCM hay không
--Lấy ra DS các mã GVQLCM
--Ktra mã GV tồn tại trong DS đó
SELECT * FROM GIAOVIEN
WHERE MAGV='001'
/*001 tồn tại trong DS*/
AND MAGV IN
(
SELECT GVQLCM FROM GIAOVIEN
)

--Truy vấn lồng trong FROM
SELECT * 
FROM GIAOVIEN, (SELECT * FROM DETAI) AS DT

--1.Xuất ra DS GV tham gia nhiều hơn 1 đề tài
--Lấy ra all thông tin của GV khi mà 
SELECT *
FROM GIAOVIEN GV
--Số lượng đề tài GV đó tgia > 1
WHERE 1<
(
SELECT COUNT(*) 
FROM THAMGIADT
WHERE MAGV =GV.MAGV
)

--2. Xuất ra thông tin của khoa mà có nhiều hơn 2 giáo viên
--Lấy được DS bộ môn nằm trong khoa hiện tại

SELECT * 
FROM KHOA K
WHERE 2<
(
SELECT COUNT(*) 
FROM BOMON BM, GIAOVIEN GV
WHERE BM.MAKHOA=K.MAKHOA
AND BM.MABM=GV.MABM
)

SELECT * FROM KHOA K, BOMON BM, GIAOVIEN GV
WHERE BM.MAKHOA=K.MAKHOA
AND BM.MABM=GV.MABM

--SẮP XẾP GIẢM DẦN
SELECT MAGV FROM GIAOVIEN
ORDER BY MAGV DESC

--SẮP XẾP TĂNG DẦN
SELECT MAGV FROM GIAOVIEN
ORDER BY MAGV ASC

--LẤY RA TOP 5 PHẦN TỬ
SELECT TOP 5 *
FROM GIAOVIEN


/*
Bài tập:
1.Xuất ra thông tin GV mà có hơn 2 người thân
2.Xuất ra DS GV lớn tuổi hơn ít nhất 5 GV trong trường
--Lấy ra DS gồm MAGV, Tuoi AS GVT
--Sắp xếp giảm dần
--Lấy ra DS GVT2 với SL phần tử là bằng COUNT(*) /2
--Ktra mã GV tồn tại trong GVT2 là đúng
*/

--BÀI LÀM
--1.
SELECT *
FROM GIAOVIEN GV
WHERE 2>
(SELECT COUNT(*)
FROM NGUOITHAN NT
WHERE GV.MAGV=NT.MAGV
);
