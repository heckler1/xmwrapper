# XMRig Wrapper to run as Admin. This allows for huge pages support.

# Check for Admin rights, if not Admin, spawn new elevated PowerShell shell
param([switch]$Elevated)

function CheckAdmin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((CheckAdmin) -eq $false) {
    if ($elevated) {
    # could not elevate, quit
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# Pool URL
$XMRPool = "pool.monero.hashvault.pro:5555"
# Pool username, usually XMR wallet recieve address
$XMRUser = ""
# Pool password; for Hash Vault this doubles as your worker ID
$XMRPassword = ""
# CPU threads to use, recommended value is 2MB of L3 cache for every thread
$Threads = 4
# Max usage of the allocated threads, in percent
$MaxCPUUsage = 100
# Donation amout, in percent
$DonateLevel = 1
# Interval that hashrate is printed to console, in seconds
$PrintTime = 30

# Run XMRig
Start-Process -File $PSScriptRoot\xmrig.exe -ArgumentList "--url=$($XMRPool) --user=$($XMRUser) --pass=$($XMRPassword) --threads=$($Threads) --max-cpu-usage=$($MaxCPUUsage) --donate-level=$($DonateLevel) --print-time=$($PrintTime)"

# Close the leftover command window
Stop-Process -Id $PID