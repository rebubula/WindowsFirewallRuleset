
# Windows Firewall Ruleset

![Alt Text](https://bitbucket.org/SuperAAAAA/shack/raw/60508e0e23d73aeb8f9a4fdc75b13ea94e56e62b/corporate.jpg)

## Table of Contents

- [Windows Firewall Ruleset](#windows-firewall-ruleset)
  - [Table of Contents](#table-of-contents)
  - [About Windows Firewall Ruleset](#about-windows-firewall-ruleset)
  - [Core benefits of this firewall project](#core-benefits-of-this-firewall-project)
  - [License](#license)
  - [Requirements](#requirements)
  - [I don't meet the requirements](#i-dont-meet-the-requirements)
  - [First time user](#first-time-user)
    - [Warning](#warning)
    - [Note](#note)
  - [Quick start](#quick-start)
  - [Where are my rules](#where-are-my-rules)
  - [Applying individual rulesets](#applying-individual-rulesets)
  - [Deleting rules](#deleting-rules)
  - [Export/Import rules](#exportimport-rules)
  - [Manage loaded rules](#manage-loaded-rules)
  - [Checking for updates](#checking-for-updates)
  - [Contributing or suggestions](#contributing-or-suggestions)
  - [Customization](#customization)
  - [More information and help](#more-information-and-help)
  - [The future](#the-future)

## About Windows Firewall Ruleset

- Windows firewall rules sorted into individual powershell scripts according to:

1. Rule group
2. Traffic direction
3. IP version (IPv4 / IPv6)
4. Further sorted according to programs and services

- Such as for example:

1. ICMP traffic
2. Browser rules
3. Rules for Windows system
4. Store apps
5. Windows services
6. Microsoft programs
7. 3rd party programs
8. broadcast traffic
9. multicast traffic
10. and the list goes on...

- In addition to firewall rules you will find a number of PowerShell modules,
scripts and functions used to gather info relevant for building a firewall such as:

1. computers on network
2. installed programs
3. users on system
4. network configuration
5. managing firewall etc.

- Meaning this project is a good base to easily extend your firewall and include more rules and
functionalities.
- Currently there are some 650+ firewall rules included, 9 modules with 50+ functions,
random scripts and useful documentation.
- You can choose which rules you want, and apply only those or apply them all with
master script to your firewall.
- All the rules are loaded into Local Group Policy (GPO),
giving you full power over the default Windows firewall.

## Core benefits of this firewall project

1. Unlike firewall rules in control panel, these rules are loaded into GPO firewall
(Local group policy), meaning random programs which install rules as part of their installation
process or system settings changes will have no effect on firewall unless you
explicitly make an exception.

2. Unlike default (built in) Windows firewall rules, these rules are more restrictive such as,
tied to explicit user accounts, rules apply to specific ports,
network interfaces, specific programs, services etc.

3. Unlike default (or your own) rules you will know which rules have no effect or are redundant
due to ie. uninstalled program or a missing Windows service which no longer exists or are
redundant/invalid for what ever other reason.

4. Changing rule attributes such as ports, addresses and similar is much easier since the rules
are in scripts, so you can use editor tools such as CTRL + F or regex to perform bulk operations on
your rules, doing this in Windows firewall GUI is beyond all pain.

5. Default outbound is "block" unless there is a rule to explicitly allow network traffic,
in default Windows firewall this is not possible unless you have rules for every possible
program/service, thanks to this collection of rules setting default outbound to block
requires very little additional work.

## License

This project **"Windows Firewall Ruleset"** is licensed under **MIT** license.

The project maintains **"per file"** license and Copyright notices.

3rd party and sublicensed code is located either inside their own folders or inside folders called
"External" for organizational purposes, each of these folders contains individual licenses.

## Requirements

1. Following x64 operating systems are currently actively tested:
   - Windows 10 Professional
   - Windows 10 Enterprise
   - Windows Server 2019 Standard
2. PowerShell Core 7.0 or Windows PowerShell 5.1
[Download PowerShell](https://github.com/PowerShell/PowerShell)
3. .NET Framework 4.8 (Windows PowerShell only) [Download Net Framework](https://dotnet.microsoft.com/download/dotnet-framework)
4. Git (Optional) [Download Git](https://git-scm.com/downloads)
5. Visual Studio Code (Recommended) [Download VSCode](https://code.visualstudio.com)
6. PowerShell Support for VSCode (Recommended)
[Download extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
7. PSScriptAnalyzer (Recommended) [Download PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)

Requirements details:

- All operating systems 10.0 (Major 10, Minor 0) and up are supported,
but only those editions listed in point 1 are actively tested.\
The list of other untested but supported systems is in [The future](#the-future)
- PowerShell "Core" is not built into Windows, you will need to install it separately (recommended)
or use [Windows PowerShell](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/WindowsPowerShell.md)
which is already installed.
- .NET Framework version 4.8 is required if using Windows PowerShell (Desktop edition)
instead of PowerShell Core
- You might want to have git to check out for updates,
to easily switch between branches or to contribute code.
- VS Code is preferred and recommended editor to navigate project and edit scripts for your
needs or contribution.
- If you get VSCode, you'll also need powershell extension for code navigation and
PowerShell specific features.

## I don't meet the requirements

At the moment this project is tested and designed for most recent Windows Desktop/Servers and that
is known to work, making use of it on older systems requires additional work.

Testing is done on 64 bit Windows, a small fraction of rules won't work for 32 bit system and
need adjustment, full functionality for 32 bit system is work in progress.\
For now you can load rules on 32 bit system just fine with the exception of few rules probably not
relevant at all for your configuration.

[This document](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/LegacySupport.md)
describes how to make use of this project on older Windows systems such as Windows 7 or Windows Server
2008

## First time user

Following are short warnings and notices first time user should be aware of

### Warning

- You might loose internet connectivity for some of your programs or in rare cases even lose internet
connectivity completely, if that happens, you can either temporarily allow outbound network traffic
or run `Scripts\ResetFirewall.ps1` script, to reset GPO firewall to system defaults and remove all rules.
- Inside `Readme` folder there is a `ResetFirewall.md`, a guide on how to do it manually, by hand,
if for some reason you're unable to run the script, or the script doesn't solve your problems.
- Also note that your current/existing rules will not be deleted unless you have rules in GPO whose
group name interfere with group names from this ruleset, however
**this does not apply to** `Scripts\ResetFirewall.ps1` which will clear GPO rules completely
and leave only those in control panel.
- If you want to be 100% sure please export your current GPO rules first, to do so either run
`Scripts\ExportFirewall.ps1` which may take some time or do it manually.\
For manual export see [ManageGPOFirewall.md](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/ManageGPOFirewall.md)
- The scripts will ask you what rules you want, to minimize internet connectivity trouble you should
apply at least all generic networking and OS related rules such as BasicNetworking, ICMP,
WindowsSystem, WindowsServices, Multicast etc. also do not ignore IPv6, Windows does need IPv6!
- Default configuration will set global firewall behavior which is not configurable in GPO GUI,
such as `stateful ftp` and `pptp` or global `IPSec` settings, if you need specific setup please visit
`Scripts\SetupProfile.ps1` and take a look at `Set-NetFirewallSetting`.\
Note that `Scripts\SetupProfile.ps1` is automatically called by `Scripts\SetupFirewall.ps1` script

### Note

- If you would like to modify basic behavior of execution, such as force loading rules and various
default actions then visit `Config\ProjectSettings.ps1` and there you'll find global variables
which are used for this.
- If you're running scripts for the first time it's highly recommended to load all rules for which you
have programs installed on system,
it should be easy to delete what you don't want in GPO, rather than later searching scripts for
what you might have missed.
- Loading rules into an empty GPO should be very fast, however loading into GPO which already
contains rules will be significantly slower (depends on number of existing rules)
- All errors and warnings will be saved to `Logs` directory, so you can review these logs later
if you want to fix some problem.
- Any rule that results in "Access denied" while loading should be reloaded by executing specific
script again.
- If the project was manually downloaded, transferred from another computer or media then you should\
[unblock all files](https://devblogs.microsoft.com/scripting/easily-unblock-all-files-in-a-directory-using-powershell/)
in project first to avoid YES/NO spam questions for every executing script, by running
`Scripts\UnblockProject.ps1` script.\
Master script `Scripts\SetupFirewall.ps1` does this in case if you forget, but initial YES/NO spam questions
will still be visible in that case.
- It's important to understand these rules are designed to be used as "Standard" user, not as
Administrative user, if you're Administrator on your computer you'll have to either create standard
user account and use that for your everyday life or modify rules to allow Administrator online access.
See [FAQ](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/FAQ.md#does-this-firewall-give-me-the-right-protection)
for more information why using Administrative account is dangerous security wise.
- Windows or software updates may rename executables or their locations, also user accounts may be
renamed by Administrator, therefore it's important to reload specific rules from time to time as
needed to update firewall for system changes that may happen at any time.

## Quick start

1. If you don't have ssh keys and other setup required to clone via SSH then either clone with HTTPS
or just download the released zip file by clicking on "Release" here on this site.\
These steps assume you have downloaded a zip file.
2. Extract the archive somewhere, these steps assume you've extracted the zip (project root directory)
into `C:\` root drive directly.
3. Open the extracted folder, right click into an empty space and there is an option to run
PowerShell Core as Administrator
(Assumes you enabled context menu during installation of PowerShell Core) if not open it manually.
4. If you would like to use Windows PowerShell 5.1 instead of PowerShell Core see:\
[How to open Windows PowerShell](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/WindowsPowerShell.md)
5. Type or copy/paste following commands and hit enter for each

    ```powershell
    Get-ExecutionPolicy
    ```

    Remember what the output of the above command is, note that PowerShell Core defaults to `RemoteSigned`
    while Windows PowerShell defaults to `Restricted`

6. Set new execution policy: (Note that `RemoteSigned` will work only if scripts are unblocked)

    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
    ```

7. Now if you don't have PowerShell context menu then move to C root drive by executing following 2
lines, this is where you extracted your downloaded zip file:

    ```powershell
    c:
    cd C:\
    ```

8. cd into downloaded folder, of course rename the command if your extracted folder is called something
else:

    ```powershell
    cd WindowsFirewallRuleset-master
    ```

9. At this point you should "unblock" all project files first by executing the script called `Scripts\UnblockProject.ps1`,
btw. project files were blocked by Windows to prevent users from running untrusted script code
downloaded from internet:

    ```powershell
    .\Scripts\UnblockProject.ps1
    ```

    Make sure your answer is `R` that is `[R] Run once` as many time as needed to run the script

10. Rules for programs such as internet browser, Visual Studio etc. depend on installation variables.\
Most paths are auto-searched and variables are updated, otherwise you get warning and description
on how to fix the problem,
If needed, you can find these installation variables in individual scripts inside `Rules` folder.

11. Back to PowerShell console and type into console:

    ```powershell
    .\Scripts\SetupFirewall.ps1
    ```

    hit enter and you will be prompted what kind of rulesets you want.

12. Follow prompt output, (ex. hit enter to accept default action),
it will take at least 10 minutes of your attention.

13. If you encounter errors or warnings, you have options such as, ignore the errors/warnings
or update script that produced the error and re-run that script once again later.

14. Once execution is done recall execution policy from step 5 and type:
(ie. if it was "RemoteSigned" which is default for PowerShell Core)

    ```powershell
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
    ```

15. Now that rules are applied you might need to adjust some of them in Local Group Policy,
not all the rules are enabled by default and you might want to toggle default Allow/Block behavior for
some rules, rules for programs which don't exist need to be made additionally.

16. Now go ahead and test your internet connection (ex. with browser or some other program),
If you're unable to connect to internet after applying these rules you have several options:

- It is recommended that you reboot system first because some rules might not be active yet
- you can temporarily open outbound firewall in GPO or [Disable firewall](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/DisableFirewall.md)
- you can troubleshoot problems: [Network troubleshooting detailed guide](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/NetworkTroubleshooting.md)
- you can [Reset Firewall to previous state](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/ResetFirewall.md)
- take a look into `Readme` folder for more troubleshooting options and documentation

## Where are my rules

Rules are loaded into local group policy, follow below steps to open local group policy.

1. Press Windows key and type: `secpol.msc`
2. Right click on `secpol.msc` and click `Run as administrator`
3. Expand node: `Windows Defender Firewall with Advanced Security`
4. Expand node: `Windows Defender Firewall with Advanced Security - Local Group Policy Object`
5. Click on either `Inbound` or `Outbound` node to view and manage rules you applied with PowerShell.

For more information about GPO see: [Configure security policy settings](https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/how-to-configure-security-policy-settings)

## Applying individual rulesets

If you want to apply only specific rules there are 2 ways to do this:

1. Execute `Scripts\SetupFirewall.ps1` and chose `Yes` only for rulesets you want, otherwise chose `No`
and hit enter to skip current ruleset.

2. Inside powershell navigate to folder containing the ruleset script you want,
and execute individual PowerShell script.

3. You might want to run `Scripts\SetupProfile.ps1` afterwards to apply default firewall behavior if
it's not set already, or you can do it manually in GPO but with limited power.
"limited power" means `Scripts\SetupProfile.ps1` configures some firewall parameters which can't be
adjusted in firewall GUI.

In all 3 cases the script will delete all of the existing rules that match the rule group (if any),
and load the rules from script
into Local Group Policy.

## Deleting rules

At the moment there are 3 options to delete firewall rules:

1. The easiest way is to select all the rules you want to delete in Local Group Policy,
right click and delete.

2. To delete rules according to file there is a function for this purpose, located in:\
`Modules\Project.Windows.Firewall\Public\Remove-FirewallRules.ps1`\
however you're advised to perform some tests before using it due to it's
experimental state.

1. To revert to your old firewall state (the one in control panel), you will need to delete all the
rules from GPO,\
and set all properties to `"Not configured"` when right clicking on node:\
`Windows Defender Firewall with Advanced Security - Local Group Policy Object`

    Deleting all rules or revetting to previous state can also be done with
    `Scripts\ResetFirewall.ps1` script.

    Note that you will also need to re-import your exported GPO rules if you had them.

## Export/Import rules

If you want to export rules from GPO there are 2 methods available:

1. Export in local group policy by clicking on `Export Policy...` menu, after right clicking on node:\
`Windows Defender Firewall with Advanced Security - Local Group Policy Object`

2. To export using PowerShell run `Scripts\ExportFirewall.ps1` which is much slower process but
unlike method from point 1 you can customize your export in almost any way you want.

If you want to import rules, importing by using GPO is same as for export, and to import with
PowerShell just run `Scripts\ImportFirewall.ps1`

To customize your export/import please take a look into `Modules\Project.Windows.Firewall\Public`,
which is where you'll find description on how to use export\import PowerShell functions.

## Manage loaded rules

There are 2 ways to manage your rules:

1. Using Local Group Policy, this method gives you basic freedom on what you can do with project rules,
such as disabling them or changing some attributes and adding new rules. For more information see
[ManageGPOFirewall.md](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/ManageGPOFirewall.md)
2. Editing PowerShell scripts, this method gives you full control, you can improve the rules,
add new ones or screw them up.

What ever your setup is, you will surely need to perform additional work such as adding more rules
in GPO to allow programs for which rules don't exist, or to reconfigure existing rules.

## Checking for updates

This repository consists of 2 branches, `master` and `develop`, develop (possibly unstable) branch is
the most recent one and is the one where all commits (updates) directly go so it's work in progress,
unlike master branch which is updated from develop branch once in a while and
not before all scripts are fully tested, meaning master brach is stable.

So if you're fine to experiment with development version switch to "develop" branch and try
it out, otherwise if development version produces errors for you switch back to "master".

There are two methods to be up to date with firewall:

1. First method requires you to download scripts, first use the "branch" button here on this site to
switch to either master or develop branch, next use "Code" button and either clone or
download project.

2. Second method is good if you want to do it in powershell console without visiting this site,
you will need [git](https://git-scm.com/downloads), [github account](https://github.com/join),
a [fork](https://guides.github.com/activities/forking) of this repository in your github account and
[SSH key](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)
to check for new updates on daily, weekly or what ever other basis you want,
follow below steps to check for updates once you installed git and cloned your own fork:

- Right click on Start button in Windows
- Click `Windows PowerShell` to open PowerShell
- First navigate to folder where your instance of WindowsFirewallRuleset instance is, for example:
- Type: `dir` to list directories, ```cd SomeDirectoryName``` to move to some directory or
```cd ..``` to go one directory back
- Type: (or copy paste command(s) and hit enter) ```cd WindowsFirewallRuleset```
to move into WindowsFirewallRuleset folder

Following command (SSH) is typed only once for initial setup:

```git remote add upstream git@github.com:metablaster/WindowsFirewallRuleset.git```

Otherwise if you cloned your fork via HTTPS and want HTTPS (no SSH), then:

```git remote add upstream https://github.com/metablaster/WindowsFirewallRuleset.git```

- Following 2 sets of commands are typed each time,
to tell git you want updates from master (stable) branch:
- Type: ```git checkout master```
- Type: ```git fetch upstream```
- Type: ```git merge upstream/master```

- Following commands are to tell git you want updates from develop (possibly unstable) branch
- Type: ```git checkout develop```
- Type: ```git fetch upstream```
- Type: ```git merge upstream/develop```

Of course you can switch from one branch to another with git in powershell as many times as you
want and all files will be auto updated without the need to re-download or re-setup anything.

Keep in mind that you need to save and upload your modification to your fork,
for more info on how to use git see [git documentation](https://git-scm.com/doc)

That's it, your scripts are now up to date, execute them as you desire (or follow steps from
"Quick start" section) to apply changes to your firewall.

## Contributing or suggestions

Below are general notes for requesting to add your rules or ideas about rules to project.\
If you would like to contribute by writing scripts you should read
[CONTRIBUTING.md](https://github.com/metablaster/WindowsFirewallRuleset/blob/develop/CONTRIBUTING.md)
instead.

Feel free to suggest or contribute new rules, or improvements for existing rules or scripts.\
Just make sure you follow below notices:

1. Provide some documentation or official reference for your rules so that it can be easy to verify
that these rules don't contain mistakes, for example, for ICMP rules you would provide a link to
[IANA](https://www.iana.org) with relevant reference document.
2. If you would like to suggest new rules or improving existing ones,
but you can't push an update here, please open new issue here on github and provide details
preferably with documentation.
3. To contribute rules, it is also important that each rule contains good description of it's
purpose, when a user clicks on a rule in firewall GUI he/she wants to see what this rule is about and
easily conclude whether to enable/disable the rule or allow/block the traffic.
4. It is also important that a rule is very specific and not generic, that means specifying protocol,
IP addresses, ports, system user, interface type and other relevant information.\
for example just saying: allow TCP outbound port 80 for any address or any user or no explanation
what is this supposed to allow or block is not acceptable.

## Customization

If you would like to customize project code or add more firewall rules to suit your private or corporate
interests then first step is to set up development environment and learn about project best practices
all of which is explained in [CONTRIBUTING.md](https://github.com/metablaster/WindowsFirewallRuleset/blob/develop/CONTRIBUTING.md)

Depending on your situation and target platform you might also want to read [Legacy Support](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/LegacySupport.md)

These 2 documents are bare minimum to get you started customizing this repository, the rest can be
found in `Readme` folder and by doing your own research.

## More information and help

Inside the [Readme](https://github.com/metablaster/WindowsFirewallRuleset/tree/master/Readme)
folder you will find useful information not only about this project but also general information on
how to troubleshoot firewall and network problems, or gather other relevant information.

It might answer some of your questions, for example
[MonitoringFirewall.md](https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/MonitoringFirewall.md)
explains how to monitor firewall in real time.

## The future

Following features are desired and might be available at some point in the future:

1. Remote firewall administration

   - Applying firewall configuration to remote computers on domain or home networks

2. Comprehensive firewall rulesets for server platforms

3. On demand registry scan to validate integrity of active firewall filtering policy

   - Any firewall rule in the registry that is not part of this repository is reported for review
   - Because, malware, hackers and even trusted software might attempt to bypass firewall at any time

4. Full functionality for the following editions of Windows 10.0+
   - Windows 10 Pro for Workstations
   - Windows 10 Pro Education
   - Windows 10 Education
   - Windows 10 IoT Core Blast
   - Windows 10 IoT Enterprise
   - Windows 10 S
   - Windows Server 2019 Essentials
   - Windows Server 2019 Datacenter
