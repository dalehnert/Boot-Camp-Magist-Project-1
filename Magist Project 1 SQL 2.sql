use magist;

# What categories of tech products does Magist have?
select * from product_category_name_translation;
# about 16, but relevant for Encian is like 2/3

select * from product_category_name_translation;

#audio, electronics, computers_accessories, pc_gamer, computers, telephony
#audio, eletronicos, informatica_acessorios, pc_gamer, pcs, telefonia

# How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
select distinct order_status from orders;
select distinct product_category_name from products;

select count(o_i.product_id)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');




select orders.order_id, sum(oi.order_item_id), p.product_category_name
	from orders
    left join order_items as oi on orders.order_id
    left join products as p on p.product_id
where p.product_category_name = 'eletronicos' or 'telefonia' or 'audio' or 'pcs' or 'pc_gamer' or 'informatica_acessorios'
group by p.product_category_name, orders.order_id;


# What’s the average price of the products being sold?
select avg(price), p.product_category_name
	from order_items
    left join products as p on p.product_id
where p.product_category_name = 'eletronicos' or 'telefonia' or 'audio' or 'pcs' or 'pc_gamer' or 'informatica_acessorios'
group by p.product_category_name, order_items.price;

select min(price), avg(price), max(price)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');


# Are expensive tech products popular? * USE CASE WHEN
select p.product_id, order_items.price, p.product_category_name
	from order_items
    left join products as p on p.product_id
where p.product_category_name = 'eletronicos' or 'telefonia' or 'audio' or 'pcs' or 'pc_gamer'
group by p.product_category_name, order_items.price, p.product_id
order by order_items.price desc limit 10;

select count(o_i.order_id),
CASE 
when o_i.price <= 500 then 'Cheap product'
when o_i.price > 500 then 'Expensive product'
End as price_category
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony')
group by price_category;

##Expensive products are NOT popular on the magist platform




#How many months of data are included in the magist database?
select order_purchase_timestamp from orders
order by order_purchase_timestamp asc limit 5;
#2016-09-04
select order_purchase_timestamp from orders
order by order_purchase_timestamp desc limit 5;
#2018-10-17, so 25 months

#How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

SELECT count(Distinct DATE_FORMAT(order_purchase_timestamp, "%Y-%m"))
FROM orders;
select count(distinct seller_id)
from sellers;

select count(DISTINCT s.seller_id)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');

# 454 distinct Tech seller

#What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?

select sum(payment_value)
from order_items as o_i
left join products as p on o_i.product_id = p.product_id 
right join product_category_name_translation as p_c_n_t on p.product_category_name = p_c_n_t.product_category_name
left join sellers as s on o_i.seller_id = s.seller_id
right join orders o on o.order_id = o_i.order_id
right join order_payments as o_p on o.order_id = o_p.order_id
where product_category_name_english in ('audio', 'electronics','computers', 'computers_accessories', 'pc_gamer', 'telephony');

## 12-13%, point against Magist


#Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?





#What’s the average time between the order being placed and the product being delivered?

select avg((TIMESTAMPDIFF(SECOND, order_purchase_timestamp, order_delivered_customer_date))/3600) AS hrs, avg((TIMESTAMPDIFF(SECOND, order_purchase_timestamp, order_delivered_customer_date))/ 24 / 3600) as days
from orders;

#12.5 delivery days


#How many orders are delivered on time vs orders delivered with a delay?

select * from orders;


#Is there any pattern for delayed orders, e.g. big products being delayed more often?

select avg(product_name_length), avg(product_description_length),  avg(product_weight_g), avg(product_length_cm), avg(product_height_cm), avg(product_width_cm)
from orders as o
right join order_items as o_i on o.order_id = o_i.order_id
right join products as p on o_i.product_id = p.product_id
where (TIMESTAMPDIFF(SECOND, order_estimated_delivery_date, order_delivered_customer_date)/3600/24) > 0;

select avg(product_name_length), avg(product_description_length),  avg(product_weight_g), avg(product_length_cm), avg(product_height_cm), avg(product_width_cm)
from orders as o
right join order_items as o_i on o.order_id = o_i.order_id
right join products as p on o_i.product_id = p.product_id
where (TIMESTAMPDIFF(SECOND, order_estimated_delivery_date, order_delivered_customer_date)/3600/24) <= 0;
