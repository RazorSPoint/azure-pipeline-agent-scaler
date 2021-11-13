[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $OrgName,
    [Parameter(Mandatory = $true)]
    [string]
    $PAT,
    [Parameter(Mandatory = $true)]
    [string]
    $PoolName
)

if ((Get-Module -ListAvailable -Name VSTeam) -eq $null) {
    $null = Install-Module VSTeam -Force -Scope CurrentUser -AllowClobber
}

$null = Import-Module VSTeam

$null = Set-VSTeamAccount -Account $OrgName -PersonalAccessToken $PAT

$pool = Get-VSTeamPool | Where-Object {$_.Name -eq $PoolName}

if ($null -ne $pool) {
    return $pool
}else {
    return Add-VSTeamPool -Name $PoolName -Description "POC Pool for Container App self-hosted Agents with KEDA autoscaler"
}
