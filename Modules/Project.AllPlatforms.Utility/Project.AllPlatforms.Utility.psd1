
#
# Module manifest for module 'Project.AllPlatforms.Utility'
#
# Generated by: metablaster
#
# Generated on: 11.2.2020.
#

@{
	# Script module or binary module file associated with this manifest.
	RootModule = 'Project.AllPlatforms.Utility.psm1'

	# Version number of this module.
	ModuleVersion = "0.6.0"

	# Supported PSEditions
	CompatiblePSEditions = 'Core, Desktop'

	# ID used to uniquely identify this module
	GUID = '5f38e46f-1bc4-489d-90df-72755129cfdd'

	# Author of this module
	Author = 'metablaster zebal@protonmail.ch'

	# Company or vendor of this module
	# CompanyName = 'Unknown'

	# Copyright statement for this module
	Copyright = 'Copyright (C) 2019, 2020 metablaster'

	# Description of the functionality provided by this module
	Description = "Utilities module for 'Windows Firewall Ruleset' project"

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'

	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ''

	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ''

	# Minimum version of Microsoft .NET Framework required by this module.
	# This prerequisite is valid for the PowerShell Desktop edition only.
	DotNetFrameworkVersion = '4.8'

	# Minimum version of the common language runtime (CLR) required by this module.
	# This prerequisite is valid for the PowerShell Desktop edition only.
	CLRVersion = '4.0'

	# Processor architecture (None, X86, Amd64) required by this module
	ProcessorArchitecture = 'None'

	# Modules that must be imported into the global environment prior to importing this module
	# RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @()

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	# ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @()

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @()

	# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
	# NestedModules = @()

	# Functions to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no functions to export.
	FunctionsToExport = @(
		"Approve-Execute"
		"Confirm-FileEncoding"
		"Update-Context"
		"Convert-SDDLToACL"
		"Show-SDDL"
		"Get-NetworkService"
		"Set-ScreenBuffer"
		"Set-NetworkProfile"
		"Get-TypeName"
		"Get-FileEncoding"
	)

	# Cmdlets to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport = @()

	# Variables to export from this module
	VariablesToExport = @(
		"CheckInitUtility"
		"ServiceHost"
	)

	# Aliases to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no aliases to export.
	AliasesToExport = @()

	# DSC resources to export from this module
	# DscResourcesToExport = @()

	# List of all modules packaged with this module
	# ModuleList = @()

	# List of all files packaged with this module
	FileList = @(
		"Project.AllPlatforms.Utility.psd1"
		"Project.AllPlatforms.Utility.psm1"
		"about_Project.AllPlatforms.Utility.help.txt"
		"External\Get-TypeName.ps1"
		"External\LICENSE"
		"External\README.md"
		"Public\Approve-Execute.ps1"
		"Public\Confirm-FileEncoding.ps1"
		"Public\Update-Context.ps1"
		"Public\Convert-SDDLToACL.ps1"
		"Public\Show-SDDL.ps1"
		"Public\Get-NetworkService.ps1"
		"Public\Set-ScreenBuffer.ps1"
		"Public\Set-NetworkProfile.ps1"
		"Public\Get-FileEncoding.ps1"
	)

	# Private data to pass to the module specified in RootModule/ModuleToProcess.
	# This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @(
				"Utility"
				"FirewallUtility"
				"Helper"
			)

			# A URL to the license for this module.
			LicenseUri = "https://raw.githubusercontent.com/metablaster/WindowsFirewallRuleset/master/LICENSE"

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/metablaster/WindowsFirewallRuleset'

			# A URL to an icon representing this module.
			# IconUri = ''

			# Prerelease string of this module
			Prerelease = "https://github.com/metablaster/WindowsFirewallRuleset/blob/develop/Readme/CHANGELOG.md"

			# ReleaseNotes of this module
			# ReleaseNotes = ''

			# Flag to indicate whether the module requires explicit user acceptance for install, update, or save.
			RequireLicenseAcceptance = $false

			# A list of external modules that this module is dependent upon.
			# ExternalModuleDependencies = @()
		} # End of PSData hashtable
	} # End of PrivateData hashtable

	# HelpInfo URI of this module
	# HelpInfoURI = ''

	# Default prefix for commands exported from this module.
	# Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ''
}
