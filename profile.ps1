$script:bg    = [Console]::BackgroundColor;
$script:first = $true;
$script:last  = 0;
Import-Module Posh-Git

$BranchBehindAndAheadStatusForegroundColor = [System.ConsoleColor]::Red
$BranchBehindStatusForegroundColor = [System.ConsoleColor]::Yellow
$BranchAheadStatusForegroundColor = [System.ConsoleColor]::Green
$BranchIdenticalStatusToForegroundColor = [System.ConsoleColor]::White
$workingAdded = '+'
$workingRemoved = '-'
$workingModified = "$([char]0x2260)"
$workingUnmerged = '?'
$BranchUntrackedSymbol = '…'
$BeforeText = ''
$BranchAheadStatusSymbol  = "$([char]0x2191)"
$BranchBehindStatusSymbol = "$([char]0x2193)"
$BranchBehindAndAheadStatusSymbol = "$BranchBehindStatusSymbol$BranchAheadStatusSymbol"
$BranchIdenticalStatusToSymbol = '≡'


function Write-PromptFancyEnd {
    Write-Host "$([char]0xe0b0)" -NoNewline -ForegroundColor $script:bg

    $script:bg = [System.ConsoleColor]::Black
}

function Write-PromptSegment {
    param(
        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        )][string]$Text,

        [Parameter(Position=1)][System.ConsoleColor] $Background = [Console]::BackgroundColor,
        [Parameter(Position=2)][System.ConsoleColor] $Foreground = [System.ConsoleColor]::White,
        [switch]$SameSegment
    )
    if(-not $SameSegment){
        if(!$script:first) {
            Write-Host "$([char]0xe0b0)" -NoNewline -BackgroundColor $Background -ForegroundColor $script:bg
        } else {
            $script:first = $false
        }
    }

    Write-Host $Text -NoNewline -BackgroundColor $Background -ForegroundColor $Foreground

    $script:bg = $background;
}

function Get-FancyDir {
    return $(Get-Location).ToString().Replace($env:USERPROFILE, '~').Replace('\', " $([char]0xe0b1) ");
}

function Write-PromptUser {
    $computerName = $env:COMPUTERNAME.ToLower()
    if($global:admin) {
        Write-PromptSegment " # ADMIN@$computerName "  Magenta White;
    } else {
        Write-PromptSegment " $env:USERNAME@$computerName " Black White;
    }
}

function Write-PromptVirtualEnv {
    if($env:VIRTUAL_ENV) {
        Write-PromptSegment " $(split-path $env:VIRTUAL_ENV -leaf) " Cyan Black
    }
}

function Write-PromptDir {
    Write-PromptSegment " $(Get-FancyDir) " DarkBlue Black
}

# Depends on posh-git
# Depends on posh-git
function Write-PromptGit {
    $Private:Status = Get-GitStatus
    if($Private:Status) {
        $branchStatusSymbol          = $null
        $branchStatusBackgroundColor = [System.ConsoleColor]::DarkGreen
        $branchStatusForegroundColor = [System.ConsoleColor]::Black
        $branchForegroundColor = [System.ConsoleColor]::Black

        if (-not $Private:status.Upstream) {
            $branchStatusSymbol  = $BranchUntrackedSymbol
        } elseif ($Private:status.BehindBy -eq 0 -and $status.AheadBy -eq 0) {
            # We are aligned with remote
            $branchStatusSymbol          = $BranchIdenticalStatusToSymbol
            #$branchStatusBackgroundColor = $BranchIdenticalStatusToBackgroundColor
            $branchStatusForegroundColor = $BranchIdenticalStatusToForegroundColor
        } elseif ($Private:status.BehindBy -ge 1 -and $status.AheadBy -ge 1) {
            # We are both behind and ahead of remote
            $branchStatusSymbol          = $BranchBehindAndAheadStatusSymbol
            #$branchStatusBackgroundColor = $s.BranchBehindAndAheadStatusBackgroundColor
            $branchStatusForegroundColor = $BranchBehindAndAheadStatusForegroundColor
        } elseif ($Private:status.BehindBy -ge 1) {
            # We are behind remote
            $branchStatusSymbol          = $BranchBehindStatusSymbol
            #$branchStatusBackgroundColor = $s.BranchBehindStatusBackgroundColor
            $branchStatusForegroundColor =$BranchBehindStatusForegroundColor 
        } elseif ($Private:status.AheadBy -ge 1) {
            # We are ahead of remote
            $branchStatusSymbol          = $BranchAheadStatusSymbol
            #$branchStatusBackgroundColor = $s.BranchAheadStatusBackgroundColor
            $branchStatusForegroundColor = $BranchAheadStatusForegroundColor
        }

        $working = " "
        if($Private:Status.HasWorking -or $Private:Status.Index.Count -ge 1){
            $branchStatusBackgroundColor = [System.ConsoleColor]::DarkYellow
            $branchStatusForegroundColor = [System.ConsoleColor]::Black

            if($Private:status.Working.Added){
                $working  += "$($workingAdded)"
            }
            if($Private:status.Working.Modified){
                $working  +="$($workingModified )"
            }
            if($Private:status.Working.Removed){
                $working  +="$($workingRemoved)"
            }
            if($Private:status.Working.Unmerged){
                $working  +="$($workingUnmerged)"
            }            
        }

        $BranchStatus = ($BeforeText + $branchStatusSymbol)
        #Write-PromptSegment $BranchStatus $branchStatusBackgroundColor $branchStatusForegroundColor 
        Write-PromptSegment (" $([char]0xe0a0) $($Private:Status.Branch)") $branchStatusBackgroundColor $branchForegroundColor
        Write-PromptSegment $working  $branchStatusBackgroundColor $branchStatusForegroundColor -SameSegment
    }
}

function prompt {
    $script:last  = $?;
    $script:first = $true;

    Write-PromptUser
    Write-PromptVirtualEnv
    Write-PromptDir
    Write-PromptGit

    Write-PromptFancyEnd

    return ' '
}