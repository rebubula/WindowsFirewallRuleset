
# How to make use of this project on older Windows systems

**First, note that Home versions of Windows do not ship with GPO (Local Group Policy),
therefore not supported by this project.**

There are workarounds for home editions however, but no help is provided here

To be able to apply rules to older systems such as Windows 7 or Windows server 2008,
you'll need to modify code.\
At a bare minimum you should do the modifications described here

## Table of contents

- [How to make use of this project on older Windows systems](#how-to-make-use-of-this-project-on-older-windows-systems)
  - [Table of contents](#table-of-contents)
  - [Initialization module](#initialization-module)
  - [Project settings](#project-settings)
  - [Target platform variable](#target-platform-variable)
  - [OS software](#os-software)
  - [Testing](#testing)

## Initialization module

Edit the module named `Project.AllPlatforms.Initialize` to allow execution for older system.

## Project settings

edit script `Config\ProjectSettings.ps1` and define new variable that defines your system version,\
following variable is defined to target Windows 10.0 versions and above by default for all rules.\
```New-Variable -Name Platform -Option Constant -Scope Global -Value "10.0+""```

For example for Windows 7, define a new variable that looks like this:\
```New-Variable -Name PlatformWin7 -Option Constant -Scope Global -Value "6.1"```

`Platform` variable specifies which version of Windows the associated rule applies.\
The acceptable format for this parameter is a number in the Major.Minor format.

For more information about other Windows systems and their version numbers see below link:\
[Operating System Version](https://docs.microsoft.com/en-us/windows/win32/sysinfo/operating-system-version)

## Target platform variable

Edit individual ruleset scripts, and take a look which rules you want or need to be loaded on
that system,\
then simply replace ```-Platform $Platform``` with ie. ```-Platform $PlatformWin7```
for each rule you want.

In VS Code for example you can also simply (CTRL + F) for each script and replace all instances.\
If you miss something you can delete, add or modify rules in GPO later.

Note that if you define your platform globally (ie. ```$Platform = "6.1"```) instead of making your
own variable, just replacing the string, but do not exclude unrelated rules,
most of the rules should work, but ie. rules for Store Apps might fail to load.

Also ie. rules for programs and services that don't exist on system will be most likely applied
but redundant.

What this means, is, just edit the GPO later to refine your imports if you go that route,
or alternatively revisit your edits and re-run individual scripts again.

## OS software

It's hard to tell what software or module dependencies might be required for your target environment,
and once you learn that you should modify version requirements in `Config\ProjectSettings.ps1`

For example .NET framework version 4.5 for Windows PowerShell may be absolute minimum to be able to
use commandlets from modules provided by Microsoft.

## Testing

To save you some time debugging you should also run code analysis with [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
with following rules enabled:

1. PSUseCompatibleCmdlets
2. PSUseCompatibleSyntax

Visit `Test` folder and run all tests individually to confirm modules and their functions work as
expected, any failure should be fixed before loading rules to save yourself from frustration.
