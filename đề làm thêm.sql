-- Tạo database
CREATE DATABASE KHANH_VAN;

-- Tạo bảng Doctors
CREATE TABLE Doctors (
    Doctor_ID VARCHAR(10) PRIMARY KEY,
    Doctor_Name VARCHAR(100),
    Specialty VARCHAR(100),
    Experience_Years INT
);

-- Tạo bảng Patients
CREATE TABLE Patients (
    Patient_ID VARCHAR(10) PRIMARY KEY,
    Patient_Name VARCHAR(100),
    Disease VARCHAR(100)
);

-- Tạo bảng Appointments
CREATE TABLE Appointments (
    Doctor_ID VARCHAR(10),
    Patient_ID VARCHAR(10),
    Date_Appointment DATE,
    Time_Appointment TIME,
    Supervisor_Doctor_ID VARCHAR(10),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
    FOREIGN KEY (Supervisor_Doctor_ID) REFERENCES Doctors(Doctor_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

-- Dữ liệu mẫu cho Doctors
INSERT INTO Doctors VALUES ('D01', 'Anna', 'Cardiology', 3);
INSERT INTO Doctors VALUES ('D02', 'Brian', 'Neurology', 5);
INSERT INTO Doctors VALUES ('D03', 'Clara', 'Orthopedics', 7);

-- Dữ liệu mẫu cho Patients
INSERT INTO Patients VALUES ('P01', 'Tom', 'Flu');
INSERT INTO Patients VALUES ('P02', 'Jerry', 'Fracture');
INSERT INTO Patients VALUES ('P03', 'Sam', 'Migraine');

-- Dữ liệu mẫu cho Appointments
INSERT INTO Appointments VALUES ('D01', 'P01', '2024-12-10', '09:00:00', 'D02');
INSERT INTO Appointments VALUES ('D02', 'P03', '2024-12-12', '10:00:00', 'D03');
INSERT INTO Appointments VALUES ('D03', 'P02', '2024-11-15', '08:30:00', 'D01');

--Câu 0: Tạo khóa chính và khóa ngoại
--Tạo khóa chính cho bảng Patients. 
alter table Patients add constrait PK_Patient primary key(Patients_ID)
--Tạo khóa ngoại từ bảng Appointments tham chiếu đến bảng Doctors.
alter table Appoinyments
add constrait FK_Appointments foreign key(Doctor_ID) 
references Doctors(Doctors_ID)
--Câu 1: Cập nhật thông tin
--Bác sĩ Anna vừa tốt nghiệp thêm 2 năm kinh nghiệm
update Doctors
set Experience_Years=Experience_Years+2
where Doctor_Name='Anna'
--thêm thuộc tính Year_Admitted kiểu int cho bảng Patients
alter table Patients
add Year_Admitted int

--Câu 2:
--Tìm tên bác sĩ không điều trị cho bệnh nhân nào
select Doctor_Name
from Doctors 
where Doctor_ID not in (select distinct Doctor_ID from Appointments)

--Tìm tên bệnh nhân chưa có lịch hẹn trong tháng 12/2024.
select Patient_Name
from Patients p 
where Patient_ID not in (select ap.Patient_ID from Appointments ap
						 where MONTH(Date_Appointment)=12
						 and YEAR(Date_Appointment)=2024)

--Tìm tên bác sĩ không làm giám sát cho bất kỳ lịch hẹn nào
select Doctor_Name
from Doctors
where Doctor_Name in (select distinct Supervisor_Doctor_ID from Appointments ap
						 where Supervisor_Doctor_ID is null)

--Đếm số bệnh nhân mỗi bác sĩ đang điều trị
select d.Doctor_ID, count(p.Patient_ID) AS SoluongBN
from Appointments ap
join Doctors d on d.Doctor_ID=ap.Doctor_ID
join Patients p on p.Patient_ID=ap.Patient_ID
group by p.Patient_ID, d.Doctor_ID

--Viết trigger đảm bảo rằng bác sĩ không thể là giám sát cho chính lịch hẹn của mình. Nếu vi phạm, thông báo:
--'A doctor cannot supervise their own appointment'
create trigger tr_Khonggiamsat
on Appointments
after insert,update
as
begin
if exists (select *
		   from inserted i
		   join Doctors d on d.Doctor_ID=i.Doctor_ID
		   where d.Doctor_ID=Supervisor_Doctor_ID)
begin
print N'Bác sĩ không được giám sát lịch hẹn chính mình'
rollback tran
end 
end

INSERT INTO Appointments VALUES ('D01', 'P03', '2025-01-02', '09:00:00', 'D01');