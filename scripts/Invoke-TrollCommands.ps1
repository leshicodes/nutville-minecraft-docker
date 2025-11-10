[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]
    $dockerContainerName = 'minecraft',
    [Parameter(Mandatory = $true)]
    [string]
    $TargetPlayer
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
    if ($TargetPlayer) {
        docker exec -it $dockerContainerName rcon-cli "/tellraw $TargetPlayer {`"text`":`"Herobrine joined the game`",`"color`":`"yellow`"}"
        Start-Sleep -Seconds $(Get-Random -Maximum 400)
        docker exec -it $dockerContainerName rcon-cli "/tellraw $TargetPlayer `"<Herobrine> I'm watching you :)`""
    }
    else {
        docker exec -it $dockerContainerName rcon-cli '/tellraw @a {"text":"Herobrine joined the game","color":"yellow"}'
        Start-Sleep -Seconds $(Get-Random -Maximum 400)
        docker exec -it $dockerContainerName rcon-cli "/tellraw @a `"<Herobrine> I'm watching you :)`""
    }
}
END {}