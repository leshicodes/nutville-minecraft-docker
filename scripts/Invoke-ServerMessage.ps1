[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]
    $dockerContainerName = 'minecraft',
    [Parameter(Mandatory = $true)]
    [string]
    $messageContent
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
    docker exec -it $dockerContainerName rcon-cli "/say $messageContent"
}
END {}