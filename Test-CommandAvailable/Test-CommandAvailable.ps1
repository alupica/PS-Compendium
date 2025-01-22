using namespace System.Management.Automation

function Test-CommandAvailable {

    [CmdletBinding()]
    [OutputType([Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Command', 'Cmd')]
        [string[]] $Name,

        [ValidateNotNullOrEmpty()]
        [string] $ParameterName
    )

    begin {
        $desktopHost, $coreHost = try {
            'powershell.exe', 'pwsh.exe' | Get-Command -CommandType Application -TotalCount 1 -ErrorAction Stop
        } catch {
            $PSCmdlet.ThrowTerminatingError([ErrorRecord]::new(
                [NotSupportedException]::new('The powershell.exe and pwsh.exe hosts must both be accessible via PATH.', $_.Exception), 
                'RequiredPSHostMissing', 
                [ErrorCategory]::ObjectNotFound,
                $_.TargetObject
            ))    
        }

        [Flags()] enum PSEdition {
            None    
            Desktop
            Core    
        }

        $thisPS, $otherPS = @{ Edition = [PSEdition]::Desktop; Host = $desktopHost }, 
                            @{ Edition = [PSEdition]::Core;    Host = $coreHost }
        if ($PSEdition -ne 'Desktop') { $otherPS, $thisPS = $thisPS, $otherPS }
    }

    process {
        foreach ($command in $Name) {
            $out = [pscustomobject] @{
                Command          = $command
                CommandPSEdition = [PSEdition]::None
                Param            = $null
                ParamPSEdition   = $null
            }
            
            # Passing a script block to the external PS process creates a mini-shell.
            # This enables PS remoting/job-like data marshalling.
            $thisPS['FoundCmds']  = Get-Command -Name $command -ErrorAction Ignore
            $otherPS['FoundCmds'] = & $otherPS['Host'] -NoProfile -Command ([scriptblock]::Create(
                "Get-Command -Name '$command' -ErrorAction Ignore"
            ))

            # Does at least one command of the specified name exist?
            if ($thisPS['FoundCmds'])  { $out.CommandPSEdition += $thisPS['Edition'] }
            if ($otherPS['FoundCmds']) { $out.CommandPSEdition += $otherPS['Edition'] }

            if ($PSBoundParameters.ContainsKey('ParameterName')) {
                $out.Param          = $ParameterName
                $out.ParamPSEdition = [PSEdition]::None
                
                ($thisPS, $otherPS).ForEach{
                    # If the command exists, does the parameter exist?
                    if ($_['FoundCmds'] -and $ParameterName -in $_['FoundCmds'].Parameters.get_Keys()) { 
                        $out.ParamPSEdition += $_['Edition'] 
                    }
                }
            }

            $out
        }
    }
}
