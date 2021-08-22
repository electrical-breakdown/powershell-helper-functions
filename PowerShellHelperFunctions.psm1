function Get-YesNoResponse {
 
    <#
    
    .SYNOPSIS
    Prompts a user to answer yes or no to a given prompt  
    
    .DESCRIPTION
    Provides a yes/no question to the user and requests a response. Returns true if the response is yes, returns false if the answer is no. Used for setting boolean variables

    .INPUTS
    Reads a string input from the console

    .OUTPUTS
    Returns a boolean value
        
    #>


    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory)]
        [String]$Prompt
    
    )

    $acceptedResponses = "y", "yes", "n", "no"
    $invalidResponseMsg = "`nInvalid Entry. Please enter 'y' or 'n'."
    $responseOptions = "(y/n)"

    while($true){
            
        $adUserResponse = Read-Host "`n$Prompt $responseOptions"  

        if ($adUserResponse -notin $acceptedResponses){

            Write-Host $invalidResponseMsg -ForegroundColor Red                                     
                            
        } 
                       
        else{   
                            
            if($adUserResponse -in ("y", "yes")){

                return $true

            }

                return $false

        }           
    }
}

#-----------------------------------------------------------------------------------------------------------#

function Show-ADUserData {

    <#
    
    .SYNOPSIS
    Displays the results of searching for a user in AD   
    
    .DESCRIPTION
    Accepts an AD user object and an array of properties as inputs. Displays that user's properties to the console

    .INPUTS
    Accepts two mandatory parameters - an AD user object, and an array of properties
        
    .OUTPUTS
    Outputs a table to the console

    #>


    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory)]
        [Microsoft.ActiveDirectory.Management.ADUser]$User,
        [Parameter(Mandatory)]
        [array]$PropertiesToShow
    
    )

    Clear-Host
    Write-Host "Results for $($User.Name):"    
    $User | Format-Table $PropertiesToShow 

}

#-----------------------------------------------------------------------------------------------------------#

function Connect-Exchange {
    
    <#
    
    .SYNOPSIS
    Creates a new Exchange Online session if there are no active sessions
    
    .DESCRIPTION
    To be used in scripts that use the Exchange Online module. First checks to see if there is an active Exchange Online session. If there is, no further action is taken. 
    If there are no active sessions, the function checks to see if the Exchange Online module is installed. If it isn't, the module is installed. Finally, a new Exchange Online session is created. 

    .INPUTS
    Does not accept any inputs
        
    .OUTPUTS
    Writes a status message to the console

    #>


    [CmdletBinding()]

    param(
        
    )

     try {      
       

        # Check to see if there is already an active Exchange Online session before connecting 
        
        $exchangeSession = Get-PSSession | Where-Object {$_.Name -like 'ExchangeOnlineInternalSession*' -and $_.State -eq 'Opened'}


        if ($null -eq $exchangeSession) {
            
            Write-Verbose "Connecting to Exchange Online. This might take a moment..." 

            
            # Force TLS 1.2 encryption for compatibility with PowerShell Gallery

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12



            # Install Exchange Online module if it isn't already installed

            if ($null -eq (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {

                Write-Verbose "Installing Exchange Online module..." 
                Install-Module ExchangeOnlineManagement -Scope CurrentUser -Confirm 

            }    

                            
            # Connect to Exchange if the module is installed and there are no active sessions

            Connect-ExchangeOnline -UserPrincipalName $env:username@electricalbreakdown.com -ShowBanner:$false 
            Write-Host "`nExchange Online session succesfully created.`n" -ForegroundColor Green
        }   
         
        
    } 

    # Halt script execution if the connection to Exchange fails

    catch {

        Write-Host "`nThere was a problem connecting to Exchange. Please reload the script and try again`n" -ForegroundColor Red
        
        throw
    
    }


}


#-----------------------------------------------------------------------------------------------------------#