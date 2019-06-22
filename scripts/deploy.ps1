Param(
    [string]$dist_directory = $ENV:DIST_DIRECTORY,
    [string]$azure_storage_key = $ENV:AZURE_STORAGE_KEY,
    $filePatterns = @("html","xml","css","js","json","css.map","js.map","jpg","JPG","png","jpeg","ico","svg","woff","woff2","otf","ttf","eot")
)

Write-host "Removing Files"
az storage blob delete-batch --source `$web --account-name $ENV:AZURE_STORAGE_ACCOUNT --account-key $azure_storage_key --pattern "*.*"
function azblobupload {
    Param(
    [string[]]$uploadArguments = @(),
    [string]$pattern = "*.*"
    )
    [string[]]$defaultArguments = @("storage","blob","upload-batch","--destination `$web","--account-name $ENV:AZURE_STORAGE_ACCOUNT","--account-key $azure_storage_key","--source $ENV:DIST_DIRECTORY","--pattern `"$pattern`"","--no-progress")
    [string[]]$FormattedArguments = $defaultArguments+$uploadArguments
    Start-Process -FilePath "az" -Wait -NoNewWindow -ArgumentList $FormattedArguments
}
foreach ($filePattern in $filePatterns) {
switch ($filePattern) {
"html" {   
Write-Host "Deploying HTML Files "
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-encoding `"gzip`"","--content-type `"text/html`"","--content-cache-control `"no-cache,Etag`"")
break
 }
"xml" {
Write-Host "Deploying XML Files "
azblobupload -pattern "*.$filePattern"
break
}
"txt" {
Write-Host "Deploying Text Files " 
azblobupload -pattern "*.$filePattern"
break
} 
"json" {    
Write-Host "Deploying JSON Files "
azblobupload -pattern "*.$filePattern"
break
}  
"css" {
    
Write-Host "Deploying CSS Files "
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-encoding `"gzip`"","--content-type `"text/css`"","--content-cache-control `"public,max-age=31536000`"")
}
"css.map" {
    
Write-Host "Deploying CSS Map Files "
azblobupload -pattern "*.$filePattern"
break
}
"js" {
Write-Host "Deploying javascript Files "
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-encoding `"gzip`"","--content-type `"application/javascript`"","--content-cache-control `"public,max-age=31536000`"")
break
} 
"js.map" {
Write-Host "Deploying Javascript Map Files "
azblobupload -pattern "*.$filePattern"
break
}
"jpg" {

Write-Host "Deploying Image (jpg) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"ico" {
    
Write-Host "Deploying Image (ico) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"png" {
    
Write-Host "Deploying Image (png) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}  
"jpeg" {
    
Write-Host "Deploying Image (jpeg) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
} 
"JPG" {
    
Write-Host "Deploying Image (JPG) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"JPG" {
    
Write-Host "Deploying Image (JPG) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"svg" {
    
Write-Host "Deploying Icon/Font/Image (SVG) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}     
"otf" {

Write-Host "Deploying Font (otf) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"woff" {
Write-Host "Deploying Font (woff) Files "          
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}  
"woff2" {        
Write-Host "Deploying Font (woff2) Files"
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"ttf" {
Write-Host "Deploying Font (ttf) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
"eot" {
Write-Host "Deploying Font (eot) Files "                     
azblobupload -pattern "*.$filePattern" -uploadArguments @("--content-cache-control `"public,max-age=31536000`"")
break
}
default {
break
}
}
}
