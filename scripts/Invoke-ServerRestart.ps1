[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]
    $dockerContainerName = 'minecraft-docker-2024-minecraft-1',
    [Parameter(Mandatory = $false)]
    [string]
    $restartTimer = "120"
)
BEGIN {
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
}
PROCESS {
    & "$PSScriptRoot/Invoke-ServerMessage.ps1" "-messageContent Server Restarting in $restartTimer seconds..."
    # Start-Sleep -Seconds $restartTimer
}
END {}