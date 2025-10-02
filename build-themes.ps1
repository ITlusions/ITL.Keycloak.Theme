# Build script for Keycloak themes
# Creates JAR files for both NL Design System and ITlusions themes

Write-Host "Building Keycloak themes..." -ForegroundColor Green

# Create output directory if it doesn't exist
if (!(Test-Path "output")) {
    New-Item -ItemType Directory -Path "output"
}

# Function to create JAR file using PowerShell compression
function Create-JarFile {
    param(
        [string]$JarName,
        [string[]]$SourcePaths
    )
    
    $TempDir = "temp_$([System.Guid]::NewGuid().ToString().Substring(0,8))"
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
    
    try {
        # Copy all source files to temp directory
        foreach ($SourcePath in $SourcePaths) {
            if (Test-Path $SourcePath) {
                Copy-Item -Path $SourcePath -Destination $TempDir -Recurse -Force
                Write-Host "  ✓ Copied $SourcePath" -ForegroundColor Gray
            } else {
                Write-Host "  ⚠ Warning: $SourcePath not found" -ForegroundColor Yellow
            }
        }
        
        # Create ZIP file (JAR is just a ZIP with specific structure)
        $JarPath = "output\$JarName"
        if (Test-Path $JarPath) {
            Remove-Item $JarPath -Force
        }
        
        Compress-Archive -Path "$TempDir\*" -DestinationPath $JarPath -Force
        Write-Host "  ✓ Created $JarPath" -ForegroundColor Green
        
        # Show file size
        $FileSize = (Get-Item $JarPath).Length
        $FileSizeKB = [math]::Round($FileSize / 1KB, 2)
        Write-Host "  📦 Size: $FileSizeKB KB" -ForegroundColor Cyan
        
    } finally {
        # Clean up temp directory
        if (Test-Path $TempDir) {
            Remove-Item $TempDir -Recurse -Force
        }
    }
}

# Build ITlusions theme
Write-Host "`nBuilding ITlusions theme..." -ForegroundColor Blue
Create-JarFile "keycloak-itlusions-theme.jar" @("theme\itlusions", "META-INF")

Write-Host "`n🎉 Build completed successfully!" -ForegroundColor Green
Write-Host "Available theme files:" -ForegroundColor White
Get-ChildItem "output\*.jar" | ForEach-Object {
    $Size = [math]::Round($_.Length / 1KB, 2)
    Write-Host "  📦 $($_.Name) ($Size KB)" -ForegroundColor Gray
}