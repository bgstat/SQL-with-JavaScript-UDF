# SQL-with-JavaScript-UDF
Problem Description: From a DB along with other fields, I need to extract a specific text from a long string field and structure of that varies from organization to organization API response.

Example of such string:

Struct Type 1(STRING): 
XYZ2fd3rthybf6084307b627ee75bat56yh2|743x1xxxx452|XYZ2fd3rthybf6084307b627ee75bat56yh2|[redact]|17.00|04/12/2019 11:26:48|Z30|null|F|Z30|E1|Z30|NA|NA|null|null|null|null|NA|NA

I have to extract text "E1" but possition of the text may very  after datetime field

Struct Type 2(STRING): 

{
  "Field1": "true",
  "Field2": "Z30",
  "Field3": "FAILURE",
  "Field4": "[redact]",
  "Field5": "8x13xxx1264",
  "Field6": "[8 characters redact]",
  "Field7": "[redact]",
  "Field9": "",
  "Field10": "E2"
}

I have to extract text "E2" but possition of the text may very  between "Field2" and "Field10"

For Type 1 , I have used JavaScript based user define function(UDF)  and for type 2, I have used regular expression extraction method to filter out specific text array. Finnaly, I have applied another Javascript based UDF to filter out exact text.
