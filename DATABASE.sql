---
----Tao database fastdood
CREATE DATABASE FASTFOOD;
USE 

--- Tao cac kieu du lieu enums
CREATE TYPE EmploymentType AS ENUM ('FULL_TIME', 'PART_TIME');

CREATE TYPE EmploymentStatus AS ENUM ('ACTIVE', 'RESIGNED', 'TERMINATED', 'ON_LEAVE');

CREATE TYPE Role AS ENUM ('MANAGER', 'CASHIER', 'COOK', 'WAITER', 'DELIVERY');

CREATE TYPE ShiftType AS ENUM ('MORNIG', 'AFTERNOON', 'EVENING', 'NIGHT');

CREATE TYPE LeaveStatus AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED');

CREATE TYPE OvertimeStatus AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

CREATE TYPE TableStatus AS ENUM ('AVAILABLE', 'OCCUPIED', 'RESERVED');

CREATE TYPE ResvervationStatus AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED');

CREATE TYPE OrderType AS ENUM ('DINE_IN', 'TAKEAWAY', 'DELIVERY');

CREATE TYPE OrderStatus AS ENUM ('PENDING', 'PROCESSING', 'SERVED', 'DELIVERED', 'CANCELLED', 'RETURNED', 'FAILED');





CREATE TYPE TransactionType AS ENUM ('IMPORT', 'EXPORT');

CREATE TYPE DeliveryStatus AS ENUM ('PENDING', 'IN_TRANSIT', 'DELIVERED', 'FAILED');

CREATE TYPE PaymentMethod AS ENUM ('CREDIT_CARD', 'CASH', 'BANK_TRANSFER');

CREATE TYPE PaymentStatus AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED');

CREATE TYPE CouponStatus AS ENUM ('AVAILABLE', 'ALLOCATED', 'EXPIRED', 'USED');

CREATE TYPE DiscountType AS ENUM ('PERCENTAGE', 'FIXED_AMOUNT');

CREATE TYPE UserTier AS ENUM ('GOLD', 'SILVER', 'BRONZE');

CREATE TYPE InventoryCategory AS ENUM ('MEAT', 'VEGETABLE', 'SPICE', 'DAIRY', 'BEVERAGE');

-----Tạo các bảng
---Tạo bảng Campain
CREATE TABLE Campaign (
	id UUID PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(255),
	startDate TIMESTAMP NOT NULL,
	userTier UserTier NOT NULL ,
	endDate TIMESTAMP NOT NULL,
	isDeleted BOOLEAN DEFAULT FALSE
);

-- Sữa lại tên cột::))
ALTER TABLE Campaign RENAME COLUMN isDeletad TO isDeleted

--- Tạo bảng CouponPool
CREATE TABLE CouponPool (
	id UUID PRIMARY KEY,
	name VARCHAR(150),
	description VARCHAR(255) NOT NULL,
	totalCoupons INT NOT NULL,
	createdAt TIMESTAMP NOT NULL,
	campaignId UUID,
	allocatedCount INT DEFAULT 0,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Coupon
CREATE TABLE Coupon (
	id UUID PRIMARY KEY,
	code VARCHAR(30) UNIQUE,
	discountType DiscountType NOT NULL,
	discountValue DECIMAL(12,2),
	minOrderValue DECIMAL(12,2) NOT NULL,
	maxDiscountValue DECIMAL(12,2) NOT NULL,
	usageLimit INT DEFAULT 1,
	status CouponStatus NOT NULL,
	isActive BOOLEAN DEFAULT TRUE,
	expiresAt TIMESTAMP,
	createdAt TIMESTAMP NOT NULL,
	updatedAt TIMESTAMP,  ---updatedAt,
	campaignId UUID,
	poolId UUID,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng CouponTarget
CREATE TABLE CouponTarget (
	id UUID PRIMARY KEY,
	couponId UUID,
	userId UUID,
	userTier UserTier NOT NULL,
	sentAt TIMESTAMP,
	expiresAt TIMESTAMP NOT NULL,
	usageLimit INT DEFAULT 1,
	isDeletad BOOLEAN DEFAULT FALSE
);

--- Tạo bảng CouponUsage
CREATE TABLE CouponUsage (
	id UUID PRIMARY KEY,
	couponId UUID,
	userId UUID,
	usedAt TIMESTAMP NOT NULL
);

--- Tạo bảng Employee
CREATE TABLE Employee (
	id UUID PRIMARY KEY,
	userId UUID UNIQUE,
	salary DECIMAL(12,2),
	hourlyRate DECIMAL(12,2),
	hireDate TIMESTAMP NOT NULL,
	role Role,
	employmentType EmploymentType NOT NULL,
	employmentStatus EmploymentStatus,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng WorkSchedule
CREATE TABLE WorkSchedule (
	id UUID PRIMARY KEY,
	employeeId UUID,
	date TIMESTAMP,
	shiftTemPlateId UUID,
	shiftStart TIMESTAMP,
	shiFtEnd TIMESTAMP,
	createdAt TIMESTAMP,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng ShiftTemplate
CREATE TABLE ShiftTemplate (
	id UUID PRIMARY KEY,
	name VARCHAR(50) UNIQUE,
	shiftType VARCHAR(50),
	startTime VARCHAR(15),
	endTime  VARCHAR(15)
);

--- Tạo bảng LeaveRequest
CREATE TABLE LeaveRequest (
	id UUID PRIMARY KEY,
	employeeId UUID,
	requestDate TIMESTAMP NOT NULL,
	startDate TIMESTAMP NOT NULL,
	endDate TIMESTAMP NOT NULL,
	reason VARCHAR(255) NOT NULL,
	status LeaveStatus,
	createdAt TIMESTAMP NOT NULL,
	updatedAt TIMESTAMP,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Attendance
CREATE TABLE Attendance (
	id UUID PRIMARY KEY,
	employeeId UUID,
	workDate TIMESTAMP NOT NULL,
	checkIn TIMESTAMP NOT NULL,
	checkOut TIMESTAMP NOT NULL,
	notes VARCHAR(255),
	overtimeMinutes INT,
	lateMinutes INT,
	earlyDepartureMinutes INT,
	createdAt TIMESTAMP  NOT NULL,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng OvertimeRequest
CREATE TABLE OvertimeRequest (
	id UUID PRIMARY KEY,
	employeeId UUID,
	date TIMESTAMP NOT NULL,
	requestedMinutes INT NOT NULL,
	reason VARCHAR(255),
	status OvertimeStatus,
	createdAt TIMESTAMP NOT NULL,
	updatedAt TIMESTAMP,
	isDeletad BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Payroll
CREATE TABLE Payroll (
	id UUID PRIMARY KEY,
	employeeId UUID,
	baseSalary DECIMAL(12,2),
	hourlyRate DECIMAL(12,2) NOT NULL,
	workedHours INT NOT NULL,
	standardHours INT,
	overtimePay DECIMAL(12,2) DEFAULT 0,
	deductions DECIMAL(12,2) DEFAULT 0,
	netSalary DECIMAL(12,2) NOT NULL,
	createdAt TIMESTAMP  NOT NULL
);

--- Tạo bảng User
CREATE TABLE User1 (
	id UUID PRIMARY KEY,
	name VARCHAR(100),
	password VARCHAR(512),
	email VARCHAR(50) UNIQUE,
	phone VARCHAR(15) UNIQUE,
	address VARCHAR(255),
	isAdmin BOOLEAN DEFAULT FALSE,
	isEmployee BOOLEAN DEFAULT FALSE,
	isActive BOOLEAN DEFAULT TRUE,
	createdAt TIMESTAMP NOT NULL,
	updatedAt TIMESTAMP,
	userTier UserTier DEFAULT 'BRONZE',
	point INT, 
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Token
CREATE TABLE Token (
	id UUID PRIMARY KEY,
	userId UUID,
	refreshToken  VARCHAR(30) NOT NULL,
	expiresAt TIMESTAMP NOT NULL,
	createdAt TIMESTAMP NOT NULL
);

--- Tạo bảng Reservation
CREATE TABLE Reservation (
	id UUID PRIMARY KEY,
	userId UUID,
	orderId UUID,
	reservationTime TIMESTAMP NOT NULL,
	status ResvervationStatus,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Review
CREATE TABLE Review (
	id UUID PRIMARY KEY,
	userId UUID,
	orderId UUID,
	rating INT NOT NULL,
	comment VARCHAR(255) NOT NULL,
	createdAt TIMESTAMP NOT NULL 
);

--- Tảo bảng Table1
CREATE TABLE Table1 (
	id UUID PRIMARY KEY,
	number VARCHAR(10),
	capacity INT,
	status TableStatus,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Order
CREATE TABLE Order1 (
	id UUID PRIMARY KEY,
	userId UUID,
	tableId UUID,
	orderType OrderType NOT NULL,
	orderDate TIMESTAMP NOT NULL,
	totalAmount DECIMAL(12,2) NOT NULL,
	shippingFee DECIMAL(12,2) NOT NULL,
	taxAmount DECIMAL(12,2) NOT NULL,
	status OrderStatus NOT NULL,
	couponId UUID,
	earnedPoint INT DEFAULT '0',
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Payment
CREATE TABLE Payment (
	id UUID PRIMARY KEY,
	orderId UUID,
	paymentDate TIMESTAMP NOT NULL,
	amount DECIMAL(12,2) NOT NULL,
	method PaymentMethod NOT NULL,
	status PaymentStatus NOT NULL
);

--- Tạo bảng Delivery
CREATE TABLE Delivery (
	id UUID PRIMARY KEY,
	orderId UUID,
	deliveryDate TIMESTAMP NOT NULL,
	status DeliveryStatus NOT NULL,
	carrier VARCHAR(50) NOT NULL,
	trackingCode VARCHAR(15) UNIQUE
);

--- Tạo bảng OrderItem
CREATE TABLE OrderItem (
	id UUID PRIMARY KEY,
	orderId UUID,
	menuItemId UUID,
	quantity INT NOT NULL,
	price DECIMAL(12,2) NOT NULL
);

--- Tạo bảng MenuItem
CREATE TABLE MenuItem (
	id UUID PRIMARY KEY,
	name VARCHAR(100),
	description VARCHAR(255),
	price DECIMAL(12,2)  NOT NULL,
	imageUrl VARCHAR(200),
	categoryId UUID,
	isAvailable BOOLEAN DEFAULT TRUE,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng MenuCategory
CREATE TABLE MenuCategory (
	id UUID PRIMARY KEY,
	name VARCHAR(100),
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng RecipeIngredient
CREATE TABLE RecipeIngredient (
	id UUID PRIMARY KEY,
	menuItemId UUID,
	inventoryItemId UUID,
	quantity INT NOT NULL,
	unit VARCHAR(10) NOT NULL
);

--- Tạo bảng InventoryItem
CREATE TABLE InventoryItem (
	id UUID PRIMARY KEY,
	name VARCHAR(50),
	category INventoryCategory,
	quantity INT NOT NULL,
	unit VARCHAR(10) NOT NULL,
	supplierId UUID,
	updatedAt TiMESTAMP NOT NULL,
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng Supplier
CREATE TABLE Supplier (
	id UUID PRIMARY KEY,
	name VARCHAR(100),
	contact VARCHAr(50) NOT NULL,
	address VARCHAR(150),
	isDeleted BOOLEAN DEFAULT FALSE
);

--- Tạo bảng InventoryTransaction
CREATE TABLE InventoryTransaction (
	id UUID PRIMARY KEY,
	inventoryItemId UUID,
	transactionType TransactionType NOT NULL,
	quantity INT NOT NULL,
	price DECIMAL(12,2) NOT NULL,
	timestamp TIMESTAMP NOT NULL
);

-----Tạo các khóa ngoại
--- Khóa ngoại bảng CouponPool tới bảng Campaign
ALTER TABLE CouponPool ADD CONSTRAINT 
fk_campaignId_CP FOREIGN KEY (campaignId) REFERENCES Campaign(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Coupon tới bảng Campaign
ALTER TABLE Coupon ADD CONSTRAINT 
fk_campaignId_C FOREIGN KEY (campaignId) REFERENCES Campaign(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Coupon tới bảng CouponPool
ALTER TABLE Coupon ADD CONSTRAINT 
fk_poolId_C FOREIGN KEY (poolId) REFERENCES CouponPool(id) ON DELETE CASCADE;
--- Khóa ngoại bảng CouponTarget tới bảng Coupon
ALTER TABLE CouponTarget ADD CONSTRAINT 
fk_couponId_CT FOREIGN KEY (couponId) REFERENCES Coupon(id) ON DELETE CASCADE;
--- Khóa ngoại bảng CouponTarget tới bảng User1
ALTER TABLE CouponTarget ADD CONSTRAINT 
fk_userId_CT FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng CouponUsage tới bảng Coupon
ALTER TABLE CouponUsage ADD CONSTRAINT 
fk_couponId_CU FOREIGN KEY (couponId) REFERENCES Coupon(id) ON DELETE CASCADE;
--- Khóa ngoại bảng CouponUsage tới bảng User1
ALTER TABLE CouponUsage ADD CONSTRAINT 
fk_userId_CU FOREIGN KEY (UserId) REFERENCES User1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Employee tới bảng User1
ALTER TABLE Employee ADD CONSTRAINT 
fk_userId_E FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;

--- Khóa ngoại bảng LeaveRequest tới bảng Employee
ALTER TABLE LeaveRequest ADD CONSTRAINT 
fk_employeeId_LR FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Attendance tới bảng Employee
ALTER TABLE Attendance ADD CONSTRAINT 
fk_employeeId_A FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;
--- Khóa ngoại bảng OvertimeRequest tới bảng Employee
ALTER TABLE OvertimeRequest ADD CONSTRAINT 
fk_employeeId_OR FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Payroll tới bảng Employee
ALTER TABLE Payroll ADD CONSTRAINT 
fk_employeeId_P FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;
--- Khóa ngoại bảng WorkSchedule tới bảng Employee
ALTER TABLE WorkSchedule ADD CONSTRAINT 
fk_employeeId_WS FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;
--- Khóa ngoại bảng WorkSchedule tới bảng ShiftTemplate
ALTER TABLE WorkSchedule ADD CONSTRAINT 
fk_shiftTemplateId_WS FOREIGN KEY (shiftTemplateId) REFERENCES ShiftTemplate(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Token tới bảng User1
ALTER TABLE Token ADD CONSTRAINT 
fk_userId_T FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Reservation tới bảng Order1
ALTER TABLE Reservation ADD CONSTRAINT 
fk_orderId_Res FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;

--- Khóa ngoại bảng Reservation tới bảng User1
ALTER TABLE Reservation ADD CONSTRAINT 
fk_userId_Res FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Review tới bảng Order1
ALTER TABLE Review ADD CONSTRAINT 
fk_orderId_Rev FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Review tới bảng User1
ALTER TABLE Review ADD CONSTRAINT 
fk_userId_Rev FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Order1 tới bảng Table1
ALTER TABLE Order1 ADD CONSTRAINT 
fk_table_O FOREIGN KEY (tableId) REFERENCES Table1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Order1 tới bảng User1
ALTER TABLE Order1 ADD CONSTRAINT 
fk_userId_O FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Order1 tới bảng Coupon
ALTER TABLE Order1 ADD CONSTRAINT 
fk_couponId_Res FOREIGN KEY (couponId) REFERENCES Coupon(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Payment tới bảng Order1
ALTER TABLE Payment ADD CONSTRAINT 
fk_orderId_P FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng Delivery tới bảng Order1
ALTER TABLE Delivery ADD CONSTRAINT 
fk_orderId_D FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;

--- Khóa ngoại bảng OrderItem tới bảng Order1
ALTER TABLE OrderItem ADD CONSTRAINT 
fk_orderId_OI FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;
--- Khóa ngoại bảng OrderItem tới bảng MenuItem
ALTER TABLE OrderItem ADD CONSTRAINT 
fk_menuItemId_OI FOREIGN KEY (menuItemId) REFERENCES MenuItem(id) ON DELETE CASCADE;
--- Khóa ngoại bảng MenuItem tới bảng MenuCategory
ALTER TABLE MenuItem ADD CONSTRAINT 
fk_categoryId_MI FOREIGN KEY (categoryId) REFERENCES MenuCategory(id) ON DELETE CASCADE;
--- Khóa ngoại bảng RecipeIngredient tới bảng MenuItem
ALTER TABLE RecipeIngredient ADD CONSTRAINT 
fk_menuItemId_RI FOREIGN KEY (menuItemId) REFERENCES MenuItem(id) ON DELETE CASCADE;
--- Khóa ngoại bảng RecipeIngredient tới bảng InventoryItem
ALTER TABLE RecipeIngredient ADD CONSTRAINT 
fk_inventoryItemId_RI FOREIGN KEY (inventoryItemId) REFERENCES InventoryItem(id) ON DELETE CASCADE;
--- Khóa ngoại bảng InventoryItem tới bảng Supplier
ALTER TABLE InventoryItem ADD CONSTRAINT 
fk_supplierId_II FOREIGN KEY (supplierId) REFERENCES Supplier(id) ON DELETE CASCADE;
--- Khóa ngoại bảng InventoryTransaction tới bảng InventoryItem
ALTER TABLE InventoryTransaction ADD CONSTRAINT 
fk_inventoryItemId_IT FOREIGN KEY (inventoryItemId) REFERENCES InventoryItem(id) ON DELETE CASCADE;

----- them du lieu vao cac bang
---bang Campain
SET datestyle TO 'ISO, YMD';
---kiem tra dinh dang ngay hien tai
SHOW datestyle;

INSERT INTO Campaign (id, name, description, startDate, userTier, endDate, isDeleted)
VALUES
    ('550e8400-e29b-41d4-a716-446655440000', 'Summer Sale', 'Big summer discounts on all items', '2025-06-01 00:00:00', 'GOLD', '2025-06-30 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440001', 'Winter Giveaway', 'Exclusive winter giveaways', '2025-12-01 00:00:00', 'SILVER', '2025-12-31 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440002', 'Black Friday', 'Biggest sale of the year', '2025-11-28 00:00:00', 'BRONZE', '2025-11-28 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440003', 'Cyber Monday', 'Online exclusive discounts', '2025-12-02 00:00:00', 'GOLD', '2025-12-02 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440004', 'New Year Deals', 'Start the new year with great offers', '2026-01-01 00:00:00', 'BRONZE', '2026-01-10 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440005', 'Spring Specials', 'Limited-time spring promotions', '2025-03-15 00:00:00', 'SILVER', '2025-03-31 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440006', 'VIP Exclusive', 'Special deals for VIP members', '2025-07-01 00:00:00', 'BRONZE', '2025-07-31 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440007', 'Back to School', 'School supplies and more on sale', '2025-08-01 00:00:00', 'GOLD', '2025-08-31 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440008', 'Halloween Specials', 'Spooky discounts on all items', '2025-10-15 00:00:00', 'SILVER', '2025-10-31 23:59:59', FALSE),
    ('550e8400-e29b-41d4-a716-446655440009', 'Flash Sale', 'Limited-time flash deals', '2025-05-01 00:00:00', 'BRONZE', '2025-05-01 23:59:59', FALSE);


--- bang Couponpool
INSERT INTO CouponPool (id, name, description, totalCoupons, createdAt, campaignId, allocatedCount, isDeleted)
VALUES
    ('660e8400-e29b-41d4-a716-446655440000', 'Summer Sale Coupons', 'Discount coupons for Summer Sale', 500, '2025-05-25 10:00:00', '550e8400-e29b-41d4-a716-446655440000', 100, FALSE),
    ('660e8400-e29b-41d4-a716-446655440001', 'Winter Giveaway Coupons', 'Exclusive giveaway coupons for winter', 300, '2025-11-20 09:30:00', '550e8400-e29b-41d4-a716-446655440001', 50, FALSE),
    ('660e8400-e29b-41d4-a716-446655440002', 'Black Friday Mega Sale', 'Biggest sale discount coupons', 1000, '2025-11-15 12:00:00', '550e8400-e29b-41d4-a716-446655440002', 200, FALSE),
    ('660e8400-e29b-41d4-a716-446655440003', 'Cyber Monday Vouchers', 'Special online discount vouchers', 700, '2025-11-28 14:00:00', '550e8400-e29b-41d4-a716-446655440003', 150, FALSE),
    ('660e8400-e29b-41d4-a716-446655440004', 'New Year Special Coupons', 'Celebrate New Year with great discounts', 400, '2025-12-30 16:00:00', '550e8400-e29b-41d4-a716-446655440004', 80, FALSE),
    ('660e8400-e29b-41d4-a716-446655440005', 'Spring Specials Discounts', 'Exclusive spring sale coupons', 350, '2025-03-10 08:30:00', '550e8400-e29b-41d4-a716-446655440005', 75, FALSE),
    ('660e8400-e29b-41d4-a716-446655440006', 'VIP Member Rewards', 'Special vouchers for VIP customers', 250, '2025-06-25 11:00:00', '550e8400-e29b-41d4-a716-446655440006', 60, FALSE),
    ('660e8400-e29b-41d4-a716-446655440007', 'Back to School Coupons', 'School supplies and accessories discount', 600, '2025-07-20 15:00:00', '550e8400-e29b-41d4-a716-446655440007', 120, FALSE),
    ('660e8400-e29b-41d4-a716-446655440008', 'Halloween Discount Codes', 'Spooky season discounts on all items', 500, '2025-10-10 17:00:00', '550e8400-e29b-41d4-a716-446655440008', 90, FALSE),
    ('660e8400-e29b-41d4-a716-446655440009', 'Flash Sale Coupons', 'Limited-time discount codes', 150, '2025-04-25 07:00:00', '550e8400-e29b-41d4-a716-446655440009', 30, FALSE);

--- bang Coupon
INSERT INTO Coupon (id, code, discountType, discountValue, minOrderValue, maxDiscountValue, usageLimit, status, isActive, expiresAt, createdAt, updatedAt, campaignId, poolId, isDeleted)
VALUES
    ('770e8400-e29b-41d4-a716-446655440000', 'SUMMER2025', 'PERCENTAGE', 10.00, 50.00, 20.00, 1, 'AVAILABLE', TRUE, '2025-06-30 23:59:59', '2025-05-25 10:00:00', NULL, '550e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', FALSE),
    ('770e8400-e29b-41d4-a716-446655440001', 'WINTERFREE', 'FIXED_AMOUNT', 5.00, 30.00, 5.00, 1, 'AVAILABLE', TRUE, '2025-12-31 23:59:59', '2025-11-20 09:30:00', NULL, '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', FALSE),
    ('770e8400-e29b-41d4-a716-446655440002', 'BLACK50', 'PERCENTAGE', 50.00, 100.00, 50.00, 1, 'AVAILABLE', TRUE, '2025-11-28 23:59:59', '2025-11-15 12:00:00', NULL, '550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', FALSE),
    ('770e8400-e29b-41d4-a716-446655440003', 'CYBER20', 'PERCENTAGE', 20.00, 50.00, 25.00, 1, 'AVAILABLE', TRUE, '2025-12-02 23:59:59', '2025-11-28 14:00:00', NULL, '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003', FALSE),
    ('770e8400-e29b-41d4-a716-446655440004', 'NEWYEAR10', 'FIXED_AMOUNT', 10.00, 40.00, 10.00, 1, 'AVAILABLE', TRUE, '2026-01-10 23:59:59', '2025-12-30 16:00:00', NULL, '550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004', FALSE),
    ('770e8400-e29b-41d4-a716-446655440005', 'SPRING15', 'PERCENTAGE', 15.00, 60.00, 30.00, 1, 'AVAILABLE', TRUE, '2025-03-31 23:59:59', '2025-03-10 08:30:00', NULL, '550e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440005', FALSE),
    ('770e8400-e29b-41d4-a716-446655440006', 'VIP30', 'PERCENTAGE', 30.00, 150.00, 50.00, 2, 'AVAILABLE', TRUE, '2025-07-31 23:59:59', '2025-06-25 11:00:00', NULL, '550e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440006', FALSE),
    ('770e8400-e29b-41d4-a716-446655440007', 'SCHOOL5', 'FIXED_AMOUNT', 5.00, 25.00, 5.00, 1, 'AVAILABLE', TRUE, '2025-08-31 23:59:59', '2025-07-20 15:00:00', NULL, '550e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440007', FALSE),
    ('770e8400-e29b-41d4-a716-446655440008', 'HALLOWEEN25', 'PERCENTAGE', 25.00, 70.00, 35.00, 1, 'AVAILABLE', TRUE, '2025-10-31 23:59:59', '2025-10-10 17:00:00', NULL, '550e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440008', FALSE),
    ('770e8400-e29b-41d4-a716-446655440009', 'FLASH10', 'FIXED_AMOUNT', 10.00, 50.00, 10.00, 1, 'AVAILABLE', TRUE, '2025-05-01 23:59:59', '2025-04-25 07:00:00', NULL, '550e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440009', FALSE);
---- bang User1

INSERT INTO User1 (id, name, password, email, phone, address, isAdmin, isEmployee, isActive, createdAt, updatedAt, userTier, point, isDeleted)
VALUES
    ('880e8400-e29b-41d4-a716-446655440000', 'Alice Johnson', 'hashed_password1', 'alice@example.com', '1234567890', '123 Main St, City A', FALSE, FALSE, TRUE, '2025-01-10 10:00:00', NULL, 'GOLD', 1500, FALSE),
    ('880e8400-e29b-41d4-a716-446655440001', 'Bob Smith', 'hashed_password2', 'bob@example.com', '1234567891', '456 Elm St, City B', FALSE, TRUE, TRUE, '2025-02-15 11:00:00', NULL, 'SILVER', 1200, FALSE),
    ('880e8400-e29b-41d4-a716-446655440002', 'Charlie Brown', 'hashed_password3', 'charlie@example.com', '1234567892', '789 Oak St, City C', TRUE, FALSE, TRUE, '2025-03-20 12:00:00', NULL, 'GOLD', 2000, FALSE),
    ('880e8400-e29b-41d4-a716-446655440003', 'David Lee', 'hashed_password4', 'david@example.com', '1234567893', '101 Pine St, City D', FALSE, FALSE, TRUE, '2025-04-25 13:00:00', NULL, 'BRONZE', 500, FALSE),
    ('880e8400-e29b-41d4-a716-446655440004', 'Emma Watson', 'hashed_password5', 'emma@example.com', '1234567894', '202 Birch St, City E', FALSE, TRUE, TRUE, '2025-05-30 14:00:00', NULL, 'SILVER', 800, FALSE),
    ('880e8400-e29b-41d4-a716-446655440005', 'Frank Martin', 'hashed_password6', 'frank@example.com', '1234567895', '303 Cedar St, City F', TRUE, FALSE, TRUE, '2025-06-05 15:00:00', NULL, 'GOLD', 2500, FALSE),
    ('880e8400-e29b-41d4-a716-446655440006', 'Grace Hill', 'hashed_password7', 'grace@example.com', '1234567896', '404 Walnut St, City G', FALSE, FALSE, TRUE, '2025-07-10 16:00:00', NULL, 'BRONZE', 300, FALSE),
    ('880e8400-e29b-41d4-a716-446655440007', 'Henry Adams', 'hashed_password8', 'henry@example.com', '1234567897', '505 Maple St, City H', FALSE, TRUE, TRUE, '2025-08-15 17:00:00', NULL, 'SILVER', 1000, FALSE);

--- bang CouponTarget
INSERT INTO CouponTarget (id, couponId, userId, userTier, sentAt, expiresAt, usageLimit, isDeletad)
VALUES
    ('990e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', '880e8400-e29b-41d4-a716-446655440000', 'GOLD', '2025-05-26 10:00:00', '2025-06-30 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 'SILVER', '2025-11-21 09:30:00', '2025-12-31 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 'GOLD', '2025-11-16 12:00:00', '2025-11-28 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440003', 'BRONZE', '2025-11-29 14:00:00', '2025-12-02 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440004', 'SILVER', '2025-12-31 16:00:00', '2026-01-10 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440005', 'GOLD', '2025-03-11 08:30:00', '2025-03-31 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440006', 'BRONZE', '2025-06-26 11:00:00', '2025-07-31 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440007', 'SILVER', '2025-07-21 15:00:00', '2025-08-31 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440000', 'GOLD', '2025-10-11 17:00:00', '2025-10-31 23:59:59', 1, FALSE),
    ('990e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440001', 'SILVER', '2025-04-26 07:00:00', '2025-05-01 23:59:59', 1, FALSE);

--- bang CouponUsage
INSERT INTO CouponUsage (id, couponId, userId, usedAt)
VALUES
    ('aa0e8400-e29b-41d4-a716-446655440000', '770e8400-e29b-41d4-a716-446655440000', '880e8400-e29b-41d4-a716-446655440000', '2025-06-15 14:00:00'),
    ('aa0e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', '2025-12-20 10:30:00'),
    ('aa0e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', '2025-11-27 16:45:00'),
    ('aa0e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440003', '2025-12-01 12:15:00'),
    ('aa0e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440004', '2026-01-05 09:20:00'),
    ('aa0e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440005', '2025-03-20 08:30:00'),
    ('aa0e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440006', '2025-07-20 11:00:00'),
    ('aa0e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440007', '2025-08-25 15:45:00'),
    ('aa0e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440000', '2025-10-30 17:30:00'),
    ('aa0e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440001', '2025-04-30 07:15:00'),
    ('aa0e8400-e29b-41d4-a716-446655440010', '770e8400-e29b-41d4-a716-446655440000', '880e8400-e29b-41d4-a716-446655440002', '2025-06-20 13:00:00'),
    ('aa0e8400-e29b-41d4-a716-446655440011', '770e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440003', '2025-12-25 18:30:00'),
    ('aa0e8400-e29b-41d4-a716-446655440012', '770e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440004', '2025-11-28 10:45:00'),
    ('aa0e8400-e29b-41d4-a716-446655440013', '770e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440005', '2025-12-02 14:20:00');

--- bang Token
INSERT INTO Token (id, userId, refreshToken, expiresAt, createdAt)
VALUES
    ('bb0e8400-e29b-41d4-a716-446655440000', '880e8400-e29b-41d4-a716-446655440000', 'token_abc123', '2025-12-31 23:59:59', '2025-06-01 10:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', 'token_def456', '2025-11-30 23:59:59', '2025-06-02 11:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440002', 'token_ghi789', '2025-10-31 23:59:59', '2025-06-03 12:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', 'token_jkl012', '2025-09-30 23:59:59', '2025-06-04 13:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440001', 'token_mno345', '2025-08-31 23:59:59', '2025-06-05 14:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440000', 'token_pqr678', '2025-07-31 23:59:59', '2025-06-06 15:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655440001', 'token_stu901', '2025-06-30 23:59:59', '2025-06-07 16:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440000', 'token_vwx234', '2025-05-31 23:59:59', '2025-06-08 17:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440000', 'token_yza567', '2025-04-30 23:59:59', '2025-06-09 18:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440009', '880e8400-e29b-41d4-a716-446655440001', 'token_bcd890', '2025-03-31 23:59:59', '2025-06-10 19:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440010', '880e8400-e29b-41d4-a716-446655440002', 'token_efg123', '2025-02-28 23:59:59', '2025-06-11 20:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440011', '880e8400-e29b-41d4-a716-446655440000', 'token_hij456', '2025-01-31 23:59:59', '2025-06-12 21:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440012', '880e8400-e29b-41d4-a716-446655440002', 'token_klm789', '2024-12-31 23:59:59', '2025-06-13 22:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655440013', '880e8400-e29b-41d4-a716-446655440001', 'token_nop012', '2024-11-30 23:59:59', '2025-06-14 23:00:00');

--- bang Employee
INSERT INTO Employee (id, userId, salary, hourlyRate, hireDate, role, employmentType, employmentStatus, isDeleted)
VALUES
    ('cc0e8400-e29b-41d4-a716-446655441230', '880e8400-e29b-41d4-a716-446655440000', 60000.00, 30.00, '2022-05-15 09:00:00', 'MANAGER', 'FULL_TIME', 'ACTIVE', FALSE),
    ('cc0e8400-e29b-41d4-a716-446655441231', '880e8400-e29b-41d4-a716-446655440001', 32000.00, 15.00, '2023-01-10 10:00:00', 'CASHIER', 'PART_TIME', 'ON_LEAVE', FALSE),
    ('cc0e8400-e29b-41d4-a716-446655441232', '880e8400-e29b-41d4-a716-446655440002', 35000.00, 17.00, '2021-09-05 08:30:00', 'COOK', 'FULL_TIME', 'ACTIVE', FALSE),
    ('cc0e8400-e29b-41d4-a716-446655441233', '880e8400-e29b-41d4-a716-446655440003', 28000.00, 12.00, '2020-06-20 07:45:00', 'WAITER', 'PART_TIME', 'RESIGNED', FALSE),
    ('cc0e8400-e29b-41d4-a716-446655441234', '880e8400-e29b-41d4-a716-446655440004', 30000.00, 14.50, '2019-03-30 09:15:00', 'DELIVERY', 'FULL_TIME', 'TERMINATED', FALSE);

--- bang LeaveRequest
INSERT INTO LeaveRequest (id, employeeId, requestDate, startDate, endDate, reason, status, createdAt, updatedAt, isDeleted)
VALUES
    ('550e8400-e29b-41d4-a716-446655441230', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-01 08:00:00', '2024-03-10 08:00:00', '2024-03-15 17:00:00', 'Family emergency', 'APPROVED', '2024-03-01 08:10:00', NULL, FALSE),
    ('550e8400-e29b-41d4-a716-446655441231', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-02-15 09:00:00', '2024-02-20 09:00:00', '2024-02-25 18:00:00', 'Medical leave', 'PENDING', '2024-02-15 09:05:00', NULL, FALSE),
    ('550e8400-e29b-41d4-a716-446655441232', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-01-10 07:30:00', '2024-01-15 07:30:00', '2024-01-20 16:00:00', 'Vacation', 'APPROVED', '2024-01-10 07:35:00', '2024-01-12 10:00:00', FALSE),
    ('550e8400-e29b-41d4-a716-446655441233', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-05 10:45:00', '2024-03-12 10:45:00', '2024-03-18 17:30:00', 'Personal matters', 'CANCELLED', '2024-03-05 10:50:00', '2024-03-06 14:20:00', FALSE),
    ('550e8400-e29b-41d4-a716-446655441234', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-04-02 12:00:00', '2024-04-05 12:00:00', '2024-04-10 17:00:00', 'Wedding leave', 'APPROVED', '2024-04-02 12:05:00', '2024-04-03 09:00:00', FALSE),
    ('550e8400-e29b-41d4-a716-446655441235', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-05-01 14:00:00', '2024-05-07 14:00:00', '2024-05-12 18:00:00', 'Sick leave', 'REJECTED', '2024-05-01 14:05:00', '2024-05-02 10:00:00', FALSE),
    ('550e8400-e29b-41d4-a716-446655441236', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-06-10 15:30:00', '2024-06-15 15:30:00', '2024-06-20 17:00:00', 'Maternity leave', 'APPROVED', '2024-06-10 15:35:00', '2024-06-11 09:30:00', FALSE),
    ('550e8400-e29b-41d4-a716-446655441237', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-07-05 11:00:00', '2024-07-10 11:00:00', '2024-07-15 16:30:00', 'Bereavement leave', 'PENDING', '2024-07-05 11:05:00', NULL, FALSE),
    ('550e8400-e29b-41d4-a716-446655441238', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-08-12 13:15:00', '2024-08-18 13:15:00', '2024-08-22 15:45:00', 'Conference attendance', 'APPROVED', '2024-08-12 13:20:00', '2024-08-13 08:50:00', FALSE),
    ('550e8400-e29b-41d4-a716-446655441239', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-09-01 09:30:00', '2024-09-07 09:30:00', '2024-09-12 17:00:00', 'Training program', 'CANCELLED', '2024-09-01 09:35:00', '2024-09-02 10:10:00', FALSE);

--- bang ShiftTemplate
INSERT INTO ShiftTemplate (id, name, shiftType, startTime, endTime)
VALUES
    ('770e8400-e29b-41d4-a716-446655441230', 'Morning Shift', 'DAY', '08:00', '16:00'),
    ('770e8400-e29b-41d4-a716-446655441231', 'Afternoon Shift', 'DAY', '12:00', '20:00'),
    ('770e8400-e29b-41d4-a716-446655441232', 'Night Shift', 'NIGHT', '20:00', '04:00'),
    ('770e8400-e29b-41d4-a716-446655441233', 'Graveyard Shift', 'NIGHT', '00:00', '08:00'),
    ('770e8400-e29b-41d4-a716-446655441234', 'Split Shift', 'MIXED', '08:00', '12:00');

--- bang WorkSchedule
INSERT INTO WorkSchedule (id, employeeId, date, shiftTemPlateId, shiftStart, shiFtEnd, createdAt, isDeleted)
VALUES
    ('660e8400-e29b-41d4-a716-446655441240', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-11 00:00:00', '770e8400-e29b-41d4-a716-446655441230', '2024-03-11 08:30:00', '2024-03-11 16:30:00', '2024-03-06 10:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441241', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-12 00:00:00', '770e8400-e29b-41d4-a716-446655441231', '2024-03-12 09:30:00', '2024-03-12 17:30:00', '2024-03-07 11:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441242', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-13 00:00:00', '770e8400-e29b-41d4-a716-446655441232', '2024-03-13 07:00:00', '2024-03-13 15:00:00', '2024-03-08 12:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441243', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-14 00:00:00', '770e8400-e29b-41d4-a716-446655441233', '2024-03-14 10:30:00', '2024-03-14 18:30:00', '2024-03-09 13:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441244', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-15 00:00:00', '770e8400-e29b-41d4-a716-446655441234', '2024-03-15 12:30:00', '2024-03-15 20:30:00', '2024-03-10 14:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441245', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-16 00:00:00', '770e8400-e29b-41d4-a716-446655441230', '2024-03-16 08:15:00', '2024-03-16 16:15:00', '2024-03-11 10:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441246', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-17 00:00:00', '770e8400-e29b-41d4-a716-446655441231', '2024-03-17 09:45:00', '2024-03-17 17:45:00', '2024-03-12 11:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441247', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-18 00:00:00', '770e8400-e29b-41d4-a716-446655441232', '2024-03-18 07:45:00', '2024-03-18 15:45:00', '2024-03-13 12:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441248', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-19 00:00:00', '770e8400-e29b-41d4-a716-446655441233', '2024-03-19 10:45:00', '2024-03-19 18:45:00', '2024-03-14 13:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441249', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-20 00:00:00', '770e8400-e29b-41d4-a716-446655441234', '2024-03-20 12:15:00', '2024-03-20 20:15:00', '2024-03-15 14:00:00', FALSE),
	('660e8400-e29b-41d4-a716-446655441250', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-11 00:00:00', '770e8400-e29b-41d4-a716-446655441230', '2024-03-11 08:30:00', '2024-03-11 16:30:00', '2024-03-06 10:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441251', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-12 00:00:00', '770e8400-e29b-41d4-a716-446655441231', '2024-03-12 09:30:00', '2024-03-12 17:30:00', '2024-03-07 11:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441252', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-13 00:00:00', '770e8400-e29b-41d4-a716-446655441232', '2024-03-13 07:00:00', '2024-03-13 15:00:00', '2024-03-08 12:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441253', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-14 00:00:00', '770e8400-e29b-41d4-a716-446655441233', '2024-03-14 10:30:00', '2024-03-14 18:30:00', '2024-03-09 13:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441254', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-15 00:00:00', '770e8400-e29b-41d4-a716-446655441234', '2024-03-15 12:30:00', '2024-03-15 20:30:00', '2024-03-10 14:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441255', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-16 00:00:00', '770e8400-e29b-41d4-a716-446655441230', '2024-03-16 08:15:00', '2024-03-16 16:15:00', '2024-03-11 10:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441256', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-17 00:00:00', '770e8400-e29b-41d4-a716-446655441231', '2024-03-17 09:45:00', '2024-03-17 17:45:00', '2024-03-12 11:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441257', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-18 00:00:00', '770e8400-e29b-41d4-a716-446655441232', '2024-03-18 07:45:00', '2024-03-18 15:45:00', '2024-03-13 12:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441258', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-19 00:00:00', '770e8400-e29b-41d4-a716-446655441233', '2024-03-19 10:45:00', '2024-03-19 18:45:00', '2024-03-14 13:00:00', FALSE),
    ('660e8400-e29b-41d4-a716-446655441259', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-20 00:00:00', '770e8400-e29b-41d4-a716-446655441234', '2024-03-20 12:15:00', '2024-03-20 20:15:00', '2024-03-15 14:00:00', FALSE);

--- bang Payroll
INSERT INTO Payroll (id, employeeId, baseSalary, hourlyRate, workedHours, standardHours, overtimePay, deductions, netSalary, createdAt)
VALUES
    ('550e8400-e29b-41d4-a716-446655441230', 'cc0e8400-e29b-41d4-a716-446655441230', 50000.00, 25.00, 8, 8, 0, 200.00, 49800.00, '2024-03-11 23:59:59'),
    ('550e8400-e29b-41d4-a716-446655441231', 'cc0e8400-e29b-41d4-a716-446655441231', 52000.00, 26.00, 8, 8, 0, 250.00, 51750.00, '2024-03-12 23:59:59'),
    ('550e8400-e29b-41d4-a716-446655441232', 'cc0e8400-e29b-41d4-a716-446655441232', 48000.00, 24.00, 8, 8, 0, 180.00, 47820.00, '2024-03-13 23:59:59'),
    ('550e8400-e29b-41d4-a716-446655441233', 'cc0e8400-e29b-41d4-a716-446655441233', 51000.00, 25.50, 8, 8, 0, 220.00, 50780.00, '2024-03-14 23:59:59'),
    ('550e8400-e29b-41d4-a716-446655441234', 'cc0e8400-e29b-41d4-a716-446655441234', 49000.00, 24.50, 8, 8, 0, 190.00, 48810.00, '2024-03-15 23:59:59');

--- bang Attendance
INSERT INTO Attendance (id, employeeId, workDate, checkIn, checkOut, notes, overtimeMinutes, lateMinutes, earlyDepartureMinutes, createdAt, isDeleted)
VALUES
    ('770e8400-e29b-41d4-a716-446655441240', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-11 00:00:00', '2024-03-11 08:35:00', '2024-03-11 16:30:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-11 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441241', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-12 00:00:00', '2024-03-12 09:25:00', '2024-03-12 17:30:00', 'Đúng giờ', 0, 0, 0, '2024-03-12 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441242', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-13 00:00:00', '2024-03-13 07:10:00', '2024-03-13 15:00:00', 'Đến trễ 10 phút', 0, 10, 0, '2024-03-13 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441243', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-14 00:00:00', '2024-03-14 10:30:00', '2024-03-14 18:40:00', 'Tăng ca 10 phút', 10, 0, 0, '2024-03-14 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441244', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-15 00:00:00', '2024-03-15 12:35:00', '2024-03-15 20:30:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-15 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441245', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-16 00:00:00', '2024-03-16 08:15:00', '2024-03-16 16:20:00', 'Tăng ca 5 phút', 5, 0, 0, '2024-03-16 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441246', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-17 00:00:00', '2024-03-17 09:50:00', '2024-03-17 17:45:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-17 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441247', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-18 00:00:00', '2024-03-18 07:40:00', '2024-03-18 15:45:00', 'Đến sớm 5 phút', 0, 0, 5, '2024-03-18 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441248', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-19 00:00:00', '2024-03-19 10:50:00', '2024-03-19 18:45:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-19 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441249', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-20 00:00:00', '2024-03-20 12:15:00', '2024-03-20 20:20:00', 'Tăng ca 5 phút', 5, 0, 0, '2024-03-20 23:59:59', FALSE),	
	('770e8400-e29b-41d4-a716-446655441250', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-11 00:00:00', '2024-03-11 08:35:00', '2024-03-11 16:30:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-11 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441251', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-12 00:00:00', '2024-03-12 09:25:00', '2024-03-12 17:30:00', 'Đúng giờ', 0, 0, 0, '2024-03-12 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441252', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-13 00:00:00', '2024-03-13 07:10:00', '2024-03-13 15:00:00', 'Đến trễ 10 phút', 0, 10, 0, '2024-03-13 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441253', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-14 00:00:00', '2024-03-14 10:30:00', '2024-03-14 18:40:00', 'Tăng ca 10 phút', 10, 0, 0, '2024-03-14 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441254', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-15 00:00:00', '2024-03-15 12:35:00', '2024-03-15 20:30:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-15 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441255', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-16 00:00:00', '2024-03-16 08:15:00', '2024-03-16 16:20:00', 'Tăng ca 5 phút', 5, 0, 0, '2024-03-16 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441256', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-17 00:00:00', '2024-03-17 09:50:00', '2024-03-17 17:45:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-17 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441257', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-18 00:00:00', '2024-03-18 07:40:00', '2024-03-18 15:45:00', 'Đến sớm 5 phút', 0, 0, 5, '2024-03-18 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441258', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-19 00:00:00', '2024-03-19 10:50:00', '2024-03-19 18:45:00', 'Đến trễ 5 phút', 0, 5, 0, '2024-03-19 23:59:59', FALSE),
    ('770e8400-e29b-41d4-a716-446655441259', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-20 00:00:00', '2024-03-20 12:15:00', '2024-03-20 20:20:00', 'Tăng ca 5 phút', 5, 0, 0, '2024-03-20 23:59:59', FALSE);

--- bang OvertimeRequest
INSERT INTO OvertimeRequest (id, employeeId, date, requestedMinutes, reason, status, createdAt, updatedAt, isDeletad)
VALUES
    ('770e8400-e29b-41d4-a716-446655441230', 'cc0e8400-e29b-41d4-a716-446655441230', '2024-03-11 18:30:00', 120, 'Hoàn thành dự án gấp', 'PENDING', '2024-03-11 10:00:00', NULL, FALSE),
    ('770e8400-e29b-41d4-a716-446655441231', 'cc0e8400-e29b-41d4-a716-446655441231', '2024-03-12 19:00:00', 90, 'Hỗ trợ nhóm kiểm thử', 'APPROVED', '2024-03-12 11:00:00', '2024-03-12 14:00:00', FALSE),
    ('770e8400-e29b-41d4-a716-446655441232', 'cc0e8400-e29b-41d4-a716-446655441232', '2024-03-13 17:30:00', 60, 'Hoàn thiện báo cáo', 'REJECTED', '2024-03-13 12:00:00', '2024-03-13 15:00:00', FALSE),
    ('770e8400-e29b-41d4-a716-446655441233', 'cc0e8400-e29b-41d4-a716-446655441233', '2024-03-14 20:00:00', 150, 'Cập nhật hệ thống', 'PENDING', '2024-03-14 13:00:00', NULL, FALSE),
    ('770e8400-e29b-41d4-a716-446655441234', 'cc0e8400-e29b-41d4-a716-446655441234', '2024-03-15 21:30:00', 180, 'Khắc phục lỗi sản xuất', 'APPROVED', '2024-03-15 14:00:00', '2024-03-15 17:00:00', FALSE);

--- bang Table1
INSERT INTO Table1 (id, number, capacity, status, isDeleted)
VALUES
    ('880e8400-e29b-41d4-a716-446655441230', 'T01', 4, 'AVAILABLE', FALSE),
    ('880e8400-e29b-41d4-a716-446655441231', 'T02', 2, 'OCCUPIED', FALSE),
    ('880e8400-e29b-41d4-a716-446655441232', 'T03', 6, 'AVAILABLE', FALSE),
    ('880e8400-e29b-41d4-a716-446655441233', 'T04', 4, 'RESERVED', FALSE),
    ('880e8400-e29b-41d4-a716-446655441234', 'T05', 8, 'OCCUPIED', FALSE),
    ('880e8400-e29b-41d4-a716-446655441235', 'T06', 10, 'AVAILABLE', FALSE),
    ('880e8400-e29b-41d4-a716-446655441236', 'T07', 4, 'RESERVED', FALSE),
    ('880e8400-e29b-41d4-a716-446655441237', 'T08', 2, 'AVAILABLE', FALSE),
    ('880e8400-e29b-41d4-a716-446655441238', 'T09', 6, 'OCCUPIED', FALSE),
    ('880e8400-e29b-41d4-a716-446655441239', 'T10', 8, 'RESERVED', FALSE);

--- bang Order
INSERT INTO Order1 (id, userId, tableId, orderType, orderDate, totalAmount, shippingFee, taxAmount, status, couponId, earnedPoint, isDeleted)
VALUES
    ('990e8400-e29b-41d4-a716-446655441230', '880e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655441230', 'DINE_IN', '2024-03-01 12:00:00', 150.00, 0.00, 15.00, 'PENDING', '770e8400-e29b-41d4-a716-446655440000', 10, FALSE),
    ('990e8400-e29b-41d4-a716-446655441231', '880e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655441231', 'TAKEAWAY', '2024-03-02 13:30:00', 75.00, 0.00, 7.50, 'PROCESSING', '770e8400-e29b-41d4-a716-446655440001', 5, FALSE),
    ('990e8400-e29b-41d4-a716-446655441232', '880e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655441232', 'DELIVERY', '2024-03-03 14:45:00', 200.00, 20.00, 20.00, 'DELIVERED', '770e8400-e29b-41d4-a716-446655440002', 15, FALSE),
    ('990e8400-e29b-41d4-a716-446655441233', '880e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655441233', 'DINE_IN', '2024-03-04 19:00:00', 50.00, 0.00, 5.00, 'SERVED', '770e8400-e29b-41d4-a716-446655440003', 3, FALSE),
    ('990e8400-e29b-41d4-a716-446655441234', '880e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655441234', 'TAKEAWAY', '2024-03-05 20:15:00', 90.00, 0.00, 9.00, 'CANCELLED', '770e8400-e29b-41d4-a716-446655440004', 0, FALSE),
    ('990e8400-e29b-41d4-a716-446655441235', '880e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655441235', 'DELIVERY', '2024-03-06 11:20:00', 180.00, 15.00, 18.00, 'FAILED', '770e8400-e29b-41d4-a716-446655440005', 0, FALSE),
    ('990e8400-e29b-41d4-a716-446655441236', '880e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655441236', 'DINE_IN', '2024-03-07 15:30:00', 120.00, 0.00, 12.00, 'SERVED', '770e8400-e29b-41d4-a716-446655440006', 8, FALSE),
    ('990e8400-e29b-41d4-a716-446655441237', '880e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655441237', 'TAKEAWAY', '2024-03-08 17:45:00', 65.00, 0.00, 6.50, 'PROCESSING', '770e8400-e29b-41d4-a716-446655440007', 4, FALSE),
    ('990e8400-e29b-41d4-a716-446655441238', '880e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655441238', 'DELIVERY', '2024-03-09 21:00:00', 230.00, 25.00, 23.00, 'DELIVERED', '770e8400-e29b-41d4-a716-446655440008', 18, FALSE),
    ('990e8400-e29b-41d4-a716-446655441239', '880e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655441239', 'DINE_IN', '2024-03-10 12:15:00', 85.00, 0.00, 8.50, 'PENDING', '770e8400-e29b-41d4-a716-446655440009', 6, FALSE),
    ('990e8400-e29b-41d4-a716-446655441240', '880e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655441230', 'TAKEAWAY', '2024-03-11 14:20:00', 70.00, 0.00, 7.00, 'CANCELLED', NULL, 0, FALSE),
    ('990e8400-e29b-41d4-a716-446655441241', '880e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655441235', 'DELIVERY', '2024-03-12 16:45:00', 195.00, 18.00, 19.50, 'DELIVERED', NULL, 12, FALSE),
    ('990e8400-e29b-41d4-a716-446655441242', '880e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655441238', 'DINE_IN', '2024-03-13 18:30:00', 130.00, 0.00, 13.00, 'SERVED', NULL, 9, FALSE),
    ('990e8400-e29b-41d4-a716-446655441243', '880e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655441232', 'TAKEAWAY', '2024-03-14 20:00:00', 55.00, 0.00, 5.50, 'PROCESSING', NULL, 3, FALSE),
    ('990e8400-e29b-41d4-a716-446655441244', '880e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655441235', 'DELIVERY', '2024-03-15 22:00:00', 210.00, 22.00, 21.00, 'DELIVERED', NULL, 14, FALSE),
	('990e8400-e29b-41d4-a716-446655441245', '880e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655441235', 'DINE_IN', '2024-03-16 12:45:00', 110.00, 0.00, 11.00, 'PENDING', '770e8400-e29b-41d4-a716-446655440002', 7, FALSE),
    ('990e8400-e29b-41d4-a716-446655441246', '880e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655441236', 'TAKEAWAY', '2024-03-17 14:30:00', 95.00, 0.00, 9.50, 'PROCESSING', NULL, 5, FALSE),
    ('990e8400-e29b-41d4-a716-446655441247', '880e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655441237', 'DELIVERY', '2024-03-18 16:15:00', 250.00, 30.00, 25.00, 'DELIVERED', '770e8400-e29b-41d4-a716-446655440004', 20, FALSE),
    ('990e8400-e29b-41d4-a716-446655441248', '880e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655441238', 'DINE_IN', '2024-03-19 18:45:00', 145.00, 0.00, 14.50, 'SERVED', NULL, 10, FALSE),
    ('990e8400-e29b-41d4-a716-446655441249', '880e8400-e29b-41d4-a716-446655440006', '880e8400-e29b-41d4-a716-446655441239', 'TAKEAWAY', '2024-03-20 20:10:00', 85.00, 0.00, 8.50, 'CANCELLED', '770e8400-e29b-41d4-a716-446655440005', 0, FALSE),
    ('990e8400-e29b-41d4-a716-446655441250', '880e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655441230', 'DELIVERY', '2024-03-21 21:30:00', 195.00, 25.00, 19.50, 'RETURNED', '770e8400-e29b-41d4-a716-446655440006', 0, FALSE),
    ('990e8400-e29b-41d4-a716-446655441251', '880e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655441231', 'DINE_IN', '2024-03-22 11:15:00', 105.00, 0.00, 10.50, 'FAILED', NULL, 0, FALSE),
    ('990e8400-e29b-41d4-a716-446655441252', '880e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655441232', 'TAKEAWAY', '2024-03-23 13:40:00', 60.00, 0.00, 6.00, 'PROCESSING', '770e8400-e29b-41d4-a716-446655440007', 3, FALSE),
    ('990e8400-e29b-41d4-a716-446655441253', '880e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655441233', 'DELIVERY', '2024-03-24 15:55:00', 175.00, 20.00, 17.50, 'DELIVERED', '770e8400-e29b-41d4-a716-446655440008', 12, FALSE),
    ('990e8400-e29b-41d4-a716-446655441254', '880e8400-e29b-41d4-a716-446655440000', '880e8400-e29b-41d4-a716-446655441234', 'DINE_IN', '2024-03-25 18:20:00', 125.00, 0.00, 12.50, 'SERVED', '770e8400-e29b-41d4-a716-446655440009', 8, FALSE);

--- bang Reservation
INSERT INTO Reservation (id, userId, orderId, reservationTime, status, isDeleted)
VALUES
    ('aa0e8400-e29b-41d4-a716-446655441230', '880e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655441230', '2024-04-01 19:00:00', 'PENDING', FALSE),
    ('aa0e8400-e29b-41d4-a716-446655441231', '880e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655441236', '2024-04-02 12:30:00', 'CONFIRMED', FALSE),
    ('aa0e8400-e29b-41d4-a716-446655441232', '880e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655441238', '2024-04-03 18:15:00', 'CANCELLED', FALSE),
    ('aa0e8400-e29b-41d4-a716-446655441233', '880e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655441249', '2024-04-04 20:45:00', 'PENDING', FALSE),
    ('aa0e8400-e29b-41d4-a716-446655441234', '880e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655441252', '2024-04-05 14:00:00', 'CONFIRMED', FALSE);

--- bang Review
INSERT INTO Review (id, userId, orderId, rating, comment, createdAt)
VALUES
    ('bb0e8400-e29b-41d4-a716-446655441230', '880e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655441231', 5, 'Dịch vụ tuyệt vời, rất hài lòng!', '2024-04-01 20:15:00'),
    ('bb0e8400-e29b-41d4-a716-446655441231', '880e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655441235', 4, 'Món ăn ngon nhưng phục vụ hơi chậm.', '2024-04-02 13:45:00'),
    ('bb0e8400-e29b-41d4-a716-446655441232', '880e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655441246', 3, 'Không gian ổn nhưng món ăn chưa đúng khẩu vị.', '2024-04-03 19:30:00'),
    ('bb0e8400-e29b-41d4-a716-446655441233', '880e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655441251', 2, 'Quán đông quá nên đợi lâu, món ăn nguội.', '2024-04-04 21:00:00'),
    ('bb0e8400-e29b-41d4-a716-446655441234', '880e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655441252', 5, 'Mọi thứ đều hoàn hảo, sẽ quay lại lần nữa!', '2024-04-05 15:00:00');

--- bang Payment
INSERT INTO Payment (id, orderId, paymentDate, amount, method, status)
VALUES
    ('aa0e8400-e29b-41d4-a716-446655441230', '990e8400-e29b-41d4-a716-446655441230', '2024-03-01 12:05:00', 165.00, 'CREDIT_CARD', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441231', '990e8400-e29b-41d4-a716-446655441231', '2024-03-02 13:35:00', 82.50, 'CASH', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441232', '990e8400-e29b-41d4-a716-446655441232', '2024-03-03 14:50:00', 240.00, 'BANK_TRANSFER', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441233', '990e8400-e29b-41d4-a716-446655441233', '2024-03-04 19:05:00', 55.00, 'CASH', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441234', '990e8400-e29b-41d4-a716-446655441234', '2024-03-05 20:20:00', 99.00, 'CREDIT_CARD', 'REFUNDED'),
    ('aa0e8400-e29b-41d4-a716-446655441235', '990e8400-e29b-41d4-a716-446655441235', '2024-03-06 11:25:00', 213.00, 'BANK_TRANSFER', 'FAILED'),
    ('aa0e8400-e29b-41d4-a716-446655441236', '990e8400-e29b-41d4-a716-446655441236', '2024-03-07 15:35:00', 132.00, 'CASH', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441237', '990e8400-e29b-41d4-a716-446655441237', '2024-03-08 17:50:00', 71.50, 'CREDIT_CARD', 'PENDING'),
    ('aa0e8400-e29b-41d4-a716-446655441238', '990e8400-e29b-41d4-a716-446655441238', '2024-03-09 21:05:00', 278.00, 'BANK_TRANSFER', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441239', '990e8400-e29b-41d4-a716-446655441239', '2024-03-10 12:20:00', 93.50, 'CASH', 'PENDING'),
    ('aa0e8400-e29b-41d4-a716-446655441240', '990e8400-e29b-41d4-a716-446655441240', '2024-03-11 14:25:00', 77.00, 'CREDIT_CARD', 'REFUNDED'),
    ('aa0e8400-e29b-41d4-a716-446655441241', '990e8400-e29b-41d4-a716-446655441241', '2024-03-12 16:50:00', 232.50, 'BANK_TRANSFER', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441242', '990e8400-e29b-41d4-a716-446655441242', '2024-03-13 18:35:00', 143.00, 'CASH', 'COMPLETED'),
    ('aa0e8400-e29b-41d4-a716-446655441243', '990e8400-e29b-41d4-a716-446655441243', '2024-03-14 20:05:00', 60.50, 'CREDIT_CARD', 'PENDING'),
    ('aa0e8400-e29b-41d4-a716-446655441244', '990e8400-e29b-41d4-a716-446655441244', '2024-03-15 22:05:00', 251.00, 'BANK_TRANSFER', 'COMPLETED');

INSERT INTO Payment (id, orderId, paymentDate, amount, method, status) VALUES
    ('a90e8400-e29b-41d4-a716-446655441245', '990e8400-e29b-41d4-a716-446655441245', '2024-03-16 12:45:00', 110.00, 'CASH', 'PENDING'),
    ('a90e8400-e29b-41d4-a716-446655441246', '990e8400-e29b-41d4-a716-446655441246', '2024-03-17 14:30:00', 95.00, 'CREDIT_CARD', 'COMPLETED'),
    ('a90e8400-e29b-41d4-a716-446655441247', '990e8400-e29b-41d4-a716-446655441247', '2024-03-18 16:15:00', 250.00, 'BANK_TRANSFER', 'COMPLETED'),
    ('a90e8400-e29b-41d4-a716-446655441248', '990e8400-e29b-41d4-a716-446655441248', '2024-03-19 18:45:00', 145.00, 'CASH', 'COMPLETED'),
    ('a90e8400-e29b-41d4-a716-446655441249', '990e8400-e29b-41d4-a716-446655441249', '2024-03-20 20:10:00', 85.00, 'CREDIT_CARD', 'FAILED'),
    ('a90e8400-e29b-41d4-a716-446655441250', '990e8400-e29b-41d4-a716-446655441250', '2024-03-21 21:30:00', 195.00, 'BANK_TRANSFER', 'REFUNDED'),
    ('a90e8400-e29b-41d4-a716-446655441251', '990e8400-e29b-41d4-a716-446655441251', '2024-03-22 11:15:00', 105.00, 'CASH', 'FAILED'),
    ('a90e8400-e29b-41d4-a716-446655441252', '990e8400-e29b-41d4-a716-446655441252', '2024-03-23 13:40:00', 60.00, 'CREDIT_CARD', 'PENDING'),
    ('a90e8400-e29b-41d4-a716-446655441253', '990e8400-e29b-41d4-a716-446655441253', '2024-03-24 15:55:00', 175.00, 'BANK_TRANSFER', 'COMPLETED'),
    ('a90e8400-e29b-41d4-a716-446655441254', '990e8400-e29b-41d4-a716-446655441254', '2024-03-25 18:20:00', 125.00, 'CASH', 'COMPLETED');
--- bang Delivery
INSERT INTO Delivery (id, orderId, deliveryDate, status, carrier, trackingCode)
VALUES
    ('dd0e8400-e29b-41d4-a716-446655441230', '990e8400-e29b-41d4-a716-446655441230', '2024-04-01 10:30:00', 'DELIVERED', 'DHL', 'TRK1234567890'),
    ('dd0e8400-e29b-41d4-a716-446655441231', '990e8400-e29b-41d4-a716-446655441234', '2024-04-02 12:45:00', 'DELIVERED', 'FedEx', 'TRK2345678901'),
    ('dd0e8400-e29b-41d4-a716-446655441232', '990e8400-e29b-41d4-a716-446655441238', '2024-04-03 15:00:00', 'DELIVERED', 'UPS', 'TRK3456789012'),
    ('dd0e8400-e29b-41d4-a716-446655441233', '990e8400-e29b-41d4-a716-446655441242', '2024-04-04 18:20:00', 'DELIVERED', 'VNPost', 'TRK4567890123'),
    ('dd0e8400-e29b-41d4-a716-446655441234', '990e8400-e29b-41d4-a716-446655441248', '2024-04-05 20:10:00', 'DELIVERED', 'DHL', 'TRK5678901234'),
    ('dd0e8400-e29b-41d4-a716-446655441235', '990e8400-e29b-41d4-a716-446655441237', '2024-04-06 08:40:00', 'IN_TRANSIT', 'FedEx', 'TRK6789012345'),
    ('dd0e8400-e29b-41d4-a716-446655441236', '990e8400-e29b-41d4-a716-446655441240', '2024-04-07 14:25:00', 'PENDING', 'UPS', 'TRK7890123456'),
    ('dd0e8400-e29b-41d4-a716-446655441237', '990e8400-e29b-41d4-a716-446655441250', '2024-04-08 17:30:00', 'DELIVERED', 'VNPost', 'TRK8901234567');

--- bang Supplier
INSERT INTO Supplier (id, name, contact, address, isDeleted) VALUES
    ('b10e8400-e29b-41d4-a716-446655441201', 'Fresh Foods Co.', '0123456789', '123 Main Street, Hanoi', FALSE),
    ('b10e8400-e29b-41d4-a716-446655441202', 'Daily Dairy Ltd.', '0987654321', '456 Milk Road, Ho Chi Minh City', FALSE),
    ('b10e8400-e29b-41d4-a716-446655441203', 'Golden Grain Suppliers', '0345678901', '789 Rice Avenue, Da Nang', FALSE),
    ('b10e8400-e29b-41d4-a716-446655441204', 'Meat & More', '0765432109', '567 Meat Street, Can Tho', FALSE),
    ('b10e8400-e29b-41d4-a716-446655441205', 'Seafood World', '0654321987', '234 Ocean Road, Hai Phong', FALSE);

--- bang InventoryItem
INSERT INTO InventoryItem (id, name, category, quantity, unit, supplierId, updatedAt, isDeleted) VALUES
    ('e10e8400-e29b-41d4-a716-446655441501', 'Beef', 'MEAT', 100, 'kg', 'b10e8400-e29b-41d4-a716-446655441201', '2024-03-10 08:30:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441502', 'Chicken', 'MEAT', 200, 'kg', 'b10e8400-e29b-41d4-a716-446655441202', '2024-03-11 10:15:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441503', 'Carrot', 'VEGETABLE', 150, 'kg', 'b10e8400-e29b-41d4-a716-446655441203', '2024-03-12 12:00:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441504', 'Onion', 'VEGETABLE', 180, 'kg', 'b10e8400-e29b-41d4-a716-446655441204', '2024-03-13 14:20:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441505', 'Salt', 'SPICE', 250, 'kg', 'b10e8400-e29b-41d4-a716-446655441205', '2024-03-14 16:45:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441506', 'Pepper', 'SPICE', 120, 'kg', 'b10e8400-e29b-41d4-a716-446655441201', '2024-03-15 18:10:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441507', 'Milk', 'DAIRY', 300, 'liters', 'b10e8400-e29b-41d4-a716-446655441202', '2024-03-16 20:00:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441508', 'Cheese', 'DAIRY', 80, 'kg', 'b10e8400-e29b-41d4-a716-446655441203', '2024-03-17 21:35:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441509', 'Orange Juice', 'BEVERAGE', 150, 'liters', 'b10e8400-e29b-41d4-a716-446655441204', '2024-03-18 09:50:00', FALSE),
    ('e10e8400-e29b-41d4-a716-446655441510', 'Coffee', 'BEVERAGE', 200, 'kg', 'b10e8400-e29b-41d4-a716-446655441205', '2024-03-19 11:15:00', FALSE);

--- bang InventoryTransaction
INSERT INTO InventoryTransaction (id, inventoryItemId, transactionType, quantity, price, timestamp) VALUES
    ('f10e8400-e29b-41d4-a716-446655441601', 'e10e8400-e29b-41d4-a716-446655441510', 'IMPORT', 50, 200.00, '2024-03-10 09:00:00'),
    ('f10e8400-e29b-41d4-a716-446655441602', 'e10e8400-e29b-41d4-a716-446655441501', 'IMPORT', 20, 80.00, '2024-03-11 11:30:00'),
    ('f10e8400-e29b-41d4-a716-446655441603', 'e10e8400-e29b-41d4-a716-446655441502', 'IMPORT', 100, 300.00, '2024-03-12 14:15:00'),
    ('f10e8400-e29b-41d4-a716-446655441604', 'e10e8400-e29b-41d4-a716-446655441503', 'IMPORT', 30, 90.00, '2024-03-13 16:45:00'),
    ('f10e8400-e29b-41d4-a716-446655441605', 'e10e8400-e29b-41d4-a716-446655441504', 'EXPORT', 75, 150.00, '2024-03-14 18:20:00'),
    ('f10e8400-e29b-41d4-a716-446655441606', 'e10e8400-e29b-41d4-a716-446655441505', 'EXPORT', 40, 120.00, '2024-03-15 20:00:00'),
    ('f10e8400-e29b-41d4-a716-446655441607', 'e10e8400-e29b-41d4-a716-446655441502', 'IMPORT', 90, 270.00, '2024-03-16 08:30:00'),
    ('f10e8400-e29b-41d4-a716-446655441608', 'e10e8400-e29b-41d4-a716-446655441507', 'IMPORT', 25, 75.00, '2024-03-17 10:45:00'),
    ('f10e8400-e29b-41d4-a716-446655441609', 'e10e8400-e29b-41d4-a716-446655441508', 'IMPORT', 60, 180.00, '2024-03-18 12:15:00'),
    ('f10e8400-e29b-41d4-a716-446655441610', 'e10e8400-e29b-41d4-a716-446655441509', 'EXPORT', 35, 105.00, '2024-03-19 14:00:00');

INSERT INTO InventoryTransaction (id, inventoryItemId, transactionType, quantity, price, timestamp) VALUES
    ('f10e8400-e29b-41d4-a716-446655441611', 'e10e8400-e29b-41d4-a716-446655441501', 'IMPORT', 120, 400.00, '2024-03-20 09:30:00'),
    ('f10e8400-e29b-41d4-a716-446655441612', 'e10e8400-e29b-41d4-a716-446655441506', 'EXPORT', 45, 160.00, '2024-03-21 11:00:00'),
    ('f10e8400-e29b-41d4-a716-446655441613', 'e10e8400-e29b-41d4-a716-446655441502', 'IMPORT', 200, 600.00, '2024-03-22 13:45:00'),
    ('f10e8400-e29b-41d4-a716-446655441614', 'e10e8400-e29b-41d4-a716-446655441508', 'EXPORT', 70, 250.00, '2024-03-23 15:30:00'),
    ('f10e8400-e29b-41d4-a716-446655441615', 'e10e8400-e29b-41d4-a716-446655441505', 'IMPORT', 90, 310.00, '2024-03-24 17:15:00');


--- bang MenuCategory
INSERT INTO MenuCategory (id, name, isDeleted) VALUES
    ('c10e8400-e29b-41d4-a716-446655441701', 'Appetizers', FALSE),
    ('c10e8400-e29b-41d4-a716-446655441702', 'Main Course', FALSE),
    ('c10e8400-e29b-41d4-a716-446655441703', 'Desserts', FALSE);

--- bang MenuItem
INSERT INTO MenuItem (id, name, description, price, imageUrl, categoryId, isAvailable, isDeleted) VALUES
    ('100e8400-e29b-41d4-a716-446655441801', 'Spring Rolls', 'Fresh Vietnamese spring rolls with shrimp and vegetables.', 5.99, 'https://example.com/spring_rolls.jpg', 'c10e8400-e29b-41d4-a716-446655441701', TRUE, FALSE),
    ('100e8400-e29b-41d4-a716-446655441802', 'Garlic Bread', 'Toasted bread with garlic and butter.', 3.99, 'https://example.com/garlic_bread.jpg', 'c10e8400-e29b-41d4-a716-446655441701', TRUE, FALSE),
    
    ('100e8400-e29b-41d4-a716-446655441803', 'Grilled Salmon', 'Salmon fillet grilled with lemon and herbs.', 15.99, 'https://example.com/grilled_salmon.jpg', 'c10e8400-e29b-41d4-a716-446655441702', TRUE, FALSE),
    ('100e8400-e29b-41d4-a716-446655441804', 'Beef Steak', 'Juicy grilled beef steak served with vegetables.', 18.99, 'https://example.com/beef_steak.jpg', 'c10e8400-e29b-41d4-a716-446655441702', TRUE, FALSE),
    ('100e8400-e29b-41d4-a716-446655441805', 'Vegetable Pasta', 'Pasta with a mix of fresh vegetables and creamy sauce.', 12.99, 'https://example.com/vegetable_pasta.jpg', 'c10e8400-e29b-41d4-a716-446655441702', TRUE, FALSE),

    ('100e8400-e29b-41d4-a716-446655441806', 'Chocolate Cake', 'Rich and moist chocolate cake with dark chocolate glaze.', 7.99, 'https://example.com/chocolate_cake.jpg', 'c10e8400-e29b-41d4-a716-446655441703', TRUE, FALSE),
    ('100e8400-e29b-41d4-a716-446655441807', 'Cheesecake', 'Creamy cheesecake with a graham cracker crust.', 6.99, 'https://example.com/cheesecake.jpg', 'c10e8400-e29b-41d4-a716-446655441703', TRUE, FALSE),
    ('100e8400-e29b-41d4-a716-446655441808', 'Fruit Salad', 'A fresh mix of seasonal fruits.', 4.99, 'https://example.com/fruit_salad.jpg', 'c10e8400-e29b-41d4-a716-446655441703', TRUE, FALSE);

--- bang Recipeingredient
INSERT INTO RecipeIngredient (id, menuItemId, inventoryItemId, quantity, unit) VALUES
    -- Spring Rolls
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd1', '100e8400-e29b-41d4-a716-446655441801', 'e10e8400-e29b-41d4-a716-446655441501', 2, 'pcs'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd2', '100e8400-e29b-41d4-a716-446655441802', 'e10e8400-e29b-41d4-a716-446655441501', 50, 'g'),
    
    -- Garlic Bread
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd3', '100e8400-e29b-41d4-a716-446655441801', 'e10e8400-e29b-41d4-a716-446655441502', 1, 'loaf'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd4', '100e8400-e29b-41d4-a716-446655441803', 'e10e8400-e29b-41d4-a716-446655441503', 10, 'g'),
    
    -- Grilled Salmon
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd5', '100e8400-e29b-41d4-a716-446655441802', 'e10e8400-e29b-41d4-a716-446655441504', 200, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd6', '100e8400-e29b-41d4-a716-446655441805', 'e10e8400-e29b-41d4-a716-446655441505', 5, 'ml'),
    
    -- Beef Steak
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd7', '100e8400-e29b-41d4-a716-446655441802', 'e10e8400-e29b-41d4-a716-446655441506', 250, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd8', '100e8400-e29b-41d4-a716-446655441804', 'e10e8400-e29b-41d4-a716-446655441507', 30, 'g'),
    
    -- Vegetable Pasta
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bd9', '100e8400-e29b-41d4-a716-446655441801', 'e10e8400-e29b-41d4-a716-446655441508', 150, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bda', '100e8400-e29b-41d4-a716-446655441805', 'e10e8400-e29b-41d4-a716-446655441509', 80, 'g'),
    
    -- Chocolate Cake
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bdb', '100e8400-e29b-41d4-a716-446655441807', 'e10e8400-e29b-41d4-a716-446655441503', 200, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bdc', '100e8400-e29b-41d4-a716-446655441808', 'e10e8400-e29b-41d4-a716-446655441501', 100, 'g'),

    -- Cheesecake
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bdd', '100e8400-e29b-41d4-a716-446655441806', 'e10e8400-e29b-41d4-a716-446655441502', 180, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bde', '100e8400-e29b-41d4-a716-446655441808', 'e10e8400-e29b-41d4-a716-446655441503', 50, 'g'),
    
    -- Fruit Salad
    ('3eded1ee-bf09-4fd3-915c-42e6eec23bdf', '100e8400-e29b-41d4-a716-446655441803', 'e10e8400-e29b-41d4-a716-446655441504', 120, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23be0', '100e8400-e29b-41d4-a716-446655441805', 'e10e8400-e29b-41d4-a716-446655441505', 50, 'g'),
    ('3eded1ee-bf09-4fd3-915c-42e6eec23be1', '100e8400-e29b-41d4-a716-446655441802', 'e10e8400-e29b-41d4-a716-446655441506', 70, 'g');

--- bang OrderItem
INSERT INTO OrderItem (id, orderId, menuItemId, quantity, price) VALUES
    ('efa1d074-0aaf-4960-a34f-27f4bb5eac55', '990e8400-e29b-41d4-a716-446655441230', '100e8400-e29b-41d4-a716-446655441801', 2, 5.99),
    ('6f6a987d-4f83-4e3a-953a-ee0ca2d91c15', '990e8400-e29b-41d4-a716-446655441232', '100e8400-e29b-41d4-a716-446655441802', 1, 3.99),
    ('96308ba1-3fa6-43bc-8851-c260aee64427', '990e8400-e29b-41d4-a716-446655441231', '100e8400-e29b-41d4-a716-446655441803', 1, 15.99),
    ('fe1b8ef5-673a-410b-90b2-8e60bfec5428', '990e8400-e29b-41d4-a716-446655441234', '100e8400-e29b-41d4-a716-446655441804', 2, 18.99),
    ('9f7df38e-b8c4-46ba-abf0-21ff4402ca37', '990e8400-e29b-41d4-a716-446655441236', '100e8400-e29b-41d4-a716-446655441805', 3, 12.99),
    ('b78f2578-c8f8-4936-ab37-570cbffb9ccd', '990e8400-e29b-41d4-a716-446655441235', '100e8400-e29b-41d4-a716-446655441806', 1, 7.99),
    ('f9dd90cd-b9e9-483a-910f-1fd84f40f760', '990e8400-e29b-41d4-a716-446655441238', '100e8400-e29b-41d4-a716-446655441807', 2, 6.99),
    ('78f0c13a-2059-4f45-9d85-d8d9cdb2a87b', '990e8400-e29b-41d4-a716-446655441239', '100e8400-e29b-41d4-a716-446655441808', 1, 4.99),
    ('7b1aca9a-c13c-44ad-a73d-c9c1aed5551c', '990e8400-e29b-41d4-a716-446655441236', '100e8400-e29b-41d4-a716-446655441801', 3, 5.99),
    ('e5509301-fba1-4969-8e2b-2f1a17f7be9b', '990e8400-e29b-41d4-a716-446655441232', '100e8400-e29b-41d4-a716-446655441802', 2, 3.99),
    ('bc6b3cc6-02ff-4ebc-88a1-ae97035034f3', '990e8400-e29b-41d4-a716-446655441236', '100e8400-e29b-41d4-a716-446655441803', 1, 15.99),
    ('234dd292-6527-4fa5-9a56-a04fcd53f13a', '990e8400-e29b-41d4-a716-446655441240', '100e8400-e29b-41d4-a716-446655441804', 2, 18.99),
    ('dc213557-126d-49df-9aef-95e316c2e09c', '990e8400-e29b-41d4-a716-446655441245', '100e8400-e29b-41d4-a716-446655441805', 1, 12.99),
    ('f094b539-212e-40bb-b6e2-af3fd2f22649', '990e8400-e29b-41d4-a716-446655441242', '100e8400-e29b-41d4-a716-446655441806', 1, 7.99),
    ('838387d9-1d96-46d0-8c2b-b7d4d4db1197', '990e8400-e29b-41d4-a716-446655441248', '100e8400-e29b-41d4-a716-446655441807', 3, 6.99),
    ('afc244c8-26ad-4d26-9bfa-8e6f73c17b27', '990e8400-e29b-41d4-a716-446655441246', '100e8400-e29b-41d4-a716-446655441808', 2, 4.99),
	('b1c52a4d-d76b-4bbd-bfaa-da4a6576e2db', '990e8400-e29b-41d4-a716-446655441247', '100e8400-e29b-41d4-a716-446655441801', 3, 5.99),
    ('673e5c10-4040-4a77-b802-24df1bebcec0', '990e8400-e29b-41d4-a716-446655441246', '100e8400-e29b-41d4-a716-446655441802', 2, 3.99),
    ('70444f0f-4c93-4360-ae45-e6baae257157', '990e8400-e29b-41d4-a716-446655441247', '100e8400-e29b-41d4-a716-446655441803', 1, 15.99),
    ('c429cf5a-b042-4d44-a08a-dd1c62a6318d', '990e8400-e29b-41d4-a716-446655441248', '100e8400-e29b-41d4-a716-446655441804', 2, 18.99),

	('efa1d074-0aaf-4960-a34f-27f4bb5eac56', '990e8400-e29b-41d4-a716-446655441254', '100e8400-e29b-41d4-a716-446655441805', 2, 6.99),
    ('6f6a987d-4f83-4e3a-953a-ee0ca2d91c16', '990e8400-e29b-41d4-a716-446655441250', '100e8400-e29b-41d4-a716-446655441806', 1, 7.99),
    ('96308ba1-3fa6-43bc-8851-c260aee64426', '990e8400-e29b-41d4-a716-446655441248', '100e8400-e29b-41d4-a716-446655441807', 1, 25.99),
    ('fe1b8ef5-673a-410b-90b2-8e60bfec5422', '990e8400-e29b-41d4-a716-446655441240', '100e8400-e29b-41d4-a716-446655441808', 2, 28.99),
    ('9f7df38e-b8c4-46ba-abf0-21ff4402ca31', '990e8400-e29b-41d4-a716-446655441241', '100e8400-e29b-41d4-a716-446655441805', 3, 12.99),
    ('b78f2578-c8f8-4936-ab37-570cbffb9cc1', '990e8400-e29b-41d4-a716-446655441242', '100e8400-e29b-41d4-a716-446655441806', 1, 5.99),
    ('f9dd90cd-b9e9-483a-910f-1fd84f40f765', '990e8400-e29b-41d4-a716-446655441243', '100e8400-e29b-41d4-a716-446655441807', 2, 9.99),
    ('78f0c13a-2059-4f45-9d85-d8d9cdb2a874', '990e8400-e29b-41d4-a716-446655441244', '100e8400-e29b-41d4-a716-446655441808', 1, 12.99),
    ('7b1aca9a-c13c-44ad-a73d-c9c1aed55511', '990e8400-e29b-41d4-a716-446655441245', '100e8400-e29b-41d4-a716-446655441801', 3, 1.99),
    ('e5509301-fba1-4969-8e2b-2f1a17f7be95', '990e8400-e29b-41d4-a716-446655441246', '100e8400-e29b-41d4-a716-446655441802', 2, 3.99),
    ('bc6b3cc6-02ff-4ebc-88a1-ae97035034f8', '990e8400-e29b-41d4-a716-446655441247', '100e8400-e29b-41d4-a716-446655441803', 1, 15.99),
    ('234dd292-6527-4fa5-9a56-a04fcd53f134', '990e8400-e29b-41d4-a716-446655441248', '100e8400-e29b-41d4-a716-446655441804', 2, 18.99),
    ('dc213557-126d-49df-9aef-95e316c2e096', '990e8400-e29b-41d4-a716-446655441249', '100e8400-e29b-41d4-a716-446655441805', 1, 12.99),
    ('f094b539-212e-40bb-b6e2-af3fd2f22645', '990e8400-e29b-41d4-a716-446655441230', '100e8400-e29b-41d4-a716-446655441806', 1, 17.99),
    ('4bdb195d-ea71-4ac9-acb9-480ac7db6092', '990e8400-e29b-41d4-a716-446655441239', '100e8400-e29b-41d4-a716-446655441807', 3, 13.99),
    ('afc244c8-26ad-4d26-9bfa-8e6f73c17b29', '990e8400-e29b-41d4-a716-446655441238', '100e8400-e29b-41d4-a716-446655441808', 2, 19.99),
	('b1c52a4d-d76b-4bbd-bfaa-da4a6576e2d0', '990e8400-e29b-41d4-a716-446655441248', '100e8400-e29b-41d4-a716-446655441801', 3, 15.99),
    ('673e5c10-4040-4a77-b802-24df1bebcec3', '990e8400-e29b-41d4-a716-446655441253', '100e8400-e29b-41d4-a716-446655441802', 2, 32.99),
    ('70444f0f-4c93-4360-ae45-e6baae257159', '990e8400-e29b-41d4-a716-446655441254', '100e8400-e29b-41d4-a716-446655441803', 1, 15.99),
    ('c429cf5a-b042-4d44-a08a-dd1c62a63181', '990e8400-e29b-41d4-a716-446655441251', '100e8400-e29b-41d4-a716-446655441804', 2, 18.99);

-------------
----- PROCEDURE
--- 1. Thêm customer
CREATE OR REPLACE PROCEDURE add_user(
    p_name VARCHAR(100),
    p_password VARCHAR(512),
    p_email VARCHAR(50),
    p_phone VARCHAR(15),
    p_address VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_id UUID;
    encrypted_password TEXT;
BEGIN
    -- Kiểm tra email/phone đã tồn tại chưa (tốt hơn là dùng unique constraint)
    IF EXISTS (SELECT 1 FROM User1 WHERE email = p_email OR phone = p_phone) THEN
        RAISE EXCEPTION 'Email or phone number already exists';
    END IF;
    
    -- Generate new UUID
    new_id := gen_random_uuid();
  
    -- Insert new user
    INSERT INTO User1 (
        id, name, password, email, phone, address, 
        isAdmin, isEmployee, isActive, createdAt, 
        userTier, point, isDeleted
    )
    VALUES (
        new_id, 
        p_name, 
        p_password, -- encrypted_password mã hóa ở đây
        p_email, 
        p_phone, 
        p_address,
        FALSE, FALSE, TRUE, CURRENT_TIMESTAMP,
        'BRONZE', 0, FALSE
    );
    
    RAISE NOTICE 'User created with ID: %', new_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Email or phone number already exists';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating user: %', SQLERRM;
END;
$$;

--- 2. Thêm Employee*
CREATE OR REPLACE PROCEDURE add_employee(
  p_userId UUID,
  p_role Role,
  p_employmentType EmploymentType,
  p_employmentStatus EmploymentStatus
)
LANGUAGE plpgsql
AS $$
DECLARE new_em_id uuid;
BEGIN
    -- Generate new UUID
    SELECT gen_random_uuid() INTO new_em_id;

    INSERT INTO Employee (
        id, userId, salary, hourlyRate, hireDate, role, employmentType, employmentStatus, isDeleted
    ) VALUES (
        new_em_id, p_userId, 0, 0, CURRENT_TIMESTAMP, p_role, p_employmentType, p_employmentStatus, FALSE
    );

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Employee ID already exists';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating employee: %', SQLERRM;
END;
$$;

---3. In ra danh sách khách hàng (User)
CREATE OR REPLACE FUNCTION get_customers()
RETURNS TABLE (
    Id UUID,
    Name VARCHAR(500),
    Email VARCHAR(500),
    Phone VARCHAR(500),
    UserTier VARCHAR(50),
	createdAt TIMESTAMP,
	point INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.Id as ID,
        u.Name,
        u.email,
        u.phone,
        u.userTier::varchar,
		u.createdAt,
		u.point
    FROM User1 u
    WHERE u.isAdmin = false 
        AND u.isEmployee = false
        AND u.isDeleted = false
	ORDER BY u.name;
END;
$$ LANGUAGE plpgsql;
--text thử funtion
SELECT * FROM get_customers();

---4. In ra danh sách nhân viên theo từng loại nhân viên
CREATE OR REPLACE FUNCTION get_employees_by_role(role_filter Role DEFAULT NULL)
RETURNS TABLE (
    employee_id UUID,
    name VARCHAR(100),
    email VARCHAR(50),
    phone VARCHAR(15),
    role Role,
    employment_type EmploymentType,
    employment_status EmploymentStatus,
    hire_date TIMESTAMP,
    salary DECIMAL(12,2),
    hourly_rate DECIMAL(12,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id AS employee_id,
        u.name,
        u.email,
        u.phone,
        e.role,
        e.employmentType AS employment_type,
        e.employmentStatus AS employment_status,
        e.hireDate AS hire_date,
        e.salary,
        e.hourlyRate AS hourly_rate
    FROM 
        Employee e
    JOIN 
        User1 u ON e.userId = u.id
    WHERE 
        e.isDeleted = FALSE
        AND (role_filter IS NULL OR e.role = role_filter)
    ORDER BY 
        e.role,
        u.name;
END;
$$ LANGUAGE plpgsql;

---5. Cập nhật thông tin người dùng
CREATE OR REPLACE FUNCTION UpdateUserInfo(
    p_updatingUserId UUID,     -- Người đang thực hiện việc cập nhật
    p_targetUserId UUID,       -- Người bị cập nhật thông tin
    p_name VARCHAR(100),
    p_email VARCHAR(50),
    p_phone VARCHAR(15),
    p_address VARCHAR(255),
    p_isAdmin BOOLEAN,
    p_isEmployee BOOLEAN,
    p_isActive BOOLEAN,
    p_userTier UserTier,
    p_point INT
)
RETURNS VOID AS $$
DECLARE
    updatingUserIsAdmin BOOLEAN;
BEGIN
    -- Kiểm tra xem người cập nhật có phải là admin không
    SELECT isAdmin INTO updatingUserIsAdmin FROM User1 WHERE id = p_updatingUserId;

    IF updatingUserIsAdmin THEN
        -- Admin có thể cập nhật tất cả các trường
        UPDATE User1
        SET
            name = p_name,
            email = p_email,
            phone = p_phone,
            address = p_address,
            isAdmin = p_isAdmin,
            isEmployee = p_isEmployee,
            isActive = p_isActive,
            userTier = p_userTier,
            updatedAt = NOW(),
			point = p_point
        WHERE id = p_targetUserId AND isDeleted = FALSE;
    ELSE
        -- Người dùng thường chỉ cập nhật thông tin cá nhân của chính mình
        UPDATE User1
        SET
            name = p_name,
            email = p_email,
            phone = p_phone,
            address = p_address,
            updatedAt = NOW()
        WHERE id = p_targetUserId AND id = p_updatingUserId AND isDeleted = FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

---6. danh sách lịch làm việc của 1 nhân viên theo employeeId
CREATE OR REPLACE FUNCTION GetWorkScheduleByEmployeeId(p_employeeId UUID)
RETURNS TABLE (
    ScheduleId UUID,
    WorkDate TIMESTAMP,
    ShiftTemplateName VARCHAR(50),
    ShiftType VARCHAR(50),
    StartTime VARCHAR(15),
    EndTime VARCHAR(15),
    ShiftStart TIMESTAMP,
    ShiftEnd TIMESTAMP,
    CreatedAt TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ws.id AS ScheduleId,
        ws.date AS WorkDate,
        st.name AS ShiftTemplateName,
        st.shiftType AS ShiftType,
        st.startTime AS StartTime,
        st.endTime AS EndTime,
        ws.shiftStart AS ShiftStart,
        ws.shiftEnd AS ShiftEnd,
        ws.createdAt AS CreatedAt
    FROM WorkSchedule ws
    JOIN ShiftTemplate st ON ws.shiftTemplateId = st.id
    WHERE ws.employeeId = p_employeeId
      AND ws.isDeleted = FALSE;
END;
$$ LANGUAGE plpgsql;

--- 7. Quy trình yêu cầu nghỉ phép
CREATE OR REPLACE PROCEDURE process_leave_request(
    p_leave_request_id UUID,
    p_status LeaveStatus
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_employee_id UUID;
    v_start_date TIMESTAMP;
    v_end_date TIMESTAMP;
BEGIN
    -- Get leave request details
    SELECT employeeId, startDate, endDate
    INTO v_employee_id, v_start_date, v_end_date
    FROM LeaveRequest
    WHERE id = p_leave_request_id;
    
    IF v_employee_id IS NULL THEN
        RAISE EXCEPTION 'Leave request not found';
    END IF;
    
    -- Update leave request status
    UPDATE LeaveRequest
    SET status = p_status,
        updatedAt = CURRENT_TIMESTAMP
    WHERE id = p_leave_request_id;
    
    -- If approved, update employee status and remove from work schedule
    IF p_status = 'APPROVED' THEN
        -- Update employee status to ON_LEAVE
        UPDATE Employee
        SET employmentStatus = 'ON_LEAVE'
        WHERE id = v_employee_id;
        
        -- Mark scheduling conflicts as deleted
        UPDATE WorkSchedule
        SET isDeleted = TRUE
        WHERE employeeId = v_employee_id
          AND date >= v_start_date::DATE
          AND date <= v_end_date::DATE;
          
        RAISE NOTICE 'Leave approved for employee % from % to %',
                     v_employee_id, v_start_date, v_end_date;
    ELSE
        RAISE NOTICE 'Leave request % %', p_leave_request_id, p_status;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error processing leave request: %', SQLERRM;
END;
$$;

--- 8. Tạo chấm công nhân viên
CREATE OR REPLACE PROCEDURE record_employee_attendance(
    p_employee_id UUID,
    p_check_in TIMESTAMP,
    p_check_out TIMESTAMP,
    p_notes VARCHAR(255) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_scheduled_shift_start TIMESTAMP;
    v_scheduled_shift_end TIMESTAMP;
    v_work_date DATE := p_check_in::DATE;
    v_late_minutes INT := 0;
    v_early_departure_minutes INT := 0;
    v_overtime_minutes INT := 0;
BEGIN
    -- Get scheduled shift times
    SELECT shiftStart, shiftEnd
    INTO v_scheduled_shift_start, v_scheduled_shift_end
    FROM WorkSchedule
    WHERE employeeId = p_employee_id
      AND date = v_work_date;
      
    -- Calculate late minutes
    IF p_check_in > v_scheduled_shift_start THEN
        v_late_minutes := EXTRACT(EPOCH FROM (p_check_in - v_scheduled_shift_start)) / 60;
    END IF;
    
    -- Calculate early departure
    IF p_check_out < v_scheduled_shift_end THEN
        v_early_departure_minutes := EXTRACT(EPOCH FROM (v_scheduled_shift_end - p_check_out)) / 60;
    END IF;
    
    -- Calculate overtime
    IF p_check_out > v_scheduled_shift_end THEN
        v_overtime_minutes := EXTRACT(EPOCH FROM (p_check_out - v_scheduled_shift_end)) / 60;
    END IF;
    
    -- Record attendance
    INSERT INTO Attendance (
        id, employeeId, workDate, checkIn, checkOut, notes,
        overtimeMinutes, lateMinutes, earlyDepartureMinutes,
        createdAt, isDeleted
    )
    VALUES (
        gen_random_uuid(), p_employee_id, v_work_date, p_check_in, p_check_out, p_notes,
        v_overtime_minutes, v_late_minutes, v_early_departure_minutes,
        CURRENT_TIMESTAMP, FALSE
    );
    
    RAISE NOTICE 'Attendance recorded for employee % on %', p_employee_id, v_work_date;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error recording attendance: %', SQLERRM;
END;
$$;

---9.  Xem thông tin chấm công
CREATE OR REPLACE FUNCTION GetAttendanceByEmployee(
    p_employeeId UUID,
    p_startDate TIMESTAMP DEFAULT NULL,
    p_endDate TIMESTAMP DEFAULT NULL
)
RETURNS TABLE (
    AttendanceId UUID,
    WorkDate DATE,
    CheckIn TIMESTAMP,
    CheckOut TIMESTAMP,
    Notes VARCHAR(255),
    OvertimeMinutes INT,
    LateMinutes INT,
    EarlyDepartureMinutes INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id::UUID AS AttendanceId,
        a.workDate::DATE AS WorkDate,
        a.checkIn::TIMESTAMP AS CheckIn,
        a.checkOut::TIMESTAMP AS CheckOut,
        a.notes::VARCHAR(255) AS Notes,
        a.overtimeMinutes::INT AS OvertimeMinutes,
        a.lateMinutes::INT AS LateMinutes,
        a.earlyDepartureMinutes::INT AS EarlyDepartureMinutes
    FROM Attendance a
    WHERE 
        a.employeeId = p_employeeId
        AND a.isDeleted = FALSE
        AND (p_startDate IS NULL OR a.workDate >= p_startDate)
        AND (p_endDate IS NULL OR a.workDate <= p_endDate)
    ORDER BY a.workDate DESC;
END;
$$ LANGUAGE plpgsql;

---10. Tạo và chỉ định lịch làm việc cho nhân viên
CREATE OR REPLACE PROCEDURE create_employee_schedule(
    p_employee_id UUID,
    p_start_date DATE,
    p_end_date DATE,
    p_shift_template_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_date DATE := p_start_date;
    v_shift_start VARCHAR(15);
    v_shift_end VARCHAR(15);
BEGIN
    -- Get shift template details
    SELECT startTime, endTime 
    INTO v_shift_start, v_shift_end
    FROM ShiftTemplate 
    WHERE id = p_shift_template_id;
    
    IF v_shift_start IS NULL THEN
        RAISE EXCEPTION 'Shift template not found';
    END IF;
    
    -- Loop through each day in the date range
    WHILE v_current_date <= p_end_date LOOP
        -- Create schedule entry
        INSERT INTO WorkSchedule (
            id, employeeId, date, shiftTemplateId, 
            shiftStart, shiftEnd, createdAt, isDeleted
        )
        VALUES (
            gen_random_uuid(), p_employee_id, v_current_date, p_shift_template_id,
            v_current_date + v_shift_start::TIME, v_current_date + v_shift_end::TIME, 
            CURRENT_TIMESTAMP, FALSE
        );
        
        -- Move to next day
        v_current_date := v_current_date + INTERVAL '1 day';
    END LOOP;
    
    RAISE NOTICE 'Schedule created for employee % from % to %', 
                 p_employee_id, p_start_date, p_end_date;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating schedule: %', SQLERRM;
END;
$$;

--- 11. Tạo bảng lương hàng tháng
CREATE OR REPLACE PROCEDURE generate_payroll(
    p_month INT,
    p_year INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    r_employee RECORD;
    v_start_date DATE;
    v_end_date DATE;
    v_worked_hours DECIMAL(10,2);
    v_standard_hours INT;
    v_overtime_hours DECIMAL(10,2);
    v_overtime_pay DECIMAL(12,2);
    v_net_salary DECIMAL(12,2);
BEGIN
    -- Set date range for the month
    v_start_date := make_date(p_year, p_month, 1);
    v_end_date := (v_start_date + INTERVAL '1 month') - INTERVAL '1 day';
    
    -- Process for each active employee
    FOR r_employee IN (
        SELECT e.id, e.salary, e.hourlyRate
        FROM Employee e
        WHERE e.employmentStatus = 'ACTIVE'
    )
    LOOP
        -- Calculate worked hours from attendance records
        SELECT COALESCE(SUM(
            EXTRACT(EPOCH FROM (checkOut - checkIn)) / 3600
        ), 0) INTO v_worked_hours
        FROM Attendance
        WHERE employeeId = r_employee.id
          AND workDate BETWEEN v_start_date AND v_end_date;
        
        -- Standard hours (assumes 8 hours/day, 22 working days)
        v_standard_hours := 8 * 22;
        
        -- Calculate overtime
        IF v_worked_hours > v_standard_hours THEN
            v_overtime_hours := v_worked_hours - v_standard_hours;
        ELSE
            v_overtime_hours := 0;
        END IF;
        
        -- Calculate overtime pay (1.5x hourly rate)
        v_overtime_pay := v_overtime_hours * r_employee.hourlyRate * 1.5;
        
        -- Calculate net salary (base salary + overtime)
        IF r_employee.salary IS NOT NULL THEN
            -- Salaried employee
            v_net_salary := r_employee.salary + v_overtime_pay;
        ELSE
            -- Hourly employee
            v_net_salary := (v_worked_hours - v_overtime_hours) * r_employee.hourlyRate + v_overtime_pay;
        END IF;
        
        -- Create payroll record
        INSERT INTO Payroll (
            id, employeeId, baseSalary, hourlyRate, workedHours,
            standardHours, overtimePay, deductions, netSalary, createdAt
        )
        VALUES (
            gen_random_uuid(), r_employee.id, r_employee.salary, r_employee.hourlyRate, 
            v_worked_hours, v_standard_hours, v_overtime_pay, 0, v_net_salary, CURRENT_TIMESTAMP
        );
        
    END LOOP;
    
    RAISE NOTICE 'Payroll generated for % %', p_month, p_year;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error generating payroll: %', SQLERRM;
END;
$$;

--12. Thêm Reservation
CREATE OR REPLACE PROCEDURE add_reservation(
    p_user_id UUID,
    p_reservation_time TIMESTAMP,
    p_table_id UUID,
    p_party_size INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_reservation_id UUID;
    v_table_capacity INT;
BEGIN
    -- Check table capacity
    SELECT capacity INTO v_table_capacity
    FROM Table1 
    WHERE id = p_table_id AND status = 'AVAILABLE';
    
    IF v_table_capacity IS NULL THEN
        RAISE EXCEPTION 'Table not found or not available';
    END IF;
    
    IF v_table_capacity < p_party_size THEN
        RAISE EXCEPTION 'Table capacity (%) is less than party size (%)', 
                        v_table_capacity, p_party_size;
    END IF;
    
    -- Generate new UUID
    SELECT gen_random_uuid() INTO new_reservation_id;
    
    -- Create the reservation
    INSERT INTO Reservation (
        id, userId, orderId, reservationTime, status, isDeleted
    )
    VALUES (
        new_reservation_id, p_user_id, NULL, p_reservation_time, 'CONFIRMED', FALSE
    );
    
    -- Update table status
    UPDATE Table1
    SET status = 'RESERVED'
    WHERE id = p_table_id;
    
    RAISE NOTICE 'Reservation created with ID: % for table % at %', 
                 new_reservation_id, p_table_id, p_reservation_time;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating reservation: %', SQLERRM;
END;
$$;


---13. Xem thông tin đặt bàn của khách hàng =>>Bị lỗi
CREATE OR REPLACE FUNCTION GetReservationsByUserId(p_userId UUID)
RETURNS TABLE (
    ReservationId UUID,
    ReservationTime TIMESTAMP,
    TableName VARCHAR(10),
    TableCapacity INT,
    Status ResvervationStatus, --  ReservationStatus => ResvervationStatus
    CreatedAt TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.id AS ReservationId,
        r.reservationTime AS ReservationTime,
        t.number AS TableName,
        t.capacity AS TableCapacity,
        r.status AS Status,
        r.createdAt AS CreatedAt
    FROM Reservation r
    JOIN User1 u ON r.userId = u.id
    JOIN Table1 t ON TRUE
    LEFT JOIN Order1 o ON r.orderId = o.id
    WHERE r.userId = p_userId AND r.isDeleted = FALSE;
END;
$$ LANGUAGE plpgsql;





--- 14. Thêm Order
CREATE OR REPLACE PROCEDURE add_order(
    p_user_id UUID,
    p_table_id UUID,
    p_order_type OrderType,
    p_coupon_id UUID DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_order_id UUID;
    v_total_amount DECIMAL(12,2) := 0;
    v_shipping_fee DECIMAL(12,2) := 0;
    v_tax_rate DECIMAL(5,2) := 0.1; -- 10% tax
    v_tax_amount DECIMAL(12,2) := 0;
    v_points_earned INT := 0;
    v_user_tier UserTier;
BEGIN
    -- Generate new UUID
    SELECT gen_random_uuid() INTO new_order_id;
    
    -- Get user tier for points calculation
    SELECT userTier INTO v_user_tier FROM User1 WHERE id = p_user_id;
    
    -- Set shipping fee based on order type
    IF p_order_type = 'DELIVERY' THEN
        v_shipping_fee := 5.00; -- Example shipping fee
    ELSE
        v_shipping_fee := 0;
    END IF;
    
    -- Calculate tax (will be updated later when order items are added)
    v_tax_amount := v_total_amount * v_tax_rate;
    
    -- Calculate points based on tier
    CASE v_user_tier
        WHEN 'BRONZE' THEN v_points_earned := 1;
        WHEN 'SILVER' THEN v_points_earned := 2;
        WHEN 'GOLD' THEN v_points_earned := 3;
    END CASE;
    
    -- Create the order
    INSERT INTO Order1 (
        id, userId, tableId, orderType, orderDate,
        totalAmount, shippingFee, taxAmount, status,
        couponId, earnedPoint, isDeleted
    )
    VALUES (
        new_order_id, p_user_id, p_table_id, p_order_type, CURRENT_TIMESTAMP,
        v_total_amount, v_shipping_fee, v_tax_amount, 'PENDING',
        p_coupon_id, v_points_earned, FALSE
    );
    
    -- Update table status if it's a dine-in order
    IF p_order_type = 'DINE_IN' AND p_table_id IS NOT NULL THEN
        UPDATE Table1 SET status = 'OCCUPIED' WHERE id = p_table_id;
    END IF;
    
    RAISE NOTICE 'Order created with ID: %', new_order_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating order: %', SQLERRM;
END;
$$;

-- 15. Thêm OrderItem
CREATE OR REPLACE PROCEDURE add_order_item(
    p_order_id UUID,
    p_menu_item_id UUID,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_item_id UUID;
    v_price DECIMAL(12,2);
    v_item_total DECIMAL(12,2);
    v_order_total DECIMAL(12,2);
    v_tax_rate DECIMAL(5,2) := 0.1; -- 10% tax
    v_order_type OrderType;
    v_coupon_id UUID;
    v_discount_type DiscountType;
    v_discount_value DECIMAL(12,2);
    v_min_order_value DECIMAL(12,2);
    v_max_discount_value DECIMAL(12,2);
    v_discount_amount DECIMAL(12,2) := 0;
    v_final_total DECIMAL(12,2);
BEGIN
    -- Check if menu item exists and get price
    SELECT price INTO v_price FROM MenuItem WHERE id = p_menu_item_id AND isAvailable = TRUE;
    IF v_price IS NULL THEN
        RAISE EXCEPTION 'Menu item not found or unavailable';
    END IF;
    
    -- Generate new UUID for order item
    SELECT gen_random_uuid() INTO new_item_id;
    
    -- Calculate item total
    v_item_total := v_price * p_quantity;
    
    -- Insert order item
    INSERT INTO OrderItem (id, orderId, menuItemId, quantity, price)
    VALUES (new_item_id, p_order_id, p_menu_item_id, p_quantity, v_price);
    
    -- Update order total and tax
    SELECT SUM(quantity * price) INTO v_order_total FROM OrderItem WHERE orderId = p_order_id;
    
    -- Get coupon information
    SELECT o.orderType, o.couponId 
    INTO v_order_type, v_coupon_id 
    FROM Order1 o WHERE o.id = p_order_id;
    
    -- Apply coupon discount if available
    IF v_coupon_id IS NOT NULL THEN
        SELECT c.discountType, c.discountValue, c.minOrderValue, c.maxDiscountValue
        INTO v_discount_type, v_discount_value, v_min_order_value, v_max_discount_value
        FROM Coupon c WHERE c.id = v_coupon_id AND c.status = 'AVAILABLE';
        
        IF v_order_total >= v_min_order_value THEN
            IF v_discount_type = 'PERCENTAGE' THEN
                v_discount_amount := v_order_total * (v_discount_value / 100);
                -- Ensure discount doesn't exceed max value
                IF v_discount_amount > v_max_discount_value THEN
                    v_discount_amount := v_max_discount_value;
                END IF;
            ELSE -- FIXED_AMOUNT
                v_discount_amount := v_discount_value;
            END IF;
        END IF;
    END IF;
    
    -- Calculate final total after discount
    v_final_total := v_order_total - v_discount_amount;
    
    -- Update order with new total and tax
    UPDATE Order1 
    SET totalAmount = v_final_total,
        taxAmount = v_final_total * v_tax_rate
    WHERE id = p_order_id;
    
    RAISE NOTICE 'Added item to order. New total: %', v_final_total;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error adding order item: %', SQLERRM;
END;
$$;

--16. In ra danh sách hoá đơn (Order) của 1 khách hàng (User.ID)
CREATE OR REPLACE FUNCTION get_customer_orders(customer_id UUID)
RETURNS TABLE (
    order_id UUID,
    order_date TIMESTAMP,
    order_type OrderType,
    status OrderStatus,
    table_number VARCHAR(10),
    total_amount DECIMAL(12,2),
    shipping_fee DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    payment_method PaymentMethod,
    payment_status PaymentStatus,
    coupon_code VARCHAR(30),
    earned_points INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id AS order_id,
        o.orderDate AS order_date,
        o.orderType AS order_type,
        o.status,
        t.number AS table_number,
        o.totalAmount AS total_amount,
        o.shippingFee AS shipping_fee,
        o.taxAmount AS tax_amount,
        p.method AS payment_method,
        p.status AS payment_status,
        c.code AS coupon_code,
        o.earnedPoint AS earned_points
    FROM 
        Order1 o
    LEFT JOIN 
        Table1 t ON o.tableId = t.id
    LEFT JOIN 
        Payment p ON p.orderId = o.id
    LEFT JOIN 
        Coupon c ON o.couponId = c.id
    WHERE 
        o.userId = customer_id
        AND o.isDeleted = FALSE
    ORDER BY 
        o.orderDate DESC;
END;
$$ LANGUAGE plpgsql;



---17. Xử lý thanh toán
CREATE OR REPLACE PROCEDURE process_payment(
    p_order_id UUID,
    p_payment_method PaymentMethod
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_payment_id UUID;
    v_total_amount DECIMAL(12,2);
    v_user_id UUID;
    v_earned_points INT;
    v_table_id UUID;
BEGIN
    -- Get order details
    SELECT totalAmount, userId, earnedPoint, tableId 
    INTO v_total_amount, v_user_id, v_earned_points, v_table_id
    FROM Order1 
    WHERE id = p_order_id;
    
    IF v_total_amount IS NULL THEN
        RAISE EXCEPTION 'Order not found';
    END IF;
    
    -- Generate new UUID for payment
    SELECT gen_random_uuid() INTO new_payment_id;
    
    -- Create payment record
    INSERT INTO Payment (id, orderId, paymentDate, amount, method, status)
    VALUES (new_payment_id, p_order_id, CURRENT_TIMESTAMP, v_total_amount, p_payment_method, 'COMPLETED');
    
    -- Update order status
    UPDATE Order1 SET status = 'SERVED' WHERE id = p_order_id;
    
    -- Add points to user
    UPDATE User1 
    SET point = point + v_earned_points
    WHERE id = v_user_id;
    
    -- Update user tier based on points
    UPDATE User1
    SET userTier = 
        CASE
            WHEN point >= 1000 THEN 'GOLD'::UserTier
            WHEN point >= 500 THEN 'SILVER'::UserTier
            ELSE 'BRONZE'::UserTier
        END
    WHERE id = v_user_id;
    
    -- Update table status if dine-in order is complete
    IF v_table_id IS NOT NULL THEN
        UPDATE Table1 SET status = 'AVAILABLE' WHERE id = v_table_id;
    END IF;
    
    RAISE NOTICE 'Payment processed successfully for order %', p_order_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error processing payment: %', SQLERRM;
END;
$$;




-- 18. Kiểm tra mức tồn kho và tạo đơn đặt hàng mua hàng
CREATE OR REPLACE PROCEDURE check_inventory_levels()
LANGUAGE plpgsql
AS $$
DECLARE
    r_item RECORD;
    v_low_threshold INT := 20; -- Default low threshold
BEGIN
    -- Find low inventory items
    FOR r_item IN (
        SELECT i.id, i.name, i.quantity, i.unit, i.supplierId, s.name as supplier_name
        FROM InventoryItem i
        JOIN Supplier s ON i.supplierId = s.id
        WHERE i.quantity <= v_low_threshold
          AND i.isDeleted = FALSE
    )
    LOOP
        -- Log low inventory alert
        RAISE NOTICE 'Low inventory: % (% %), Supplier: %', 
                     r_item.name, r_item.quantity, r_item.unit, r_item.supplier_name;
                     
        -- Here you could automatically create purchase orders
        -- or send notifications to staff
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error checking inventory: %', SQLERRM;
END;
$$;


-- 19. Quản lý hàng tồn kho sau khi đặt hàng
CREATE OR REPLACE PROCEDURE update_inventory_after_order(
    p_order_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    r_item RECORD;
    r_ingredient RECORD;
BEGIN
    -- Loop through each item in the order
    FOR r_item IN (
        SELECT oi.menuItemId, oi.quantity
        FROM OrderItem oi
        WHERE oi.orderId = p_order_id
    )
    LOOP
        -- Find ingredients for this menu item
        FOR r_ingredient IN (
            SELECT ri.inventoryItemId, ri.quantity * r_item.quantity as total_quantity
            FROM RecipeIngredient ri
            WHERE ri.menuItemId = r_item.menuItemId
        )
        LOOP
            -- Update inventory quantity
            UPDATE InventoryItem
            SET quantity = quantity - r_ingredient.total_quantity,
                updatedAt = CURRENT_TIMESTAMP
            WHERE id = r_ingredient.inventoryItemId;
            
            -- Record transaction
            INSERT INTO InventoryTransaction (
                id, inventoryItemId, transactionType, 
                quantity, price, timestamp
            )
            SELECT 
                gen_random_uuid(), r_ingredient.inventoryItemId, 'EXPORT'::TransactionType,
                r_ingredient.total_quantity, ii.price, CURRENT_TIMESTAMP
            FROM (SELECT r_ingredient.inventoryItemId, 0.00 as price) as ii;
            
            -- Check for low inventory
            PERFORM 1 FROM InventoryItem 
            WHERE id = r_ingredient.inventoryItemId AND quantity < 10;
            
            IF FOUND THEN
                RAISE NOTICE 'Low inventory alert for item ID: %', r_ingredient.inventoryItemId;
            END IF;
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'Inventory updated for order %', p_order_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating inventory: %', SQLERRM;
END;
$$;

---20  Xem thông tin vận chuyển đơn hàng
CREATE OR REPLACE FUNCTION GetDeliveryByTrackingCode(p_Code VARCHAR(15))
RETURNS TABLE (
    DeliveryId UUID,
    OrderId UUID,
    DeliveryDate TIMESTAMP,
    Status DeliveryStatus,
    Carrier VARCHAR(50),
    TrackingCode VARCHAR(15)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.id AS DeliveryId,
        d.orderId AS OrderId,
        d.deliveryDate AS DeliveryDate,
        d.status::DeliveryStatus AS Status,
        d.carrier AS Carrier,
        d.trackingCode AS TrackingCode
    FROM Delivery d
    WHERE d.trackingCode = p_Code;
END;
$$ LANGUAGE plpgsql;


---21. Cập nhật thông tin vận chuyển đơn hàng
CREATE OR REPLACE FUNCTION UpdateDelivery(
    p_deliveryId UUID,
    p_deliveryDate TIMESTAMP DEFAULT NULL,
    p_status DeliveryStatus DEFAULT NULL,
    p_carrier VARCHAR(50) DEFAULT NULL,
    p_trackingCode VARCHAR(15) DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    UPDATE Delivery
    SET
        deliveryDate = COALESCE(p_deliveryDate, deliveryDate),
        status = COALESCE(p_status, status),
        carrier = COALESCE(p_carrier, carrier),
        trackingCode = COALESCE(p_trackingCode, trackingCode)
    WHERE id = p_deliveryId AND isDeleted = FALSE;
END;
$$ LANGUAGE plpgsql;



-- 22. Tạo chiến dịch phiếu giảm giá
CREATE OR REPLACE PROCEDURE create_coupon_campaign(
    p_name VARCHAR(50),
    p_description VARCHAR(255),
    p_start_date TIMESTAMP,
    p_end_date TIMESTAMP,
    p_target_tier UserTier,
    p_discount_type DiscountType,
    p_discount_value DECIMAL(12,2),
    p_min_order_value DECIMAL(12,2),
    p_max_discount_value DECIMAL(12,2),
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_campaign_id UUID;
    new_pool_id UUID;
    i INT;
    v_coupon_code VARCHAR(30);
BEGIN
    -- Generate UUIDs
    SELECT gen_random_uuid() INTO new_campaign_id;
    SELECT gen_random_uuid() INTO new_pool_id;
    
    -- Create campaign
    INSERT INTO Campaign (
        id, name, description, startDate, userTier, endDate, isDeletad
    )
    VALUES (
        new_campaign_id, p_name, p_description, p_start_date, 
        p_target_tier, p_end_date, FALSE
    );
    
    -- Create coupon pool
    INSERT INTO CouponPool (
        id, name, description, totalCoupons, createdAt, 
        campaignId, allocatedCount, isDeleted
    )
    VALUES (
        new_pool_id, p_name || ' Pool', p_description, p_quantity, 
        CURRENT_TIMESTAMP, new_campaign_id, 0, FALSE
    );
    
    -- Generate coupons
    FOR i IN 1..p_quantity LOOP
        -- Generate unique coupon code (prefix + random)
        v_coupon_code := LEFT(p_name, 3) || '-' || 
                         LPAD(i::TEXT, 5, '0') || '-' || 
                         SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 5);
        
        -- Create coupon
        INSERT INTO Coupon (
            id, code, discountType, discountValue, minOrderValue,
            maxDiscountValue, usageLimit, status, isActive,
            expiresAt, createdAt, updatedAt, campaignId, poolId, isDeleted
        )
        VALUES (
            gen_random_uuid(), v_coupon_code, p_discount_type, p_discount_value, 
            p_min_order_value, p_max_discount_value, 1, 'AVAILABLE',
            TRUE, p_end_date, CURRENT_TIMESTAMP, NULL, 
            new_campaign_id, new_pool_id, FALSE
        );
    END LOOP;
    
    RAISE NOTICE 'Created campaign % with % coupons', new_campaign_id, p_quantity;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error creating coupon campaign: %', SQLERRM;
END;
$$;


---23. xem thông tin các coupon trong một chiến dịch (campaign)
CREATE OR REPLACE FUNCTION GetCouponsByCampaign(p_campaignId UUID)
RETURNS TABLE (
    CouponCode VARCHAR(30),
    DiscountType VARCHAR,
    DiscountValue DECIMAL(12,2),
    MinOrderValue DECIMAL(12,2),
    MaxDiscountValue DECIMAL(12,2),
    Status VARCHAR,
    ExpiresAt TIMESTAMP,
    UsageLimit INT,
    CampaignName VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.code AS CouponCode,
        c.discountType::VARCHAR AS DiscountType,
        c.discountValue AS DiscountValue,
        c.minOrderValue AS MinOrderValue,
        c.maxDiscountValue AS MaxDiscountValue,
        c.status::VARCHAR AS Status,
        c.expiresAt AS ExpiresAt,
        c.usageLimit AS UsageLimit,
        cmp.name AS CampaignName
    FROM Coupon c
    JOIN Campaign cmp ON c.campaignId = cmp.id::UUID
    LEFT JOIN CouponTarget ct ON ct.couponId = c.id
    WHERE c.campaignId = p_campaignId;
END;
$$ LANGUAGE plpgsql;

-- 24. Gán phiếu giảm giá cho người dùng
CREATE OR REPLACE PROCEDURE assign_coupons_to_users(
    p_campaign_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    r_campaign RECORD;
    r_user RECORD;
    r_coupon RECORD;
BEGIN
    -- Get campaign details
    SELECT c.id, c.userTier, c.endDate
    INTO r_campaign
    FROM Campaign c
    WHERE c.id = p_campaign_id;
    
    IF r_campaign.id IS NULL THEN
        RAISE EXCEPTION 'Campaign not found';
    END IF;
    
    -- Find eligible users
    FOR r_user IN (
        SELECT u.id, u.userTier
        FROM User1 u
        WHERE u.userTier = r_campaign.userTier
          AND u.isActive = TRUE
    )
    LOOP
        -- Find available coupon
        SELECT c.id
        INTO r_coupon
        FROM Coupon c
        WHERE c.campaignId = p_campaign_id
          AND c.status = 'AVAILABLE'
        LIMIT 1;
        
        IF r_coupon.id IS NOT NULL THEN
            -- Assign coupon to user
            INSERT INTO CouponTarget (
                id, couponId, userId, userTier, sentAt,
                expiresAt, usageLimit, isDeletad
            )
            VALUES (
                gen_random_uuid(), r_coupon.id, r_user.id, r_user.userTier,
                CURRENT_TIMESTAMP, r_campaign.endDate, 1, FALSE
            );
            
            -- Update coupon status
            UPDATE Coupon
            SET status = 'ALLOCATED'
            WHERE id = r_coupon.id;
            
            -- Update allocation count
            UPDATE CouponPool
            SET allocatedCount = allocatedCount + 1
            WHERE campaignId = p_campaign_id;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Coupons assigned for campaign %', p_campaign_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error assigning coupons: %', SQLERRM;
END;
$$;


--25. Thêm Review*
CREATE OR REPLACE PROCEDURE add_review(
  p_userId UUID,
  p_orderId UUID,
  p_rating INT,
  p_comment VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
   new_review_id UUID;
BEGIN
   -- Generate a new UUID
   new_review_id := gen_random_uuid();

   -- Insert into Review table
   INSERT INTO Review (id, userId, orderId, rating, comment, createdAt)
   VALUES (new_review_id, p_userId, p_orderId, p_rating, p_comment, CURRENT_TIMESTAMP);
END;
$$;

--FUNCTIONS
---1. Functions tính số lần sử dụng mã giảm giá của khách hàng
CREATE OR REPLACE FUNCTION GetCouponUsageCountByUser(p_userId UUID)
RETURNS INT AS $$
DECLARE
    usage_count INT;
BEGIN
    SELECT COUNT(*) INTO usage_count
    FROM CouponUsage cu
    WHERE cu.userId = p_userId;

    RETURN usage_count;
END;
$$ LANGUAGE plpgsql;



---2. Function theo dõi mức độ ưa thích của từng món ăn dựa trên số lượng đặt hàng và xếp hạng món ăn theo doanh thu.
CREATE OR REPLACE FUNCTION GetMenuItemPopularitys()
RETURNS TABLE (
    MenuItemId UUID,
    MenuItemName VARCHAR(100),
    TotalQuantity INT,
    TotalRevenue DECIMAL(12,2),
    OrderCount BIGINT,
    RevenueRank BIGINT,     -- Đã sửa từ INT → BIGINT
    QuantityRank BIGINT     -- Đã sửa từ INT → BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mi.id AS MenuItemId,
        mi.name AS MenuItemName,
        COALESCE(SUM(oi.quantity), 0)::INT AS TotalQuantity,
        COALESCE(SUM(oi.quantity * oi.price), 0)::DECIMAL(12,2) AS TotalRevenue,
        COUNT(DISTINCT oi.orderId)::BIGINT AS OrderCount,
        RANK() OVER (ORDER BY SUM(oi.quantity * oi.price) DESC) AS RevenueRank,
        RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS QuantityRank
    FROM MenuItem mi
    LEFT JOIN OrderItem oi ON mi.id = oi.menuItemId
    LEFT JOIN Order1 o ON oi.orderId = o.id AND o.status = 'DELIVERED'
    GROUP BY mi.id, mi.name
    ORDER BY TotalRevenue DESC;
END;
$$ LANGUAGE plpgsql;


---3. Function: Doanh thu theo ngày / tháng / năm, Số lượng đơn hàng trong kỳ, Trung bình doanh thu trên mỗi đơn hàng, Tổng doanh thu tích lũy đến kỳ hiện tại
CREATE OR REPLACE FUNCTION GetRevenueByDateGroup(p_groupType VARCHAR)
RETURNS TABLE (
    period TEXT,
    totalRevenue DECIMAL(18, 2),
    orderCount INT,
    avgRevenuePerOrder DECIMAL(18, 2),
    runningTotalRevenue DECIMAL(18, 2)
) AS $$
BEGIN
    IF p_groupType = 'DAY' THEN
        RETURN QUERY
        SELECT 
            sub.period,
            sub.totalRevenue,
            sub.orderCount,
            sub.avgRevenuePerOrder,
            SUM(sub.totalRevenue) OVER (ORDER BY sub.period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runningTotalRevenue
        FROM (
            SELECT 
                TO_CHAR(o.orderDate, 'YYYY-MM-DD') AS period,
                COALESCE(SUM(o.totalAmount), 0)::DECIMAL(18,2) AS totalRevenue,
                COUNT(*)::INT AS orderCount,
                COALESCE(AVG(o.totalAmount), 0)::DECIMAL(18,2) AS avgRevenuePerOrder
            FROM Order1 o
            WHERE o.status = 'DELIVERED'
            GROUP BY TO_CHAR(o.orderDate, 'YYYY-MM-DD')
            ORDER BY period
        ) sub;

    ELSIF p_groupType = 'MONTH' THEN
        RETURN QUERY
        SELECT 
            sub.period,
            sub.totalRevenue,
            sub.orderCount,
            sub.avgRevenuePerOrder,
            SUM(sub.totalRevenue) OVER (ORDER BY sub.period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runningTotalRevenue
        FROM (
            SELECT 
                TO_CHAR(o.orderDate, 'YYYY-MM') AS period,
                COALESCE(SUM(o.totalAmount), 0)::DECIMAL(18,2) AS totalRevenue,
                COUNT(*)::INT AS orderCount,
                COALESCE(AVG(o.totalAmount), 0)::DECIMAL(18,2) AS avgRevenuePerOrder
            FROM Order1 o
            WHERE o.status = 'DELIVERED'
            GROUP BY TO_CHAR(o.orderDate, 'YYYY-MM')
            ORDER BY period
        ) sub;

    ELSIF p_groupType = 'YEAR' THEN
        RETURN QUERY
        SELECT 
            sub.period,
            sub.totalRevenue,
            sub.orderCount,
            sub.avgRevenuePerOrder,
            SUM(sub.totalRevenue) OVER (ORDER BY sub.period ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runningTotalRevenue
        FROM (
            SELECT 
                TO_CHAR(o.orderDate, 'YYYY') AS period,
                COALESCE(SUM(o.totalAmount), 0)::DECIMAL(18,2) AS totalRevenue,
                COUNT(*)::INT AS orderCount,
                COALESCE(AVG(o.totalAmount), 0)::DECIMAL(18,2) AS avgRevenuePerOrder
            FROM Order1 o
            WHERE o.status = 'DELIVERED'
            GROUP BY TO_CHAR(o.orderDate, 'YYYY')
            ORDER BY period
        ) sub;

    ELSE
        RAISE EXCEPTION 'Invalid group type. Use DAY, MONTH or YEAR';
    END IF;
END;
$$ LANGUAGE plpgsql;


---4. Function: Thống kê số lượng đơn hàng đã hoàn thành, Tổng doanh thu từ đơn thành công, Tổng số đơn (tất cả trạng thái), Tỷ lệ % đơn thành công
CREATE OR REPLACE FUNCTION GetCompletedOrdersSummary()
RETURNS TABLE (
    completedOrderCount INT,
    totalRevenue DECIMAL(18,2),
    totalOrders INT,
    successRatePercent DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) FILTER (WHERE status = 'DELIVERED')::INT,
        COALESCE(SUM(totalAmount) FILTER (WHERE status = 'DELIVERED'), 0)::DECIMAL(18,2),
        COUNT(*)::INT,
        ROUND(
            (COUNT(*) FILTER (WHERE status = 'DELIVERED')::DECIMAL / NULLIF(COUNT(*), 0)) * 100,
            2
        )::DECIMAL(5,2)
    FROM Order1;
END;
$$ LANGUAGE plpgsql;


---5. Function: Báo cáo doanh thu theo từng món ăn, Tỷ lệ phần trăm doanh thu so với tổng doanh thu, Phân hạng Top N món bán chạy nhất, tên danh mục món ăn, giá trung bình mỗi lần bán món đó
CREATE OR REPLACE FUNCTION GetRevenueByMenuItem(topN INT)
RETURNS TABLE (
    Rank INT,
    MenuItemId UUID,
    MenuItemName VARCHAR(100),
    CategoryName VARCHAR(100),
    TotalQuantity INT,
    TotalRevenue DECIMAL(18,2),
    AvgPrice DECIMAL(18,2),
    OrderCount INT,
    RevenuePercentage DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        RANK() OVER (ORDER BY SUM(oi.quantity * oi.price) DESC)::INT AS Rank,  -- CHỈNH TẠI ĐÂY
        mi.id AS MenuItemId,
        mi.name AS MenuItemName,
        mc.name AS CategoryName,
        SUM(oi.quantity)::INT AS TotalQuantity,
        SUM(oi.quantity * oi.price)::DECIMAL(18,2) AS TotalRevenue,
        ROUND(AVG(oi.price), 2)::DECIMAL(18,2) AS AvgPrice,
        COUNT(DISTINCT o.id)::INT AS OrderCount,
        ROUND(
            (SUM(oi.quantity * oi.price) / NULLIF((SELECT SUM(quantity * price) FROM OrderItem oi2 
                                                  JOIN Order1 o2 ON oi2.orderId = o2.id AND o2.status = 'DELIVERED'), 0)) * 100,
            2
        )::DECIMAL(5,2) AS RevenuePercentage
    FROM OrderItem oi
    JOIN Order1 o ON oi.orderId = o.id AND o.status = 'DELIVERED'
    JOIN MenuItem mi ON oi.menuItemId = mi.id
    JOIN MenuCategory mc ON mi.categoryId = mc.id
    GROUP BY mi.id, mi.name, mc.name
    ORDER BY TotalRevenue DESC
    LIMIT topN;
END;
$$ LANGUAGE plpgsql;


---6. Function: So sánh doanh thu giữa hai khoảng thời gian, Doanh thu tăng/giảm bao nhiêu (giá trị tuyệt đối), Tỷ lệ phần trăm tăng/giảm (%), dữ liệu từng kỳ + dòng tổng kết
CREATE OR REPLACE FUNCTION CompareRevenueBetweenPeriods(
    p_startDate1 TIMESTAMP,
    p_endDate1 TIMESTAMP,
    p_startDate2 TIMESTAMP,
    p_endDate2 TIMESTAMP
)
RETURNS TABLE (
    period TEXT,
    totalRevenue DECIMAL(18,2),
    orderCount INT,
    revenueChange DECIMAL(18,2),
    revenueChangePercent DECIMAL(5,2),
    orderChange INT,
    orderChangePercent DECIMAL(5,2)
) AS $$
DECLARE
    revenue1 DECIMAL(18,2);
    revenue2 DECIMAL(18,2);
    orders1 INT;
    orders2 INT;
BEGIN

    --  Kiểm tra điều kiện: Khoảng thời gian 2 phải bắt đầu sau khi thời gian 1 kết thúc
    IF p_startDate2 <= p_endDate1 THEN
        RAISE EXCEPTION 'Khoảng thời gian sau (Period 2) phải bắt đầu sau khi khoảng thời gian trước (Period 1) kết thúc. Vui lòng kiểm tra lại ngày!';
    END IF;

    -- Lấy dữ liệu cho Period 1
    SELECT COALESCE(SUM(totalAmount), 0), COUNT(*) INTO revenue1, orders1
    FROM Order1
    WHERE status = 'DELIVERED'
      AND orderDate BETWEEN p_startDate1 AND p_endDate1;

    -- Lấy dữ liệu cho Period 2
    SELECT COALESCE(SUM(totalAmount), 0), COUNT(*) INTO revenue2, orders2
    FROM Order1
    WHERE status = 'DELIVERED'
      AND orderDate BETWEEN p_startDate2 AND p_endDate2;

    -- Trả về dữ liệu Period 1
    RETURN QUERY
    SELECT 
        'Period 1'::TEXT,
        revenue1,
        orders1,
        NULL::DECIMAL(18,2),
        NULL::DECIMAL(5,2),
        NULL::INT,
        NULL::DECIMAL(5,2);

    -- Trả về dữ liệu Period 2
    RETURN QUERY
    SELECT 
        'Period 2'::TEXT,
        revenue2,
        orders2,
        NULL::DECIMAL(18,2),
        NULL::DECIMAL(5,2),
        NULL::INT,
        NULL::DECIMAL(5,2);

    -- Trả về dòng so sánh
    RETURN QUERY
    SELECT 
        'Comparison (P2 vs P1)'::TEXT,
        NULL::DECIMAL(18,2),
        NULL::INT,
        (revenue2 - revenue1)::DECIMAL(18,2),
        ROUND((revenue2 - revenue1) / NULLIF(revenue1, 0) * 100, 2)::DECIMAL(5,2),
        (orders2 - orders1)::INT,
        ROUND((orders2 - orders1)::DECIMAL / NULLIF(orders1, 0) * 100, 2)::DECIMAL(5,2);
END;
$$ LANGUAGE plpgsql;


---7. Function: Doanh thu theo phương thức thanh toán, tỷ lệ phần trăm doanh thu so với tổng (RevenuePercentage)
CREATE OR REPLACE FUNCTION GetRevenueByPaymentMethod()
RETURNS TABLE (
    PaymentMethod VARCHAR(50),
    TotalRevenue DECIMAL(18,2),
    OrderCount INT,
    RevenuePercentage DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.method::VARCHAR(50),
        SUM(p.amount)::DECIMAL(18,2),
        COUNT(*)::INT,
        ROUND(
            (SUM(p.amount) / NULLIF((SELECT SUM(p2.amount) FROM Payment p2
                                     JOIN Order1 o2 ON p2.orderId = o2.id AND o2.status = 'DELIVERED'), 0)) * 100,
            2
        )::DECIMAL(5,2)
    FROM Payment p
    JOIN Order1 o ON p.orderId = o.id AND o.status = 'DELIVERED'
    GROUP BY p.method
    ORDER BY TotalRevenue DESC;
END;
$$ LANGUAGE plpgsql;



---8. Tính tổng lương của 1 Employee
CREATE OR REPLACE FUNCTION calculate_employee_salary(employee_id UUID)
RETURNS DECIMAL(12,2) AS $$
DECLARE
    net_salary DECIMAL(12,2);
BEGIN
    SELECT 
        baseSalary 
        + (hourlyRate * LEAST(workedHours, standardHours))
        + (hourlyRate * overtimePay * GREATEST(0, workedHours - standardHours))
        - deductions
    INTO net_salary
    FROM Payroll
    WHERE employeeId = employee_id;

    RETURN COALESCE(net_salary, 0);
END;
$$ LANGUAGE plpgsql;


--9. Tính tổng giá của 1 Order
CREATE OR REPLACE FUNCTION calculate_order_total(order_id UUID)
RETURNS DECIMAL(12,2) AS $$
DECLARE
    total DECIMAL(12,2);
    discount DECIMAL(12,2);
    discount_type TEXT;
    shipping_fee DECIMAL(12,2);
    tax_amount DECIMAL(12,2);
    subtotal DECIMAL(12,2);
BEGIN
    -- Lấy thông tin đơn hàng và mã giảm giá
    SELECT 
        o.shippingFee,
        o.taxAmount,
        COALESCE(c.discountType, NULL),
        COALESCE(c.discountValue, 0),
        SUM(oi.quantity * oi.price)
    INTO 
        shipping_fee,
        tax_amount,
        discount_type,
        discount,
        subtotal
    FROM Order1 o
    LEFT JOIN Coupon c ON o.couponId = c.id
    LEFT JOIN OrderItem oi ON o.id = oi.orderId
    WHERE o.id = order_id
    GROUP BY o.id, c.discountType, c.discountValue;

    -- Tính tổng giá theo loại giảm giá
    IF discount_type = 'PERCENTAGE' THEN
        total := (((shipping_fee + subtotal) - ((shipping_fee + subtotal) * (discount / 100))) * ((100 + tax_amount) / 100));
    ELSIF discount_type = 'FIXED_AMOUNT' THEN
        total := (((shipping_fee + subtotal) - discount) * ((100 + tax_amount) / 100));
    ELSE
        total := ((shipping_fee + subtotal) * ((100 + tax_amount) / 100));
    END IF;

    RETURN total;
END;
$$ LANGUAGE plpgsql;



--TRIGGER
--1. Tạo Trigger thỏa mãn điều kiện khi xóa một Employee sẽ xóa các thông tin liên quan. (DELETE)
CREATE OR REPLACE FUNCTION employee_delete_cascade()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE User1
    SET isDeleted = TRUE, updatedAt = NOW()
    WHERE id = OLD.userId AND isDeleted = FALSE;
    

    UPDATE WorkSchedule
    SET isDeleted = TRUE
    WHERE employeeId = OLD.id AND isDeleted = FALSE;
    

    UPDATE LeaveRequest
    SET isDeleted = TRUE, updatedAt = NOW()
    WHERE employeeId = OLD.id AND isDeleted = FALSE;
    

    UPDATE OvertimeRequest
    SET isDeleted = TRUE, updatedAt = NOW()
    WHERE employeeId = OLD.id AND isDeleted = FALSE;
    

    UPDATE Attendance
    SET isDeleted = TRUE
    WHERE employeeId = OLD.id AND isDeleted = FALSE;
    
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_employee_delete
BEFORE UPDATE OF isDeleted ON Employee
FOR EACH ROW
WHEN (OLD.isDeleted = FALSE AND NEW.isDeleted = TRUE)
EXECUTE FUNCTION employee_delete_cascade();


--2. Tạo Trigger thỏa mãn điều kiện khi xóa một Order sẽ xóa các thông tin liên quan. (DELETE)
CREATE OR REPLACE FUNCTION order_delete_cascade()
RETURNS TRIGGER AS $$
BEGIN

    DELETE FROM OrderItem
    WHERE orderId = OLD.id;
    
    UPDATE Reservation
    SET isDeleted = TRUE
    WHERE orderId = OLD.id AND isDeleted = FALSE;
    
    IF OLD.tableId IS NOT NULL THEN
        UPDATE Table1
        SET status = 'AVAILABLE'
        WHERE id = OLD.tableId AND status = 'OCCUPIED';
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER before_order_delete
BEFORE UPDATE OF isDeleted ON Order1
FOR EACH ROW
WHEN (OLD.isDeleted = FALSE AND NEW.isDeleted = TRUE)
EXECUTE FUNCTION order_delete_cascade();


--3. Tạo Trigger thỏa mãn điều kiện khi xóa một User sẽ xóa các thông tin liên quan. (DELETE)
CREATE OR REPLACE FUNCTION user_delete_cascade()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Employee
    SET isDeleted = TRUE
    WHERE userId = OLD.id AND isDeleted = FALSE;
    
    UPDATE Order1
    SET isDeleted = TRUE
    WHERE userId = OLD.id AND isDeleted = FALSE;
    
    UPDATE Reservation
    SET isDeleted = TRUE
    WHERE userId = OLD.id AND isDeleted = FALSE;
    
    DELETE FROM Token
    WHERE userId = OLD.id;
    
    UPDATE CouponTarget
    SET isDeletad = TRUE  -- Note: There's a typo in the schema 'isDeletad' instead of 'isDeleted'
    WHERE userId = OLD.id AND isDeletad = FALSE;
        
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_user_delete
BEFORE UPDATE OF isDeleted ON User1
FOR EACH ROW
WHEN (OLD.isDeleted = FALSE AND NEW.isDeleted = TRUE)
EXECUTE FUNCTION user_delete_cascade();


--4. Trigger thỏa mãn điều kiện khi xóa một MenuItem sẽ xóa các thông tin liên quan. (DELETE)
CREATE OR REPLACE FUNCTION menu_item_delete_cascade()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM RecipeIngredient
    WHERE menuItemId = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_menu_item_delete
BEFORE UPDATE OF isDeleted ON MenuItem
FOR EACH ROW
WHEN (OLD.isDeleted = FALSE AND NEW.isDeleted = TRUE)
EXECUTE FUNCTION menu_item_delete_cascade();



--5. Tạo trigger Kiểm tra quyền hạn phụ trách của nhân viên (employee) (INSERT, UPDATE)
CREATE OR REPLACE FUNCTION check_employee_permissions()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM User1 
        WHERE id = NEW.userId 
        AND isEmployee = TRUE
        AND isActive = TRUE
        AND isDeleted = FALSE
    ) THEN
        RAISE EXCEPTION 'User with ID % is not marked as an active employee in the User table', NEW.userId;
    END IF;
    
    IF NEW.role = 'MANAGER' AND NEW.employmentType != 'FULL_TIME' THEN
        RAISE EXCEPTION 'Only FULL_TIME employees can be assigned the MANAGER role';
    END IF;
    
    IF TG_OP = 'UPDATE' THEN
        IF OLD.employmentStatus = 'TERMINATED' AND NEW.employmentStatus = 'ACTIVE' THEN
            RAISE EXCEPTION 'Cannot change employment status from TERMINATED to ACTIVE';
        END IF;
        
        IF OLD.employmentStatus = 'ON_LEAVE' AND OLD.role != NEW.role THEN
            RAISE EXCEPTION 'Cannot change role for employees who are on leave';
        END IF;
    END IF;
    
    IF NEW.salary < 0 OR NEW.hourlyRate < 0 THEN
        RAISE EXCEPTION 'Salary and hourly rate must be non-negative values';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_employee_change
BEFORE INSERT OR UPDATE ON Employee
FOR EACH ROW
EXECUTE FUNCTION check_employee_permissions();


--6. Tạo trigger gán shippingFee = 0 khi orderType = ‘DINE_IN ‘ hoặc ‘TAKEAWAY’ trong bảng (Order) (INSERT, UPDATE)
CREATE OR REPLACE FUNCTION set_shipping_fee()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.orderType IN ('DINE_IN', 'TAKEAWAY') THEN
        NEW.shippingFee = 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_order_insert_update
BEFORE INSERT OR UPDATE OF orderType ON Order1
FOR EACH ROW
EXECUTE FUNCTION set_shipping_fee();



------ TẠO CÁC ROLE
CREATE ROLE admin_role

CREATE ROLE manager_role

CREATE ROLE employee_role

CREATE ROLE customer_role

----- Phân quyền cho các role
--- ROLE admin_role
-- Cho phép truy cập vào schema
GRANT USAGE ON SCHEMA public TO admin_role

-- Toàn quyền trên tất cả bảng, sequence, function, procedure hiện có
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_role
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO admin_role

-- Cấp quyền mặc định cho các đối tượng sẽ được tạo sau này
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO admin_role

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON FUNCTIONS TO admin_role

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON ROUTINES TO admin_role;

-- Thu hồi toàn bộ quyền trên bảng User1 từ role
REVOKE ALL ON TABLE User1 FROM admin_role



--- ROLE manager_role
-- Cho phép truy cập vào schema
GRANT USAGE ON SCHEMA public TO manager_role

-- Phân quyền cho manager_role trên các bảng
GRANT SELECT, INSERT, UPDATE, DELETE ON Employee TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON WorkSchedule TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON LeaveRequest TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Attendance TO manager_role;
GRANT SELECT, INSERT, UPDATE ON Payroll TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON ShiftTemplate TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON OvertimeRequest TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Order1 TO manager_role;
GRANT SELECT, INSERT, UPDATE ON Payment TO manager_role;
GRANT SELECT, INSERT, UPDATE ON Coupon TO manager_role;
GRANT SELECT, INSERT, UPDATE ON Campaign TO manager_role;
GRANT SELECT, INSERT, UPDATE ON CouponPool TO manager_role;
GRANT SELECT, INSERT ON CouponTarget TO manager_role;
GRANT SELECT, INSERT, UPDATE ON CouponUsage TO manager_role;
GRANT SELECT ON Token TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservation TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Review TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Table1 TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Delivery TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderItem TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON MenuItem TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON MenuCategory TO manager_role;
GRANT SELECT ON RecipeIngredient TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON InventoryItem TO manager_role;
GRANT SELECT, INSERT, UPDATE ON Supplier TO manager_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON InventoryTransaction TO manager_role;

-- Phân quyền cho manager_role trên Store Procedure
GRANT EXECUTE ON PROCEDURE add_employee TO manager_role;
GRANT EXECUTE ON FUNCTION get_customers TO manager_role;
GRANT EXECUTE ON FUNCTION get_employees_by_role TO manager_role;
GRANT EXECUTE ON FUNCTION UpdateUserInfo TO manager_role;
GRANT EXECUTE ON FUNCTION GetWorkScheduleByEmployeeId TO manager_role;
GRANT EXECUTE ON PROCEDURE process_leave_request TO manager_role;
GRANT EXECUTE ON PROCEDURE record_employee_attendance TO manager_role;
GRANT EXECUTE ON FUNCTION GetAttendanceByEmployee TO manager_role;
GRANT EXECUTE ON PROCEDURE create_employee_schedule TO manager_role;
GRANT EXECUTE ON PROCEDURE add_reservation TO manager_role;
GRANT EXECUTE ON FUNCTION GetReservationsByUserId TO manager_role;
GRANT EXECUTE ON PROCEDURE add_order TO manager_role;
GRANT EXECUTE ON PROCEDURE add_order_item TO manager_role;
GRANT EXECUTE ON FUNCTION get_customer_orders TO manager_role;
GRANT EXECUTE ON PROCEDURE process_payment TO manager_role;
GRANT EXECUTE ON PROCEDURE check_inventory_levels TO manager_role;
GRANT EXECUTE ON PROCEDURE update_inventory_after_order TO manager_role;
GRANT EXECUTE ON FUNCTION GetDeliveryByTrackingCode TO manager_role;
GRANT EXECUTE ON FUNCTION UpdateDelivery TO manager_role;
GRANT EXECUTE ON FUNCTION GetCouponsByCampaign TO manager_role;
GRANT EXECUTE ON PROCEDURE assign_coupons_to_users TO manager_role;
GRANT EXECUTE ON PROCEDURE add_review TO manager_role;

-- Phân quyền cho manager_role trên Functions
GRANT EXECUTE ON FUNCTION GetCouponUsageCountByUser(UUID) TO manager_role;
GRANT EXECUTE ON FUNCTION GetMenuItemPopularitys() TO manager_role;
GRANT EXECUTE ON FUNCTION GetRevenueByDateGroup(VARCHAR) TO manager_role;
GRANT EXECUTE ON FUNCTION GetCompletedOrdersSummary() TO manager_role;
GRANT EXECUTE ON FUNCTION GetRevenueByMenuItem(INT) TO manager_role;
GRANT EXECUTE ON FUNCTION CompareRevenueBetweenPeriods(TIMESTAMP, TIMESTAMP, TIMESTAMP, TIMESTAMP) TO manager_role;
GRANT EXECUTE ON FUNCTION GetRevenueByPaymentMethod() TO manager_role;
GRANT EXECUTE ON FUNCTION calculate_order_total(UUID) TO manager_role;


--- ROLE Employee_role
-- Cho phép truy cập vào schema
GRANT USAGE ON SCHEMA public TO employee_role;

--- Phân quyền về bảng của Employee_role
GRANT SELECT, UPDATE ON User1 TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON LeaveRequest TO employee_role;
GRANT SELECT ON Attendance TO employee_role;
GRANT SELECT, UPDATE ON ShiftTemplate TO employee_role;
GRANT SELECT ON WorkSchedule TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON OvertimeRequest TO employee_role;
GRANT SELECT, INSERT, UPDATE ON Reservation TO employee_role;
GRANT SELECT ON Review TO employee_role;
GRANT SELECT, UPDATE ON Table1 TO employee_role;
GRANT SELECT, INSERT, UPDATE ON Delivery TO employee_role;
GRANT SELECT, INSERT, UPDATE ON Order1 TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderItem TO employee_role;
GRANT SELECT ON MenuItem TO employee_role;
GRANT SELECT ON MenuCategory TO employee_role;
GRANT SELECT ON RecipeIngredient TO employee_role;
GRANT SELECT, UPDATE ON InventoryItem TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON InventoryTransaction TO employee_role;
GRANT SELECT ON Supplier TO employee_role;
GRANT SELECT ON Payment TO employee_role;
GRANT SELECT ON CouponPool TO employee_role;
GRANT SELECT ON Campaign TO employee_role;
GRANT SELECT ON Coupon TO employee_role;
GRANT SELECT ON CouponUsage TO employee_role;

-- Phân quyền cho employee_role trên Store Procedure
GRANT EXECUTE ON FUNCTION get_customers TO employee_role;
GRANT EXECUTE ON FUNCTION get_employees_by_role TO employee_role;
GRANT EXECUTE ON FUNCTION UpdateUserInfo TO employee_role;
GRANT EXECUTE ON FUNCTION GetWorkScheduleByEmployeeId TO employee_role;
GRANT EXECUTE ON FUNCTION GetAttendanceByEmployee TO employee_role;
GRANT EXECUTE ON PROCEDURE add_reservation TO employee_role;
GRANT EXECUTE ON FUNCTION GetReservationsByUserId TO employee_role;
GRANT EXECUTE ON PROCEDURE add_order TO employee_role;
GRANT EXECUTE ON PROCEDURE add_order_item TO employee_role;
GRANT EXECUTE ON FUNCTION get_customer_orders TO employee_role;
GRANT EXECUTE ON PROCEDURE process_payment TO employee_role;
GRANT EXECUTE ON PROCEDURE check_inventory_levels TO employee_role;
GRANT EXECUTE ON PROCEDURE update_inventory_after_order TO employee_role;
GRANT EXECUTE ON FUNCTION GetDeliveryByTrackingCode TO employee_role;
GRANT EXECUTE ON FUNCTION UpdateDelivery TO employee_role;
GRANT EXECUTE ON FUNCTION GetCouponsByCampaign TO employee_role;

-- Phân quyền cho employee_role trên Functions
GRANT EXECUTE ON FUNCTION GetCouponUsageCountByUser(UUID) TO employee_role;
GRANT EXECUTE ON FUNCTION GetMenuItemPopularitys() TO employee_role;
GRANT EXECUTE ON FUNCTION calculate_order_total(UUID) TO employee_role;



--- ROLE Customer_role
-- Cho phép truy cập vào schema
GRANT USAGE ON SCHEMA public TO customer_role;

--- Phân quyền về bảng của Customer_role
GRANT SELECT, UPDATE ON User1 TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservation TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Review TO customer_role;
GRANT SELECT ON Table1 TO customer_role;
GRANT SELECT ON Delivery TO customer_role;
GRANT SELECT, INSERT, DELETE ON OrderItem TO customer_role;
GRANT SELECT ON MenuItem TO customer_role;
GRANT SELECT ON MenuCategory TO customer_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Order1 TO customer_role;
GRANT SELECT ON Payment TO customer_role;
GRANT SELECT ON Coupon TO customer_role;
GRANT SELECT ON Campaign TO customer_role;
GRANT SELECT ON CouponUsage TO customer_role;

-- Phân quyền cho customer_role trên Store Procedure
GRANT EXECUTE ON FUNCTION UpdateUserInfo TO customer_role;
GRANT EXECUTE ON PROCEDURE add_reservation TO customer_role;
GRANT EXECUTE ON FUNCTION GetReservationsByUserId TO customer_role;
GRANT EXECUTE ON PROCEDURE add_order TO customer_role;
GRANT EXECUTE ON PROCEDURE add_order_item TO customer_role;
GRANT EXECUTE ON FUNCTION get_customer_orders TO customer_role;
GRANT EXECUTE ON FUNCTION GetDeliveryByTrackingCode TO customer_role;
GRANT EXECUTE ON PROCEDURE add_review TO customer_role;

-- Phân quyền cho customer_role trên Functions
GRANT EXECUTE ON FUNCTION GetCouponUsageCountByUser(UUID) TO customer_role;
GRANT EXECUTE ON FUNCTION calculate_order_total(UUID) TO customer_role;


----- View
--- View ẩn thông tin cá nhân
-- View chỉ cho phép xem thông tin tài khoản của chính mình
CREATE OR REPLACE VIEW user1_safe_view AS
SELECT	
	id, name, password, email, phone,
    address, isAdmin, isEmployee, isActive,
    createdAt, updatedAt, userTier, point, isDeleted
FROM User1
WHERE email = current_user

-- thu hồi quyền SELECT TRÊN user1 và cấp lại trên các view
REVOKE SELECT ON User1 FROM admin_role, manager_role, 
						employee_role, customer_role;
GRANT SELECT ON user1_safe_view TO admin_role;
GRANT SELECT ON user1_safe_view TO manager_role;
GRANT SELECT ON user1_safe_view TO employee_role;
GRANT SELECT ON user1_safe_view TO customer_role;

--- View ẩn thông tin lương với các nhân viên khác
CREATE OR REPLACE VIEW employee_view AS
SELECT
    id,
    userId,
    hireDate,
    role,
    employmentType,
    employmentStatus,
    isDeleted
FROM Employee;
 
REVOKE SELECT ON Employee FROM employee_role;
GRANT SELECT ON employee_view TO employee_role;

-- View ẩn thông tin phiếu lương của các nhân viên với nhau
CREATE OR REPLACE VIEW payroll_safe_view AS
SELECT
    P.id,
    P.employeeId,
	P.baseSalary,
	P.hourlyRate,
	P.workedHours,
	P.standardHours,
	P.overtimePay,
	P.deductions,
	P.netSalary,
	P.createdAt
FROM Payroll P join Employee E on P.employeeId = E.id
		join User1 U on E.userId = U.id
WHERE U.email = current_user

REVOKE SELECT ON Payroll FROM employee_role;
GRANT SELECT ON payroll_safe_view TO employee_role;

--- View thống kê các phiếu giảm giá khả dụng cho User
CREATE OR REPLACE VIEW user_available_coupons AS
SELECT 
    c.id AS coupon_id,
    c.code AS coupon_code,
    c.discountType,
    c.discountValue,
    c.minOrdervalue,
    c.maxDiscountValue,
    ut.usageLimit,
    ut.expiresAt,
    ut.sentAt,
    c.status,
    c.isActive 
FROM User1 u JOIN CouponTarget ut ON u.id = ut.userId
		JOIN Coupon c ON ut.couponId = c.id
WHERE u.email = current_user
    AND c.isActive = true
    AND ut.isDeletad = false
    AND (c.expiresAt IS NULL OR c.expiresAt > CURRENT_TIMESTAMP)
    AND (ut.expiresAt > CURRENT_TIMESTAMP)
    AND (ut.usageLimit > 0 OR ut.usageLimit IS NULL)
	AND c.status = 'ALLOCATED'
    AND u.isActive = true
    AND u.isDeleted = false;

GRANT SELECT ON user_available_coupons TO admin_role, 
			manager_role, employee_role, customer_role;

--- View thống kê các hóa đơn trong 30 ngày gần đây
CREATE VIEW recent_orders_last_30_days AS
SELECT *
FROM Order1
WHERE orderDate >= NOW() - INTERVAL '30 days';

GRANT SELECT ON recent_orders_last_30_days TO admin_role, 
				manager_role, employee_role, customer_role;

--- View xem các đơn hàng mà mình mua
CREATE VIEW my_orders AS
SELECT o.*
FROM Order1 o JOIN User1 u ON o.userId = u.id
WHERE u.email = current_user;

GRANT SELECT ON my_orders TO admin_role, 
				manager_role, employee_role, customer_role;

--- View xem top 10 sản phẩm bán chạy nhất trong 30 ngày gần đây
CREATE OR REPLACE VIEW Top10BestSellingItems_30Days AS
SELECT 
    m.id AS menuItemId,
    m.name AS menuItemName,
    SUM(oi.quantity) AS totalSold,
    m.price,
    m.imageUrl
FROM OrderItem oi JOIN MenuItem m ON oi.menuItemId = m.id
	 JOIN Order1 o ON oi.orderId = o.id
WHERE m.isDeleted = FALSE 
    AND m.isAvailable = TRUE
    AND o.orderDate >= NOW() - INTERVAL '30 days'
GROUP BY m.id, m.name, m.price, m.imageUrl
ORDER BY totalSold DESC
LIMIT 10;

GRANT SELECT ON Top10BestSellingItems_30Days TO admin_role, 
				manager_role, employee_role, customer_role;

--- View xem  lịch làm tuần hiện tại của nhân viên
CREATE OR REPLACE VIEW WeeklyWorkScheduleSimple AS
SELECT 
    employeeId,
    date,
    shiftStart,
    shiftEnd,
    createdAt
FROM WorkSchedule
WHERE isDeleted = FALSE
    AND date >= date_trunc('week', CURRENT_DATE)                         -- thứ 2 tuần này
    AND date < date_trunc('week', CURRENT_DATE) + INTERVAL '7 days'         -- trước thứ 2 tuần sau
ORDER BY employeeId, date;

GRANT SELECT ON WeeklyWorkScheduleSimple TO admin_role, 
				manager_role, employee_role;

--- View xem bảng chấm công của nhân viên trong tháng
CREATE OR REPLACE VIEW MonthlyAttendance AS
SELECT 
    id AS attendanceId,
    employeeId,
    workDate,
    checkIn,
    checkOut,
    notes
FROM 
    Attendance
WHERE isDeleted = FALSE
    AND workDate >= date_trunc('month', CURRENT_DATE)                         -- từ đầu tháng
    AND workDate < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'    -- đến trước đầu tháng sau
ORDER BY employeeId, workDate;

GRANT SELECT ON MonthlyAttendance TO admin_role, 
				manager_role, employee_role;

--- View danh sách hàng nhập kho trong tháng hiện tại
CREATE OR REPLACE VIEW MonthlyInventoryImport AS
SELECT 
    it.id AS transactionId,
    ii.name AS itemName,
    ii.category,
    it.quantity,
    it.price,
    it.timestamp
FROM InventoryTransaction it  JOIN 
    InventoryItem ii ON it.inventoryItemId = ii.id
WHERE it.transactionType = 'IMPORT'
    AND it.timestamp >= date_trunc('month', CURRENT_DATE)
    AND it.timestamp < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
ORDER BY it.timestamp DESC;

GRANT SELECT ON MonthlyInventoryImport TO admin_role, manager_role;

--- View danh sách hàng xuất kho trong tháng hiện tại
CREATE OR REPLACE VIEW MonthlyInventoryExport AS
SELECT 
    it.id AS transactionId,
    ii.name AS itemName,
    ii.category,
    it.quantity,
    it.price,
    it.timestamp
FROM InventoryTransaction it JOIN 
    InventoryItem ii ON it.inventoryItemId = ii.id
WHERE it.transactionType = 'EXPORT'
    AND it.timestamp >= date_trunc('month', CURRENT_DATE)
    AND it.timestamp < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
ORDER BY it.timestamp DESC;

GRANT SELECT ON MonthlyAttendance TO admin_role, manager_role;

--- View thống kê các bàn còn trống trong 2 giờ tới
CREATE VIEW AvailableTablesInNext2Hours AS
SELECT 
    t.id,
    t.number,
    t.capacity,
    t.status
FROM Table1 t
WHERE t.isDeleted = false
    AND t.status = 'AVAILABLE'
    AND t.id NOT IN (
        SELECT o.tableId
        FROM Reservation r
        JOIN Order1 o ON r.orderId = o.id
        WHERE 
            r.reservationTime BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP 
			+ INTERVAL '2 hours' AND r.status IN ('PENDING', 'CONFIRMED')
            AND r.isDeleted = false );

GRANT SELECT ON AvailableTablesInNext2Hours TO admin_role, 
				manager_role, employee_role, customer_role;

--- View thống kê các đơn hàng phải giao lại trong ngày hôm nay
CREATE OR REPLACE VIEW orders_with_multiple_deliveries AS
SELECT 
    d.orderId AS order_id,
    COUNT(*) AS delivery_attempts,  -- Đếm số giao hàng cho mỗi hóa đơn
    MAX(d.deliveryDate) AS last_delivery_date,
    MAX(d.status) AS last_delivery_status,
    STRING_AGG(d.carrier, ', ' ORDER BY d.deliveryDate) AS carriers_used,
    STRING_AGG(d.trackingCode, ', ' ORDER BY d.deliveryDate) AS tracking_codes
FROM Delivery d
WHERE d.status::DeliveryStatus IN ('IN_TRANSIT', 'DELIVERED', 'FAILED')
		AND DATE(d.deliveryDate) = CURRENT_DATE
GROUP BY d.orderId
HAVING COUNT(*) >= 2;  

GRANT SELECT ON orders_with_multiple_deliveries TO admin_role, 
					manager_role, employee_role, customer_role;

--- View thống kê số lượng tài khoản khách hàng tạo mỗi tháng trong 12 thánh gần nhất
CREATE OR REPLACE VIEW monthly_customer_registrations AS
SELECT 
    DATE_TRUNC('month', createdAt) AS registration_month,
    COUNT(id) AS user_count
FROM User1
WHERE 
    createdAt >= (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '11 months')
    AND isDeleted = false
    AND isActive = true
    AND isEmployee = false
	AND isAdmin = false
GROUP BY DATE_TRUNC('month', createdAt)
ORDER BY registration_month DESC;

GRANT SELECT ON monthly_customer_registrations TO admin_role, 
									manager_role, employee_role;

--- View đếm số lượng khách hàng theo hạng thành viên
CREATE OR REPLACE VIEW customr_tier_statistics AS
SELECT 
    userTier AS membership_tier,
    COUNT(id) AS user_count,
    ROUND(COUNT(id) * 100.0 / (SELECT COUNT(*) 
							FROM User1 
							WHERE isDeleted = false
							AND isAdmin = false
							AND isEmployee = false), 2) AS percentage
FROM User1
WHERE isDeleted = false
    AND isEmployee = false
	AND isAdmin = false
    AND userTier IS NOT NULL
GROUP BY userTier
ORDER BY 
    CASE userTier
        WHEN 'GOLD' THEN 1
        WHEN 'SILVER' THEN 2
        WHEN 'BRONZE' THEN 3
    END;

GRANT SELECT ON customr_tier_statistics TO admin_role, 
					manager_role, employee_role;

--- View tính doanh thu trong ngày hiện tại
CREATE OR REPLACE VIEW daily_net_revenue AS
SELECT
    CURRENT_DATE AS report_date,
    -- Tổng doanh thu thực tế (chỉ tính giao dịch thành công)
    SUM(p.amount) AS net_revenue,
    -- Phân tích theo phương thức thanh toán
    SUM(CASE WHEN p.method = 'CASH' THEN p.amount ELSE 0 END) AS cash_revenue,
    SUM(CASE WHEN p.method = 'CREDIT_CARD' THEN p.amount ELSE 0 END) AS credit_card_revenue,
    SUM(CASE WHEN p.method = 'BANK_TRANSFER' THEN p.amount ELSE 0 END) AS bank_transfer_revenue,
    -- Thống kê giao dịch
    COUNT(DISTINCT o.id) AS successful_order_count,
    COUNT(DISTINCT CASE WHEN p.status = 'REFUNDED' THEN p.id END) AS refunded_transactions,
    SUM(CASE WHEN p.status = 'REFUNDED' THEN p.amount ELSE 0 END) AS refunded_amount
FROM Order1 o JOIN Payment p ON o.id = p.orderId
WHERE DATE(p.paymentDate) = CURRENT_DATE
    AND o.isDeleted = false
    AND p.status::PaymentStatus = 'COMPLETED';

GRANT SELECT ON daily_net_revenue TO admin_role, manager_role, employee_role

--- View thống kê giao dịch lỗi/hoàn tiền
CREATE OR REPLACE VIEW payment_issue_stats AS
SELECT
    CURRENT_DATE AS report_date,
    COUNT(CASE WHEN p.status = 'FAILED' THEN p.id END) AS failed_payments,
    COUNT(CASE WHEN p.status = 'REFUNDED' THEN p.id END) AS refunded_payments,
    SUM(CASE WHEN p.status = 'FAILED' THEN p.amount ELSE 0 END) AS failed_amount,
    SUM(CASE WHEN p.status = 'REFUNDED' THEN p.amount ELSE 0 END) AS refunded_amount,
    ROUND(COUNT(CASE WHEN p.status = 'FAILED' THEN p.id END) * 100.0 / 
         NULLIF(COUNT(p.id), 0), 2) AS failure_rate_percentage
FROM Payment p
WHERE DATE(p.paymentDate) = CURRENT_DATE;

GRANT SELECT ON payment_issue_stats TO admin_role, manager_role, employee_role

--- View thống kê phiếu giảm giá theo chiến dịch
CREATE OR REPLACE VIEW campaign_coupon_usage_stats AS
SELECT 
    c.id AS campaign_id,
    c.name AS campaign_name,
    c.startDate AS start_date,
    c.endDate AS end_date,
    -- Thống kê ban hành
    COUNT(DISTINCT cp.id) AS total_coupons_created,
    -- Thống kê sử dụng (từ bảng CouponUsage)
    COUNT(DISTINCT cu.id) AS total_coupons_used,
    COUNT(DISTINCT cu.userId) AS unique_users_used,
    -- Tính tỷ lệ sử dụng (dựa trên số phiếu đã tạo)
    ROUND(COUNT(DISTINCT cu.id) * 100.0 / NULLIF(COUNT(DISTINCT cp.id), 0), 2) 
			AS usage_rate_percentage
FROM Campaign c LEFT JOIN Coupon cp ON c.id = cp.campaignId
    LEFT JOIN CouponUsage cu ON cp.id = cu.couponId
WHERE c.isDeleted = false
    AND cp.isDeleted = false
GROUP BY c.id, c.name, c.startDate, c.endDate
ORDER BY c.startDate DESC;

GRANT SELECT ON campaign_coupon_usage_stats TO admin_role, 
						manager_role, employee_role;

---  View thống kê người người dùng đăng nhập theo giờ
CREATE OR REPLACE VIEW daily_active_users AS
SELECT
    DATE(t.createdAt) AS login_date,
    COUNT(DISTINCT t.userId) AS active_users_count,
    -- Thời gian đăng nhập trung bình
    TO_CHAR(AVG(t.createdAt::time), 'HH24:MI:SS') AS avg_login_time,  
    -- Thống kê số lần đăng nhập theo mỗi user
    COUNT(t.id) AS token_issued_count
FROM Token t
WHERE DATE(t.createdAt) = CURRENT_DATE
    AND t.expiresAt > CURRENT_TIMESTAMP
GROUP BY DATE(t.createdAt)
ORDER BY login_date DESC;

GRANT SELECT ON daily_active_users TO admin_role, 
						manager_role, employee_role;

--- View thông kê các món ăn hết hàng do hết nguyên liệu trong kho
CREATE OR REPLACE VIEW OutOfStockMenuItems AS
SELECT DISTINCT mi.id AS menuItemId, mi.name AS menuItemName
FROM MenuItem mi
JOIN RecipeIngredient ri ON mi.id = ri.menuItemId
JOIN InventoryItem ii ON ri.inventoryItemId = ii.id
WHERE ii.quantity <= 0
  AND mi.isDeleted = false
  AND ii.isDeleted = false;

GRANT SELECT ON OutOfStockMenuItems TO admin_role, 
						manager_role, employee_role;


--- View liệt kê các function, procedure hiện có  trong database
CREATE OR REPLACE VIEW view_functions_procedures AS
SELECT
    p.proname AS name,
    CASE
        WHEN p.prokind = 'f' THEN 'FUNCTION'
        WHEN p.prokind = 'p' THEN 'PROCEDURE'
        ELSE 'OTHER'
    END AS type,
    n.nspname AS schema,
    pg_get_function_arguments(p.oid) AS arguments,
    pg_get_function_result(p.oid) AS return_type
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')

GRANT SELECT ON view_functions_procedures TO admin_role

--- View liệt kê các Trigger hiện có  trong database
CREATE OR REPLACE VIEW view_triggers AS
SELECT
    event_object_table AS table_name,
    trigger_name,
    action_timing AS trigger_timing,
    event_manipulation AS event,
    action_statement AS definition
FROM information_schema.triggers
WHERE trigger_schema NOT IN ('pg_catalog', 'information_schema')

GRANT SELECT ON view_triggers TO admin_role

--- View liệt kê các user được phân theo role 
CREATE OR REPLACE VIEW UserRolesView AS
SELECT 
    u.id,
    u.name,
    CASE
        WHEN u.isAdmin = TRUE THEN 'admin_role'
        WHEN u.isEmployee = TRUE AND e.role = 'MANAGER' THEN 'manager_role'
        WHEN u.isEmployee = TRUE AND e.role != 'MANAGER' THEN 'employee_role'
        ELSE 'customer_role'
    END AS userRole
FROM User1 u
	LEFT JOIN Employee e ON u.id = e.userId;

GRANT SELECT ON UserRolesView TO admin_role




------ MA HOA DU LIEU
--- Tạo trigger mã hoá mật khẩu khi Insert new User
CREATE OR REPLACE FUNCTION encrypt_user_password()
RETURNS TRIGGER AS $$
DECLARE
    encrypted_password VARCHAR(512); --Lưu trữ giá trị mật khẩu sau khi được mã hóa.
    secret_key VARCHAR(512) := 'key_password'; -- Khóa bí mật dùng để mã hóa AES.
BEGIN
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.password IS DISTINCT FROM NEW.password) THEN --Kiểm tra loại hành động (INSERT hoặc UPDATE có thay đổi mật khẩu)
        -- Băm mật khẩu bằng bcrypt
        encrypted_password := crypt(NEW.password, gen_salt('bf'));

        -- Mã hóa bằng AES-256 CBC
        encrypted_password := pgp_sym_encrypt(encrypted_password, secret_key, 'cipher-algo=aes256');

        -- Gán vào trường password
        NEW.password := encrypted_password;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_user_insert_update -- Gọi hàm trên trước khi chèn hoặc cập nhật dữ liệu.
BEFORE INSERT OR UPDATE ON User1
FOR EACH ROW
EXECUTE FUNCTION encrypt_user_password(); --Gọi hàm xử lý mỗi lần trigger kích hoạt.


-- Kiểm tra xem extension đã có chưa
SELECT * FROM pg_available_extensions WHERE name = 'pgcrypto';

-- Cài đặt extension nếu chưa có
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Dùng hàm store procedure thêm User add_user(name, password, email, phone, address) để thêm một User vào hệ thống
CALL add_user('Robert G. Holman', 'abc123ASde', 'RobertGHolman@example.com', '447706218252', '80 Peachfield Road, CHADDERTON');

select password 
from User1
where email = 'RobertGHolman@example.com';


-- Xác thực
CREATE OR REPLACE FUNCTION verify_user_login(p_email TEXT, p_password TEXT)
RETURNS BOOLEAN AS $$
-- Khai báo biến cục bộ
DECLARE
    stored_encrypted_password TEXT; --Lưu trữ mật khẩu đã được mã hóa từ DB.
    secret_key TEXT := 'key_password'; --Khóa bí mật dùng để giải mã AES-256 (phải giống với khóa đã dùng để mã hóa).
    decrypted_hashed_password TEXT; --Kết quả sau khi giải mã
BEGIN
    SELECT password INTO stored_encrypted_password FROM User1 WHERE email = p_email; --Truy vấn mật khẩu đã mã hóa từ bảng User

	--Kiểm tra xem password đã được mã hoá có tồn tại trong database hay không
    IF stored_encrypted_password IS NULL THEN
        RETURN FALSE;
    END IF;

	--Giải mã mật khẩu đã lưu
    BEGIN
        decrypted_hashed_password := pgp_sym_decrypt(stored_encrypted_password::bytea, secret_key); 
    EXCEPTION WHEN others THEN
        RAISE WARNING 'Xác thực thất bại cho người dùng: %', p_email;
        RETURN FALSE;
    END;

	--So sánh mật khẩu người dùng nhập vào với mật khẩu đã lưu
    RETURN crypt(p_password, decrypted_hashed_password) = decrypted_hashed_password;
END;
$$ LANGUAGE plpgsql;

SELECT verify_user_login('RobertGHolman@example.com', 'my_plain_password');
SELECT verify_user_login('RobertGHolman@example.com', 'myplainpassword');




--- 
CREATE OR REPLACE FUNCTION sync_pg_user()
RETURNS TRIGGER AS $$
DECLARE
    username TEXT;
    userRole TEXT;
BEGIN
    -- Xử lý tên người dùng: biến email thành tên PostgreSQL hợp lệ
    username := replace(replace(replace(lower(NEW.email), '@', '_at_'), '.', '_'), '-', '_');

    -- Xác định vai trò người dùng
    IF NEW.isAdmin = TRUE THEN
        userRole := 'admin_role';
    ELSIF NEW.isEmployee = TRUE AND EXISTS (
        SELECT 1 FROM Employee e WHERE e.userId = NEW.id AND e.role = 'MANAGER'
    ) THEN
        userRole := 'manager_role';
    ELSIF NEW.isEmployee = TRUE THEN
        userRole := 'employee_role';
    ELSE
        userRole := 'customer_role';
    END IF;

    -- Nếu là thao tác INSERT → Tạo user mới
    IF TG_OP = 'INSERT' THEN
        IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = username) THEN
            EXECUTE FORMAT('CREATE USER %I WITH PASSWORD %L;', username, NEW.password);
            EXECUTE FORMAT('GRANT %I TO %I;', userRole, username);
            EXECUTE FORMAT('ALTER USER %I SET ROLE %I;', username, userRole);
        END IF;

    -- Nếu là thao tác UPDATE → Cập nhật mật khẩu hoặc vai trò
    ELSIF TG_OP = 'UPDATE' THEN
        IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = username) THEN
            -- Cập nhật mật khẩu nếu thay đổi
            IF NEW.password IS DISTINCT FROM OLD.password THEN
                EXECUTE FORMAT('ALTER USER %I WITH PASSWORD %L;', username, NEW.password);
            END IF;

            -- Cập nhật role nếu thay đổi điều kiện
            EXECUTE FORMAT('REVOKE ALL ON SCHEMA public FROM %I;', username); -- Revoke cũ
            EXECUTE FORMAT('GRANT %I TO %I;', userRole, username);
            EXECUTE FORMAT('ALTER USER %I SET ROLE %I;', username, userRole);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_sync_pg_user
AFTER INSERT OR UPDATE ON User1
FOR EACH ROW
EXECUTE FUNCTION sync_pg_user();



SELECT 
    u.rolname AS user_name,
    u.rolcanlogin,
    ARRAY(
        SELECT r.rolname
        FROM pg_auth_members m
        JOIN pg_roles r ON m.roleid = r.oid
        WHERE m.member = u.oid
    ) AS roles
FROM pg_roles u
WHERE u.rolcanlogin = true
ORDER BY u.rolname;


-- Xem tất cả view trong database hiện tại
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public';
-- Hoặc chi tiết hơn
SELECT table_schema, table_name, view_definition 
FROM information_schema.views 
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

-- Xem quyền trên tất cả view
SELECT grantee, table_name, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_schema = 'public' AND table_name IN (
    SELECT table_name 
    FROM information_schema.views 
    WHERE table_schema = 'public'
);
-- Liệt kê tất cả role
SELECT rolname FROM pg_roles;
-- Xem view bạn có quyền truy cập
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public'
AND has_table_privilege(current_user, table_name, 'SELECT');

----- Xem quyền cụ thể của từng user trên database hiện tại
SELECT 
    grantee AS username,
    privilege_type,
    table_name
FROM 
    information_schema.role_table_grants
WHERE 
    grantee NOT LIKE 'pg_%' -- Loại bỏ các role hệ thống
ORDER BY 
    grantee, table_name, privilege_type;

	