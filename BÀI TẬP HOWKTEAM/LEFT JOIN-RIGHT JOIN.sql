--LEFT JOIN
--Bảng bên phải nhập vào bảng bên trái
--Record nào bảng phải ko có thì để null
--Record nào bảng trái ko có thì ko điền vào
SELECT *
FROM GIAOVIEN 
LEFT JOIN BOMON
ON BOMON.MABM=GIAOVIEN.MABM

--RIGHT JOIN
SELECT *
FROM BOMON
RIGHT JOIN GIAOVIEN
ON BOMON.MABM=GIAOVIEN.MABM