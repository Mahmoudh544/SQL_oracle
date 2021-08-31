/*MAX AND MIN PO GROUP BY ORG*/

SELECT TOT.max_po_amount,TOT.min_po_amount,TOT.max_po_number,MIN(TOT.min_po_number),TOT.ORG_ID
FROM
(
SELECT
    po_amount.max_po_amount,
    po_amount.min_po_amount,
    po_amount.ORG_ID,
    po_number.SEGMENT1 AS max_po_number,
    po_num.SEGMENT1 AS min_po_number

FROM
    (
    SELECT MAX(total_price) AS max_po_amount,
           MIN(total_price) AS min_po_amount,
           ORG_ID
    FROM
        (
        /*TOTAL POs GROUPED BY ORG POH*/
        SELECT
            SUM(POL.UNIT_PRICE*POL.QUANTITY) AS total_price,
            POH.ORG_ID,
            POH.SEGMENT1
        FROM
            PO_HEADERS_ALL POH 
            LEFT JOIN PO_LINES_ALL POL
            ON POH.PO_HEADER_ID=POL.PO_HEADER_ID
        GROUP BY
            POH.ORG_ID,
            POH.SEGMENT1
        )
    GROUP BY
        org_id
    ) po_amount
    INNER JOIN
    (
    /*TOTAL POs GROUPED BY ORG POH*/
    SELECT
        SUM(POL.UNIT_PRICE*POL.QUANTITY) AS total_price,
        POH.ORG_ID,
        POH.SEGMENT1
    FROM
        PO_HEADERS_ALL POH 
        LEFT JOIN PO_LINES_ALL POL
        ON POH.PO_HEADER_ID=POL.PO_HEADER_ID
    GROUP BY
        POH.ORG_ID,
        POH.SEGMENT1
    ) po_number
    ON po_amount.ORG_ID=po_number.ORG_ID
    AND po_amount.max_po_amount=po_number.total_price
    INNER JOIN
    (
      SELECT
        SUM(POL.UNIT_PRICE*POL.QUANTITY) AS total_price,
        POH.ORG_ID,
        POH.SEGMENT1
    FROM
        PO_HEADERS_ALL POH 
        LEFT JOIN PO_LINES_ALL POL
        ON POH.PO_HEADER_ID=POL.PO_HEADER_ID
    GROUP BY
        POH.ORG_ID,
        POH.SEGMENT1    
        ) PO_NUM
         ON po_amount.ORG_ID=po_num.ORG_ID
         AND po_amount.min_po_amount=po_num.total_price) TOT
         GROUP BY
         TOT.max_po_amount,TOT.min_po_amount,TOT.max_po_number,TOT.ORG_ID
         