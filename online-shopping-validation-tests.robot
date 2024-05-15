*** Settings ***
Documentation    Validate the price calculation in the shopping cart checkout as well as the post code Validation

Library  SeleniumLibrary
Library    String
#Library    Dialogs
Suite Setup    Start Test
Suite Teardown     End Test

 
*** Variables ***
${SEARCH_URL}       https://posti.fi/en
${BROWSER}          Firefox

${login_xpath}    xpath = //button[@class="sc-1i37xtg-0 guFYiI sc-nbuspz-5 sc-nbuspz-10 kRWyff bQopvN"]
${online_store_xpath}    xpath = //button[span[text()='Online shop']]
${cookies_accept_xpath}   xpath = //button[@id="onetrust-accept-btn-handler"]
${order_stamp_xpath}    xpath = //button[@class="sc-8cub1p-0 jiAnjG"]
${stamps_list_xpath}    xpath = //li[@class="ProductList__ListItem-sc-1l5h14a-0 cUupfp"]
${add_to_cart_xpath}    xpath = //button[@class="sc-8cub1p-0 brqSrJ AddToCartButton__AddButton-sc-3zhkh6-1 dqSrAi"]
${get_individual_stamp_value_xpath}    xpath = //div[@class="sc-1o4c90t-0 urlKey__Price-sc-161v7eb-2 bCfLHR hwSdBm"]
${overlay_1_xpath}    xpath = //div[@class="LoadingOverlay__BackDrop-sc-9hhqmx-2 kTUmWM"]
${go_to_cart_xpath}    xpath = //span[@class="CartButton__CartText-sc-e8t2bo-1 kAfxvi"]
${go_to_check_out_xpath}    xpath = //span[@class="CartTotals__Sum-sc-4buoch-5 BQmBH"]
${overlay_2_xpath}    xpath = //div[@class="CartTotals__LoaderContainer-sc-4buoch-7 hakYKC"]
${shopping_card_total_cost_xpath}    xpath = //span[@class="CartTotals__Sum-sc-4buoch-5 BQmBH"]//h3[@id="cart-totals-total-value"]
${total_cost_of_purchase_xpath}    xpath = //span[@class="sc-1o4c90t-0 CartTotals__StyledHeadline-sc-4buoch-2 kqUQwn llfOoS"]
${shopping_cart_checkout_xpath}   xpath = //button[@id="cart-totals-cta"]
${postal_code_xpath}    xpath = //input[@id="billing-postcode-field"]
${warning_message_post_code_xpath}    xpath = //p[@class="sc-zfwtr2-0 cnxoHB"]

${total_cost_in_cart}    0


*** Keywords ***
Count Stamps in Sale
    Wait Until Element Is Visible  ${stamps_list_xpath}
    ${stamps_count}=    Get Element Count    ${stamps_list_xpath}
    Log    ${stamps_count}

Select Stamp By Index
    [Arguments]    ${item_index}
    Wait Until Element Is Visible  ${stamps_list_xpath}
    ${elements}=    Get WebElements    ${stamps_list_xpath}    
    #FOR    ${element}    IN    @{elements}
        #Log    ${element.text}
    #END
    #Wait Until Element Is Visible    ${elements}[0]    15
    Click Element    ${elements}[${item_index}]    
    #END

Add Stamp To Cart
    Wait Until Element Is Not Visible    ${overlay_1_xpath}    15
    Wait Until Element Is Visible    ${add_to_cart_xpath}

    Click Element    ${add_to_cart_xpath}
    ${price}=    Get Text    ${get_individual_stamp_value_xpath}
    Log    ${price}
    ${split}=    Split String    ${price} 
    Log    ${split}
    Log    float(${split}[0])
    ${total}    Evaluate    ${total_cost_in_cart} + float(${split}[0])
    Set Global Variable    ${total_cost_in_cart}    ${total}   
    Log    ${total_cost_in_cart}
    Log    ${total}

Go To Shopping Cart
    Wait Until Element Is Visible    ${go_to_cart_xpath}
    Click Element    ${go_to_cart_xpath}

Validate Total Cost Calculation
    #Wait Until Element Is Visible    ${cart_total_sum_xpath}
    #${total_price}=    Get Text    ${cart_total_sum_xpath}
    #Log    ${total_price}
    Wait Until Element Is Visible    ${shopping_card_total_cost_xpath}
    ${total_price}=    Get Text    ${shopping_card_total_cost_xpath}
    Log    ${total_price}
    ${split}=    Split String    ${total_price}    
    Should Be Equal As Numbers    ${split}[0]    ${total_cost_in_cart}


Checkout The Items In Shopping Cart
    Wait Until Element Is Visible    ${overlay_2_xpath}    15
    Wait Until Element Is Not Visible    ${overlay_2_xpath}    15
    Wait Until Element Is Visible  ${go_to_check_out_xpath}
    Click Element    ${go_to_check_out_xpath}

Enter Data To Postal Text Box
    [Arguments]    ${postal_code}
    Wait Until Element Is Visible  ${postal_code_xpath}
    #Click Element    ${postal_code_xpath}
    Clear Element Text    ${postal_code_xpath}
    Input Text    ${postal_code_xpath}    ${postal_code}

Check For Warning Messages
    [Arguments]    ${warning_expected}

    IF    ${warning_expected} == $False
        Element Should Not Be Visible    ${warning_message_post_code_xpath}
    ELSE
        Element Should Be Visible    ${warning_message_post_code_xpath}
        ${warn_message}=    Get Text    ${warning_message_post_code_xpath}
        Log    ${warn_message}
        Should Not Be Empty    ${warn_message}
    END

Start Test
    Set Global Variable    ${total_cost_in_cart}    0

Initialize Test Case
    Open Browser  ${SEARCH_URL}  browser=${BROWSER}
End Test
    Close Browser

Accept cookies
    Wait Until Element Is Visible  ${cookies_accept_xpath}    15
    Click Element   ${cookies_accept_xpath} 

Visit Online Store
    Wait Until Element Is Visible    ${login_xpath}    15
    Click Element    ${login_xpath}
    Wait Until Element Is Visible   ${online_store_xpath}    15
    Click Button    ${online_store_xpath}

Go To Stamp Purchase Page
    Wait Until Element Is Visible  ${order_stamp_xpath}
    Click Element   ${order_stamp_xpath}

Go To Final Checkout Page
    Wait Until Element Is Visible    ${shopping_cart_checkout_xpath}
    Click Element       ${shopping_cart_checkout_xpath}

*** Test Cases ***
Validate The Shopping Cart Checkout Price Calculation
    Initialize Test Case
    Accept cookies
    Visit Online Store
    Go To Stamp Purchase Page
    #Count Stamps in Sale
    Select Stamp By Index    1
    Add Stamp To Cart
    Go Back
    Select Stamp By Index    2
    Add Stamp To Cart
    Go To Shopping Cart
    Checkout The Items In Shopping Cart
    Validate Total Cost Calculation
    End Test

Check the Postal Code Validation
    Initialize Test Case
    Accept cookies
    Visit Online Store
    Go To Stamp Purchase Page
    #Count Stamps in Sale
    #Get All Stamps in Sale
    Select Stamp By Index    1
    Add Stamp To Cart
    Go Back
    Select Stamp By Index    3
    Add Stamp To Cart
    Go To Shopping Cart
    Checkout The Items In Shopping Cart
    #Validate Total Cost Calculation
    Go To Final Checkout Page
    Enter Data To Postal Text Box    12345
    Check For Warning Messages    False
    Enter Data To Postal Text Box    1234
    Check For Warning Messages    True
    End Test
  




