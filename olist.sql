create proc truncta_Tables
as
	if exists ( select * from sys.tables where name = 'customer')
		truncate table customer
	if exists ( select * from sys.tables where name = 'location')
		truncate table location
	if exists ( select * from sys.tables where name = 'Product')
		truncate table product
select count(*)
from order_item
create view fact_table
as
select  oi.order_id , oi.order_item_id,oi.product_id,oi.seller_id,oi.shipping_limit_date,oi.freight_value,oi.price,
r.customer_id,r.order_approved_at,r.order_delivered_customer_date,r.order_estimated_delivery_date,r.order_purchase_timestamp,r.order_status,
op.payment_installments,op.payment_sequential,op.payment_type,op.payment_value
from order_item oi , orders r ,order_payment op
where oi.order_id = r.order_id and op.order_id =oi.order_id
order by r.customer_id
select * from fact_table
create view remove_duplicate_order_payment
as
select   * 
from ( select * , row_number() over(partition by order_id order by order_id) as RN
from order_payment) as new_tabl
delete from remove_duplicate_order_payment
where RN >1
select * from remove_duplicate_order_payment
truncate table order_payment
select distinct order_id from order_payment
select order_id from order_payment

select * into oredr_payment2
from remove_duplicate_order_payment
insert into order_payment
select [order_id] ,[payment_sequential],[payment_type],
[payment_installments],[payment_value]

from  oredr_payment2 
where rn<=1
select * from oredr_payment2
select   order_id  from order_item
select distinct order_id 
from order_item
except
select distinct order_id 
from order_payment 
except
select distinct order_id 
from order_item
select   order_id 
from order_payment 
where order_id ='bfbd0f9bdef84302105ad712db648a6c'
insert into order_payment (order_id) values('bfbd0f9bdef84302105ad712db648a6c')
-------------------------------------
select * into fact_tables
from fact_table
--------------
select sum(#trips)
from(
select p.product_category_name,count(order_id) as #trips
from fact_tables f, Product p
where f.product_id= p.product_id
group by p.product_category_name
) as fff
-----------------------
select count(*)
from fact_tables
------------------
create view product_cat_conflict
as
select distinct p.product_category_name
from product p  
except
select distinct p.product_category_name
from product_category p
insert into product_category(product_category_name)
select * from product_cat_conflict p
where p.product_category_name is Not NULL
select * from product_category
delete from product_category where product_category_name =' '
delete from product where product_category_name =' '
update product
set  [product_name_lenght]    =  'NA' ,
[product_description_lenght] = 'NA',
[product_photos_qty] = 'NA'
where [product_name_lenght] =''
update dim_product 
set [product_photos_qty] = '20'
where [product_photos_qty]  = '2NA'
select * from dim_product where [product_photos_qty]  = '20'
select * from Product where product_category_name =' 1'
create schema olist
alter schema olist transfer orders
create proc make_new_prduct_table
as
select p.product_id,p.product_category_name,pc.product_category_name_english
,p.product_photos_qty into Dim_Product
from product p full outer join product_category pc
on p.product_category_name=pc.product_category_name
exec make_new_prduct_table
select * from Dim_Product  
select * from fact_tables f
order by f.order_approved_at
-----------------------------
CREATE TABLE [dbo].[Dim_Date](
	[date] [datetime] NOT NULL,
	[hour] [tinyint] NOT NULL,
	[day] [tinyint] NOT NULL,
	[year] [int] NOT NULL,
	[month] [tinyint] NOT NULL,
	[MonthName] [varchar](20) NOT NULL,
	[DayName] [varchar](20) NOT NULL,
	[Quarter] [varchar](2) NOT NULL,
	[Week] [tinyint] NOT NULL,
	[day_of_year] [int] NOT NULL
) ON [PRIMARY]

alter proc [dbo].[populateDateDim] @StartDate datetime , @endDate datetime 
as
begin 
truncate table dim_date;
	-- first i should add the Default Value of Date TO Handle Any Error
	insert into dim_date
		(
			date		,
			hour		,
			day			,	
			year		,	
			month		,	
			MonthName  	,
			DayName    	,
			Quarter		,
			Week		,
			day_of_year	
		)
	values 
		(
			'2016-08-01 00:00:00',
			0,
			0,
			0,
			0,
			'N/A',
			'N/A',
			'NA',
			0,
			0
		);	

		-- With the end of this insert statement i should Start with The Real Work That is Adding the Real Values of Date
		-- That i Will Work With 
		while @StartDate < @endDate
		begin 
			insert into dim_date
			(
				date		,
				hour		,
				day			,	
				year		,	
				month		,	
				MonthName  	,
				DayName    	,
				Quarter		,
				Week		,
				day_of_year	
			)
			values 
			(
				@StartDate,
				DATEPART(HOUR, @StartDate),
				day(@StartDate),
				year(@StartDate),
				format(@StartDate,'mm'),
				format(@StartDate,'MMMM'),
				format(@StartDate,'ddd'),
				'Q'+cast(DATEPART(q,@StartDate) as varchar),
				format(@StartDate,'dd')/7,
				DATEPART(dy,@StartDate)
			);	
		set @StartDate = dateadd(HH,1,@StartDate)
		end
select 'The Population Operation Has Compleated';
select * from dim_date;
Commit ;
end
exec populateDateDim  '2016-08-01 00:00:00', '2019-01-01 00:00:00'
select * from dim_date
delete from dim_date where format (cast (date as datetime),'yyyy') ='2001'
insert into dim_date (date) values( CAST('N//1' as date))
SELECT SUBSTRING('SQLddui',7, 7)
select * from [olist].[orders]  r
order by order_id
select * from orders  r
order by  [order_approved_at]
