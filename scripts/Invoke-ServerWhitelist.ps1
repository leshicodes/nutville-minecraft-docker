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
    $usernames
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
}
PROCESS {
    foreach ($username in $usernames) {
        if ($username -match '^[a-zA-Z0-9_]{3,16}$') {
            $messageContent = $username
            Write-Host "Processing whitelist action '$WhitelistAction' for user '$username'"
            $rconCliResponse += $(docker exec -it $dockerContainerName rcon-cli "/whitelist $WhitelistAction $messageContent")
        } else {
            Write-Warning "Invalid username '$username'. Usernames must be 3-16 characters long and can only contain letters, numbers, and underscores."
        }
    }
}
END {
    return $rconCliResponse
}