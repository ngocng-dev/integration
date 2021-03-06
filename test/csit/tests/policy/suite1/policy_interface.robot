*** Settings ***
Documentation	  The main interface for interacting with Policy. It handles low level stuff like managing the http request library and Policy required fields
Library	   eteutils/RequestsClientCert.py
#Library	   RequestsClientCert
Library    RequestsLibrary
Library    String
Library    eteutils/JSONUtils.py
#Library    JSONUtils
Library    Collections      
Resource   global_properties.robot

*** Variables ***
${POLICY_HEALTH_CHECK_PATH}        /healthcheck

*** Keywords ***

Run Policy Health Check
     [Documentation]    Runs Policy Health check
     ${auth}=    Create List    ${GLOBAL_POLICY_USERNAME}    ${GLOBAL_POLICY_PASSWORD}    
     Log    Creating session ${GLOBAL_POLICY_SERVER_URL}
     ${session}=    Create Session 	policy 	${GLOBAL_POLICY_HEALTHCHECK_URL}   auth=${auth}
     ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json
     ${resp}= 	Get Request 	policy 	${POLICY_HEALTH_CHECK_PATH}     headers=${headers}
     Log    Received response from policy ${resp.text}
     Should Be Equal As Strings 	${resp.status_code} 	200
     Should Be True 	${resp.json()['healthy']}
     @{ITEMS}=    Copy List    ${resp.json()['details']}
     :FOR    ${ELEMENT}    IN    @{ITEMS}
     \    Should Be Equal As Strings 	${ELEMENT['code']} 	200
     \    Should Be True    ${ELEMENT['healthy']}
    
Run Policy Put Request
     [Documentation]    Runs Policy Put request
     [Arguments]    ${data_path}  ${data}
     Log    Creating session ${GLOBAL_POLICY_SERVER_URL}
     ${session}=    Create Session 	policy 	${GLOBAL_POLICY_SERVER_URL}
     ${headers}=  Create Dictionary     Accept=application/json    Content-Type=application/json    Authorization=Basic ${GLOBAL_POLICY_AUTH}   ClientAuth=${GLOBAL_POLICY_CLIENTAUTH}    Environment=TEST
     ${resp}= 	Put Request 	policy 	${data_path}     data=${data}    headers=${headers}
     Log    Received response from policy ${resp.text}
     [Return]    ${resp}
     
Run Policy Delete Request
     [Documentation]    Runs Policy Delete request
     [Arguments]    ${data_path}  ${data}
     Log    Creating session ${GLOBAL_POLICY_SERVER_URL}
     ${session}=    Create Session 	policy 	${GLOBAL_POLICY_SERVER_URL}
     ${headers}=    Create Dictionary     Accept=application/json    Content-Type=application/json    Authorization=Basic ${GLOBAL_POLICY_AUTH}   ClientAuth=${GLOBAL_POLICY_CLIENTAUTH}    Environment=TEST
     ${resp}= 	Delete Request 	policy 	${data_path}    data=${data}    headers=${headers}
     Log    Received response from policy ${resp.text}
     [Return]    ${resp}
     
Run Policy Get Configs Request
    [Documentation]    Runs Policy Get Configs request
    [Arguments]    ${data_path}  ${data}
    Log    Creating session ${GLOBAL_POLICY_SERVER_URL}
    ${session}=    Create Session 	policy 	${GLOBAL_POLICY_SERVER_URL}
    ${headers}=    Create Dictionary     Accept=application/json    Content-Type=application/json    Authorization=Basic ${GLOBAL_POLICY_AUTH}   ClientAuth=${GLOBAL_POLICY_CLIENTAUTH}    
    ${resp}= 	Post Request 	policy 	${data_path}    data=${data}    headers=${headers}
    Log    Received response from policy ${resp.text}
    [Return]    ${resp}