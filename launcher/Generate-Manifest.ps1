param(
    [string]$RootDir = "./build",
    [string]$OutputFile = "./manifest.json"
)

$root = (Resolve-Path $RootDir).Path

$files = Get-ChildItem $root -Recurse -File |
    Where-Object { $_.FullName -ne (Join-Path $root $OutputFile) } |
    ForEach-Object {
        [PSCustomObject]@{
            Path = $_.FullName.Substring($root.Length + 1).Replace('\', '/')
            Sha256 = (Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLower()
        }
    }

@{
    Files = $files
} |
ConvertTo-Json -Depth 3 |
Set-Content $OutputFile -Encoding UTF8

Write-Host "Manifest saved to $OutputFile"