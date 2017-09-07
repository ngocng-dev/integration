*** settings ***
Library     Collections
Library     RequestsLibrary
Library     OperatingSystem
Library     json

*** Variables ***
@{return_ok_list}=   200  201  202
${queryswagger_url}    /api/catalog/v1/swagger.json

*** Test Cases ***
CatalogSwaggerTest
    [Documentation]    query nslcm swagger info rest test
    Should Be Equal    2.0    2.0