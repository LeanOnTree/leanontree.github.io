Param(
    [string]$dist_directory = $ENV:DIST_DIRECTORY,
    [string]$azure_blob_url = $ENV:AZURE_BLOB_URL,
    [string]$sas_token = $ENV:SAS_TOKEN,
    [string]$scripts_directory = $ENV:SCRIPTS_DIRECTORY
    
)
Write-host "Downloading Azure Copy"
Invoke-WebRequest https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -OutFile $scripts_directory\azcopyv10.zip
Expand-Archive $scripts_directory\azcopyv10.zip -DestinationPath $scripts_directory\azcopyv10
Set-Location $scripts_directory\azcopyv10\**

Write-host "Remove Files"
.\azcopy rm "$azure_blob_url/`$web/$sas_token" --recursive=true

Write-Host "Deploying HTML Files"
.\azcopy cp "$dist_directory\*.html" "$azure_blob_url/`$web/$sas_token" --recursive=true --content-encoding "gzip" --content-type "text/html" --cache-control "no-cache,Etag"

Write-Host "Deploying CSS Files"
.\azcopy cp "$dist_directory\css\*.css" "$azure_blob_url/`$web/css/$sas_token" --recursive=true --content-encoding "gzip" --content-type "text/css" --cache-control "public,max-age=31536000"

<#Write-Host "Deploying CSS Map Files"
& azcopy sync "$dist_directory" "$azure_blob_url/`$web/$sas_token" --include="*.css.map;"
#>
Write-Host "Deploying JavaScript Files"
.\azcopy cp "$dist_directory\js\*.js" "$azure_blob_url/`$web/js/$sas_token" --recursive=true --content-encoding "gzip" --content-type "application/javascript" --cache-control "public,max-age=31536000"

Write-Host "Deploying JavaScript Files"
.\azcopy cp "$dist_directory\*.js" "$azure_blob_url/`$web/$sas_token" --recursive=true --content-encoding "gzip" --content-type "application/javascript" --cache-control "public,max-age=31536000"

Write-Host "Deploying CSS Map Files"
.\azcopy copy "$dist_directory\js\*.js.map" "$azure_blob_url/`$web/js/$sas_token"  --recursive=true

<#Write-Host "Deploying Image Files(jpg)"
& azcopy cp "$dist_directory\**\*.jpg" "$azure_blob_url/`$web/$sas_token" --recursive=true --cache-control "public,max-age=31536000"

Write-Host "Deploying Image Files(JPG)"
& azcopy cp "$dist_directory\**\*.JPG" "$azure_blob_url/`$web/$sas_token" --recursive=true --cache-control "public,max-age=31536000"

Write-Host "Deploying Image Files(jpeg)"
& azcopy cp "$dist_directory\**\*.jpeg" "$azure_blob_url/`$web/$sas_token" --recursive=true --cache-control "public,max-age=31536000"
#>
Write-Host "Deploying Image Files(ico)"
.\azcopy cp "$dist_directory\*.ico" "$azure_blob_url/`$web/$sas_token" --recursive=true --cache-control "public,max-age=31536000"

Write-Host "Deploying Image Files(png)"
.\azcopy cp "$dist_directory\img\icons\*.png" "$azure_blob_url/`$web/img/icons/$sas_token" --recursive=true --cache-control "public,max-age=31536000"

Write-Host "Deploying Image/font Files(svg)"
.\azcopy cp "$dist_directory\img\icons\*.svg" "$azure_blob_url/`$web/img/icons/$sas_token" --recursive=true --cache-control "public,max-age=31536000"

Write-Host "Deploying config Files(JSON)"
.\azcopy cp "$dist_directory\*.json" "$azure_blob_url/`$web/$sas_token" --recursive=true

Write-Host "Deploying config Files(TxT)"
.\azcopy cp "$dist_directory\*.txt" "$azure_blob_url/`$web/$sas_token" --recursive=true

<#Write-Host "Deploying config Files(XML)"
& azcopy cp "$dist_directory\**\*.xml" "$azure_blob_url/`$web/$sas_token" --recursive=true
#>