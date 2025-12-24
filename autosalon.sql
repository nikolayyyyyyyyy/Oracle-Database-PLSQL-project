create sequence country_seq start with 1 increment by 1;
create sequence city_seq start with 1 increment by 1;
create sequence client_seq start with 1 increment by 1;
create sequence position_seq start with 1 increment by 1;
create sequence employee_seq start with 1 increment by 1;
create sequence brand_seq start with 1 increment by 1;
create sequence model_seq start with 1 increment by 1;
create sequence color_seq start with 1 increment by 1;
create sequence car_seq start with 1 increment by 1;
create sequence sale_seq start with 1 increment by 1;
create sequence sales_cars_seq start with 1 increment by 1;

drop sequence car_seq;
drop table cars cascade constraint;

--Create tables--
create table countries(
country_id number primary key,
country_name varchar(100) unique
);
 
create table cities(
city_id number primary key,
city_name varchar(50) unique,
country_id number not null,
constraint city_country_FK foreign key(country_id) references countries(country_id)
);
 
create table clients(
client_id number primary key,
first_name varchar(50) not null,
middle_name varchar(50) not null,
last_name varchar(50) not null,
available_amount number(10,2) not null,
address varchar(100) not null,
phone_number varchar(10) not null,
city_id number not null,
constraint client_city_FK foreign key (city_id) references cities(city_id)
);
 
create table positions(
position_id number primary key,
position_name varchar(50) not null unique
);

create table employees(
employee_id number primary key,
first_name varchar(50) not null,
middle_name varchar(50) not null,
last_name varchar(50) not null,
phone_number varchar(10),
position_id number,
constraint employee_position_FK foreign key (position_id) references positions(position_id)
);

create table brands(
brand_id number primary key,
brand varchar(50) not null unique
);
 
create table models(
model_id number primary key,
"model" varchar(50) not null unique,
brand_id number not null,
constraint model_brand_FK foreign key (brand_id) references brands(brand_id)
);
 
create table colors(
color_id number primary key,
color varchar(50) not null unique
);
 
create table cars(
car_id number primary key,
kilometers number(9,2) default 100000.00 check (kilometers > 0),
available_cars_count number check (available_cars_count > 0),
price number(10,2) check (price > 0),
manufacture_year date not null,
model_id number not null,
color_id number not null,
constraint car_model_FK foreign key (model_id) references models(model_id),
constraint car_color_FK foreign key (color_id) references colors(color_id)
);
 
create table sales(
sale_id number primary key,
sale_amount number(10,2) check (sale_amount >= 0),
discount number check (discount >= 0),
sale_day date,
employee_id number not null,
client_id number not null,
constraint sales_employee_FK foreign key (employee_id) references employees(employee_id),
constraint sale_clients_FK foreign key (client_id) references clients(client_id)
);

create table sales_cars(
sales_cars_id number primary key,
car_id number not null,
sale_id number not null,
constraint sales_cars_car_FK foreign key (car_id) references cars(car_id),
constraint sales_cars_sale_FK foreign key (sale_id) references sales(sale_id)
);

--Create AutoIncrement triggers--
create or replace trigger country_auto_increment
before insert on countries 
for each row
begin
    :new.country_id := country_seq.nextval;
end;

create or replace trigger city_auto_increment
before insert on cities
for each row
begin
    :new.city_id := city_seq.nextval;
end;

create or replace trigger client_auto_increment
before insert on clients
for each row
begin
    :new.client_id := client_seq.nextval;
end;

create or replace trigger position_auto_increment
before insert on positions
for each row
begin
    :new.position_id := position_seq.nextval;
end;

create or replace trigger employee_auto_increment
before insert on employees
for each row
begin
    :new.employee_id := employee_seq.nextval;
end;

create or replace trigger brand_auto_increment
before insert on brands
for each row
begin
    :new.brand_id := brand_seq.nextval;
end;

create or replace trigger model_auto_increment
before insert on models
for each row
begin
    :new.model_id := model_seq.nextval;
end;

create or replace trigger color_auto_increment
before insert on colors
for each row
begin
    :new.color_id := color_seq.nextval;
end;

create or replace trigger car_auto_increment
before insert on cars
for each row
begin
    :new.car_id := car_seq.nextval;
end;

create or replace trigger sale_auto_increment
before insert on sales
for each row
begin
    :new.sale_id := sale_seq.nextval;
end;

create or replace trigger sales_cars_auto_increment
before insert on sales_cars
for each row
begin
    :new.sales_cars_id := sales_cars_seq.nextval;
end;
 
--Create procedures for insert values--
create or replace procedure countries_ins(country_name countries.country_name%type) as
begin
    insert into countries(country_name)
        values(country_name);
end;

create or replace procedure countries_upd(v_country_id countries.country_id%type,
                                            v_country_name countries.country_name%type)
as begin
    update countries
        set country_name = v_country_name
    where country_id = v_country_id;
end;
 
create or replace procedure cities_ins(v_city_name cities.city_name%type,v_country_id cities.country_id%type) as
begin
    insert into cities(city_name,country_id)
        values(v_city_name,v_country_id);
end;

create or replace procedure cities_upd(v_city_id cities.city_id%type,v_city_name cities.city_name%type)
as begin
    update cities
        set city_name = v_city_name
    where city_id = v_city_id;
end;
 
create or replace procedure clients_ins(
v_first_name clients.first_name%type,
v_middle_name clients.middle_name%type,
v_last_name clients.last_name%type,
v_available_amount clients.available_amount%type,
v_address clients.address%type,
v_phone_number clients.phone_number%type,
v_city_id clients.city_id%type) as
begin
    insert into clients(first_name,
                        middle_name,
                        last_name,
                        available_amount,
                        address,
                        phone_number,
                        city_id)
          values(v_first_name,
                 v_middle_name,
                 v_last_name,
                 v_available_amount,
                 v_address,
                 v_phone_number,
                 v_city_id);
end;

create or replace procedure clients_upd(v_client_id clients.client_id%type,
                                        v_client_first_name clients.first_name%type,
                                        v_client_middle_name clients.middle_name%type,
                                        v_client_last_name clients.last_name%type,
                                        v_client_available_amount clients.available_amount%type,
                                        v_client_address clients.address%type,
                                        v_number clients.phone_number%type)
as begin
    update clients
        set first_name = v_client_first_name,
            middle_name = v_client_middle_name,
            last_name = v_client_last_name,
            available_amount = v_client_available_amount,
            address = v_client_address,
            phone_number = v_number
    where client_id = v_client_id;
end;

create or replace procedure positions_ins(v_position_name positions.position_name%type) as
begin
    insert into positions(position_name)
        values(v_position_name);
end;

create or replace procedure positions_upd(v_position_id positions.position_id%type,
                                        v_position_name positions.position_name%type)
as begin
    update positions
        set position_name = v_position_name
    where position_id = v_position_id;
end;
 
create or replace procedure employees_ins(
v_first_name employees.first_name%type,
v_middle_name employees.middle_name%type,
v_last_name employees.last_name%type,
v_phone_number employees.phone_number%type,
v_position_id employees.position_id%type)
as
begin
    insert into employees(first_name,middle_name,last_name,phone_number,
                        position_id)
          values(v_first_name,
                 v_middle_name,
                 v_last_name,
                 v_phone_number,
                 v_position_id);
end;

create or replace procedure employees_upd(
v_employee_id employees.employee_id%type,
v_employee_first_name employees.first_name%type,
v_employee_middle_name employees.middle_name%type,
v_employee_last_name employees.last_name%type,
v_employee_position_id employees.position_id%type,
v_number employees.phone_number%type)
as begin
    update employees
        set first_name = v_employee_first_name,
            middle_name = v_employee_middle_name,
            last_name = v_employee_last_name,
            position_id = v_employee_position_id,
            phone_number = v_number
    where employee_id = v_employee_id;
end;

create or replace procedure brands_ins(
v_brand brands.brand%type)
as
begin
    insert into brands(brand)
        values(v_brand);
end;

create or replace procedure brands_upd(v_brand_id brands.brand_id%type,
                                        v_brand brands.brand%type)
as begin
    update brands
        set brand = v_brand
    where brand_id = v_brand_id;
end;
 
create or replace procedure models_ins(
v_model models."model"%type,
v_brand_id models.brand_id%type)
as
begin
    insert into models("model",brand_id)
        values(v_model,v_brand_id);
end;

create or replace procedure models_upd(v_model_id models.model_id%type,
                                        v_model models."model"%type,
                                        v_brand_id models.brand_id%type)
as begin
    update models
        set "model" = v_model,
            brand_id = v_brand_id
    where model_id = v_model_id;
end;

create or replace procedure colors_ins(
v_color colors.color%type)
as
begin
    insert into colors(color)
        values(v_color);
end;

create or replace procedure colors_upd(v_color_id number,
                                        v_color colors.color%type)
as begin 
    update colors
        set color = v_color
    where color_id = v_color_id;
end;

create or replace procedure cars_ins(
v_kilometers cars.kilometers%type,
v_available_cars_count cars.available_cars_count%type,
v_price cars.price%type,
v_manufacture_year cars.manufacture_year%type,
v_model_id cars.model_id%type,
v_color_id cars.color_id%type)
as
begin
    insert into cars(kilometers,available_cars_count,price,manufacture_year,model_id,
                    color_id)
        values(v_kilometers,
            v_available_cars_count,
            v_price,
            v_manufacture_year,
            v_model_id,
            v_color_id);
end;

create or replace procedure cars_upd(v_car_id cars.car_id%type,
v_car_kilometers cars.kilometers%type,
v_car_available_car_count cars.available_cars_count%type,
v_car_price cars.price%type,
v_car_manufacture_year cars.manufacture_year%type,
v_car_model_id cars.model_id%type,
v_car_color_id cars.color_id%type)
as begin
    update cars
        set kilometers = v_car_kilometers,
            available_cars_count = v_car_available_car_count,
            price = v_car_price,
            manufacture_year = v_car_manufacture_year,
            model_id = v_car_model_id,
            color_id = v_car_color_id            
    where car_id = v_car_id;
end;

create or replace procedure sales_ins(
v_sale_amount sales.sale_amount%type,
v_discount sales.discount%type,
v_sale_day sales.sale_day%type,
v_employee_id sales.employee_id%type,
v_client_id sales.client_id%type)
as
begin
    insert into sales(sale_amount,discount,sale_day,employee_id,client_id)
        values(v_sale_amount,v_discount,v_sale_day,v_employee_id,v_client_id);
end;

create or replace procedure sales_upd(v_sale_id sales.sale_id%type,
v_sale_sale_amount sales.sale_amount%type,
v_sale_discount sales.discount%type,
v_sale_sale_day sales.sale_day%type,
v_sale_employee_id sales.employee_id%type,
v_sale_client_id sales.client_id%type)
as begin
    update sales
        set sale_amount = v_sale_sale_amount,
            discount = v_sale_discount,
            sale_day = v_sale_sale_day,
            employee_id = v_sale_employee_id,
            client_id = v_sale_client_id
    where sale_id = v_sale_id;
end;
 
create or replace procedure sales_cars_ins(
v_car_id sales_cars.car_id%type,
v_sale_id sales_cars.sale_id%type)
as
begin
    insert into sales_cars(car_id,sale_id)
        values(v_car_id,v_sale_id);
end;

create or replace procedure sales_cars_upd(v_sales_cars_id sales_cars.sales_cars_id%type,
                                            v_car_id sales_cars.car_id%type,
                                            v_sale_id sales_cars.sale_id%type)
as begin 
    update sales_cars
        set car_id = v_car_id,
            sale_id = v_sale_id
    where sales_cars_id = v_sales_cars_id;
end;

create or replace procedure sales_cars_delete(v_sales_cars_id sales_cars.sales_cars_id%type)
as begin
    delete sales_cars
    where sales_cars_id = v_sales_cars_id;
end;

--Inserting Rows into tables
begin
    countries_ins('България');
end;
select * from countries;

begin
    cities_ins('Смядово',1);
    cities_ins('Шумен',1);
end;
select * from cities;

begin
    clients_ins('Николай','Христов','Николаев',1000000,'Ул. Преслав Номер.4','0879318112',1);
    clients_ins('Иван','Димитров','Калимаров',1000,'Ул, Априлско Възтание Номер.2','0587456987',2);
    clients_ins('Атанас','Атанасов','Генчев',150000,'Ул. Преслав Номер.1','0215879654',1);
    clients_ins('Гиновева','Йорданова','Николаева',1000,'Ул. Център Номер.10','0987878787',1);
end;
select * from clients;

begin
    positions_ins('Продавач');
end;
select * from positions;

begin
    employees_ins('Гиновева','Данаилова','Николаева','0215478965',1);
    employees_ins('Кристина','Станиславова','Николаева','0236547858',1);
end;
select * from employees;

begin
    brands_ins('Ауди');
    brands_ins('БМВ');
    brands_ins('Мерцедес');
    brands_ins('Фолксваген');
end;
select * from brands;
 
begin
    models_ins('A6',1);
    models_ins('A5',1);
    models_ins('A7',1);
    models_ins('M3',2);
    models_ins('M2',2);
    models_ins('M5',2);
    models_ins('CLS',3);
    models_ins('Sclass',3);
    models_ins('SL-500',3);
    models_ins('Passat',4);
    models_ins('Golf 3',4);
    models_ins('Touareg',4);
end;
select * from models;
 
begin
    colors_ins('Черен');
    colors_ins('Сив');
end;
select * from colors;

begin
    cars_ins(190000,1,12400,TO_DATE('03-11-2010', 'DD-MM-YYYY'),1,1);
    cars_ins(190000,2,12400,TO_DATE('03-11-2010', 'DD-MM-YYYY'),1,2);
    cars_ins(190400,2,11300,TO_DATE('11-01-2019', 'DD-MM-YYYY'),2,1);
    cars_ins(190400,2,11300,TO_DATE('11-01-2019', 'DD-MM-YYYY'),3,1);
    cars_ins(220000,1,10400,TO_DATE('04-05-2015', 'DD-MM-YYYY'),4,1);
    cars_ins(263000,3,11400,TO_DATE('10-02-2022', 'DD-MM-YYYY'),5,1);
    cars_ins(280000,4,33400,TO_DATE('10-01-2005', 'DD-MM-YYYY'),6,2);
    cars_ins(173000,2,11900,TO_DATE('21-01-2011', 'DD-MM-YYYY'),7,2);
    cars_ins(163040,2,18900,TO_DATE('21-01-2011', 'DD-MM-YYYY'),8,2);
    cars_ins(160000,3,32900,TO_DATE('24-03-2014', 'DD-MM-YYYY'),9,2);
    cars_ins(211000,4,33200,TO_DATE('24-03-2014', 'DD-MM-YYYY'),10,1);
    cars_ins(100000,3,320900,TO_DATE('24-11-2024', 'DD-MM-YYYY'),11,1);
    cars_ins(170000,4,340000,TO_DATE('20-02-2025', 'DD-MM-YYYY'),12,2);
end;
select * from cars;

begin
    sales_ins(47400,0,TO_DATE('12-12-2025', 'DD-MM-YYYY'),1,1);
    sales_ins(55200,0,TO_DATE('01-12-2025', 'DD-MM-YYYY'),1,2);
    sales_ins(63700,0,TO_DATE('20-11-2025', 'DD-MM-YYYY'),2,3);
    sales_ins(694100,0,TO_DATE('24-11-2025', 'DD-MM-YYYY'),2,4);
end;
select * from sales;
 
begin
    sales_cars_ins(1,1);
    sales_cars_ins(2,1);
    sales_cars_ins(3,1);
    sales_cars_ins(4,1);

    sales_cars_ins(5,2);
    sales_cars_ins(6,2);
    sales_cars_ins(7,2);

    sales_cars_ins(8,3);
    sales_cars_ins(9,3);
    sales_cars_ins(10,3);

    sales_cars_ins(11,4);
    sales_cars_ins(12,4);
    sales_cars_ins(13,4);
end;
select * from sales_cars;
 
--Select car by given brand
create or replace procedure search_car_by_brand(v_brand brands.brand%type)
as begin
    dbms_output.put_line('Коли по марка.');
    declare
        cursor by_brand is 
            select
            c.kilometers,
            c.available_cars_count,
            c.price,
            c.manufacture_year,
            m."model",
            b.brand,
            cc.color
            from cars c
            join models m on m.model_id = c.model_id
            join brands b on m.brand_id = b.brand_id
            join colors cc on c.color_id = cc.color_id
            where b.brand = v_brand
            order by c.price desc;

            begin
                for car_row in by_brand 
                loop
                    dbms_output.put_line(car_row.kilometers 
                                        || ','
                                        || car_row.available_cars_count 
                                        || ','
                                        || car_row.price 
                                        || ','
                                        || car_row.manufacture_year 
                                        || ','
                                        || car_row."model" 
                                        || ','
                                        || car_row.brand 
                                        || ','
                                        || car_row.color);
                end loop;
    end;
end;
exec search_car_by_brand('Мерцедес');

--Select car by given model
create or replace procedure search_car_by_model(v_model models."model"%type)
as begin
    dbms_output.put_line('Коли по модел.');
        declare
            cursor by_model is
                select
                c.kilometers,
                c.available_cars_count,
                c.price,
                c.manufacture_year,
                m."model",
                b.brand,
                cc.color
                from cars c
                join models m on m.model_id = c.model_id
                join brands b on m.brand_id = b.brand_id
                join colors cc on c.color_id = cc.color_id
                where m."model" = v_model
                order by c.price desc;
        begin
            for car_row in by_model
            loop
                dbms_output.put_line(car_row.kilometers 
                    || ','
                    || car_row.available_cars_count 
                    || ','
                    || car_row.price 
                    || ','
                    || car_row.manufacture_year 
                    || ','
                    || car_row."model" 
                    || ','
                    || car_row.brand 
                    || ','
                    || car_row.color);
        end loop;
    end;
end;
exec search_car_by_model('A6');

--Seelct car by given color
create or replace procedure search_car_by_color(v_color colors.color%type)
as begin
    dbms_output.put_line('Коли по цвят.');
        declare
            cursor by_color is
                select
                c.kilometers,
                c.available_cars_count,
                c.price,
                c.manufacture_year,
                m."model",
                b.brand,
                cc.color
                from cars c
                join models m on m.model_id = c.model_id
                join brands b on m.brand_id = b.brand_id
                join colors cc on c.color_id = cc.color_id
                where cc.color = v_color
                order by c.price desc;
    begin
        for car_row in by_color 
        loop
            dbms_output.put_line(car_row.kilometers 
                    || ','
                    || car_row.available_cars_count 
                    || ','
                    || car_row.price 
                    || ','
                    || car_row.manufacture_year 
                    || ','
                    || car_row."model" 
                    || ','
                    || car_row.brand 
                    || ','
                    || car_row.color);
        end loop;
    end;
end;
exec search_car_by_color('Черен');

--Select car by given year
create or replace procedure search_by_year(v_year number)
as begin
    dbms_output.put_line('Коли по година.');
        declare
            cursor by_year is
                select
                c.kilometers,
                c.available_cars_count,
                c.price,
                c.manufacture_year,
                m."model",
                b.brand,
                cc.color
                from cars c
                join models m on m.model_id = c.model_id
                join brands b on m.brand_id = b.brand_id
                join colors cc on c.color_id = cc.color_id
                where extract(year from c.manufacture_year) = v_year
                order by c.price desc;
    begin
        for car_row in by_year 
        loop
             dbms_output.put_line(car_row.kilometers 
                    || ','
                    || car_row.available_cars_count 
                    || ','
                    || car_row.price 
                    || ','
                    || car_row.manufacture_year 
                    || ','
                    || car_row."model" 
                    || ','
                    || car_row.brand
                    || ','
                    || car_row.color);
        end loop;
    end;
end;
exec search_by_year(2025);

--Select car by given kilometers
create or replace procedure search_by_kilometers(v_kilometers cars.kilometers%type)
as begin
    dbms_output.put_line('Коли по километри.');
        declare
            cursor by_kilometers is
                select
                c.kilometers,
                c.available_cars_count,
                c.price,
                c.manufacture_year,
                m."model",
                b.brand,
                cc.color
                from cars c
                join models m on m.model_id = c.model_id
                join brands b on m.brand_id = b.brand_id
                join colors cc on c.color_id = cc.color_id
                where c.kilometers = v_kilometers
                order by c.price desc;
    begin
        for car_row in by_kilometers 
        loop
            dbms_output.put_line(car_row.kilometers 
                    || ','
                    || car_row.available_cars_count 
                    || ','
                    || car_row.price 
                    || ','
                    || car_row.manufacture_year 
                    || ','
                    || car_row."model" 
                    || ','
                    || car_row.brand
                    || ','
                    || car_row.color);
        end loop;
    end;
end;
exec search_by_kilometers(190000);

--Select car up to given price
create or replace procedure search_car_by_price(v_price cars.price%type)
as begin
    dbms_output.put_line('Коли по цена');
        declare 
            cursor by_price is
                select
                c.kilometers,
                c.available_cars_count,
                c.price,
                c.manufacture_year,
                m."model",
                b.brand,
                cc.color
                from cars c
                join models m on m.model_id = c.model_id
                join brands b on m.brand_id = b.brand_id
                join colors cc on c.color_id = cc.color_id
                where c.price <= v_price
                order by c.price desc;
    begin
        for car_row in by_price
        loop
            dbms_output.put_line(car_row.kilometers 
                    || ','
                    || car_row.available_cars_count 
                    || ','
                    || car_row.price 
                    || ','
                    || car_row.manufacture_year 
                    || ','
                    || car_row."model" 
                    || ','
                    || car_row.brand
                    || ','
                    || car_row.color);
        end loop;
    end;
end;
exec search_car_by_price(12400);

-- Top 5 cars by price for the last 3 months
create or replace procedure top_five_cars_from_sale_for_period_in_days(s_date number)
as begin
    dbms_output.put_line('Най-скъпите 2 продажби за последните месеци в дни.');
        declare cursor top_five is
            select * from (
                select
                    s.sale_amount,
                    s.discount,
                    s.sale_day,
                    c.first_name || ' ' || c.middle_name || ' ' || c.last_name as Client_Name,
                    e.first_name || ' ' || e.middle_name || ' ' || e.last_name as Employee_Name
                from sales s
                join clients c on c.client_id = s.client_id
                join employees e on e.employee_id = s.employee_id
                where s.sale_day >= sysdate - s_date
                order by sale_amount desc
            )
            where rownum <= 2;
    begin
        for sale_row in top_five 
        loop
                dbms_output.put_line(sale_row.sale_amount 
                || ','
                || sale_row.discount 
                || ','
                || sale_row.sale_day 
                || ','
                || sale_row.Client_Name 
                || ','
                || sale_row.Employee_Name);
        end loop;
    end;
end;
exec top_five_cars_from_sale_for_period_in_days(90);

--Sum of saled cars by brand and model
create or replace procedure sum_of_saled_cars_by_brand_and_model
as begin
    dbms_output.put_line('Суми от продадени коли по модел и марка');
        declare
            cursor sum_by_model_and_brand is
                select
                    MAX(m."model") as Model,
                    MAX(b.brand) as Brand,
                    sum(c.price) as Total_Price
                from sales s
                join sales_cars sc on sc.sale_id = s.sale_id
                join cars c on c.car_id = sc.car_id
                join models m on c.model_id = m.model_id
                join brands b on b.brand_id = m.brand_id
                group by m.model_id, b.brand_id
                order by sum(c.price) desc;
    begin
        for sale_row in sum_by_model_and_brand 
        loop
            dbms_output.put_line(sale_row.Model 
                || ','
                || sale_row.Brand
                || ','
                || sale_row.Total_Price);
        end loop;
    end;
end;
exec sum_of_saled_cars_by_brand_and_model;
 
--Last 3 sales order by price
create or replace procedure sales_per_price_limit(v_limit number)
as begin
    dbms_output.put_line('Последните n продадени коли подредени по цена.');
        declare
            cursor limited_cars is
                select * from (
                    select
                        s.sale_amount,
                        s.discount,
                        s.sale_day,
                        c.first_name || ' ' || c.middle_name || ' ' || c.last_name as Client_Name,
                        e.first_name || ' ' || e.middle_name || ' ' || e.last_name as Employee_Name
                    from sales s
                    join clients c on c.client_id = s.client_id
                    join employees e on e.employee_id = s.employee_id
                    order by sale_amount desc
                    )
                where rownum <= v_limit;
    begin
        for sale_row in limited_cars
        loop
            dbms_output.put_line(sale_row.sale_amount 
                || ','
                || sale_row.discount
                || ','
                || sale_row.sale_day
                || ','
                || sale_row.Client_Name
                || ','
                || sale_row.Employee_Name);
        end loop;
    end;
end;
exec sales_per_price_limit(4);

--Sales by client
create or replace procedure sales_of_client_by_phone_number(v_client_number varchar)
as begin
    dbms_output.put_line('Покупки на клиент.');
        declare
            cursor sales_by_client is
                select
                    cl.first_name || ' ' || cl.middle_name || ' ' || cl.last_name as Client_Name,
                    cl.phone_number as Client_Phone,
                    s.sale_day,
                    c.kilometers as Car_Kilometers,
                    c.price as Car_Price,
                    c.manufacture_year as Car_Manufacture,
                    m."model" as Car_Model,
                    b.brand as Car_Brand,
                    co.color as Car_Color
                from sales_cars sc
                join sales s on s.sale_id = sc.sale_id
                join clients cl on cl.client_id = s.client_id
                join cars c on c.car_id = sc.car_id
                join models m on m.model_id = c.model_id
                join brands b on b.brand_id = m.brand_id
                join colors co on co.color_id = c.color_id
                where cl.phone_number = v_client_number
                order by s.sale_amount desc;
    begin
        for sale_row in sales_by_client
        loop
            dbms_output.put_line(sale_row.Client_Name 
                || ','
                || sale_row.Client_Phone
                || ','
                || sale_row.sale_day
                || ','
                || sale_row.Car_Kilometers
                || ','
                || sale_row.Car_Price
                || ','
                || sale_row.Car_Manufacture
                || ','
                || sale_row.Car_Model
                || ','
                || sale_row.Car_Brand
                || ','
                || sale_row.Car_Color);
        end loop;
    end;
end;
exec sales_of_client_by_phone_number('0879318112');

--Sales for period
create or replace procedure saled_for_period(v_first_period varchar, v_second_period varchar)
as begin
    dbms_output.put_line('Продажби за преиод.');
        declare
            cursor for_period is
                select
                    cl.first_name || ' ' || cl.middle_name || ' ' || cl.last_name as Client_Name,
                    cl.phone_number as Client_Phone,
                    s.sale_day,
                    c.kilometers as Car_Kilometers,
                    c.price as Car_Price,
                    c.manufacture_year as Car_Manufacture,
                    m."model" as Car_Model,
                    b.brand as Car_Brand,
                    co.color as Car_Color,
                    s.sale_amount,
                    s.discount
                from sales_cars sc
                join sales s on s.sale_id = sc.sale_id
                join clients cl on cl.client_id = s.client_id
                join cars c on c.car_id = sc.car_id
                join models m on m.model_id = c.model_id
                join brands b on b.brand_id = m.brand_id
                join colors co on co.color_id = c.color_id
                where to_date(s.sale_day) BETWEEN to_date(v_first_period, 'DD-MON-YYYY') and to_date(v_second_period, 'DD-MON-YYYY')
                order by c.price desc;
    begin
        for sale_row in for_period
        loop
            dbms_output.put_line(sale_row.Client_Name 
                || ','
                || sale_row.Client_Phone
                || ','
                || sale_row.sale_day
                || ','
                || sale_row.Car_Kilometers
                || ','
                || sale_row.Car_Price
                || ','
                || sale_row.Car_Manufacture
                || ','
                || sale_row.Car_Model
                || ','
                || sale_row.Car_Brand
                || ','
                || sale_row.Car_Color);
        end loop;
    end;
end;
exec saled_for_period('01-NOV-2025', '31-DEC-2025');

create or replace trigger car_cannot_be_saled_twice
before insert on sales_cars 
for each row
    declare is_car_sold number;
begin 
    select
        count(*)
    into is_car_sold
    from sales_cars
    where car_id = :new.car_id;

    if is_car_sold != 0 then
        raise_application_error(
            -20000,
            'Колата не може да бъде продадена 2 пъти.'
        );
    end if;
end;
begin
    sales_cars_ins(1,2);
end;
