CREATE DATABASE QUAN_LY_CHUYEN_BAY_DE_2

-- Bảng Pilots (Phi công)
CREATE TABLE Pilots (
    Pilot_ID INT PRIMARY KEY,
    Pilot_name VARCHAR(100),
    Plane_type VARCHAR(50),
    Flight_hours INT
);


-- Bảng Planes (Máy bay)
CREATE TABLE Planes (
    Plane_ID INT PRIMARY KEY,
    Plane_name VARCHAR(100),
    Plane_type VARCHAR(50)
);

-- Bảng Flight_Schedule (Lịch bay)
CREATE TABLE Flight_Schedule (
    Pilot_ID INT,
    Plane_ID INT,
    Pilot_ID_Supervisor INT,
    Date_flight DATE,
    Time_flight TIME,
    Flight_status VARCHAR(50),
    FOREIGN KEY (Pilot_ID) REFERENCES Pilots(Pilot_ID),
    FOREIGN KEY (Plane_ID) REFERENCES Planes(Plane_ID),
    FOREIGN KEY (Pilot_ID_Supervisor) REFERENCES Pilots(Pilot_ID)
)

--Tạo dữ liệu
--Bảng Pilots
INSERT INTO Pilots (Pilot_ID, Pilot_name, Plane_type, Flight_hours) VALUES
(1, N'Jane', 'Airbus A320', 1500),
(2, N'Joane', 'Boeing 737', 2000),
(3, N'Lê Văn C', 'Airbus A320', 1200),
(4, N'John', 'Boeing 777', 3000),
(5, N'Hoàng Thị E', 'Boeing 737', 1000);


--Bảng Planes
INSERT INTO Planes (Plane_ID, Plane_name, Plane_type) VALUES
(101, N'Máy bay A1', 'Airbus A320'),
(102, N'Máy bay B1', 'Boeing 737'),
(103, N'Máy bay C1', 'Boeing 777'),
(104, N'Máy bay D1', 'Airbus A320');

--Bảng Flight_Schedule
INSERT INTO Flight_Schedule (Pilot_ID, Plane_ID, Pilot_ID_Supervisor, Date_flight, Time_flight) VALUES
(1, 101, 2, '2024-12-01', '08:00:00'),
(2, 102, 4, '2025-06-02', '10:30:00'),
(3, 104, 1, '2024-07-03', '13:45:00'),
(5, 102, 2, '2025-05-04', '15:00:00'),
(4, 103, 2, '2024-12-05', '07:15:00');


