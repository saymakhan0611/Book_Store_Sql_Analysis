create database Store_Project;

-- CREATE BOOKS TABLE --
drop table if exists books;
create table Books(
Book_ID int primary key,
Title nvarchar(255),
Author nvarchar(255),
Genre nvarchar(255),
Published_Year int,
Price float,
Stock int
);
select * from book;
select * from Customers;



create table Orders(
Order_ID int not null primary key,
Customer_ID int references Customers(Customer_ID),
Book_ID int references book(Book_ID),
Order_Date date,
Quantity int,
Total_Amount float
);

ALTER TABLE book
ALTER COLUMN Book_ID INT NOT NULL;

ALTER TABLE book
ADD CONSTRAINT PK_book
PRIMARY KEY (Book_ID);

select * from Orders;


-- BASICS QURIES --

-- 1) RETRIEW ALL BOOK IN "FICTIONS" GENRE--
select * from book
where Genre='Fiction';

-- 2) FIND BOOK PUBLISH AFTER THE YEAR 1950--
select * from book
where Published_Year>1950;

-- 3) LIST ALL CUSTOMERS FROM CANADA --
select * from Customers
where Country='Canada';

-- 4) ORDERS PLACE IN NOVEMBER 2023 --
select * from Orders
where Order_Date between '2023-11-1' and '2023-11-30';

-- 5) RETRERIE THE TOTAL STOCK OF BOOK AVAILABEL--
select sum(Stock)as Total_Stock
from book;


-- 6) FIND THE DETAILS OF MOST EXPENSIVE BOOK --
SELECT TOP 1 *
FROM book
ORDER BY Price DESC;

-- 7) SHOW ALL CUSTOMER WHO ORDER MORE THAN ONE QUANTITY BOOK --
select * from Orders 
where Quantity>1;

-- 8) RETERIEW ALL ORDERS WHERE THE TOTAL AMOUNT EXCEEDS 20 --
select * from Orders
where Total_Amount>20;

-- 9) LIST ALL GENRES AVAILABLE IN BOOK STORE --
select distinct Genre from book;

-- 10) FIND THE BOOK WITH THE LOWEST STOCK --
select * from book order by Stock;

-- 11) CALCULATE TOTAL REVENUE GENERATE FROM ALL ORDERS --
select sum(Total_Amount)as Total_Revenue from Orders;

-- ADVANCED QURIES --

-- 1) TOTAL NO OF BOOK SOLD OF EACH GENRE --

select b.Genre,sum(o.Quantity)as Total_Sold
from Orders o
join book b on o.Book_ID=b.Book_ID
group by Genre;

-- 2) AVERAGE PRICE OF BOOK IN THE FANTACY GRNRE--
select AVG(Price) AS Average_Price 
from book
where Genre='Fantasy';

-- 3) LIST CUSTOMERS WHO HAVE PLACE AT LEATS 2 ORDERS--
select Customer_ID,count(Order_ID) 
from Orders
group by Customer_ID
having count(Order_ID)>=2;  -- having used for condition in aggregate functions--


-- 4) FIND MOST FREQUENTLY ORDER BOOK --
Select top 1 o.Book_ID,b.Title,count(o.Order_ID)as No_Of_Order_Book 
from Orders o
join book b
on o.Book_ID=b.Book_ID
group by o.Book_ID,b.Title
order by No_Of_Order_Book DESC;

-- 5)SHOW TOP 3 MOST EXPENSIVE BOOK OF FANTASY GENRE --
select top 3 * 
from book
where Genre='Fantasy'
order by Price DESC; 

-- 6) TOTAL QUANTITY OF BOOK SOLD BY EACH AUTHOR-- 
select b.Author,Sum(o.Quantity)as total_sold
from book b
join Orders o
on b.Book_ID=o.Book_ID
group by b.Author;

-- 7) LIST THE CITIES WHERE CUSTOMER WHO SPENT A OVER $30 ARE LOCATED --
select distinct c.City,o.Total_Amount
from Customers c
join Orders o
on c.Customer_ID=o.Customer_ID
where o.Total_Amount>30;

-- 8) FIND CUSTOMERS WHO SPENT MOST ON ORDERS--
select top 1 c.Customer_ID,c.Customer_Name,sum(o.total_Amount)as Total_Spent
from Orders o
join Customers c
on c.Customer_ID=o.Customer_ID
group by c.Customer_Name,c.Customer_ID
order by Total_Spent DESC ;
 
 -- 9) CALCULATE STOCK REMAINING AFTER FULFILING ALL ORDERS--
 select b.Book_ID, b.Title, b.Stock, COALESCE(sum(o.Quantity),0)as Order_Quantity,b.Stock-COALESCE(sum(o.Quantity),0)as Remaining_Orders
 from book b
 left join Orders o
 on b.Book_ID=o.Book_ID
 group by b.Book_ID,b.Title, b.Stock;

 -- here COALESCE function first find the sum of order quantity then substract that order quantity from stock to find remauning stock--