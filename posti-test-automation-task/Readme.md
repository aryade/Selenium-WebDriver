# Environment setup
set up a python virtual environment

Install the following python packages:
* pip install robotframework
* pip install robotframework-seleniumlibrary

For Browser drivers:
* pip install webdrivermanager
* webdrivermanager firefox

# Test case description
The robot test case uses selenium library to automate the UI testing of the post.fi/en page. The test scenarios are, 
* Visit online shop and add two stamps and validate the total cost shown during checkout
* Check the validation of the postal code by entering a valid and invalid and check the warning message shown.

# How to run the test
Activate the virtual env
robot online-shopping-validation-tests.robot

The test case uses Firefoxx browser to access the webpages.

# Test bundles
The tarball package contains
* Test case with name online-shopping-validation-tests.robot
* The logs from a local execution of the test case.


