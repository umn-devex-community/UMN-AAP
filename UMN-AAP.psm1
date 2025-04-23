######## Base Functions

#region Get-AapToken -instance $instance
function Get-AapToken
{
  [CmdletBinding()]
  Param
  (
    [string]$instance
  )
  
  # URL to Azure Function to get token
  $funct_uri = 'https://devex.azurewebsites.net/api/Tower_Token?code='
  # The access key for the function is provided as ENV variable by the function
  $fuction_key = $env:devex_function_key
  $body = @{instance = $instance} | ConvertTo-Json
  return  Invoke-RestMethod -Uri ($funct_uri+$fuction_key) -UseBasicParsing -Method Post -Body $body -ContentType "application/json"
}
#endregion

#region Get-AapHeader -instance $instance -tower_access_token $tower_access_token
# The Tower header contians short term creds to access Tower API
function Get-AapHeader
{
  [CmdletBinding()]
  Param
  (
    [string]$instance,

    [string]$tower_access_token
  )
  
  if ($null -eq $tower_access_token -or $tower_access_token -eq ''){$tower_access_token = Get-AapToken -instance $instance}
  
  return @{Authorization = "Bearer $tower_access_token"}

}
#endregion

#region Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
function Get-AapBaseCall
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$uri
  )

  $results = $null
  do
  {
    if (-not $results){$uri = $uri}
    else {$uri = $fqdn+$($return.next)}
    $return = Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -ContentType 'application/json'
    $results += ($return).results    
  } while ($return.next)
  
  return $results
}
#endregion

############## ADD Functions

#region Add-AapAzureSocialAuthTeamMap  -header $header -fqdn $fqdn -map $map
function Add-AapAzureSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [hashtable]$map
  )

  $body = @{SOCIAL_AUTH_AZUREAD_OAUTH2_TEAM_MAP = $map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/azuread-oauth2/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion

#region Add-AapCredential -header $header -fqdn $fqdn -body $body
function Add-AapCredential
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/credentials/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapCredentialInputSource -header $header -fqdn $fqdn -body $body
# Link secrets from a KeyVault to a Credential
function Add-AapCredentialInputSource
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/credential_input_sources/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapCredentialTypes -header $header -fqdn $fqdn -body $body
function Add-AapCredentialTypes
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/credential_types/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapInventory -header $header -fqdn $fqdn -body $body
function Add-AapInventory
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/inventories/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapInventoryHost -header $header -fqdn $fqdn -inventory $inventory.id -hostname $hostname
function Add-AapInventoryHost
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$inventory,

    [Parameter(Mandatory)]
    [string]$hostname
  )

  $uri = "$fqdn/api/controller/v2/inventories/$($inventory)/hosts/"
  $body = @{
    name = $hostname
    inventory = $inventory
  } | ConvertTo-Json
  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapInventorySource -header $header -fqdn $fqdn -body $body
function Add-AapInventorySource
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/inventory_sources/"
  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapNotificationTemplates -header $header -fqdn $fqdn -body $body
function Add-AapNotificationTemplates
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/notification_templates/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapOrg -header $header -fqdn $fqdn -org $org
function Add-AapOrg
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$org = $null
  )

  $uri = "$fqdn/api/controller/v2/organizations/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body (@{name=$org}| ConvertTo-Json) -UseBasicParsing -ContentType 'application/json')
}
#endregion


#region Add-AapRole -header $header -fqdn $fqdn -role $role -team $team -user $user
function Add-AapRole
{
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [int32]$role,

    [Parameter(Mandatory,ParameterSetName='team')]
    [string]$team,

    [Parameter(Mandatory,ParameterSetName='user')]
    [string]$user
  )

  switch ($PSCmdlet.ParameterSetName)
  {
    'team' { $uri  = "$fqdn/api/controller/v2/teams/$team/roles/" }
    'user' { $uri  = "$fqdn/api/controller/v2/users/$user/roles/" }
  }

  $body = @{id=$role} | ConvertTo-Json
  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapTeam -header $header -fqdn $fqdn -team $team -org $org
function Add-AapTeam
{
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$team,

    [Parameter(Mandatory)]
    [string]$org
  )

  $uri = "$fqdn/api/controller/v2/teams/"
  $body = @{
    name          = $team
    organization  = $org
  } | ConvertTo-Json

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapUserToAllGlobalSocialAuthTeamMap  -header $header -fqdn $fqdn -email $email -user_map $user_map
function Add-AapUserToAllGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$email,

    [Parameter(Mandatory)]
    [hashtable]$user_map
  )

  foreach ($team_name in $user_map.keys)
  {
    $user_map[$team_name].users += @($email)
  }  
  $body = @{SOCIAL_AUTH_TEAM_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/authentication/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion

#region Add-AapTeamToGlobalSocialAuthTeamMap  -header $header -fqdn $fqdn -user_map $user_map -team_name $team_name -org_name $org_name
function Add-AapTeamToGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$team_name,

    [Parameter(Mandatory)]
    [string]$org_name,

    [Parameter(Mandatory)]
    [hashtable]$user_map
  )

  # if team already exists .. cool.
  if ($user_map.Keys -contains $team_name){return $true}
  $user_map[$team_name] = @{
    organization = $org_name
    remove       = $true
    users        = @()
  }
  $body = @{SOCIAL_AUTH_TEAM_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/authentication/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion

#region Add-AapUserToGlobalSocialAuthTeamMap  -header $header -fqdn $fqdn -email $email -user_map $user_map -team_name $team_name
function Add-AapUserToGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$email,

    [Parameter(Mandatory)]
    [string]$team_name,

    [Parameter(Mandatory)]
    [hashtable]$user_map
  )

  # Validate user not already in there
  if ($user_map[$team_name].users -contains $email){return $true}
  # validate Unit exists
  if ($user_map.keys -notcontains $team_name){throw "$team_name not in map"}
  $user_map[$team_name].users += @($email)
  $body = @{SOCIAL_AUTH_TEAM_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/authentication/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion


#region Add-AapJobTemplate -header $header -fqdn $fqdn -body $body
function Add-AapJobTemplate
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/job_templates/"
  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapJobTemplateCredential -header $header -fqdn $fqdn -template_id $template_id -credential_id $cred_id
function Add-AapJobTemplateCredential
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$template_id,

    [Parameter(Mandatory)]
    [int]$credential_id
  )

  $uri = "$fqdn/api/controller/v2/job_templates/$template_id/credentials/"
  $body = @{id=$credential_id} | ConvertTo-Json
  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapJobTemplateNotifications -header $header -fqdn $fqdn -template_id $template_id -notification_id $notification_id -status $status
function Add-AapJobTemplateNotifications
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [int]$notification_id,

    [Parameter(Mandatory)]
    [string]$template_id,

    [Parameter(Mandatory)]
    [ValidateSet("started", "success", "error")]
    [string]$status
  )

  $uri = "$fqdn/api/controller/v2/job_templates/$template_id/notification_templates_$status/"
  $body = @{id = $notification_id} | ConvertTo-Json
  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

#region Add-AapJobTemplateSurvey -header $header -fqdn $fqdn -template_id $template_id -path $path
  # if you used Get-AapJobTemplates to get the template, then the path is $template.related.survey_spec
  function Add-AapJobTemplateSurvey
  {
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn,

      [Parameter(Mandatory,ParameterSetName='path')]
      [string]$path,

      [Parameter(Mandatory,ParameterSetName='template_id')]
      [string]$template_id,

      [Parameter(Mandatory)]
      [array]$spec
    )

    switch ($PSCmdlet.ParameterSetName) {
      'path'        {$uri = $fqdn + $path}
      'template_id' {$uri = $fqdn + "/api/controller/v2/job_templates/$template_id/survey_spec/"}
    }
    $body = @{
      spec        = $spec
      name        = ""
      description = ""
    } | ConvertTo-Json
    return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
  }
#endregion

#region Add-AapProject -header $header -fqdn $fqdn -body $body
function Add-AapProject
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$body
  )

  $uri = "$fqdn/api/controller/v2/projects/"

  return (Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $body -UseBasicParsing -ContentType 'application/json')
}
#endregion

############## GET Functions

#region Get-AapGlobalSocialAuthTeamMap -header $header -fqdn $fqdn
function Get-AapGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn
  )
  
  $uri = "$fqdn/api/controller/v2/settings/authentication/"
  $map = (Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -ContentType 'application/json').SOCIAL_AUTH_TEAM_MAP
  # convert psobject to a more useful hashtable
  $user_map = @{}
  foreach( $property in $map.psobject.properties.name ){$user_map[$property] = $map.$property}
  return $user_map
}
#endregion

#region Get-AapHosts -header $header -fqdn $fqdn -inventory $inventory -id $id -name $name
  function Get-AapHosts
  {
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn,

      [string]$id,

      [Int32]$inventory,

      [string]$name
    )
    
    $uri = "$fqdn/api/controller/v2/hosts/"
    if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
    else {
      if ($inventory){
        uri += "?inventory=$inventory"
        $other = $true
      }
      if ($name)
      {
        if ($other){$uri += "&name=$name"}
        else{$uri += "?name=$name"}
        $other = $true
      }
    }
    return (Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri)
  }
#endregion

#region Get-AapHostMetrics -header $header -fqdn $fqdn
  # Host Metrics at specific at the moment this is called
  function Get-AapHostMetrics
  {
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn
    )
    
    $uri = "$fqdn/api/controller/v2/host_metrics/"
    return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
  }
#endregion

#region Get-AapHostMetricsSummaryMonthly -header $header -fqdn $fqdn
  # Host Metrics summary for the month
  function Get-AapHostMetricsSummaryMonthly
  {
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn
    )
    
    $uri = "$fqdn/api/controller/v2/host_metric_summary_monthly/"
    return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
  }
#endregion

#region Get-AapInventories -header $header -fqdn $fqdn -org $org -name $name -id $id
function Get-AapInventories
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$org = $null,

    [string]$name = $null,

    [string]$id = $null
  )

  $uri = "$fqdn/api/controller/v2/inventories/"
  if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
  else {
    if ($org){
      $uri += "?organization=$org"
      $other = $true
    }
    if ($name)
    {
      if ($other){$uri += "&name=$name"}
      else{$uri += "?name=$name"}
      $other = $true
    }
  }
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
}
#endregion

#region Get-AapInventoriesSources -header $header -fqdn $fqdn -org_id $org -name $name -id $id
function Get-AapInventorySources
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$org = $null,

    [string]$name = $null,

    [string]$id = $null
  )

  $uri = "$fqdn/api/controller/v2/inventory_sources/"
  if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
  else {
    if ($org){
      $uri += "?organization=$org"
      $other = $true
    }
    if ($name)
    {
      if ($other){$uri += "&name=$name"}
      else{$uri += "?name=$name"}
      $other = $true
    }
  }
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
}
#endregion

#region Get-AapMetrics -header $header -fqdn $fqdn
  # sytem level metrics THIS APPEARS TO BE BROKEN
  function Get-AapMetrics
  {
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn
    )
    
    $uri = "$fqdn/api/controller/v2/metrics/"
    return Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -ContentType 'application/json'
  }
#endregion

#region Get-AapNotificationTemplates -header $header -fqdn $fqdn -org $org -name $name -id $id
function Get-AapNotificationTemplates
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$org = $null,

    [string]$name = $null,

    [string]$id = $null
  )

  $uri = "$fqdn/api/controller/v2/notification_templates/"
  if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
  else {
    if ($org){
      $uri += "?organization=$org"
      $other = $true
    }
    if ($name)
    {
      if ($other){$uri += "&name=$name"}
      else{$uri += "?name=$name"}
      $other = $true
    }
  }
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
}
#endregion

#region Get-AapOrgRoles -header $header -fqdn $fqdn -org $org
function Get-AapOrgRoles
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$org
  )

  return (Get-AapOrg -header $header -fqdn $fqdn -org $org).summary_fields.object_roles
}
#endregion

#region Get-AapTeams -header $header -fqdn $fqdn -team $team -org $org -name $name
  function Get-AapTeams
  {
    [CmdletBinding()]
    Param
    (
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn,

      [string]$team,

      [string]$org,

      [string]$name
    )
    
    $uri = "$fqdn/api/controller/v2/teams/"
    if ($team){return Invoke-RestMethod -Uri ($uri+"$team/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
    else
    {
      if ($org){
        $uri += "?organization=$org"
        $other = $true
      }
      if ($name)
      {
        if ($other){$uri += "&name=$name"}
        else{$uri += "?name=$name"}
        $other = $true
      }
    }
    return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
  }
#endregion

#region Get-AapAllOrgs -header $header -fqdn $fqdn
function Get-AapAllOrgs
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn
  )

  $uri = "$fqdn/api/controller/v2/organizations/"
  $orgs = Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
  
  return ($orgs | Select-Object id,name)
}
#endregion

#region Get-AapCredentials -header $header -fqdn $fqdn -credential_type $credential_type -org $org -id $id
function Get-AapCredentials
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$id,

    [string]$name,

    # Filter by credential_type ID/Number NOT name
    [string]$credential_type = $null,

    # Filter by ORG ID, NOT name
    [string] $org = $null
  )
  $uri = "$fqdn/api/controller/v2/credentials/"
  
  if ($id)
  {
    $uri += "$id/"
    return Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -ContentType 'application/json'
  }
  else
  {
    if ($org){
      $uri += "?organization=$org"
      $other = $true
    }
    if ($credential_type)
    {
      if ($other){$uri += "&credential_type=$credential_type"}
      else{$uri += "?credential_type=$credential_type"}
      $other = $true
    }
    if ($name)
    {
      if ($other){$uri += "&name=$name"}
      else{$uri += "?name=$name"}
      $other = $true
    }
  }
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
}
#endregion

#region Get-AapCredentialTypes -header $header -fqdn $fqdn
function Get-AapCredentialTypes
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$id,

    [string]$name
  )

  $uri = "$fqdn/api/controller/v2/credential_types/"
  if ($id){
    $uri += "$id/"
    return Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -ContentType 'application/json'
  }
  else {
    if ($name)
    {
      $uri += "?name=$name"
      $other = $true
    }
  }
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri

}
#endregion

#region Get-AapJobTemplates -header $header -fqdn $fqdn -org $org -name $name -id $id
function Get-AapJobTemplates
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$org = $null,

    [string]$name = $null,

    [string]$id = $null
  )

  $uri = "$fqdn/api/controller/v2/job_templates/"
  if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
  else {
    if ($org){
      $uri += "?organization=$org"
      $other = $true
    }
    if ($name)
    {
      if ($other){$uri += "&name=$name"}
      else{$uri += "?name=$name"}
      $other = $true
    }
  }
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
}
#endregion

#region Get-AapJobTemplateNotifications -header $header -fqdn $fqdn -template_id $id
function Get-AapJobTemplateNotifications
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$template_id
  )

  # Get the template info 
  $template = Get-AapJobTemplates -header $header -fqdn $fqdn -id $template_id
  $notifications = @{}
  # Start
  $notifications['started'] = Get-AapBaseCall -header $header -fqdn $fqdn -uri ($fqdn +$template.related.notification_templates_started)
  # Finish/success
  $notifications['success'] = Get-AapBaseCall -header $header -fqdn $fqdn -uri ($fqdn + $template.related.notification_templates_success)
  # Error/Failed
  $notifications['error'] = Get-AapBaseCall -header $header -fqdn $fqdn -uri ($fqdn + $template.related.notification_templates_error)
  
  return $notifications
}
#endregion

#region Get-AapJobTemplateSurvey -header $header -fqdn $fqdn -path $path
  # Use $template = Get-AapJobTemplates [switches here] to get the template, then the path is $template.related.survey_spec
  function Get-AapJobTemplateSurvey
  {
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn,

      [Parameter(Mandatory)]
      [string]$path
    )

    return (Invoke-RestMethod -Uri ($fqdn+$path) -Headers $header_src -UseBasicParsing -ContentType 'application/json').spec
  }
#endregion

#region Get-AapOrg -header $header -fqdn $fqdn -org $org -org_name $org_name
function Get-AapOrg
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory,ParameterSetName='id')]
    [string]$org,

    [Parameter(Mandatory,ParameterSetName='name')]
    [string]$org_name
  )

  $uri = "$fqdn/api/controller/v2/organizations/"
  switch ($PSCmdlet.ParameterSetName) {
    'id'    {return Invoke-RestMethod -Uri ($uri+"$org/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
    'name'  {return (Invoke-RestMethod -Uri ($uri+"?name=$org_name") -Headers $header -UseBasicParsing -ContentType 'application/json').results}
  }
}
#endregion

#region Get-AapProjects -header $header -fqdn $fqdn -org $org -name $name -id $id
function Get-AapProjects
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [string]$org = $null,

    [string]$name = $null,

    [string]$id = $null
  )

  $uri = "$fqdn/api/controller/v2/projects/"
  if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
  if ($name){$uri += "?name=$name"}
  elseif ($org){$uri += "?organization=$org"}
  return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
}
#endregion

#region Get-AapUser -header $header -fqdn $fqdn -email $email
function Get-AapUser
{
  [CmdletBinding()]
  Param(

    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$email
  )
  $uri = "$fqdn/api/controller/v2/users/?search=$email"
  $user_info = (Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -ContentType 'application/json').results
  if ($user_info.Length -eq 0 -OR $null -eq $user_info){throw "Unable to find $email"}
  if ($user_info.email -ne $email){throw "User $email mismatch  $($user_info.email)"}
  return $user_info
}
#endregion

#region Get-AapWorkflows -header $header -fqdn $fqdn -org $org -name $name -id $id
  # Names are not globally unique so consider using org with name
  function Get-AapWorkflows
  {
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn,

      [string]$org = $null,

      [string]$name = $null,

      [string]$id = $null
    )

    $uri = "$fqdn/api/v2/workflow_job_templates/"
    if ($id){return Invoke-RestMethod -Uri ($uri+"$id/") -Headers $header -UseBasicParsing -ContentType 'application/json'}
    else {
      if ($org){
        $uri += "?organization=$org"
        $other = $true
      }
      if ($name)
      {
        if ($other){$uri += "&name=$name"}
        else{$uri += "?name=$name"}
        $other = $true
      }
    }
    return Get-AapBaseCall -header $header -fqdn $fqdn -uri $uri
  }
#endregion

#region Get-AapWorkflowNodes -header $header -fqdn $fqdn -path $path
  # Use $template = Get-AapJobTemplates [switches here] to get the template, then the path is $template.related.workflow_nodes
  function Get-AapWorkflowNodes
  {
    [CmdletBinding()]
    Param(
      [Parameter(Mandatory)]
      [Hashtable]$header,

      [Parameter(Mandatory)]
      [string]$fqdn,

      [Parameter(Mandatory)]
      [string]$path
    )

    return (Invoke-RestMethod -Uri ($fqdn+$path) -Headers $header_src -UseBasicParsing -ContentType 'application/json').results
  }
#endregion
####### Remove Functions ######################################

#region Remove-AapTeamFromGlobalSocialAuthTeamMap  -header $header -fqdn $fqdn -user_map $user_map -team_name $team_name
function Remove-AapTeamFromGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$team_name,

    [Parameter(Mandatory)]
    [hashtable]$user_map
  )

  # remove team
  $user_map.Remove($team_name)
  $body = @{SOCIAL_AUTH_TEAM_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/authentication/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion

#region Remove-AapUserFromGlobalSocialAuthTeamMap  -header $header -fqdn $fqdn -email $email -user_map $user_map -team_name $team_name
function Remove-AapUserFromGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$email,

    [Parameter(Mandatory)]
    [string]$team_name,

    [Parameter(Mandatory)]
    [hashtable]$user_map
  )

  # Validate user not already in there
  if ($user_map[$team_name].users -notcontains $email){throw "$email not in $team_name"}
  # validate Unit exists
  if ($user_map.keys -notcontains $team_name){throw "$team_name not in map"}
  $user_map[$team_name].users = $user_map[$team_name].users | Where-Object {$_ -ne $email}
  $body = @{SOCIAL_AUTH_TEAM_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/authentication/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion

#region Remove-AapUserFromAllGlobalSocialAuthTeamMap  -header $header -fqdn $fqdn -email $email -user_map $user_map
function Remove-AapUserFromAllGlobalSocialAuthTeamMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [Hashtable]$header,

    [Parameter(Mandatory)]
    [string]$fqdn,

    [Parameter(Mandatory)]
    [string]$email,

    [Parameter(Mandatory)]
    [hashtable]$user_map
  )

  foreach ($team_name in $user_map.keys)
  {
    $user_map[$team_name].users = $user_map[$team_name].users | Where-Object {$_ -ne $email}
  }  
  $body = @{SOCIAL_AUTH_TEAM_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$fqdn/api/controller/v2/settings/authentication/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  return $true
}
#endregion

####### OLDER functions

#
function Add-AapUserToAzureAdOrgMap
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [string]$email,

    [Parameter(Mandatory)]
    [string]$unit,

    [Parameter(Mandatory)]
    [hashtable]$user_map,

    [Parameter(Mandatory)]
    [string]$basepath,

    [Parameter(Mandatory)]
    [Collections.Hashtable]$header
  )

  # Validate user not already in there
  if ($user_map[$unit].admins -contains $email){$msg = "$email already in unit: $unit";return $msg}
  # validate Unit exists
  if ($user_map.keys -notcontains $unit){$user_map[$unit] = @{admins = @();users = "false"}}
  $user_map[$unit].admins += @($email)
  $body = @{SOCIAL_AUTH_AZUREAD_OAUTH2_ORGANIZATION_MAP = $user_map} | ConvertTo-Json -Depth 5
  $null = Invoke-RestMethod -Uri "$basepath/settings/azuread-oauth2/" -Method Patch -Body $body -Headers $header -UseBasicParsing -ContentType 'application/json'
  $msg = "Added $email to $unit"
  Write-Host $msg
  return $msg
}
#

