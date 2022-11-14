CREATE OR REPLACE FUNCTION get_action(invoice_id NUMBER)
  RETURN VARCHAR2 IS
  action   VARCHAR2;
  count_status NUMBER
  
  cursor c1 is
  SELECT BCM_INVOICE_STATUS,ROWNUM FROM INVOICE I,ORDER_INVOICE O 
    WHERE I.BCM_INVOICE_ID = O.BCM_INVOICE_ID;
  
BEGIN
	for order_rec in c1
	 LOOP
		IF order_rec.BCM_INVOICE_STATUS = 'Paid' THEN
			count_status := count_status +1;
			
			IF count_status = ROWNUM THEN
			action :='OK';
			END IF;
			
		ELSIF order_rec.BCM_INVOICE_STATUS = 'Rejected' THEN
			action := 'To follow up';
			
		ELSIF order_rec.BCM_INVOICE_STATUS = NULL THEN
		action := 'To Verify';
	
	  END IF;
   END LOOP;
	
  RETURN action;
END last_first_name; 
