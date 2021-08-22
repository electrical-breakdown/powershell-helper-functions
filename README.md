# PowerShell Helper Functions
A collection of PowerShell functions I use in my scripts.

## Get-YesNoResponse
This is a function that gets user response in the form of a question that can be answered with 'yes' or 'no.' The function will continue to prompt the user until a valid response is received. If the response is 'y' or 'yes', the function returns $true. If the response is 'n' or 'no', the function returns $false. 

I often use this to set boolean variables that are used to control optional parts of a script. 'Do you want to export results to a file?', 'Do you want to search again?', etc. 

## Show-ADUserData
This function is used to format and display various properties of an AD user object. Takes in two arguments - an AD user object, and an array of properties to display. The properties are formatted into a table and displayed to the console. 

Just a quick little function that keeps me from having to repeat code when working with AD user objects in helpdesk utilities. 

## Connect-Exchange
A function that checks for an active Exchange Online session. If there is no active session, the function checks to see if the Exchange Online module is installed. If not, it installs it. When there are no active Exchange sessions and the module is installed, an Exchange Online session is established. 

I use this for any scripts that require cmdlets from the Exchange Online module. 