create database sales_management;

use sales_management;

create table customer (
    customer_id int primary key auto_increment,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) unique,
    address varchar(255),
    gender varchar(10),
    birth_date date,
    created_at datetime default current_timestamp
);

create table category (
    category_id int primary key auto_increment,
    category_name varchar(100) not null unique,
    description text
);

create table product (
    product_id int primary key auto_increment,
    product_name varchar(150) not null,
    price decimal(10,2) not null,
    stock int not null default 0,
    category_id int not null,

    foreign key (category_id)
    references category(category_id)
);

create table orders (
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date datetime default current_timestamp,
    status varchar(50) not null,

    foreign key (customer_id)
    references customer(customer_id)
);

create table order_detail (
    order_id int not null,
    product_id int not null,
    quantity int not null,
    unit_price decimal(10,2) not null,

    primary key (order_id, product_id),

    foreign key (order_id)
    references orders(order_id),

    foreign key (product_id)
    references product(product_id)
);

insert into category (category_name, description) values 
('Phone', 'Smart phone products'),
('Laptop', 'Laptop products'),
('Accessory', 'Accessories'),
('Mouse', 'Computer mouse'),
('Keyboard', 'Mechanical keyboard');

insert into product (product_name, price, stock, category_id) values 
('Redmi 12', 3500000, 10, 1),
('Poco X7 Pro', 8000000, 5, 1),
('Lenovo LOQ 2025', 22000000, 3, 2),
('Logitech G102 Mouse', 400000, 20, 4),
('Akko Mechanical Keyboard', 1200000, 15, 5),
('Dell Inspiron', 18000000, 4, 2),
('Razer Mouse', 900000, 10, 4);

insert into customer 
(full_name, email, phone, address, gender, birth_date) 
values 
('Dinh Quang Hao', 'hao@gmail.com', '0901234567', 'Ho Chi Minh City', 'Male', '2005-03-12'),
('Nguyen Khac Duy', 'duy@gmail.com', '0912345678', 'Thu Duc, Ho Chi Minh City', 'Male', '2004-08-21'),
('Le Thanh Hai', 'hai@gmail.com', '0923456789', 'District 1, Ho Chi Minh City', 'Male', '2003-01-15'),
('Nguyen Nhat Quoc Hung', 'hung@gmail.com', '0934567890', 'District 3, Ho Chi Minh City', 'Male', '2002-07-09'),
('Bui Minh Hieu', 'hieu@gmail.com', '0945678901', 'District 5, Ho Chi Minh City', 'Male', '2006-11-30');

insert into orders (order_date, customer_id, status) values 
('2026-05-01', 1, 'Pending'),
('2026-05-02', 2, 'Completed'),
('2026-05-03', 3, 'Shipping'),
('2026-05-04', 4, 'Pending'),
('2026-05-05', 5, 'Cancelled');

insert into order_detail (order_id, product_id, quantity, unit_price) values 
(1, 3, 1, 22000000),
(2, 1, 1, 3500000),
(3, 4, 2, 400000),
(4, 2, 1, 8000000),
(5, 5, 1, 1200000);

update product
set price = 5000000
where product_id = 1;

update customer
set email = 'lethanhhai@gmail.com'
where customer_id = 3;

delete from order_detail
where order_id = 5;

delete from orders
where order_id = 5;

insert into customer(full_name, email, phone, address)
values ('Tran Van A', 'vana@gmail.com', '0999999999', 'Ha Noi');

select 
    full_name as 'Ho Ten',
    email as 'Email',
    case
        when gender = 'Male' then 'Nam'
        when gender = 'Female' then 'Nu'
        else 'Khac'
    end as 'Gioi Tinh'
from customer;

select 
    full_name,
    birth_date,
    timestampdiff(year, birth_date, now()) as age
from customer
order by age asc
limit 3;

select 
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
from orders o
inner join customer c
on o.customer_id = c.customer_id;

select 
    c.category_name,
    count(p.product_id) as total_products
from category c
inner join product p
on c.category_id = p.category_id
group by c.category_name
having count(p.product_id) >= 2;

select 
    product_name,
    price
from product
where price > (
    select avg(price)
    from product
);

select 
    full_name,
    email
from customer
where customer_id not in (
    select customer_id
    from orders
);

select 
    c.category_name,
    sum(od.quantity * od.unit_price) as total_revenue
from category c
inner join product p
on c.category_id = p.category_id
inner join order_detail od
on p.product_id = od.product_id
group by c.category_name
having sum(od.quantity * od.unit_price) > (
    select avg(revenue) * 1.2
    from (
        select 
            sum(od.quantity * od.unit_price) as revenue
        from category c
        inner join product p
        on c.category_id = p.category_id
        inner join order_detail od
        on p.product_id = od.product_id
        group by c.category_id
    ) as temp
);

select 
    p1.product_name,
    p1.price,
    c.category_name
from product p1
inner join category c
on p1.category_id = c.category_id
where p1.price = (
    select max(p2.price)
    from product p2
    where p2.category_id = p1.category_id
);

select full_name
from customer
where customer_id in (

    select customer_id
    from orders
    where order_id in (

        select order_id
        from order_detail
        where product_id in (

            select product_id
            from product
            where category_id in (

                select category_id
                from category
                where category_name = 'Phone'
            )
        )
    )
)
and customer_id in (
    select customer_id
    from orders
    group by customer_id
    having count(order_id) >= 1
);