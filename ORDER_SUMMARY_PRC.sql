create or replace 
PROCEDURE "GET_ORDER_SUMMARY_PRC" (
    p_orders          OUT SYS_REFCURSOR,
    p_cust_code         IN VARCHAR2,
    p_cust_class_code   IN VARCHAR2,
    p_sec_code          IN VARCHAR2
) AS

BEGIN
	OPEN p_orders FOR
	SELECT
		SUBSTR(bo.BCM_ORDER_REF,5,6) AS "Order Reference",
		SUBSTR(to_date(bo.BCM_ORDER_DATE,'dd-MM-YYYY'),4,9) AS "Order Period",
		INITCAP(bs.BCM_SUPPLIER_NAME) "Supplier Name",
		to_char(bo.BCM_ORDER_TOTAL_AMOUNT,'L99G999D99MI') AS "Order Total Amount",
		bo.BCM_ORDER_STATUS As "Order Status"
		i.BCM_INVOICE_REFERENCE AS "Invoice Reference",
		SUM(oi.BCM_INVOICE_AMOUNT) AS "Invoice Total Amount",
		get_action(i.BCM_INVOICE_ID)
		
		from BCM_ORDER bo,SUPPLIER bs,INVOICE i,SUPPLIER_ORDER su,ORDER_INVOICE oi where bo.BCM_ORDER_ID=su.BCM_ORDER_ID and bs.BCM_SUPPLIER_ID=su.BCM_SUPPLIER_ID and i.BCM_INVOICE_ID=oi.BCM_INVOICE_ID;
		
END GET_ORDER_SUMMARY_PRC;