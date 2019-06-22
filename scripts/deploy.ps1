Param(
    [string]$dist_directory = $ENV:DIST_DIRECTORY,
    [string]$azure_blob_url = $ENV:AZURE_BLOB_URL,
    [string]$sas_token = $ENV:SAS_TOKEN,
    [string]$scripts_directory = $ENV:SCRIPTS_DIRECTORY,
    $filePatterns=@("html","xml","css","js","json","css.map","js.map","jpg","JPG","png","jpeg","ico","svg","woff","woff2","otf","ttf","eot")
)
$scripts_directory = Get-Location
$current_directory = Get-Location
$file = $null
$directory = $null
Write-host "Downloading Azure Copy"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -UseBasicParsing -OutFile $scripts_directory\azcopyv10.zip
Expand-Archive $scripts_directory\azcopyv10.zip -DestinationPath $scripts_directory\azcopyv10 -Force
Set-Location $scripts_directory\azcopyv10\**

Write-host "Removing Files"
.\azcopy rm "$azure_blob_url/`$web/$sas_token" --recursive=true --log-level "ERROR"


function azcopyBasicCommand {
    Param(
    [string[]]$copyArguments = $null
    )
    [string[]]$defaultArguments = @("`"cp`"","`"$script:dist_directory$script:file`"","`"$script:azure_blob_url/`$web$script:directory/$script:sas_token`"","--log-level ERROR")
    [string[]]$FormattedArguments = $defaultArguments+$copyArguments
    Start-Process -FilePath ".\azcopy.exe" -Wait -NoNewWindow -ArgumentList $FormattedArguments
}
function determineFileAndDirectory($item) {
    $script:file = $item.fullname.substring($dist_directory.Length)
    $script:directory = $item.DirectoryName.substring($dist_directory.Length)
}
foreach ($filePattern in $filePatterns) {
    $childItems = Get-ChildItem -Path $dist_directory -Include "*.$filePattern" -Recurse
    if($childItems) {
        foreach($item in $childItems) {
            switch ($filePattern) {
                "html" {
   determineFileAndDirectory($item)
   Write-Host "Deploying HTML Files $script:file"
   azcopyBasicCommand -copyArguments @("--content-encoding `"gzip`"","--content-type `"text/html`"","--cache-control `"no-cache,Etag`"")
break
 }
 "xml" {
    determineFileAndDirectory($item)
Write-Host "Deploying XML Files $script:file"
azcopyBasicCommand
break
}
"txt" {
    determineFileAndDirectory($item)
Write-Host "Deploying Text Files $script:file" 
azcopyBasicCommand
break
} 
"json" {
    determineFileAndDirectory($item)
Write-Host "Deploying JSON Files $script:file"
azcopyBasicCommand
break
}  
"css" {
    determineFileAndDirectory($item)
Write-Host "Deploying CSS Files $script:file"
azcopyBasicCommand -copyArguments @("--content-encoding `"gzip`"","--content-type `"text/css`"","--cache-control `"public,max-age=31536000`"")
}
"css.map" {
    determineFileAndDirectory($item)
Write-Host "Deploying CSS Map Files $script:file"
azcopyBasicCommand
break
}
"js" {
    determineFileAndDirectory($item)
Write-Host "Deploying javascript Files $script:file"                     
azcopyBasicCommand -copyArguments @("--content-encoding `"gzip`"","--content-type `"application/javascript`"","--cache-control `"public,max-age=31536000`"")
break
} 
"js.map" {
determineFileAndDirectory($item)
Write-Host "Deploying Javascript Map Files $script:file"                     
azcopyBasicCommand
break
}
"jpg" {
determineFileAndDirectory($item)
Write-Host "Deploying Image (jpg) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}
"ico" {
    determineFileAndDirectory($item)
Write-Host "Deploying Image (ico) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}
"png" {
    determineFileAndDirectory($item)
Write-Host "Deploying Image (png) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}  
"jpeg" {
    determineFileAndDirectory($item)
Write-Host "Deploying Image (jpeg) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
} 
"JPG" {
    determineFileAndDirectory($item)
Write-Host "Deploying Image (JPG) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}
"JPG" {
    determineFileAndDirectory($item)
Write-Host "Deploying Image (JPG) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}
"svg" {
    determineFileAndDirectory($item)
Write-Host "Deploying Icon/Font/Image (SVG) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}     
"otf" {
determineFileAndDirectory($item)
Write-Host "Deploying Font (otf) Files $script:file"                     
azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
break
}
"woff" {
    determineFileAndDirectory($item)
    Write-Host "Deploying Font (woff) Files $script:file"                     
    azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
    break
    }  
    "woff2" {
        determineFileAndDirectory($item)
        Write-Host "Deploying Font (woff2) Files $script:file"                     
        azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
        break
        }
    "ttf" {
        determineFileAndDirectory($item)
        Write-Host "Deploying Font (ttf) Files $script:file"                     
        azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
        break
        }
        "eot" {
            determineFileAndDirectory($item)
            Write-Host "Deploying Font (eot) Files $script:file"                     
            azcopyBasicCommand -copyArguments @("--cache-control `"public,max-age=31536000`"")
            break
            }
                default {
                    break
                }
            }
        }
       
    }
}
Set-Location $current_directory
