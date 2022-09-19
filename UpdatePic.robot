*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Library     OperatingSystem

*** Variables ***
${base_rul}             https://sailapp.studio:81

*** Test Cases ***
Login 2fa
    create session          MySession                           ${base_rul}                 
    ...                     disable_warnings=1
    ${body}=                Create Dictionary                   email=pandi                 
    ...                     password=nMt8zGP?                           
    ...                     fingerprint=1652435559794
    ${response}=            POST On Session                     MySession                    
    ...                     /auth/login                                 
    ...                     data=${body}
    log to console          ${response.json()}
    ${authToken}=           Collections.Get From Dictionary     ${response.json()}           
    ...                     authToken
    Set Global Variable     ${authToken}
    log to console          ${response.status_code}
    log to console          ${response.content}
    ${status_code}=         convert to string                   ${response.status_code}
    should be equal         ${status_code}                      200
    ${res_body}=            convert to string                   ${response.content}
    should contain          ${res_body}                         0

Request-Authentication
    create session          MySession                           ${base_rul}
    ${param}=               Create Dictionary                   email=pandi                    
    ...                     password=hYtZY2$o                           
    ...                     fingerprint=1652435559794
    ${headers}=             Create Dictionary                   fingerprint=1652435559794      
    ...                     authToken=${authToken}
    ${response}=            POST On Session                     MySession                      
    ...                     /auth/request-authentication/email
    ...                     data=${param}                       headers=${headers}
    log to console          ${response.status_code}
    log to console          ${response.content}

Valid-authentication
    create session          MySession                           ${base_rul}
    ${body}=                Create Dictionary                   code=123456
    ${headers}=             Create Dictionary                   fingerprint=1652435559794       
    ...                     authToken=${authToken}
    ${response}=            POST On Session                     MySession                       
    ...                     /auth/validate-authentication               
    ...                     data=${body}                        headers=${headers}
    log to console          ${response.status_code}
    log to console          ${response.content}

Update an Image profile
    create session           MySession                           ${base_rul}
    ${binary}=               Get Binary File                     ${CURDIR}\\boy.jpg
    ${encode}=               Evaluate                            base64.b64encode(b'$binary').decode('utf-8')    
    ...                      modules=base64
    ${headers}=              Create Dictionary                   fingerprint=1652435559794       
    ...                      authToken=${authToken}  
    ${body}=                 Create Dictionary                   Content-Type=multipart/form-data    
    ...                      Accept=application                  firstName=Pandi                     
    ...                      lastName=Pranata                    contact=65|999998877       
    ...                      email=pandirotama@yahoo.com         profileImage=${encode}               removeImage=0
    ${response}=             PUT On Session                      MySession                            /users/my-profile               
    ...                      data=${body}                        headers=${headers}
    log to console           ${response.status_code}
    log to console           ${response.content}

Logout
    create session           MySession                           ${base_rul}
    ${headers}=              Create Dictionary                   fingerprint=1652435559794              authToken=${authToken}
    ${response}=             POST On Session                     MySession                              /auth/logout                                headers=${headers}
    log to console           ${response.status_code}
    log to console           ${response.content}