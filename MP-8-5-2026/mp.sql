create database sales_management;

use sales_management;

create table customer (
    customer_id int primary key auto_increment,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) unique,
    address varchar(255),
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