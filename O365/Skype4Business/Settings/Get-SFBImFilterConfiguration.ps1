﻿#Requires -Version 5.0
#Requires -Modules SkypeOnlineConnector

<#
    .SYNOPSIS
        Returns the instant messaging (IM) link filters configured in your organization
    
    .DESCRIPTION  

    .NOTES
        This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
        The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
        The terms of use for ScriptRunner do not apply to this script. In particular, ScriptRunner Software GmbH assumes no liability for the function, 
        the use and the consequences of the use of this freely available script.
        PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of ScriptRunner Software GmbH.
        © ScriptRunner Software GmbH

    .COMPONENT
        Requires Module SkypeOnlineConnector
        Requires Library script SFBLibrary.ps1

    .LINK
        https://github.com/scriptrunner/ActionPacks/tree/master/O365/Skype4Business/Settings

    .Parameter SFBCredential
        [sr-en] Credential object containing the Skype for Business user/password

    .Parameter Identity
        [sr-en] The unique identifier of the settings you want to retrieve

    .Parameter LocalStore
        [sr-en] Retrieves the IM filter configuration from the local replica of the Central Management store, rather than the Central Management store itself
#>

param(    
    [Parameter(Mandatory = $true)]
    [PSCredential]$SFBCredential,  
    [string]$Identity,
    [switch]$LocalStore
)

Import-Module SkypeOnlineConnector

try{
    ConnectS4B -S4BCredential $SFBCredential

    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'LocalStore' =$LocalStore
                            }      
    if([System.String]::IsNullOrWhiteSpace($Identity) -eq $false){
        $cmdArgs.Add('Identity',$Identity)
    } 

    $result = Get-CsImFilterConfiguration @cmdArgs | Select-Object *

    if($SRXEnv) {
        $SRXEnv.ResultMessage = $result
    }
    else {
        Write-Output $result 
    }    
}
catch{
    throw
}
finally{
    DisconnectS4B
}