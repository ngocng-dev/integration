*** settings ***
Library     Collections
Library     RequestsLibrary
Library     OperatingSystem
Library     json
Library     HttpLibrary.HTTP

*** Variables ***
@{return_ok_list}=   200  201  202  204

*** Test Cases ***
MonitorSwaggerTest
    [Documentation]    query Monitor swagger info rest test
    Should Be Equal    2.0    2.0
