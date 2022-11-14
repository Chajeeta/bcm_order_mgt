create or replace 
PROCEDURE "GET_HIGHEST_ORDER_PRC" (
    p_orders          OUT SYS_REFCURSOR,
    p_cust_code         IN VARCHAR2,
    p_cust_class_code   IN VARCHAR2,
    p_sec_code          IN VARCHAR2
) AS

BEGIN
	OPEN p_orders FOR
	SELECT
		SUBSTR(bo.BCM_ORDER_REF,5,6) AS "Order Reference",
		SUBSTR(to_date(bo.BCM_ORDER_DATE,'MONTH-DD-YYYY'),4,9) AS "Order Period",
		To_UPPER(bs.BCM_SUPPLIER_NAME) "Supplier Name",
		to_char(bo.BCM_ORDER_TOTAL_AMOUNT,'L99G999D99MI') AS "Order Total Amount",
		bo.BCM_ORDER_STATUS As "Order Status"
		i.BCM_INVOICE_REFERENCE AS "Invoice Reference",
		SUM(oi.BCM_INVOICE_AMOUNT) AS "Invoice Total Amount",
		get_action(i.BCM_INVOICE_ID)
		
		select * from (select * from (select ORDER_REF,ORDER_TOTAL_AMOUNT from XXBCM_ORDER_MGT order by ORDER_TOTAL_AMOUNT DESC)
where rownum < 4 order by ORDER_TOTAL_AMOUNT)
where rownum = 1;
		
END GET_HIGHEST_ORDER_PRC;