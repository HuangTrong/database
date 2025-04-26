-- Employment Related Enums
CREATE TYPE EmploymentType AS ENUM (
    'FULL_TIME',
    'PART_TIME'
);

CREATE TYPE EmploymentStatus AS ENUM (
    'ACTIVE',
    'RESIGNED',
    'TERMINATED',
    'ON_LEAVE'
);

CREATE TYPE Role AS ENUM (
    'MANAGER',
    'CASHIER',
    'COOK',
    'WAITER',
    'DELIVERY'
);

-- Shift and Leave Enums
CREATE TYPE ShiftType AS ENUM (
    'MORNING',
    'AFTERNOON', 
    'EVENING',
    'NIGHT'
);

CREATE TYPE LeaveStatus AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED'
);

CREATE TYPE OvertimeStatus AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);

-- Create table DB_and Reservation Enums
CREATE TYPE TableStatus AS ENUM (
    'AVAILABLE',
    'OCCUPIED',
    'RESERVED'
);

CREATE TYPE ReservationStatus AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED'
);

-- Order Related Enums
CREATE TYPE OrderType AS ENUM (
    'DINE_IN',
    'TAKEAWAY',
    'DELIVERY'
);

CREATE TYPE OrderStatus AS ENUM (
    'PENDING',
    'PROCESSING',
    'SERVED',
    'DELIVERED',
    'CANCELLED',
    'RETURNED',
    'FAILED'
);

-- Transaction and Delivery Enums
CREATE TYPE TransactionType AS ENUM (
    'IMPORT',
    'EXPORT'
);

CREATE TYPE DeliveryStatus AS ENUM (
    'PENDING',
    'IN_TRANSIT',
    'DELIVERED',
    'FAILED'
);

-- Payment Related Enums
CREATE TYPE PaymentMethod AS ENUM (
    'CREDIT_CARD',
    'CASH',
    'BANK_TRANSFER'
);

CREATE TYPE PaymentStatus AS ENUM (
    'PENDING',
    'COMPLETED',
    'FAILED',
    'REFUNDED'
);

-- Coupon and Discount Enums
CREATE TYPE CouponStatus AS ENUM (
    'AVAILABLE',
    'ALLOCATED',
    'EXPIRED',
    'USED'
);

CREATE TYPE DiscountType AS ENUM (
    'PERCENTAGE',
    'FIXED_AMOUNT'
);

-- User and Inventory Enums
CREATE TYPE UserTier AS ENUM (
    'GOLD',
    'SILVER',
    'BRONZE'
);

CREATE TYPE InventoryCategory AS ENUM (
    'MEAT',
    'VEGETABLE',
    'SPICE',
    'DAIRY',
    'BEVERAGE'
);
-----Tạo các bảng
---Tạo bảng Campain
CREATE TABLE Campaign (
	id UUID PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(255),
	startDate TIMESTAMP NOT NULL,
	userTier UserTier NOT NULL ,
	endDate TIMESTAMP NOT NULL,
	isDeletad BOOLEAN DEFAULT FALSE
);

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

----alter table Coupon rename column campaidnId to campaignId
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
	password VARCHAR(128),
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
	status ReservationStatus,
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
ALTER TABLE CouponPool ADD CONSTRAINT 
fk_campaignId_CP FOREIGN KEY (campaignId) REFERENCES Campaign(id) ON DELETE CASCADE;
---
ALTER TABLE Coupon ADD CONSTRAINT 
fk_campaignId_C FOREIGN KEY (campaignId) REFERENCES Campaign(id) ON DELETE CASCADE;

ALTER TABLE Coupon ADD CONSTRAINT 
fk_poolId_C FOREIGN KEY (poolId) REFERENCES CouponPool(id) ON DELETE CASCADE;
---
ALTER TABLE CouponTarget ADD CONSTRAINT 
fk_couponId_CT FOREIGN KEY (couponId) REFERENCES Coupon(id) ON DELETE CASCADE;

ALTER TABLE CouponTarget ADD CONSTRAINT 
fk_userId_CT FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
---
ALTER TABLE CouponUsage ADD CONSTRAINT 
fk_couponId_CU FOREIGN KEY (couponId) REFERENCES Coupon(id) ON DELETE CASCADE;

ALTER TABLE CouponUsage ADD CONSTRAINT 
fk_userId_CU FOREIGN KEY (UserId) REFERENCES User1(id) ON DELETE CASCADE;

---
ALTER TABLE Employee ADD CONSTRAINT 
fk_userId_E FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;


--- Khoá ngoại bảng LeaveRequest tới bảng Employee
ALTER TABLE LeaveRequest ADD CONSTRAINT 
fk_employeeId_LR FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;

--- Khoá ngoại bảng Attendance tới bảng Employee
ALTER TABLE Attendance ADD CONSTRAINT 
fk_employeeId_A FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;

--- Khoá ngoại bảng OvertimeRequest tới bảng Employee
ALTER TABLE OvertimeRequest ADD CONSTRAINT 
fk_employeeId_OR FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;

--- Khoá ngoại bảng Payroll tới bảng Employee
ALTER TABLE Payroll ADD CONSTRAINT 
fk_employeeId_P FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;

--- Khoá ngoại bảng WorkSchedule tới bảng Employee
ALTER TABLE WorkSchedule ADD CONSTRAINT 
fk_employeeId_WS FOREIGN KEY (employeeId) REFERENCES Employee(id) ON DELETE CASCADE;

--- Khoá ngoại bảng WorkSchedule tới bảng ShiftTemplate
ALTER TABLE WorkSchedule ADD CONSTRAINT 
fk_shiftTemplateId_WS FOREIGN KEY (shiftTemplateId) REFERENCES ShiftTemplate(id) ON DELETE CASCADE;

--- Khoá ngoại bảng Token tới bảng User1
ALTER TABLE Token ADD CONSTRAINT 
fk_userId_T FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;

---Khoá ngoại bảng Reservation tới bảng Order1
ALTER TABLE Reservation ADD CONSTRAINT 
fk_orderId_Res FOREIGN KEY (orderId) REFERENCES Order1 (id) ON DELETE CASCADE;

ALTER TABLE Reservation ADD CONSTRAINT 
fk_userId_Res FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
---
ALTER TABLE Review ADD CONSTRAINT 
fk_orderId_Rev FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;

ALTER TABLE Review ADD CONSTRAINT 
fk_userId_Rev FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;
---
ALTER TABLE Order1 ADD CONSTRAINT 
fk_table_O FOREIGN KEY (tableId) REFERENCES Table1(id) ON DELETE CASCADE;

ALTER TABLE Order1 ADD CONSTRAINT 
fk_userId_O FOREIGN KEY (userId) REFERENCES User1(id) ON DELETE CASCADE;

ALTER TABLE Order1 ADD CONSTRAINT 
fk_couponId_Res FOREIGN KEY (couponId) REFERENCES Coupon(id) ON DELETE CASCADE;

ALTER TABLE Payment ADD CONSTRAINT 
fk_orderId_P FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;

ALTER TABLE Delivery ADD CONSTRAINT 
fk_orderId_D FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;
---
ALTER TABLE OrderItem ADD CONSTRAINT 
fk_orderId_OI FOREIGN KEY (orderId) REFERENCES Order1(id) ON DELETE CASCADE;

ALTER TABLE OrderItem ADD CONSTRAINT 
fk_menuItemId_OI FOREIGN KEY (menuItemId) REFERENCES MenuItem(id) ON DELETE CASCADE;
---
ALTER TABLE MenuItem ADD CONSTRAINT 
fk_categoryId_MI FOREIGN KEY (categoryId) REFERENCES MenuCategory(id) ON DELETE CASCADE;
---
ALTER TABLE RecipeIngredient ADD CONSTRAINT 
fk_menuItemId_RI FOREIGN KEY (menuItemId) REFERENCES MenuItem(id) ON DELETE CASCADE;

ALTER TABLE RecipeIngredient ADD CONSTRAINT 
fk_inventoryItemId_RI FOREIGN KEY (inventoryItemId) REFERENCES InventoryItem(id) ON DELETE CASCADE;
---
ALTER TABLE InventoryItem ADD CONSTRAINT 
fk_supplierId_II FOREIGN KEY (supplierId) REFERENCES Supplier(id) ON DELETE CASCADE;
---
ALTER TABLE InventoryTransaction ADD CONSTRAINT 
fk_inventoryItemId_IT FOREIGN KEY (inventoryItemId) REFERENCES InventoryItem(id) ON DELETE CASCADE;






--STORE PROCEDURE
--1. In ra danh sách User (User)
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

--2. In ra danh sách nhân viên (Employee)
CREATE OR REPLACE FUNCTION get_all_employees()
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
    ORDER BY 
        u.name;
END;
$$ LANGUAGE plpgsql;


--3. In ra danh sách hoá đơn (Order) của 1 khách hàng (User.ID)
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


--4. In ra danh sách nhân viên theo từng loại nhân viên (Employee) (Employee.role)
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


--5. In ra danh sách nhân viên làm việc trong ngày nào đó (Employee + Work schedule) (WorkSchedule.date ~ WorkSchedule)
CREATE OR REPLACE FUNCTION get_employees_working_on_date(work_date DATE)
RETURNS TABLE (
    employee_id UUID,
    name VARCHAR(100),
    email VARCHAR(50),
    phone VARCHAR(15),
    role Role,
    shift_name VARCHAR(50),
    shift_type VARCHAR(50),
    shift_start TIMESTAMP,
    shift_end TIMESTAMP,
    start_time VARCHAR(15),
    end_time VARCHAR(15)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id AS employee_id,
        u.name,
        u.email,
        u.phone,
        e.role,
        st.name AS shift_name,
        st.shiftType AS shift_type,
        ws.shiftStart AS shift_start,
        ws.shiftEnd AS shift_end,
        st.startTime AS start_time,
        st.endTime AS end_time
    FROM 
        WorkSchedule ws
    JOIN 
        Employee e ON ws.employeeId = e.id
    JOIN 
        User1 u ON e.userId = u.id
    LEFT JOIN
        ShiftTemplate st ON ws.shiftTemPlateId = st.id
    WHERE 
        e.isDeleted = FALSE
        AND ws.isDeleted = FALSE
        AND DATE(ws.date) = work_date
    ORDER BY 
        st.name,
        u.name;
END;
$$ LANGUAGE plpgsql;



--6. In ra danh sách coupon (Coupon)
CREATE OR REPLACE FUNCTION get_coupons(
    status_filter CouponStatus DEFAULT NULL,
    is_active_filter BOOLEAN DEFAULT NULL
)
RETURNS TABLE (
    coupon_id UUID,
    code VARCHAR(30),
    discount_type DiscountType,
    discount_value DECIMAL(12,2),
    min_order_value DECIMAL(12,2),
    max_discount_value DECIMAL(12,2),
    usage_limit INT,
    status CouponStatus,
    is_active BOOLEAN,
    expires_at TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    campaign_name VARCHAR(50),
    pool_name VARCHAR(150),
    allocated_count INT,
    usage_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id AS coupon_id,
        c.code,
        c.discountType AS discount_type,
        c.discountValue AS discount_value,
        c.minOrderValue AS min_order_value,
        c.maxDiscountValue AS max_discount_value,
        c.usageLimit AS usage_limit,
        c.status,
        c.isActive AS is_active,
        c.expiresAt AS expires_at,
        c.createdAt AS created_at,
        c.updatedAt AS updated_at,
        cam.name AS campaign_name,
        cp.name AS pool_name,
        cp.allocatedCount AS allocated_count,
        COUNT(cu.id) AS usage_count
    FROM 
        Coupon c
    LEFT JOIN 
        Campaign cam ON c.campaignId = cam.id
    LEFT JOIN 
        CouponPool cp ON c.poolId = cp.id
    LEFT JOIN 
        CouponUsage cu ON c.id = cu.couponId
    WHERE 
        c.isDeleted = FALSE
        AND (status_filter IS NULL OR c.status = status_filter)
        AND (is_active_filter IS NULL OR c.isActive = is_active_filter)
    GROUP BY
        c.id, c.code, c.discountType, c.discountValue, c.minOrderValue, 
        c.maxDiscountValue, c.usageLimit, c.status, c.isActive, c.expiresAt, 
        c.createdAt, c.updatedAt, cam.name, cp.name, cp.allocatedCount
    ORDER BY 
        c.createdAt DESC;
END;
$$ LANGUAGE plpgsql;


--7. In ra danh sách bàn đã đặt (Table.TableStatus = ‘OCCUPIED’) (Table)
CREATE OR REPLACE FUNCTION get_occupied_tables()
RETURNS TABLE (
    table_id UUID,
    table_number VARCHAR(10),
    capacity INT,
    status TableStatus,
    order_id UUID,
    order_type OrderType,
    order_date TIMESTAMP,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(15),
    total_amount DECIMAL(12,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id AS table_id,
        t.number AS table_number,
        t.capacity,
        t.status,
        o.id AS order_id,
        o.orderType AS order_type,
        o.orderDate AS order_date,
        u.name AS customer_name,
        u.phone AS customer_phone,
        o.totalAmount AS total_amount
    FROM 
        Table1 t
    LEFT JOIN 
        Order1 o ON t.id = o.tableId AND o.status NOT IN ('CANCELLED', 'RETURNED', 'FAILED')
    LEFT JOIN 
        User1 u ON o.userId = u.id
    WHERE 
        t.status = 'OCCUPIED'
        AND t.isDeleted = FALSE
    ORDER BY 
        t.number;
END;
$$ LANGUAGE plpgsql;

-- 8. Thêm User
CREATE OR REPLACE PROCEDURE add_user(
  p_id UUID,
  p_name VARCHAR(100),
  p_password VARCHAR(128),
  p_email VARCHAR(50),
  p_phone VARCHAR(15),
  p_address VARCHAR(255),
  p_isAdmin BOOLEAN DEFAULT FALSE,
  p_isEmployee BOOLEAN DEFAULT FALSE,
  p_createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  p_userTier UserTier DEFAULT 'BRONZE',
  p_point INT DEFAULT 0
)
LANGUAGE SQL
AS $$
INSERT INTO User1 (id, name, password, email, phone, address, isAdmin, isEmployee, createdAt, userTier, point)
VALUES (p_id, p_name, p_password, p_email, p_phone, p_address, p_isAdmin, p_isEmployee, p_createdAt, p_userTier, p_point);
$$;

-- 9. Thêm Employee
CREATE OR REPLACE PROCEDURE add_employee(
  p_id UUID,
  p_userId UUID,
  p_salary DECIMAL(12,2),
  p_hourlyRate DECIMAL(12,2),
  p_hireDate TIMESTAMP,
  p_role Role,
  p_employmentType EmploymentType
)
LANGUAGE SQL
AS $$
INSERT INTO Employee (id, userId, salary, hourlyRate, hireDate, role, employmentType)
VALUES (p_id, p_userId, p_salary, p_hourlyRate, p_hireDate, p_role, p_employmentType);
$$;

-- 10. Thêm MenuItem
CREATE OR REPLACE PROCEDURE add_menu_item(
  p_id UUID,
  p_name VARCHAR(100),
  p_description VARCHAR(255),
  p_price DECIMAL(12,2),
  p_categoryId UUID,
  p_isAvailable BOOLEAN DEFAULT TRUE
)
LANGUAGE SQL
AS $$
INSERT INTO MenuItem (id, name, description, price, categoryId, isAvailable)
VALUES (p_id, p_name, p_description, p_price, p_categoryId, p_isAvailable);
$$;

-- 11. Thêm OrderItem
CREATE OR REPLACE PROCEDURE add_order_item(
  p_id UUID,
  p_orderId UUID,
  p_menuItemId UUID,
  p_quantity INT,
  p_price DECIMAL(12,2)
)
LANGUAGE SQL
AS $$
INSERT INTO OrderItem (id, orderId, menuItemId, quantity, price)
VALUES (p_id, p_orderId, p_menuItemId, p_quantity, p_price);
$$;

-- 12. Thêm Coupon
CREATE OR REPLACE PROCEDURE add_coupon(
  p_id UUID,
  p_code VARCHAR(30),
  p_discountType DiscountType,
  p_discountValue DECIMAL(12,2),
  p_minOrderValue DECIMAL(12,2),
  p_maxDiscountValue DECIMAL(12,2),
  p_usageLimit INT,
  p_status CouponStatus,
  p_expiresAt TIMESTAMP,
  p_campaignId UUID,
  p_poolId UUID
)
LANGUAGE SQL
AS $$
INSERT INTO Coupon (id, code, discountType, discountValue, minOrderValue, maxDiscountValue, usageLimit, status, expiresAt, campaignId, poolId)
VALUES (p_id, p_code, p_discountType, p_discountValue, p_minOrderValue, p_maxDiscountValue, p_usageLimit, p_status, p_expiresAt, p_campaignId, p_poolId);
$$;


--13. Thêm Reservation
CREATE OR REPLACE PROCEDURE add_reservation(
  p_id UUID,
  p_userId UUID,
  p_orderId UUID,
  p_reservationTime TIMESTAMP,
  p_status ReservationStatus,
)
LANGUAGE SQL
AS $$
INSERT INTO Reservation (id, userId, orderId, reservationTime, status)
VALUES (p_id, p_userId, p_orderId, p_reservationTime, p_status);
$$;


--14. Thêm Review
CREATE OR REPLACE PROCEDURE add_review(
  p_id UUID,
  p_userId UUID,
  p_orderId UUID,
  p_rating int,
  p_comment varchar(255),
  p_createdAt TIMESTAMP
)
LANGUAGE SQL
AS $$
INSERT INTO Review (id, userId, orderId, rating, comment, createdAt)
VALUES (p_id, p_userId, p_orderId, p_rating, p_comment, p_createdAt);
$$;




--FUNCTIONS
--1. Tính số User đã đăng ký (User.isActive = true)
CREATE OR REPLACE FUNCTION count_active_users()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM User1 WHERE isActive = true 
          AND isDeleted = false);
END;
$$ LANGUAGE plpgsql;


--1.1 Tính số Employee đã vào làm (User.isEmployee = true)
CREATE OR REPLACE FUNCTION count_employees()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM User1 WHERE isEmployee = true 
          AND isDeleted = false);
END;
$$ LANGUAGE plpgsql;


--2. Tính tổng lương của 1 Employee
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


--3. Tính số coupon đã được kích hoạt (Coupon.isActive = true)
CREATE OR REPLACE FUNCTION count_active_coupons()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM Coupon WHERE isActive = true 
          AND isDeleted = false);
END;
$$ LANGUAGE plpgsql;


--4. Tính số coupon đã được sử dụng (Coupon.status = 'USED')
CREATE OR REPLACE FUNCTION count_used_coupons()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM Coupon  WHERE status = 'USED'::CouponStatus 
          AND isDeleted = false and isActive = true);
END;
$$ LANGUAGE plpgsql;


--5. Tính số bàn đã được đặt (Table.TableStatus = 'OCCUPIED')
CREATE OR REPLACE FUNCTION count_occupied_tables()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM Table1  WHERE status = 'OCCUPIED'::TableStatus 
          AND isDeleted = false);
END;
$$ LANGUAGE plpgsql;


--6. Tính tổng số bàn có trong cửa hàng
CREATE OR REPLACE FUNCTION count_total_tables()
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM Table1 WHERE isDeleted = false);
END;
$$ LANGUAGE plpgsql;


--7. Tính tổng số món ăn đã order trong 1 order
CREATE OR REPLACE FUNCTION total_order_items(order_id UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT SUM(quantity) FROM OrderItem WHERE orderId = order_id);
END;
$$ LANGUAGE plpgsql;


--8. Số lượng order trong 1 tháng/1 ngày
CREATE OR REPLACE FUNCTION count_orders_by_date(date_filter DATE, filter_type TEXT)
RETURNS INTEGER AS $$
BEGIN
    IF filter_type = 'DAY' THEN
        RETURN (SELECT COUNT(*) FROM Order1 WHERE DATE(orderDate) = date_filter);
    ELSIF filter_type = 'MONTH' THEN
        RETURN (SELECT COUNT(*) FROM Order1 WHERE DATE_TRUNC('month', orderDate) = DATE_TRUNC('month', date_filter));
    ELSE
        RAISE EXCEPTION 'Invalid filter type. Use "DAY" or "MONTH".';
    END IF;
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


--- Tạo role cho Admin
CREATE ROLE admin_role;

--- Tạo role cho quản lý
CREATE ROLE manager_role;

--- Tạo role cho nhân viên
CREATE ROLE employee_role;

--- Tạo role cho khách hàng
CREATE ROLE customer_role;


--- Tạo người dùng Admin và gán role
CREATE USER restaurant_admin WITH PASSWORD 'admin_secure_password';
GRANT admin_role TO restaurant_admin;
ALTER USER restaurant_admin SET ROLE admin_role;

--- Tạo người dùng Manager và gán role
CREATE USER restaurant_manager WITH PASSWORD 'manager_secure_password';
GRANT manager_role TO restaurant_manager;
ALTER USER restaurant_manager SET ROLE manager_role;

--- Tạo người dùng Employee và gán role
create user restaurant_employee with password 'employee_secure_password';
grant employee_role to restaurant_employee;
ALTER USER restaurant_employee SET ROLE employee_role;

--- Tạo người dùng Customer và gán role
create user restaurant_customer with password 'customer_password';
grant customer_role to restaurant_customer;
ALTER USER restaurant_customer SET ROLE customer_role;


--- Phân tất cả các quyền về Bảng, functions, procedures cho Admin_role
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_role;
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA public TO admin_role;



--- Phân quyền về bảng của Manager_role
GRANT USAGE ON SCHEMA public TO manager_role;
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

