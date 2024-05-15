*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
${BROWSER}    Chrome    #Firefox
${data_URL}    https://www.google.com/search?client=firefox-b-d&q=ganesh+vasudevan
${accept_button}    xpath = //button[@id="L2AGLb"]
${select_data_xpath}    xpath = //h3[contains(@class,'LC20lb MBeuO')]

*** Keywords ***
Initialize The Test
    Open Browser    ${data_URL}    browser=${BROWSER}    
    Maximize Browser Window

Accept the Google Agreement
    Wait Until Element Is Visible    ${accept_button}
    Click Element    ${accept_button}
    
Select the Details with Label
    ${element} =    Get WebElement    ${select_data_xpath}
    Click Element    ${element}

End the Test
    Close Browser







*** Test Cases ***
Check the Details in LinkedIn
    Initialize The Test
    Accept the Google Agreement
    Select the Details with Label
    End the Test
    




 
