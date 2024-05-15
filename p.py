from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
import time
from selenium.webdriver.common.action_chains import ActionChains

driver = webdriver.Firefox()
driver = webdriver.Chrome(executable_path= '/usr/local/bin/chromedriver')

driver.get("https://shop.posti.fi/en")

wait = WebDriverWait(driver, 10)

cookies_accept_xpath = '//button[@id="onetrust-accept-btn-handler"]'
wait.until(EC.element_to_be_clickable((By.XPATH, cookies_accept_xpath)))
driver.find_element(By.XPATH, cookies_accept_xpath).click()

# stamps button element
driver.find_element(By.XPATH, '//button[@class="sc-8cub1p-0 jiAnjG"]').click()

stamps_list_xpath = '//li[@class="ProductList__ListItem-sc-1l5h14a-0 cUupfp"]'
# Wait for products to load
wait.until(EC.element_to_be_clickable((By.XPATH, stamps_list_xpath)))
num_elements = len(driver.find_elements(By.XPATH, stamps_list_xpath))
print(num_elements)

ac = ActionChains(driver)
total_cost_of_purchase = 0
# Add first two products to cart
for i in range(2):
    # Wait until elements are clickable
    wait.until(EC.element_to_be_clickable((By.XPATH, stamps_list_xpath)))
    # Get all elements and select only the i-th one
    element = driver.find_elements(By.XPATH, stamps_list_xpath)[i]
    # Click the element with the offset from center to actually go to the other page
    ac.move_to_element(element).move_by_offset(0, 100).click().perform()

    time.sleep(3)
    wait.until(EC.invisibility_of_element_located((By.XPATH, '//div[@class="LoadingOverlay__BackDrop-sc-9hhqmx-2 kTUmWM"]')))
    add_to_cart_xpath = '//button[@class="sc-8cub1p-0 brqSrJ AddToCartButton__AddButton-sc-3zhkh6-1 dqSrAi"]'
    get_value_xpath = '//div[@class="sc-1o4c90t-0 urlKey__Price-sc-161v7eb-2 bCfLHR hwSdBm"]'
    wait.until(EC.element_to_be_clickable((By.XPATH, add_to_cart_xpath)))

    driver.find_element(By.XPATH, add_to_cart_xpath).click()
    p = driver.find_element(By.XPATH, get_value_xpath)
    price = p.text
    total_cost_of_purchase = total_cost_of_purchase + float(price.split()[0])
    print(price, total_cost_of_purchase)
    time.sleep(1)
    # Go back to the previous page
    driver.execute_script("window.history.go(-1)")


go_to_cart_xpath = '//span[@class="CartButton__CartText-sc-e8t2bo-1 kAfxvi"]'
wait.until(EC.element_to_be_clickable((By.XPATH, go_to_cart_xpath)))
driver.find_element(By.XPATH, go_to_cart_xpath).click()

#cart_total_sum_xpath = '//h3[@id="cart-totals-total-value"]'
cart_total_sum_xpath = '//span[@class="CartTotals__Sum-sc-4buoch-5 BQmBH"]'
wait.until(EC.element_to_be_clickable((By.XPATH, cart_total_sum_xpath)))
#wait.until(EC.element_to_be_clickable((By.XPATH, cart_total_sum_xpath)))

#total = driver.find_element(By.XPATH, cart_total_sum_xpath)
#total = driver.find_element(By.ID, "cart-totals-total-value")

# sometimes the checkout is not clickable, so wait for the overlay to disappear
wait.until(EC.invisibility_of_element_located((By.XPATH, '//div[@class="CartTotals__LoaderContainer-sc-4buoch-7 hakYKC"]')))
checkout_xpath = '//span[@class="sc-8cub1p-1 fxyYSE"]'
wait.until(EC.element_to_be_clickable((By.XPATH, checkout_xpath)))
driver.find_element(By.XPATH, checkout_xpath).click()

total_cost_xpath = '//span[@class="CartTotals__Sum-sc-4buoch-5 BQmBH"]//h3[@id="cart-totals-total-value"]'
wait.until(EC.element_to_be_clickable((By.XPATH, total_cost_xpath)))

total = driver.find_element(By.XPATH, total_cost_xpath).text
print(total)
print(float(total.split()[0]), total_cost_of_purchase)
assert float(total.split()[0]) == total_cost_of_purchase

postal_code_xpath = '//input[@class="sc-1ufh44s-4 gPrMWJ"]'
wait.until(EC.visibility_of_element_located((By.XPATH, postal_code_xpath)))
postal_code = driver.find_element(By.ID, "billing-postcode-field")
postal_code.send_keys("1234")
# Wait for postal code to load

warning_message_post_code_xpath = '//p[@class="sc-zfwtr2-0 cnxoHB"]'
wait.until(EC.visibility_of_element_located((By.XPATH, warning_message_post_code_xpath)))
warning_message = driver.find_element(By.XPATH, warning_message_post_code_xpath).text
assert warning_message == "Value must be in the following form:"
print(warning_message)

postal_code_xpath = '//input[@class="sc-1ufh44s-4 gPrMWJ"]'
wait.until(EC.visibility_of_element_located((By.XPATH, postal_code_xpath)))
postal_code = driver.find_element(By.ID, "billing-postcode-field")
postal_code.clear()
postal_code.send_keys("12345")
# Wait for postal code to load

warning_message_post_code_xpath = '//p[@class="sc-zfwtr2-0 cnxoHB"]'
#wait.until(EC.invisibility_of_element_located((By.XPATH, warning_message_post_code_xpath)))
warn = driver.find_elements(By.XPATH, warning_message_post_code_xpath)
print(len(warn))
assert len(warn) == 0

#assert not warning_message


#value_elements = len(By.ID, postal_code)#(driver.find_elements(By.ID, postal_code))
#assert element.get_attribute('value') == "01000"#print(num_elements)

#firstname_input = driver.find_element(By.ID, 'billing-firstname-field')
#firstname_input.send_keys("test")

#lastname_input = driver.find_element(By.ID, 'billing-lastname-field')
#lastname_input.send_keys("XYZ")

# Submit the form (replace 'submit_button_selector' with the actual selector)
#submit_button_xpath = '//span[@class="sc-8cub1p-1 fGqsCK"¨]'
#driver.find_element(By.XPATH, submit_button_xpath)
#submit_button_xpath.click()

# Wait for the validation message to appear
#validation_message = WebDriverWait(driver, 10).until(
#    EC.visibility_of_element_located((By.CSS_SELECTOR, 'validation_message_selector'))
#)

# Check if the validation message indicates success or failure
#if "valid" in validation_message.text:
#    print("Postal code validation successful!")
#else:
#    print("Postal code validation failed.")

# Close the browser
driver.quit()