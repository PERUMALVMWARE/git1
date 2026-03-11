# All Storage-Related Get Commands

function Section($title) {
    Write-Host "`n=== $title ===" -ForegroundColor Cyan
}

# 1. Get-Disk
Section "Get-Disk"
Get-Disk | Select-Object Number, FriendlyName, Model, SerialNumber, BusType,
    @{Name="Size(GB)"; Expression={[math]::Round($_.Size/1GB,2)}},
    PartitionStyle, HealthStatus, OperationalStatus | Format-Table -AutoSize

# 2. Get-PhysicalDisk
Section "Get-PhysicalDisk"
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, MediaType, BusType,
    @{Name="Size(GB)"; Expression={[math]::Round($_.Size/1GB,2)}},
    HealthStatus, OperationalStatus, SpindleSpeed | Format-Table -AutoSize

# 3. Get-Partition
Section "Get-Partition"
Get-Partition | Select-Object DiskNumber, PartitionNumber, DriveLetter, Type, IsActive, IsHidden,
    @{Name="Size(GB)"; Expression={[math]::Round($_.Size/1GB,2)}} | Format-Table -AutoSize

# 4. Get-Volume
Section "Get-Volume"
Get-Volume | Select-Object DriveLetter, FileSystemLabel, FileSystem, DriveType,
    @{Name="Size(GB)"; Expression={[math]::Round($_.Size/1GB,2)}},
    @{Name="FreeSpace(GB)"; Expression={[math]::Round($_.SizeRemaining/1GB,2)}},
    @{Name="Used%"; Expression={if($_.Size -gt 0){[math]::Round((($_.Size-$_.SizeRemaining)/$_.Size)*100,1)}else{0}}},
    HealthStatus | Format-Table -AutoSize

# 5. Get-StorageSubSystem
Section "Get-StorageSubSystem"
Get-StorageSubSystem | Select-Object FriendlyName, HealthStatus, OperationalStatus,
    Manufacturer, Model | Format-Table -AutoSize

# 6. Get-StoragePool
Section "Get-StoragePool"
try {
    $pools = Get-StoragePool -ErrorAction Stop
    if ($pools) { $pools | Select-Object FriendlyName, OperationalStatus, HealthStatus,
        @{Name="Size(GB)"; Expression={[math]::Round($_.Size/1GB,2)}},
        @{Name="Allocated(GB)"; Expression={[math]::Round($_.AllocatedSize/1GB,2)}} | Format-Table -AutoSize }
    else { Write-Host "No storage pools found." -ForegroundColor Gray }
} catch { Write-Host "No storage pools configured." -ForegroundColor Gray }

# 7. Get-StorageProvider
Section "Get-StorageProvider"
Get-StorageProvider | Select-Object Name, Manufacturer, Version, RemoteSubsystemSupported | Format-Table -AutoSize

# 8. Get-StorageNode
Section "Get-StorageNode"
try {
    Get-StorageNode | Select-Object Name, OperationalStatus, StorageSubSystemName | Format-Table -AutoSize
} catch { Write-Host "Not available on this system." -ForegroundColor Gray }

# 9. Get-StorageReliabilityCounter
Section "Get-StorageReliabilityCounter"
try {
    Get-PhysicalDisk | Get-StorageReliabilityCounter |
        Select-Object DeviceId, Temperature, ReadErrorsUncorrected, WriteErrorsUncorrected,
        PowerOnHours, Wear | Format-Table -AutoSize
} catch { Write-Host "Reliability counters not available." -ForegroundColor Gray }

# 10. Get-StorageTier
Section "Get-StorageTier"
try {
    $tiers = Get-StorageTier -ErrorAction Stop
    if ($tiers) { $tiers | Format-Table -AutoSize }
    else { Write-Host "No storage tiers found." -ForegroundColor Gray }
} catch { Write-Host "No storage tiers configured." -ForegroundColor Gray }

# 11. Get-StorageJob
Section "Get-StorageJob"
try {
    $jobs = Get-StorageJob -ErrorAction Stop
    if ($jobs) { $jobs | Format-Table -AutoSize }
    else { Write-Host "No active storage jobs." -ForegroundColor Gray }
} catch { Write-Host "No storage jobs found." -ForegroundColor Gray }

# 12. Get-DiskImage
Section "Get-DiskImage"
try {
    $images = Get-DiskImage -ErrorAction Stop
    if ($images) { $images | Format-Table -AutoSize }
    else { Write-Host "No mounted disk images." -ForegroundColor Gray }
} catch { Write-Host "No disk images found." -ForegroundColor Gray }

# 13. Get-PSDrive (FileSystem only)
Section "Get-PSDrive (FileSystem)"
Get-PSDrive -PSProvider FileSystem | Select-Object Name, Root, CurrentLocation,
    @{Name="Used(GB)"; Expression={[math]::Round($_.Used/1GB,2)}},
    @{Name="Free(GB)"; Expression={[math]::Round($_.Free/1GB,2)}},
    @{Name="Total(GB)"; Expression={[math]::Round(($_.Used+$_.Free)/1GB,2)}} | Format-Table -AutoSize

# 14. Get-FileShare
Section "Get-FileShare"
try {
    $shares = Get-FileShare -ErrorAction Stop
    if ($shares) { $shares | Select-Object Name, FileSharingProtocol, HealthStatus | Format-Table -AutoSize }
    else { Write-Host "No file shares found." -ForegroundColor Gray }
} catch { Write-Host "File shares not available." -ForegroundColor Gray }

# 15. Get-SmbShare
Section "Get-SmbShare"
try {
    Get-SmbShare | Select-Object Name, Path, Description, ShareState | Format-Table -AutoSize
} catch { Write-Host "SMB shares not available." -ForegroundColor Gray }

Write-Host "`n=== Done ===" -ForegroundColor Green
