param (
    [string] $organisation,
    [string] $personalAccessToken
)

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$result = Invoke-RestMethod -Uri "https://dev.azure.com/$organisation/_apis/projects?api-version=6.0" -Method Get -Headers $headers

$projectNames = $result.value.name

$projectNames | ForEach-Object {
    $project = $_

    $result = Invoke-RestMethod -Uri "https://dev.azure.com/$organisation/$project/_apis/git/repositories?api-version=6.0" -Method Get -Headers $headers

    $result.value
} | Sort-Object