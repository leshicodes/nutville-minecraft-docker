[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]
    $dockerContainerName = 'minecraft',
    [Parameter(Mandatory = $false)]
    [string]
    $WhitelistAction = 'add',
    [Parameter(Mandatory = $true)]
    [string[]]
    $usernames,
    [Parameter(Mandatory = $false)]
    [ValidateSet('Java', 'Bedrock')]
    [string]
    $PlayerType = 'Java'
)
BEGIN {
    if ($WhitelistAction -ne 'add' -and $WhitelistAction -ne 'remove') {
        Write-Error "Invalid WhitelistAction '$WhitelistAction'. Valid values are 'add' or 'remove'."
        exit 1
    }
    try {
        $dockerContainerInspect = docker inspect $dockerContainerName
    } catch {
        Write-Error "Unable to find container '$dockerContainerName'"
        exit 1
    }
    if ($LASTEXITCODE -eq 1) {
        Write-Error "Unable to find container '$dockerContainerName'"
        exit 1
    }
    $rconCliResponse = @()
    
    # Determine the whitelist command based on player type
    $whitelistCommand = if ($PlayerType -eq 'Bedrock') { 'fwhitelist' } else { 'whitelist' }
}
PROCESS {
    foreach ($username in $usernames) {
        if ($username -match '^[a-zA-Z0-9_]{3,16}$') {
            Write-Host "Processing $PlayerType whitelist action '$WhitelistAction' for user '$username'"
            $rconCliResponse += $(docker exec -it $dockerContainerName rcon-cli "/$whitelistCommand $WhitelistAction $username")
        } else {
            Write-Warning "Invalid username '$username'. Usernames must be 3-16 characters long and can only contain letters, numbers, and underscores."
        }
    }
}
END {
    return $rconCliResponse
}