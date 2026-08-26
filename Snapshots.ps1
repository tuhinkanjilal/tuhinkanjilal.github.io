# Connect to your VMware vCenter Server
Connect-VIServer -Server dcr-v-vcsa01 # -User <username> -Password <password>
Connect-VIServer -Server vcenter.sddc-18-133-135-29.vmwarevmc.com -Protocol https -User cloudadmin@vmc.local -Password 'hVdG0I+T0SyRo-b'
 
# Get all VMs with snapshots older than 7 days
$vmsWithOldSnapshots = Get-VM | Get-Snapshot | Where-Object {($_.Created -lt (Get-Date).AddDays(-7))}
 
# Create an empty array to store snapshot information
$snapshotInfoArray = @()
 
# Iterate through each VM with old snapshots
foreach ($vmSnapshot in $vmsWithOldSnapshots) {
    # Add snapshot information to the array
    $snapshotInfoArray += [PSCustomObject]@{
        "VM Name" = $vmSnapshot.VM.Name
        "Snapshot Name" = $vmSnapshot.Name
        "Snapshot Age (Days)" = ((Get-Date) - $vmSnapshot.Created).Days
        "Snapshot Created" = $vmSnapshot.Created
    }
}
 
# Generate HTML output
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
<style>
table {
  font-family: Arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}
 
td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}
 
tr:nth-child(even) {
  background-color: #f2f2f2;
}
</style>
</head>
<body>
 
<h2>VMware Snapshots Older Than 7 Days</h2>
 
<table>
  <tr>
    <th>VM Name</th>
    <th>Snapshot Name</th>
    <th>Snapshot Age (Days)</th>
    <th>Snapshot Created</th>
  </tr>
"@
 
foreach ($snapshotInfo in $snapshotInfoArray) {
    $htmlContent += @"
  <tr>
    <td>$($snapshotInfo.'VM Name')</td>
    <td>$($snapshotInfo.'Snapshot Name')</td>
    <td>$($snapshotInfo.'Snapshot Age (Days)')</td>
    <td>$($snapshotInfo.'Snapshot Created')</td>
  </tr>
"@
}
 
$htmlContent += @"
</table>
 
</body>
</html>
"@
 
# Save HTML content to a file
$htmlFilePath = "SnapshotsOlderThan7Days.html"
$htmlContent | Out-File -FilePath $htmlFilePath
 
# Disconnect from the VMware vCenter Server
Disconnect-VIServer -Server * #<vCenterServer> -Confirm:$false