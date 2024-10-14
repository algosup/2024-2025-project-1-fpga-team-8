import gspread
from google.oauth2.service_account import Credentials
import json
import time

scopes = [
    "https://www.googleapis.com/auth/spreadsheets" 
]# Scopes for Google Sheets API
creds = Credentials.from_service_account_file("credentials.json", scopes=scopes) # Load credentials from file
client = gspread.authorize(creds) # Authorize the client with the credentials

sheet_id = "13jn9MZXwvPJthTED8lPlTzNpH2iK69MnvhQDEM3IoZw" # ID of the Google Sheet used for Testing
workbook = client.open_by_key(sheet_id) # We are opening the Google Sheets document

validated_test = {i: False for i in range(1, 55)} # Dictionary to keep track of validated tests during this run

f = open("test_cases.json", "r") # Load the test cases from the JSON file
data = json.load(f) # Load the JSON file into a dictionary
f.close() # Close the file to avoid data corruption

# Function to verify if the worksheets exist in the Google Sheets document
def verify_worksheets_existence():
    worksheet_list = map(lambda x: x.title, workbook.worksheets()) # Map of the worksheet titles
    i = 0
    for test in data['tests']: # Iterate over the tests
        i += 1
        if (f"{i}. {test['test_name']}" not in worksheet_list): #Verify if a worksheet with the test name exists
            created_worksheet = workbook.add_worksheet(title=f"{i}. {test['test_name']}", rows=100, cols=20) # Create the worksheet if it does not exist
            print(f"✅ Worksheet📊 {created_worksheet.title} created") # Print a message to the user
            initialize_worksheet(created_worksheet, test) # Initialize the worksheet with the test data
    return
            
# Function to initialize the worksheet with the test data
def initialize_worksheet(current_worksheet: gspread.Worksheet, test: dict):
    
    time.sleep(60) # Avoid Google API rate limit (300 write requests/min)
    
    # Initialize the worksheet with the test data
    current_worksheet.update_acell("A1", "Test Name")
    current_worksheet.update_acell("B1", "Test ID")
    current_worksheet.update_acell("C1", "Test Description")
    current_worksheet.update_acell("D1", "Test Execution Count")
    current_worksheet.update_acell("E1", "Expected Result")
    time.sleep(15)
    current_worksheet.update_acell("A2", test["test_name"])
    current_worksheet.update_acell("B2", test["test_id"])
    current_worksheet.update_acell("C2", test["test_description"])
    current_worksheet.update_acell("D2", 0)
    current_worksheet.update_acell("E2", test["expected_result"])
    time.sleep(15)
    current_worksheet.update_acell("B5", "Execution Date & Time")
    current_worksheet.update_acell("C5", "Execution ID")
    current_worksheet.update_acell("D5", "Status")
    current_worksheet.update_acell("E5", "Result")
    current_worksheet.update_acell("F5", "Addtional Notes")

    time.sleep(15)
    current_worksheet.format(["A1:E1", "B5:F5"], {"textFormat": {"bold": True}}) # Format the cells with bold text
    print(f"✅ Worksheet {current_worksheet.title} initialized") # Print a message to the user
    return

# Function to run the tests
def run_tests():
    for i, test in enumerate(data['tests'], start=1): # Iterate over the tests
        worksheet = workbook.worksheet(f"{i}. {test['test_name']}") # Get the worksheet for the test
        test_run_id = int(worksheet.acell("D2").value) + 1 # Get the test run ID
       
        if test['test_type'] == "manual": # Check if the test is manual
            print(f"Please run manually the test \"{test['test_name']}\"") # Print a message to the user
            print("Follow the following steps:\n\n\n")
            for step in test['steps_to_follow']:
                print(f"Step {step['step_number']}: {step['step_description']}") # Print the steps to follow
            print("\n\n\n")
            match = input(f"Does the result match the expected result? \"{test['test_name']}\" [y/n]:") # Ask the user if the result matches the expected result
            if match == "y":
                # Update the worksheet with the test data for a successful test
                validated_test[i] = True # Update the validated test dictionary
                
                worksheet.update_acell(f"B{test_run_id + 5}", time.strftime("%Y-%m-%d %H:%M:%S")) # Update the execution date & time
                worksheet.update_acell(f"C{test_run_id + 5}", str(test_run_id)) # Update the execution ID
                worksheet.update_acell(f"D{test_run_id + 5}", "Success") # Update the status
                worksheet.update_acell(f"E{test_run_id + 5}", "The expected result was met.") # Update the result
                worksheet.update_acell(f"F{test_run_id + 5}", "/") # Update the additional notes
                
                worksheet.format(f"D{test_run_id + 5}", {"backgroundColor": {"red": 0.0, "green": 1.0, "blue": 0.0}}) # Format the cell with green color

            else:
                validated_test[i] = False # Update the validated test dictionary
                notes = input("Could you add some notes to explain why the test failed?") # Ask the user to add notes to explain why the test failed
                
                worksheet.update_acell(f"B{test_run_id + 5}", time.strftime("%Y-%m-%d %H:%M:%S")) # Update the execution date & time
                worksheet.update_acell(f"C{test_run_id + 5}", str(test_run_id)) # Update the execution ID
                worksheet.update_acell(f"D{test_run_id + 5}", "Failed") # Update the status
                worksheet.update_acell(f"E{test_run_id + 5}", "The expected result was not met.") # Update the result
                worksheet.update_acell(f"F{test_run_id + 5}", str(notes)) # Update the additional notes
                
                worksheet.format(f"D{test_run_id + 5}", {"backgroundColor": {"red": 1.0, "green": 0.0, "blue": 0.0}}) # Format the cell with red color
    return

# Function to update the main page with the testing results
def update_main_page():
    main_worksheet = workbook.worksheet("0. Overview") # Get the main worksheet
    
    main_worksheet.update_acell("A3", "Overview of testing results") # Update the main worksheet with the testing results and titles
    main_worksheet.update_acell("B3", "Always")
    main_worksheet.update_acell("B4", "Total count of realized tests")
    main_worksheet.update_acell("C4", "Average of succeeding tests")
    main_worksheet.update_acell("E3", "Last execution overview")
    main_worksheet.update_acell("E4", "Realized tests")
    main_worksheet.update_acell("F4", "Average of succeeding tests")
    
    main_worksheet.format(["A3", "B3", "B4", "C4", "E3", "E4", "F4"], {"textFormat": {"bold": True}}) # Format the cells with bold text
    
    for i in range (1, 55): # Iterate over the tests
        worksheet = workbook.worksheet(f"{i}. {data['tests'][i-1]['test_name']}") # Get the worksheet for the test
        test_results = worksheet.col_values(4) # Get the test results
        test_results = test_results[6:] # Remove the first 5 rows as they are not test results
        test_results = list(map(lambda x: 1 if x == "Success" else 0, test_results)) # Map the test results to 1 if success and 0 if failure
        avg_sucess_rate = sum(test_results) / len(test_results) # Calculate the average success rate
        
        main_worksheet.update_acell(f"B5", len(test_results))
        main_worksheet.update_acell(f"C5", avg_sucess_rate)
    
    currently_validated_tests = 0 # Initialize the variable to keep track of the currently validated tests
      
    for i in range(validated_test): 
        if validated_test[i + 1] == True:
            currently_validated_tests += 1 # If the test was validated, increment the variable keeping track of the currently validated tests
    
    main_worksheet.update_acell("E5", 55)
    main_worksheet.update_acell("F5", currently_validated_tests) # Update the main worksheet with the currently validated tests
    
if __name__ == "__main__":
    verify_worksheets_existence() # Verify if the worksheets exist
    run_tests() # Run the tests
    update_main_page() # Update the main page with the testing results
    print("✅ - Everything ran successfully")


