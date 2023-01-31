USE magist;
SELECT * FROM orders;
SELECT DISTINCT * FROM products;
SELECT * FROM sellers;


SELECT * FROM product_category_name_translation;
SELECT product_id, price
FROM order_items
ORDER BY price ASC LIMIT 10;


SELECT COUNT(order_id) FROM orders;
SELECT COUNT(order_id), order_status FROM orders
GROUP BY order_status;


SELECT COUNT(DISTINCT product_id) FROM products;
SELECT COUNT(DISTINCT product_id), product_category_name FROM products
GROUP BY product_category_name
ORDER BY COUNT(DISTINCT product_id) DESC;

SELECT 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM orders
GROUP BY year_ , month_
ORDER BY year_ , month_;

SELECT 
	COUNT(DISTINCT product_id)
FROM
	order_items;
    
select max(payment_value) as MAX, min(payment_value) as MIN
	from order_payments;
    
    

