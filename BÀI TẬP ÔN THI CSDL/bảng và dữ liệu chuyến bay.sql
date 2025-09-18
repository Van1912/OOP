CREATE DATABASE QUAN_LY_CHUYEN_BAY

-- Tạo bảng Pilots (Thông tin phi công)
CREATE TABLE Pilots (
    Pilot_ID INT PRIMARY KEY,                  -- Mã số phi công
    Pilot_name NVARCHAR(100),                  -- Tên phi công
    Plane_type NVARCHAR(50),                   -- Loại máy bay phi công có thể lái
    Flight_hours INT                           -- Số giờ bay
);

-- Tạo bảng Planes (Thông tin máy bay)
CREATE TABLE Planes (
    Plane_ID INT PRIMARY KEY,                  -- Mã số máy bay
    Plane_name NVARCHAR(100),                  -- Tên máy bay
    Plane_type NVARCHAR(50)                    -- Loại của máy bay
);

-- Tạo bảng Flight_Schedule (Lịch bay)
CREATE TABLE Flight_Schedule (
    Pilot_ID INT,                              -- Mã phi công
    Plane_ID INT,                              -- Mã máy bay
    Pilot_ID_Supervisor INT,                   -- Mã phi công giám sát
    Date_flight DATE,                          -- Ngày bay
    Time_flight TIME,                          -- Giờ bay

    PRIMARY KEY (Pilot_ID, Plane_ID, Date_flight, Time_flight),

    FOREIGN KEY (Pilot_ID) REFERENCES Pilots(Pilot_ID),
    FOREIGN KEY (Plane_ID) REFERENCES Planes(Plane_ID),
    FOREIGN KEY (Pilot_ID_Supervisor) REFERENCES Pilots(Pilot_ID)
);


--Tạo dữ liệu
--Bảng Pilots
INSERT INTO Pilots (Pilot_ID, Pilot_name, Plane_type, Flight_hours) VALUES
(1, N'John', 'Airbus A320', 1500),
(2, N'Trần Thị B', 'Boeing 737', 2000),
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

