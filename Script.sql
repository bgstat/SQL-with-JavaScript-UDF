/* UDF to filter out exact text */
CREATE TEMP FUNCTION Specific_text(resp_code ARRAY<STRING>)
RETURNS ARRAY<STRING>
LANGUAGE js AS """
  var intend_list = ['E1','E2','E3','E10'];
  let match = intend_list.filter(x => resp_code.includes(x));
	return match;
"""
;

/* UDF to split 'Struct Type 1' string and provide sub-array of possible text strings*/

CREATE TEMP FUNCTION split_res_msg_t1(text STRING)
  RETURNS ARRAY<STRING>
  LANGUAGE js AS """
  var field = text.split("|");
  var fLen = field.length;
  var mod_field = [];
  for (var i=6;i<12;i++){ 
    if (field[i]!="null" && field[i]!="NA" ) {
        mod_field[mod_field.length] = field[i] ;
      }
  }  
  return mod_field;
"""
;

DEFINE MACRO split_res_msg_t1
  SELECT
    Id,
    split_res_msg_t1(response_message) AS res_msg_array_t1
  FROM Database_1
  WHERE response_message IS NOT NULL
;

/* UDF to split 'Struct Type 2' string and provide sub-array of possible text strings*/
DEFINE MACRO split_res_msg_t2
  SELECT
    Id,
    [Comp1,Comp2] AS res_msg_array_t2
  FROM
    (
      SELECT
       Id,
       COALESCE(REGEXP_EXTRACT(response_message, r'.*Field2": "(.*)"'),"") AS Comp1,
       COALESCE(REGEXP_EXTRACT(response_message, r'.*Field10": "(.*)"'),"") AS Comp2
      FROM Database_1
    )
 ;

/* Combine UDFs and SQL functions to get final result */

SELECT
d.Id,
d.response_code,
IF(d.Org_type = "T1" ,COALESCE(Specific_text(T1.res_msg_array_t1)[SAFE_ORDINAL(1)],""),
  IF(d.Org_type = "T2" ,COALESCE(Specific_text(T2.res_msg_array_t2)[SAFE_ORDINAL(1)],""),d.response_message)
  ) AS Specific_resp_code
  
FROM Database_1 d
LEFT JOIN ($split_res_msg_t1) T1 ON T1.Id = d.Id 
LEFT JOIN ($split_res_msg_t2) T2 ON T2.Id = d.Id 
;
