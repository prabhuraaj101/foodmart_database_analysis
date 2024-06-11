#CREATE OR REPLACE VIEW foodmart_dwh_description AS 
WITH p (tablename, description) AS
  (VALUES
('account',	'Internal accounts table'),
('agg_c_10_sales_fact_1997',	'store sales facts with time details'),
('agg_c_14_sales_fact_1997',	'Product, customer and promotion colreated store sales with  store and time details'),
('agg_c_special_sales_fact_1997',	'redundant of agg_c_14_sales_fact_1997'),
('agg_g_ms_pcat_sales_fact_1997',	'store wise sales and customercount by categories of customer and product, and by time'),
('agg_lc_06_sales_fact_1997',	'Time based store sales fact by location'),
('agg_lc_100_sales_fact_1997',	'Store sales correlated by customer and product with store location and time details'),
('agg_ll_01_sales_fact_1997',	'store sales correlated by Prodcut, time and customer'),
('agg_l_03_sales_fact_1997',	'store sales fact correlated by time and customer'),
('agg_l_04_sales_fact_1997',	'time base store sales fact'),
('agg_l_05_sales_fact_1997',	'store sales fact correlated by product, cutomer, promotion and store'),
('agg_pl_01_sales_fact_1997',	'store sales fact correlated by product, customer and time'),
('category',	'expense category'),
('employee_closure',	'employee closure details'),
('expense_fact',	'expenses in appropriate currency, category and time'),
('inventory_fact_1997',	'inventory fact correlated by product, time, warehouse and store for 1997'),
('inventory_fact_1998',	'inventory fact correlated by product, time, warehouse, store for 1998'),
('position',	'Employee position details'),
('product',	'Product details'),
('product_class',	'product category table'),
('promotion',	'customer promotion information table'),
('region',	'Region information table'),
('reserve_employee',	'table with details of employees on reserve in corrlation with  position, store, supervisor and department'),
('currency',	'Currency conversion ratio by date'),
('customer',	'customer dedtails table'),
('days',	'week days table'),
('department',	'department table'),
('employee',	'Employee details table'),
('salary',	'Salary details correlated by employee, department'),
('sales_fact_1997',	'Main total sales fact table for 1997 correlated by product, time, store, customer and promotion'),
('sales_fact_1998',	'Main total sales fact table for 1998 correlated by product, time, store, customer and promotion'),
('sales_fact_dec_1998',	'total sales fact table for 1998 in December month correlated by product, time, store, customer and promotion'),
('store',	'Store details table'),
('store_ragged',	'Store details table'),
('time_by_day',	'table for time entry with id'),
('warehouse',	'Warehouse details table'),
('warehouse_class',	'Warehouse Category table'))
SELECT t1.*, p.description, t2.table_columns FROM (
SELECT 
	c1.TABLE_NAME AS table_name, 
	c1.COLUMN_NAME AS column_name,
	(SELECT TABLE_NAME 
		FROM information_schema.COLUMNS AS c2 
		WHERE 
			(CASE 
				WHEN c2.TABLE_NAME = 'time_by_day' THEN 'time_id'
				ELSE  
			CONCAT(c2.TABLE_NAME, '_id') END )= c1.COLUMN_NAME
			AND c2.TABLE_SCHEMA = 'foodmartdwh'
			AND c2.TABLE_NAME <> c1.TABLE_NAME
		LIMIT 1) AS related_table
FROM information_schema.COLUMNS AS c1
WHERE c1.TABLE_SCHEMA = 'foodmartdwh') AS t1 
JOIN (SELECT tb.TABLE_NAME, GROUP_CONCAT(COLUMN_NAME) AS table_columns FROM information_schema.COLUMNS AS tb
		WHERE tb.TABLE_SCHEMA = 'foodmartdwh'
		GROUP BY TABLE_NAME) t2
	ON t2.TABLE_NAME =  t1.TABLE_NAME
JOIN p ON p.tablename = t1.table_name
WHERE t1.related_table IS NOT NULL;

