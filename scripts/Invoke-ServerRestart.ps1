[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]
    $dockerContainerName = 'minecraft',
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
    $restartTimerHalf = $restartTimer / 2

    & "$PSScriptRoot/Invoke-ServerMessage.ps1" -messageContent "Server Restarting in $restartTimer seconds..."
    Start-Sleep -Seconds $restartTimerHalf
    & "$PSScriptRoot/Invoke-ServerMessage.ps1" -messageContent "Server Restarting in $restartTimerHalf seconds..."
    Start-Sleep -Seconds $restartTimerHalf
    & "$PSScriptRoot/Invoke-ServerMessage.ps1" -messageContent "Server Restarting in 3..."
    Start-Sleep -Seconds 1
    & "$PSScriptRoot/Invoke-ServerMessage.ps1" -messageContent "Server Restarting in 2..."
    Start-Sleep -Seconds 1
    & "$PSScriptRoot/Invoke-ServerMessage.ps1" -messageContent "Server Restarting in 1..."
    Start-Sleep -Seconds 1

    docker restart $dockerContainerName
}
END {}