select top 1 store_id, (sum(pay_amount)) as sale
from orders
where merchant_id = 43
group by store_id
order by sale desc


2.

declare @last_days int  = 30
declare @top_n int  = 5

select top 5 item_id, Name, sum(quantity) as sq
from ( 
SELECT o.order_id,oi.item_id ,o.merchant_id,o.payment_status, oi.Name, oi.quantity, oi.price, o.created_at
FROM 
(select * 
from Orders
where merchant_id = 43 and payment_status =3 and
created_at >= DATEADD(day,-@last_days,'2021-05-28') 
and   created_at <= '2021-05-28' )o
INNER JOIN [order items] oi ON o.order_id=oi.order_id
) t
group by item_id, name
order by sq desc

with gatedate() function


declare @last_days int  = 30
declare @top_n int  = 5

select top 5 item_id, Name, sum(quantity) as sq
from ( 
SELECT o.order_id,oi.item_id ,o.merchant_id,o.payment_status, oi.Name, oi.quantity, oi.price, o.created_at
FROM 
(select * 
from Orders
where merchant_id = 43 and payment_status =3 and
created_at >= DATEADD(day,-@last_days,getdate()) 
and   created_at <= getdate() )o
INNER JOIN [order items] oi ON o.order_id=oi.order_id
) t
group by item_id, name
order by sq desc

for getting last x day
use 

declare @last_days int  = 30
and for date use getdate() function 
3.
select top 1 user_phone, sum(quantity) as sq
from (
SELECT o.order_id,o.user_phone ,oi.item_id ,o.merchant_id,o.payment_status, oi.Name, oi.quantity, oi.price, o.created_at
FROM 
(select * 
from Orders
where
created_at >= DATEADD(day,-30,'2021-05-28') 
and   created_at <= '2021-05-28'
----where payment_status =3 
 )o
INNER JOIN 
(
select * from 
[order items]
where item_id = 4913) oi ON o.order_id=oi.order_id
) t 
group by user_phone
order by sq desc


4.
declare @last_days int  = 30
select order_id, pay_amount from 
(select order_id, pay_amount, DENSE_RANK() over (order by pay_amount desc) as rankn
from orders
where payment_status = 3
and created_at >= DATEADD(day,-@last_days,getdate()) 
and   created_at <= getdate()
) t
where rankn =100


5.select payment_method, successful, total, (successful*100.00)/total as Success_percent from 
(select payment_method, count(*) as successful
from orders 
where payment_status = 3
group by payment_method) a
left join 
(
select payment_method as pm, count(*) as total
from orders
group by payment_method
) b on a.payment_method = b.pm
order by Success_percent desc


6.select count(payment_method)
from(
select payment_method,  count(payment_method) as c
from orders
----where pay_amount = 4300
group by payment_method
) t


7.select user_phone, created_at, sp
from
(
select user_phone, created_at, sum(pay_amount) as sp, 
ROW_NUMBER() over (partition by created_at order by sum(pay_amount) desc) as rn
from orders
where store_id = 71
group by user_phone, created_at

) t
where rn = 1
