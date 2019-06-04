<#
.Disclaimer
	This scripts is provided AS IS without warranty of any kind.
	In no event shall the author be liable for any damages whatsoever 
	(including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss)
	arising out of the use of or inability to use script,
	even if the Author has been advised of the possibility of such damages

.Author
	Ben Whitmore

.Created
	04/06/2019

.DESCRIPTION
 	Script to set the Wake On Lan BIOS value using the Dell Command PowerShell Provider

.PREREQS
	PowerShell Version 3.0 or above
	Dell Command PowerShell Provider 2.2 from https://www.powershellgallery.com/packages/DellBIOSProvider/2.2.0.330

.PARAM
	Valid Parameters to pass with the CurrentValue switch are "Disabled", "LanOnly", "WlanOnly", "LanWlan", "LanWithPxeBoot"
 
.EXAMPLE
	Set-WOL.ps1 -CurrentValue LanOnly

#>

Param (
	[Parameter(Mandatory = $True)]
	[string]$CurrentValue
)

$AllowedCurrentValues = @("Disabled", "LanOnly", "WlanOnly", "LanWlan", "LanWithPxeBoot")

ForEach ($Value in $AllowedCurrentValues)
{
	
	Write-Output $Value
	
	If ($CurrentValue -eq $Value)
	{
		
		$ModuleExists = Get-Module -ListAvailable -Name DellBIOSProvider
		
		If ($ModuleExists)
		{
			
			Import-Module DellBiosProvider
			Set-Location DellSMBios:
			
			$WakeOnLanState = Get-Item .\PowerManagement\WakeOnLan
			
			If ($WakeOnLanState.CurrentValue -ne $CurrentValue)
			{
				
				Set-Item .\PowerManagement\WakeOnLan $CurrentValue
				Write-Output "WakeOnLan state set to $($CurrentValue)"
				
			}
			else
			{
				
				Write-Output "WakeOnLan was already set to $($WakeOnLanState.CurrentValue)"
				
			}
		}
		
		else
		{
			
			Write-Output 'Dell PowerShell Provider Module not installed'
			
		}
	}
}
