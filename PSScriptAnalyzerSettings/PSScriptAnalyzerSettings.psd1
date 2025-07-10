##############################################################################################################################
# PSScriptAnalyzerSettings.psd1 - Settings for PSScriptAnalyzer invocation.
# 7/8/2025 - setting up PS version compatibility intellisense (and other config settings granularly)
# https://devblogs.microsoft.com/powershell/using-psscriptanalyzer-to-check-powershell-version-compatibility/
# PS REFERENCE => https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/rules/readme?view=ps-modules
##############################################################################################################################

@{
    # Only diagnostic records of the specified severity will be generated.
    # Uncomment the following line if you only want Errors and Warnings but, not Information diagnostic records.
    #
    #Severity = @('Error', 'Warning')

    # Analyze **only** the following rules. Use IncludeRules when you want
    # to invoke only a small subset of the default rules.
    #
    # IncludeRules = @(
    #     'PSAvoidDefaultValueSwitchParameter',
    #     'PSMisleadingBacktick',
    #     'PSMissingModuleManifestField',
    #     'PSReservedCmdletChar',
    #     'PSReservedParams',
    #     'PSShouldProcess',
    #     'PSUseApprovedVerbs',
    #     'PSAvoidUsingCmdletAliases',
    #     'PSUseDeclaredVarsMoreThanAssignments'
    # )

    # Do not analyze the following rules. Use ExcludeRules when you have
    # commented out the IncludeRules settings above and want to include all
    # the default rules except for those you exclude below.
    # Note that if a rule is in both IncludeRules and ExcludeRules, the rule will be excluded.
    ExcludeRules = @('PSAvoidTrailingWhitespace', 'PSUseApprovedVerbs', 'PSAvoidUsingWriteHost')
    
    # rule configuration to configure rules that support it:
    Rules = @{
        PSUseCompatibleCommands = @{
            Enable = $true # Turns the rule on

            # Lists the PowerShell platforms we want to check compatibility with
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework', # 5.1 on Windows Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework'   # 5.1 on Windows Server 2019
            )
        }
        
        PSUseCompatibleSyntax   = @{
            # This turns the rule on (setting it to false will turn it off)
            Enable = $true

            # Simply list the targeted versions of PowerShell here
            TargetVersions = @(
                '5.1',
                '7.0',
                '7.2',
                '7.4'
            )
        }

        PSReviewUnusedParameter = @{
            CommandsToTraverse = @(
                'Invoke-Command'
            )
        }
    }
}
