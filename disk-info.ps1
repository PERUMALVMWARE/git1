# Disk Information Script

Write-Host "=== Disk Information ===" -ForegroundColor Cyan

# Physical Disks
Write-Host "`n--- Physical Disks ---" -ForegroundColor Yellow
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size, HealthStatus, OperationalStatus |
    Format-Table -AutoSize

# Logical Drives / Partitions
Write-Host "--- Logical Drives ---" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Select-Object Name, Root,
    @{Name="Used(GB)"; Expression={[math]::Round(($_.Used / 1GB), 2)}},
    @{Name="Free(GB)"; Expression={[math]::Round(($_.Free / 1GB), 2)}},
    @{Name="Total(GB)"; Expression={[math]::Round((($_.Used + $_.Free) / 1GB), 2)}} |
    Format-Table -AutoSize

# Disk Partitions
Write-Host "--- Partitions ---" -ForegroundColor Yellow
Get-Partition | Select-Object DiskNumber, PartitionNumber, DriveLetter, Type,
    @{Name="Size(GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}} |
    Format-Table -AutoSize

# Volume Details
Write-Host "--- Volume Details ---" -ForegroundColor Yellow
Get-Volume | Where-Object {$_.DriveType -ne "CD-ROM"} |
    Select-Object DriveLetter, FileSystemLabel, FileSystem, DriveType,
        @{Name="Size(GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}},
        @{Name="FreeSpace(GB)"; Expression={[math]::Round($_.SizeRemaining / 1GB, 2)}},
        HealthStatus |
    Format-Table -AutoSize
