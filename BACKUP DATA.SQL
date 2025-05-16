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
--- 1. Thêm customer
CREATE OR REPLACE PROCEDURE add_user(
    p_name VARCHAR(100),
    p_password VARCHAR(128),
    p_email VARCHAR(50),
    p_phone VARCHAR(15),
    p_address VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_id UUID;
BEGIN
    -- Generate new UUID
    SELECT gen_random_uuid() INTO new_id;
    
    -- Insert new user
    INSERT INTO User1 (
        id, name, password, email, phone, address, 
        isAdmin, isEmployee, isActive, createdAt, 
        userTier, point, isDeleted
    )
    VALUES (
        new_id, p_name, p_password, p_email, p_phone, p_address,
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
DECLARE
    new_em_id uuid;
BEGIN
    -- Generate new UUID
    SELECT gen_random_uuid() INTO new_em_id;

    INSERT INTO Employee (
        id, userId, salary, hourlyRate, hireDate, role, employmentType, employmentStatus, isDeleted
    ) VALUES (
        new_em_id, p_userId, 0, 0, CURRENT_TIMESTAMP, p_role, p_employmentType, p_employmentStatus, FALSE
    );

    RAISE NOTICE 'Employee created with ID: %', new_em_id;

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

---4. In ra danh sách nhân viên theo từng loại nhân viên (Employee) (Employee.role)
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


---13. Xem thông tin đặt bàn của khách hàng
CREATE OR REPLACE FUNCTION GetReservationsByUserId(p_userId UUID)
RETURNS TABLE (
    ReservationId UUID,
    ReservationTime TIMESTAMP,
    TableName VARCHAR(10),
    TableCapacity INT,
    Status ReservationStatus,
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


--- Phân tất cả các quyền về Bảng
GRANT USAGE ON SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_role;

-- Phân quyền cho admin_role trên tất cả các Store Procedure
GRANT EXECUTE ON PROCEDURE add_user TO admin_role;
GRANT EXECUTE ON PROCEDURE add_employee TO admin_role;
GRANT EXECUTE ON FUNCTION get_customers TO admin_role;
GRANT EXECUTE ON FUNCTION get_employees_by_role TO admin_role;
GRANT EXECUTE ON FUNCTION UpdateUserInfo TO admin_role;
GRANT EXECUTE ON FUNCTION GetWorkScheduleByEmployeeId TO admin_role;
GRANT EXECUTE ON PROCEDURE process_leave_request TO admin_role;
GRANT EXECUTE ON PROCEDURE record_employee_attendance TO admin_role;
GRANT EXECUTE ON FUNCTION GetAttendanceByEmployee TO admin_role;
GRANT EXECUTE ON PROCEDURE create_employee_schedule TO admin_role;
GRANT EXECUTE ON PROCEDURE generate_payroll TO admin_role;
GRANT EXECUTE ON PROCEDURE add_reservation TO admin_role;
GRANT EXECUTE ON FUNCTION GetReservationsByUserId TO admin_role;
GRANT EXECUTE ON PROCEDURE add_order TO admin_role;
GRANT EXECUTE ON PROCEDURE add_order_item TO admin_role;
GRANT EXECUTE ON FUNCTION get_customer_orders TO admin_role;
GRANT EXECUTE ON PROCEDURE process_payment TO admin_role;
GRANT EXECUTE ON PROCEDURE check_inventory_levels TO admin_role;
GRANT EXECUTE ON PROCEDURE update_inventory_after_order TO admin_role;
GRANT EXECUTE ON FUNCTION GetDeliveryByTrackingCode TO admin_role;
GRANT EXECUTE ON FUNCTION UpdateDelivery TO admin_role;
GRANT EXECUTE ON PROCEDURE create_coupon_campaign TO admin_role;
GRANT EXECUTE ON FUNCTION GetCouponsByCampaign TO admin_role;
GRANT EXECUTE ON PROCEDURE assign_coupons_to_users TO admin_role;
GRANT EXECUTE ON PROCEDURE add_review TO admin_role;

-- Phân quyền cho admin_role trên tất cả Functions 
GRANT EXECUTE ON FUNCTION GetCouponUsageCountByUser(UUID) TO admin_role;
GRANT EXECUTE ON FUNCTION GetMenuItemPopularitys() TO admin_role;
GRANT EXECUTE ON FUNCTION GetRevenueByDateGroup(VARCHAR) TO admin_role;
GRANT EXECUTE ON FUNCTION GetCompletedOrdersSummary() TO admin_role;
GRANT EXECUTE ON FUNCTION GetRevenueByMenuItem(INT) TO admin_role;
GRANT EXECUTE ON FUNCTION CompareRevenueBetweenPeriods(TIMESTAMP, TIMESTAMP, TIMESTAMP, TIMESTAMP) TO admin_role;
GRANT EXECUTE ON FUNCTION GetRevenueByPaymentMethod() TO admin_role;
GRANT EXECUTE ON FUNCTION calculate_employee_salary(UUID) TO admin_role;
GRANT EXECUTE ON FUNCTION calculate_order_total(UUID) TO admin_role;




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



--- Phân quyền về bảng của Employee_role
GRANT USAGE ON SCHEMA public TO employee_role;

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






--- Phân quyền về bảng của Customer_role
GRANT USAGE ON SCHEMA public TO customer_role;

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



--- Tạo trigger mã hoá mật khẩu khi Insert new User
CREATE OR REPLACE FUNCTION encrypt_user_password()
RETURNS TRIGGER AS $$
DECLARE
    encrypted_password TEXT; --Lưu trữ giá trị mật khẩu sau khi được mã hóa.
    secret_key TEXT := 'key_password'; -- Khóa bí mật dùng để mã hóa AES.
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

-- Dùng hàm store procedure thêm User add_user(name, password, email, phone, address) để thêm một User vào hệ thống
CALL add_user('Robert G. Holman', 'my_plain_password', 'RobertGHolman@example.com', '447706218252', '80 Peachfield Road, CHADDERTON');



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



