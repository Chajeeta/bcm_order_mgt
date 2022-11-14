create or replace 
PROCEDURE "GET_SUPLIER_ORDER_PRC" (
    p_orders          OUT SYS_REFCURSOR,
    p_cust_code         IN VARCHAR2,
    p_cust_class_code   IN VARCHAR2,
    p_sec_code          IN VARCHAR2
) AS

BEGIN
	OPEN p_orders FOR
	SELECT
		s.bcm_supplier_name AS "Supplier Name",
		s.bcm_supp_contact_name AS "Supplier Contact Name",
		s.bcm_supp_contact_number) "Supplier Contact Number",
		COUNT(bo.bcm_order_id) AS "Total Number of orders",
		sum(bo.bcm_order_total_amount) AS "Order Total Amount"
		FROM supplier S, supplier_order SO,bcm_order BO WHERE so.bcm_supplier_id = s.bcm_supplier_id;
		
END GET_SUPLIER_ORDER_PRC;