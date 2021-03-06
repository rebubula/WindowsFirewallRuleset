
<#
MIT License

This file is part of "Windows Firewall Ruleset" project
Homepage: https://github.com/metablaster/WindowsFirewallRuleset

Copyright (C) 2020 metablaster zebal@protonmail.ch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

<#
.SYNOPSIS
Gets the encoding of a file
.DESCRIPTION
Gets the encoding of a file, if the encoding can't be determined, ex. the file
contains unicode charaters but no BOM, then by default UTF-8 is assumed.
.PARAMETER FilePath
The path of the file to get the encoding of
.PARAMETER DefaultEncoding
Default encoding for non ASCII files and without BOM
.EXAMPLE
PS> Get-FileEncoding .\utf8BOM.txt
utf-8 with BOM
.EXAMPLE
PS> Get-FileEncoding .\utf32.txt
utf-32
.EXAMPLE
PS> Get-FileEncoding .\utf32.txt
utf-32
.INPUTS
None. You cannot pipe objects to Get-FileEncoding
.OUTPUTS
[string]
Encoding type of a file
.NOTES
TODO: utf-16LE detected as utf-16 with BOM
NOTE: This function is based on (but is not) sample from "Windows PowerShell Cookbook"
#>
function Get-FileEncoding
{
	[OutputType([string])]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string] $FilePath,

		[Parameter(Mandatory = $False)]
		[System.Text.Encoding] $DefaultEncoding = [System.Text.Encoding]::UTF8
	)

	Write-Debug -Message "[$($MyInvocation.InvocationName)] params($($PSBoundParameters.Values))"

	if (!(Test-Path -Path $FilePath -PathType Leaf))
	{
		Write-Error -Category ObjectNotFound -TargetObject $FilePath `
			-Message "Cannot find path '$FilePath' because it does not exist"
		return
	}

	# First, check if the file is binary. That is, if the first
	# 5 lines contain any non-printable characters.
	# TODO: encoding parameter needed?
	$NonPrintable = [char[]] (0..8 + 10..31 + 127 + 129 + 141 + 143 + 144 + 157)
	$Lines = Get-Content -Path $FilePath -ErrorAction Ignore -TotalCount 5

	$Result = @($Lines | Where-Object {
			$_.IndexOfAny($NonPrintable) -ge 0
		})

	if ($Result.Count -gt 0)
	{
		return "binary"
	}

	# Next, check if it matches a well-known encoding.
	# The hashtable used to store our mapping of encoding bytes to their
	# name. For example, "255-254 = Unicode"
	$Encodings = @{}

	# Find all of the encodings understood by the .NET Framework. For each,
	# determine the bytes at the start of the file (the preamble) that the .NET
	# Framework uses to identify that encoding.
	foreach ($Encoding in [System.Text.Encoding]::GetEncodings())
	{
		$Preamble = $Encoding.GetEncoding().GetPreamble()

		if ($Preamble)
		{
			$EncodingBytes = $Preamble -join '-'
			$Encodings[$EncodingBytes] = $Encoding.GetEncoding()
		}
	}

	# Find out the lengths of all of the preambles.
	$EncodingLengths = $Encodings.Keys | Where-Object { $_ } |
	ForEach-Object {
		($_ -split "-").Count
	}

	# To read file as bytes, that depends on PowerShell edition
	if ($PSVersionTable.PSEdition -eq "Core")
	{
		$Params = @{
			# Warning issued if Encoding used with this param
			AsByteStream = $true
		}
	}
	else
	{
		$Params = @{
			Encoding = "Byte"
		}
	}

	# Is there BOM in file
	[bool] $BOM = $false

	# Go through each of the possible preamble lengths, read that many
	# bytes from the file, and then see if it matches one of the encodings we know about.
	foreach ($EncodingLength in $EncodingLengths | Sort-Object -Descending)
	{
		$Bytes = Get-Content @Params -ReadCount $EncodingLength -Path $FilePath | Select-Object -First 1
		$Encoding = $Encodings[$Bytes -join '-']

		# If we found an encoding that had the same preamble bytes,
		# save that output and break.
		if ($Encoding)
		{
			$Result = $Encoding

			# For UTF encoding this will match only if there is BOM in file
			$BOM = switch ($Result | Select-Object -ExpandProperty BodyName)
			{
				"utf-8" { $true }
				"utf-16" { $true }
				"utf-32" { $true }
				default { $false }
			}

			break
		}

		Write-Debug -Message "[$($MyInvocation.InvocationName)] Length: $EncodingLength, Encoding: $Encoding"
	}

	if (!$Result)
	{
		# If there is no BOM present in file, parse file for non ASCII characters
		# TODO: not sure what encoding should be default for this
		if ($PSVersionTable.PSEdition -eq "Core")
		{
			$FileData = Get-Content -Path $FilePath -Encoding utf8NoBOM
		}
		else
		{
			$FileData = Get-Content -Path $FilePath -Encoding Ascii
		}

		foreach ($Line in $FileData)
		{
			# ASCIIEncoding encodes Unicode characters as single 7-bit ASCII characters.
			# This encoding only supports character values between U+0000 and U+007F. Code page 20127.
			# TODO: not clear if this is correct, it should be the opposite?
			if ($Line -cmatch "[^\u0000-\u007F]")
			{
				Write-Debug -Message "[$($MyInvocation.InvocationName)] Non ASCII line: $Line"

				# We only know it's not ASCII and there is no BOM, so use default encoding
				$Result = $DefaultEncoding
				break
			}
		}

		if (!$Result)
		{
			# All characters in file are in ASCII range
			$Result = [System.Text.Encoding]::ASCII
		}
	}

	# TODO: we can create custom object to tell us more about encoding of target file
	$OutputString = $Result | Select-Object -ExpandProperty BodyName

	if ($BOM)
	{
		$OutputString += " with BOM"
	}

	Write-Output $OutputString
}
