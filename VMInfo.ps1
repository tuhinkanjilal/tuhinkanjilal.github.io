$vcenters = @("dcr-v-vcsa01");
$SMTPServer = "smtp.channel4.co.uk"
$EmailFrom = "vmreport@channel4.co.uk"
$EmailTo = "tkanjilal@channel4.co.uk"
$DisplayToScreen = $true
$SendEmail = $true
$Colour1 = "111133"
$Colour2 = "992200"
$Colour3 = "283744"
$Colour4 = "C71227"
$Colour5 = "666677"
$Colour6 = "EAE1C2"
$Colour7 = "DAB183"
#$SetUsername = ""
#$CredentialFile = ".\MyCredentials.crd"
$Comments = $true
$ShowClusterResourceSummary = $true
$ErrorActionPreference = "silentlycontinue"

Function Write-ToConsole ($Details){
	$LogDate = Get-Date -Format T
	Write-Host "$($LogDate) $Details"
}

Function Send-SMTPmail($to, $from, $subject, $smtpserver, $body) {
	$mailer = new-object Net.Mail.SMTPclient($smtpserver)
	$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
	$msg.IsBodyHTML = $true
	$mailer.send($msg)
}

Function Get-ClusterResourceSummary ($Header){
$Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($Header)</title>
		<META http-equiv=Content-Type content='text/html; charset=windows-1252'>

		<style type="text/css">

		TABLE			{
						FONT-SIZE: 100%;
						TABLE-LAYOUT: fixed;
						WIDTH: 100%;
					}

		*
					{
						MARGIN:0;
					}

		.dspDetail 		{
						BACKGROUND-COLOR: #$($Colour6);
						BORDER-BOTTOM: #bbbbbb 1px solid;
						BORDER-LEFT: #bbbbbb 1px solid;
						BORDER-RIGHT: #bbbbbb 1px solid;
						BORDER-TOP: #bbbbbb 1px solid;
						COLOR: #000000;
						FONT-FAMILY: tahoma;
						FONT-SIZE: 8pt;
						FONT-WEIGHT: normal;
						MARGIN-BOTTOM: -1px;
						MARGIN-LEFT: 100px;
						MARGIN-RIGHT: 100px;
						PADDING-BOTTOM: 5px;
						PADDING-LEFT: 5px;
						PADDING-TOP: 5px;
						POSITION: relative;
						WIDTH: 80%;
					}

		.filler 		{
						BACKGROUND: none transparent scroll repeat 0% 0%;
						BORDER-BOTTOM: medium none;
						BORDER-LEFT: medium none;
						BORDER-RIGHT: medium none;
						BORDER-TOP: medium none;
						COLOR: #ffffff;
						DISPLAY: block;
						FONT: 100%/8px tahoma;
						MARGIN-BOTTOM: -1px;
						MARGIN-LEFT: 43px;
						MARGIN-RIGHT: 0px;
						PADDING-TOP: 4px;
						POSITION: relative;
					}

		.pageholder		{
						MARGIN: 0px auto;
					}

		.dsp
					{
						COLOR: #ffffff;
						BORDER-BOTTOM: #bbbbbb 1px solid;
						BORDER-LEFT: #bbbbbb 1px solid;
						BORDER-RIGHT: #bbbbbb 1px solid;
						BORDER-TOP: #bbbbbb 1px solid;
						DISPLAY: block;
						FONT-FAMILY: tahoma;
						FONT-SIZE: 8pt;
						FONT-WEIGHT: bold;
						HEIGHT: 1.75em;
						MARGIN-BOTTOM: -1px;
						MARGIN-LEFT: 0px;
						MARGIN-RIGHT: 0px;
						PADDING-LEFT: 0px;
						PADDING-RIGHT: 0px;
						PADDING-TOP: 5px;
						POSITION: relative;
						TEXT-INDENT: 10px;
						WIDTH: 95%;
					}

		.dspvCenter		{
						BACKGROUND-COLOR: #$($Colour1);
						MARGIN-LEFT: 25px;
						MARGIN-RIGHT: 25px;
						WIDTH: 95%;
					}

		.dspDatacenter		{
						
						BACKGROUND-COLOR: #$($Colour2);
						MARGIN-LEFT: 50px;
						MARGIN-RIGHT: 50px;
						WIDTH: 90%;
					}

		.dspCluster		{
						
						BACKGROUND-COLOR: #$($Colour3);
						MARGIN-LEFT: 75px;
						MARGIN-RIGHT: 75px;
						WIDTH: 85%;
					}

		.dspComments		{
						BACKGROUND-COLOR:#ffffe1;
						COLOR: #000000;
						FONT-SIZE: 8pt;
						FONT-STYLE: italic;
						FONT-WEIGHT: normal;
					}

		td			{
						FONT-FAMILY: tahoma;
						VERTICAL-ALIGN: top;
					}

		th			{
						COLOR: #$($Colour1);
						FONT-WEIGHT: normal;
						TEXT-ALIGN: left;
						VERTICAL-ALIGN: tOP;
					}

		BODY			{
						MARGIN-LEFT: 4pt;
						MARGIN-RIGHT: 4pt;
						MARGIN-TOP: 6pt;
					}

		.MainTitle		{
						FONT-FAMILY: arial, helvetica, sans-serif;
						FONT-SIZE: 18px;
						FONT-WEIGHT: bolder;
					}

		.SubTitle		{
						FONT-FAMILY: arial, helvetica, sans-serif;
						FONT-SIZE: 12px;
						FONT-WEIGHT: bold;
					}

		.Created		{
						FONT-FAMILY: arial, helvetica, sans-serif;
						FONT-SIZE: 10px;
						FONT-WEIGHT: bold;
						MARGIN-BOTTOM: 5px;
						MARGIN-LEFT: 25px;
						MARGIN-RIGHT: 25px;
						MARGIN-TOP: 10px;
						WIDTH: 95%;
					}

		.Links			{	FONT-FAMILY: arial, helvetica, sans-serif;
						FONT-SIZE: 10px;
						FONT-STYLE: italic;
					}

		</style>
	</head>
	<body>
<div class="MainTitle">$($Header)</div>
        <hr size="8" color="#$($Colour5)">
        <div class="SubTitle">Report generated on $($ENV:Computername)</div>
	    <br/>
		<div class="Created">Report created on $(Get-Date)</div>
"@
Return $Report
}

Function Get-vCenterHeader ($Heading, $Detail){
$Report = @"
		<div class="pageholder">		
		
		<h1 class="dsp dspvCenter">$($Heading) $Detail</h1>
	
	<div class="filler"></div>
"@
Return $Report
}

Function Get-DatacenterHeader ($Heading, $Detail){
$Report = @"
		<div class="pageholder">		
		
		<h1 class="dsp dspDatacenter">$($Heading) $Detail</h1>
	
	<div class="filler"></div>
"@
Return $Report
}

Function Get-ClusterHeader ($Heading, $Detail, $Comment){
$Report = @"
		<h2 class="dsp dspCluster">$($Heading) $Detail</h2>
"@
If ($Comments) {
	$Report += @"
			<div class="dsp dspComments">$($cmnt)</div>
"@
}
$Report += @"
	<div class="dspDetail">
"@
Return $Report
}

Function Get-ClusterHeaderClose{

	$Report = @"
		</DIV>
		<div class="filler"></div>
"@
Return $Report
}

Function Get-DatacenterHeaderClose{
	$Report = @"
</DIV>
"@
Return $Report
}

Function Get-vCenterHeaderClose{
	$Report = @"
</DIV>
"@
Return $Report
}

Function Get-ClusterResourceSummaryClose{
	$Report = @"
</div>

</body>
</html>
"@
Return $Report
}

Function Get-ClusterDetail0 ($Heading, $Detail){
$Report = @"
<TABLE>
	<tr>
	<th width='50%'><b>$Heading</b></font></th>
	<td width='50%'>$($Detail)</td>
	</tr>
</TABLE>
"@
Return $Report
}

Function Get-ClusterDetail1 ($Heading, $Detail){
$Report = @"
<TABLE>
	<tr>
	<th width='25%'>$Heading</th>
	<td width='25%'>$($Detail)</td>
"@
Return $Report
}

Function Get-ClusterDetail2 ($Heading, $Detail){
$Report = @"
	<th width='25%'>$Heading</th>
	<td width='25%'>$($Detail)</td>
	</tr>
</TABLE>
"@
Return $Report
}

Function Get-ClusterDetailSeparator{
$Report = @"
<TABLE>
	<tr>
	<td width='100%'></td>
	</tr>
	<tr>
	<td width='100%'></td>
	</tr>
</TABLE>
"@
Return $Report
}

$Date = Get-Date

$MyReport = Get-ClusterResourceSummary "Channel4 Monthly Report - VMware Cluster Resource Summary"
	
	if ($ShowClusterResourceSummary){
		Write-ToConsole "... Starting Channel4 Monthly Report - VMware Cluster Resource Summary"
		
		foreach($vcenter in $vcenters){
			Write-ToConsole "... Connecting to vCenter Server $vcenter"
			Connect-VIServer -Server $vcenter
			$MyReport += Get-vCenterHeader "vCenter Server Name: " $vcenter
			$datacenters = Get-Datacenter | Sort Name
			
			foreach($datacenter in $Datacenters){
				Write-ToConsole "... Retrieving from Datacenter $datacenter"
				$MyReport += Get-DatacenterHeader "Datacenter Name: " $datacenter.Name
				$clusters = Get-Cluster -location $datacenter | Sort Name
				
				foreach($cluster in $clusters){
					Write-ToConsole "... Collecting from Cluster $Cluster"
					$esxi = $cluster | Get-VMHost
					$data = Get-Datastore -VMHost $esxi | where {$_.Type -eq "VMFS" -and (Get-View $_).Summary.MultipleHostAccess}
					$nvms = $cluster | Get-VM
					$days = (Get-Date).AddDays(-7)
					$scpu = $cluster | Get-Stat -Start $days -Stat cpu.usage.average | Measure-Object Value -min -max -ave
					$smem = $cluster | Get-Stat -Start $days -Stat mem.usage.average | Measure-Object Value -min -max -ave
					$CommentsSet = $Comments
					$Comments = $false
					$MyReport += Get-ClusterHeader "Cluster Name: " $cluster.Name
						$MyReport += (Get-ClusterDetail1 "Number Of Hosts: " ($esxi | Measure-Object).Count) , (Get-ClusterDetail2 "Total Disk Space (GB): " ("{0:f2}" -f (($data | where {$_.Type -eq "VMFS"} | Measure-Object -Property CapacityMB -Sum).Sum / 1KB)))
						$MyReport += (Get-ClusterDetail1 "Number Of Datastores: " ($data | Measure-Object).Count) , (Get-ClusterDetail2 "Current Consumed Disk Space (GB): " ("{0:f2}" -f (($data | Measure-Object -InputObject {$_.CapacityMB - $_.FreeSpaceMB} -Sum).Sum / 1KB)))
						$MyReport += (Get-ClusterDetail1 "Number Of Virtual Machines: " ($nvms | Measure-Object).Count) , (Get-ClusterDetail2 "Current Available Disk Space (GB): " ("{0:f2}" -f (($data | Measure-Object -Property FreeSpaceMB -Sum).Sum / 1KB)))
						$MyReport += Get-ClusterDetailSeparator " "
						$MyReport += (Get-ClusterDetail1 "Total Processor (Ghz): " ("{0:f2}" -f (($esxi | Measure-Object -Property CpuTotalMhz -Sum).Sum / 1000))) , (Get-ClusterDetail2 "7 Day Minimum Processor Usage (%): " ("{0:f2}" -f ($scpu.minimum)))
						$MyReport += (Get-ClusterDetail1 "Current Consumed Processor (Ghz): " ("{0:f2}" -f (($esxi | Measure-Object -Property CpuUsageMhz -Sum).Sum / 1000))) , (Get-ClusterDetail2 "7 Day Maximum Processor Usage (%): " ("{0:f2}" -f ($scpu.maximum)))
						$MyReport += (Get-ClusterDetail1 "Current Available Processor (Ghz): " ("{0:f2}" -f (($esxi | Measure-Object -InputObject {$_.CpuTotalMhz - $_.CpuUsageMhz} -Sum).Sum / 1000))) , (Get-ClusterDetail2 "7 Day Average Processor Usage (%): " ("{0:f2}" -f ($scpu.Average)))
						$MyReport += Get-ClusterDetailSeparator " "
						$MyReport += (Get-ClusterDetail1 "Total Memory (GB): " ("{0:f2}" -f (($esxi | Measure-Object -Property MemoryTotalMB -Sum).Sum / 1KB))) , (Get-ClusterDetail2 "7 Day Minimum Memory Usage (%): " ("{0:f2}" -f ($smem.minimum)))
						$MyReport += (Get-ClusterDetail1 "Current Consumed Memory (GB): " ("{0:f2}" -f (($esxi | Measure-Object -Property MemoryUsageMB -Sum).Sum / 1KB))) , (Get-ClusterDetail2 "7 Day Maximum Memory Usage (%): " ("{0:f2}" -f ($smem.maximum)))
						$MyReport += (Get-ClusterDetail1 "Current Available Memory (GB): " ("{0:f2}" -f (($esxi | Measure-Object -InputObject {$_.MemoryTotalMB - $_.MemoryUsageMB} -Sum).Sum / 1KB))) , (Get-ClusterDetail2 "7 Day Average Memory Usage (%): " ("{0:f2}" -f ($smem.average)))
#						$MyReport += Get-ClusterDetailSeparator " "
					$Comments = $CommentsSet
					$MyReport += Get-ClusterHeaderClose
				}
				
				$MyReport += Get-DatacenterHeaderClose
			}
			
			$MyReport += Get-vCenterHeaderClose
			Write-ToConsole "... Disconnecting from vCenter Server $vcenter"
			Disconnect-VIServer -Server $vcenter -Confirm:$false
		}
		
	}
	
$MyReport += Get-ClusterResourceSummaryClose

if ($DisplayToScreen) {
	Write-ToConsole "... Displaying Channel4 Monthly Report - VMware Cluster Resource Summary"
	if (-not (test-path E:\Wintel\TUHIN\SCRIPT\Script\Tested\VMWare\vmreporttesting\)){
		MD E:\Wintel\TUHIN\SCRIPT\Script\Tested\VMWare\vmreporttesting | Out-Null
	}
	$Filename = "E:\Wintel\TUHIN\SCRIPT\Script\Tested\VMWare\vmreporttesting\Monthly-VMwareClusterResourceSummary" + "_" + $Date.Month + "-" + $Date.Day + "-" + $Date.Year + "_" + $Date.Hour + "-" + $Date.Minute + "-" + $Date.Second + ".htm"
	$MyReport | out-file -encoding ASCII -filepath $Filename
	Invoke-Item $Filename
}

if ($SendEmail) {
	Write-ToConsole "... Sending Email of Channel4 Monthly Report - VMware Cluster Resource Summary to $EmailTo"
	send-SMTPmail $EmailTo $EmailFrom "Channel4 Monthly Report - VMware Cluster Resource Summary" $SMTPServer $MyReport
}
