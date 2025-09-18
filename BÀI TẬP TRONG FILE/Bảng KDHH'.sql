CREATE DATABASE KDHH
GO

-- Bảng hàng hóa
CREATE TABLE HANG_HOA (
    mahh CHAR(6) PRIMARY KEY,              -- Mã hàng hóa
    tenhh NVARCHAR(50) NOT NULL,           -- Tên hàng hóa
    dvthh NVARCHAR(10) NOT NULL            -- Đơn vị tính
);

-- Bảng khách hàng (có thể là nhà cung cấp hoặc khách mua hàng)
CREATE TABLE KHACH_HANG (
    makh CHAR(4) PRIMARY KEY,              -- Mã khách hàng
    tenkh NVARCHAR(100) NOT NULL,          -- Tên khách hàng
    diachikh NVARCHAR(100),                -- Địa chỉ
    dthoaikh NVARCHAR(20)                  -- Điện thoại
);

-- Phiếu nhập hàng từ nhà cung cấp
CREATE TABLE PHIEU_NHAP (
    sopn CHAR(5) PRIMARY KEY,              -- Số phiếu nhập
    ngaypn DATE NOT NULL,                  -- Ngày nhập hàng
    makh CHAR(4) NOT NULL,                 -- Mã nhà cung cấp
    FOREIGN KEY (makh) REFERENCES KHACH_HANG(makh)
);

-- Chi tiết phiếu nhập
CREATE TABLE CHITIET_PN (
    sopn CHAR(5) NOT NULL,
    mahh CHAR(6) NOT NULL,
    solghhpn INT NOT NULL,                 -- Số lượng nhập
    thanhtienhhpn REAL NOT NULL,           -- Thành tiền
    PRIMARY KEY (sopn, mahh),
    FOREIGN KEY (sopn) REFERENCES PHIEU_NHAP(sopn),
    FOREIGN KEY (mahh) REFERENCES HANG_HOA(mahh)
);

-- Đơn đặt hàng từ khách hàng
CREATE TABLE DON_DH (
    sodh CHAR(5) PRIMARY KEY,              -- Số đơn hàng
    ngaydh DATE,                           -- Ngày đặt hàng
    ngaygiaodk DATE,                       -- Ngày giao dự kiến
    makh CHAR(4) NOT NULL,                 -- Mã khách hàng
    FOREIGN KEY (makh) REFERENCES KHACH_HANG(makh)
);

-- Chi tiết đơn đặt hàng
CREATE TABLE CHITIET_DH (
    sodh CHAR(5),
    mahh CHAR(6),
    solghhdh INT NOT NULL,                 -- Số lượng đặt
    sotienhhdh REAL NOT NULL,              -- Thành tiền
    PRIMARY KEY (sodh, mahh),
    FOREIGN KEY (sodh) REFERENCES DON_DH(sodh),
    FOREIGN KEY (mahh) REFERENCES HANG_HOA(mahh)
);

-- Phiếu giao hàng
CREATE TABLE PHIEU_GH (
    sogh CHAR(5) PRIMARY KEY,              -- Số phiếu giao hàng
    ngaygh DATE NOT NULL,                  -- Ngày giao hàng
    sodh CHAR(5),                          -- Liên kết đơn hàng
    FOREIGN KEY (sodh) REFERENCES DON_DH(sodh)
);

-- Chi tiết phiếu giao hàng
CREATE TABLE CHITIET_GH (
    sogh CHAR(5),
    mahh CHAR(6),
    solghhgh INT NOT NULL,                 -- Số lượng giao
    PRIMARY KEY (sogh, mahh),
    FOREIGN KEY (sogh) REFERENCES PHIEU_GH(sogh),
    FOREIGN KEY (mahh) REFERENCES HANG_HOA(mahh)
);

-- Hóa đơn bán lẻ
CREATE TABLE HOA_DON (
    sohd CHAR(5) PRIMARY KEY,              -- Số hóa đơn
    ngayhd DATE NOT NULL,                  -- Ngày hóa đơn
    tenkhachhang NVARCHAR(100),            -- Khách vãng lai
    trigiahd REAL NOT NULL                 -- Tổng trị giá
);

-- Chi tiết hóa đơn bán lẻ
CREATE TABLE CHITIET_HD (
    sohd CHAR(5),
    mahh CHAR(6),
    solghhhd INT NOT NULL,                 -- Số lượng bán
    thanhtienhhhd REAL NOT NULL,           -- Thành tiền
    PRIMARY KEY (sohd, mahh),
    FOREIGN KEY (sohd) REFERENCES HOA_DON(sohd),
    FOREIGN KEY (mahh) REFERENCES HANG_HOA(mahh)
);

-- Phiếu chi trả tiền cho nhà cung cấp
CREATE TABLE PHIEU_CHI (
    sopc CHAR(5) PRIMARY KEY,              -- Số phiếu chi
    ngaypc DATE NOT NULL,                  -- Ngày chi
    sotienpc REAL NOT NULL,                -- Số tiền chi
    makh CHAR(4),                          -- Mã khách hàng nhận tiền
    FOREIGN KEY (makh) REFERENCES KHACH_HANG(makh)
);

-- Phiếu thu tiền từ khách hàng
CREATE TABLE PHIEU_THU (
    sopt CHAR(5) PRIMARY KEY,              -- Số phiếu thu
    ngaypt DATE NOT NULL,                  -- Ngày thu
    sotienpt REAL NOT NULL,                -- Số tiền thu
    makh CHAR(4) NOT NULL,                 -- Mã khách hàng trả tiền
    FOREIGN KEY (makh) REFERENCES KHACH_HANG(makh)
);

-- Bảng tồn kho theo tháng
CREATE TABLE TON_KHO (
    namthg CHAR(6),                        -- Năm/tháng (yyyyMM)
    mahh CHAR(6),
    tondauky INT NOT NULL,                 -- Tồn đầu kỳ
    solgnhap INT NOT NULL,                 -- Số lượng nhập trong kỳ
    solgxuat INT NOT NULL,                 -- Số lượng xuất trong kỳ
    PRIMARY KEY (namthg, mahh),
    FOREIGN KEY (mahh) REFERENCES HANG_HOA(mahh)
);

-- Bảng công nợ theo tháng
CREATE TABLE CONG_NO (
    namthg CHAR(6),
    makh CHAR(4),
    nodauky REAL NOT NULL,                 -- Nợ đầu kỳ (>0 nếu công ty nợ khách)
    phsinhno REAL NOT NULL,                -- Phát sinh nợ trong kỳ
    phsinhco REAL NOT NULL,                -- Phát sinh có trong kỳ
    PRIMARY KEY (namthg, makh),
    FOREIGN KEY (makh) REFERENCES KHACH_HANG(makh)
);