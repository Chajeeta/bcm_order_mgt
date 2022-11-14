create or replace 
PACKAGE BODY BCMORDER_PKG
AS
/************************************************************************
     *                                                                       *
     *    Project      :  BCM ORDER                                  		 *
     *                                                                       *
     *    Script       :  BCMORDER_PKG               						 *                                                                         
     *                                                                       *
     *    Database     :  Oracle 11g Interprise Edition                      *
     *                                                                       *
     *    Program Type :  Package body creation script                       *
     *    Description  :                                    				 *
     *                                                                       *
     *    Dependencies :  Non                                                *                                                                      *
     *                                                                       *
     *    Version$     :  1.0                                                *
     *                                                                       *
     *    Development and Maintenance History (Reverse order of date)        *
     *                                                                       *
     *    Date         Ver. Done By        Description                       *
     *    -----------  ---- ------------   --------------------------------  *
     *    13-NOV-2022   1.0 CHAJEETA       First Release
     *                                                                       *
     *************************************************************************/
create or replace 
PROCEDURE "MERGE_ORDER_PRC" (p_order_ref IN VARCHAR2 )
AS
BEGIN

	MERGE INTO BCM_ORDER D USING
    ( SELECT 
		ORDER_REF,
		ORDER_DATE,
		ORDER_TOTAL_AMOUNT, 
		ORDER_DESCRIPTION, 
		ORDER_STATUS
		FROM XXBCM_ORDER_MGT WHERE ORDER_REF=SUBSTR( ORDER_REF, 1, 5 )
		ORDER BY ORDER_REF
    )S1 ON (D.BCM_ORDER_REF = S1.ORDER_REF)
    WHEN NOT MATCHED THEN
	INSERT
    (
		BCM_ID,
		BCM_ORDER_REF, 
		BCM_ORDER_DATE,
		BCM_ORDER_TOTAL_AMOUNT,
		BCM_ORDER_DESCRIPTION,
		BCM_ORDER_STATUS 
    )
    VALUES
    (
      SQ_ORDER_ID.nextval,
      S1.ORDER_REF,
      S1.ORDER_DATE,
      S1. ORDER_TOTAL_AMOUNT,
      S1.ORDER_DESCRIPTION,
      S1.ORDER_STATUS
      
    );
END;

create or replace 
PROCEDURE "MERGE_ORDER_LINE_PRC" (p_order_ref IN VARCHAR2 )
AS
BEGIN

	MERGE INTO ORDER_LINE D USING
    ( SELECT 
		ORDER_REF,
		ORDER_LINE_AMOUNT
		FROM XXBCM_ORDER_MGT WHERE order_ref like '%-%'
		ORDER BY ORDER_REF
    )S1 ON (D.BCM_ORDER_REF = S1.ORDER_REF)
    WHEN NOT MATCHED THEN
	INSERT
    (
		BCM_ORDER_LINE_ID,
		BCM_ORDER_LINE_REF, 
		BCM_ORDER_LINE_AMOUNT, 
		BCM_ORDER_ID, 
    )
    VALUES
    (
      SQ_ORDER_LINE_ID.nextval,
      S1.ORDER_REF,
      S1.ORDER_LINE_AMOUNT,
      select BCM_ID from BCM_ORDER where BCM_ORDER_REF=SUBSTR(BCM_ORDER.ORDER_REF, 1, 5 ) 
      
    );
END;

create or replace 
PROCEDURE "MERGE_SUPPLIER_PRC" (p_order_ref IN VARCHAR2 )
AS
BEGIN

	MERGE INTO SUPPLIER D USING
    ( SELECT DISTINCT
		SUPPLIER_NAME, 
		SUPP_CONTACT_NAME, 
		SUPP_ADDRESS, 
		SUPP_CONTACT_NUMBER , 
		SUPP_EMAIL
		FROM XXBCM_ORDER_MGT
		WHERE ORDER_REF=SUBSTR( ORDER_REF, 1, 5 )
    )S1 ON (D.BCM_ORDER_REF = S1.ORDER_REF)
    WHEN NOT MATCHED THEN
	INSERT
    (
		BCM_SUPPLIER_ID,
		BCM_SUPPLIER_NAME, 
		BCM_SUPP_CONTACT_NAME, 
		BCM_SUPP_ADDRESS, 
		BCM_SUPP_CONTACT_NUMBER,
		BCM_SUPP_EMAIL,	 
    )
    VALUES
    (
      SQ_SUPPLIER_ID.nextval,
      S1.BCM_SUPPLIER_NAME,
      S1.BCM_SUPP_CONTACT_NAME,
	  S1.BCM_SUPP_ADDRESS,
	  S1.BCM_SUPP_CONTACT_NUMBER,
	  S1.BCM_SUPP_EMAIL  
    );

END;

create or replace 
PROCEDURE "MERGE_INVOICE_PRC" (p_order_ref IN VARCHAR2 )
AS
BEGIN

	MERGE INTO INVOICE D USING
    ( SELECT INVOICE_REFERENCE,
		INVOICE_DATE, 
		INVOICE_DESCRIPTION
		FROM XXBCM_ORDER_MGT
		WHERE INVOICE_REFERENCE IS NOT NULL
    )S1 ON (D.BCM_INVOICE_REFERENCE = S1.INVOICE_REFERENCE)
    WHEN NOT MATCHED THEN
	INSERT
    (
		BCM_INVOICE_ID,
		BCM_INVOICE_REFERENCE, 
		BCM_INVOICE_DATE, 
		BCM_INVOICE_DESCRIPTION
    )
    VALUES
    (
      SQ_INVOICE_ID.nextval,
      S1.BCM_INVOICE_REFERENCE,
      S1.BCM_INVOICE_DATE,
	  S1.BCM_INVOICE_DESCRIPTION
    );
	
end;

create or replace 
PROCEDURE "MERGE_ORDER_INVOICE_PRC" (p_order_ref IN VARCHAR2 )
AS
BEGIN

	MERGE INTO ORDER_INVOICE D USING
    ( SELECT INVOICE_REFERENCE,INVOICE_AMOUNT,
		INVOICE_STATUS, 
		INVOICE_HOLD_REASON
		FROM XXBCM_ORDER_MGT
		WHERE INVOICE_REFERENCE IS NOT NULL
    )S1 ON (D.BCM_INVOICE_REFERENCE = S1.INVOICE_REFERENCE)
    WHEN NOT MATCHED THEN
	INSERT
    (
		BCM_ORDER_LINE_ID,
		BCM_INVOICE_ID, 
		BCM_INVOICE_AMOUNT, 
		BCM_INVOICE_STATUS,
		BCM_INVOICE_HOLD_REASON
    )
    VALUES
    (
      SQ_INVOICE_ID.nextval,
      S1.BCM_INVOICE_REFERENCE,
      S1.INVOICE_AMOUNT,
	  S1.INVOICE_STATUS,
	  S1.INVOICE_HOLD_REASON
    );
	
END;

END BCMORDER_PKG;