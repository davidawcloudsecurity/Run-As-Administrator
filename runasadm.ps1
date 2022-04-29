#open directory
Function Get-FileName($initialDirectory)
{  
 [System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = “All files (*.*)| *.*”
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}

$getfile =  Get-FileName -initialDirectory ".\";
$HexPass = Get-Content $getfile

$adm = Read-Host -Prompt 'Enter username'
$securedValue = Read-Host "Enter Pin" -AsSecureString
$value =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedValue))

#$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedValue)
#$value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

$Hexpass = $Hexpass -replace $value
break;
Try{
$Credential = New-Object -TypeName PSCredential -ArgumentList $adm, ($HexPass | ConvertTo-SecureString)
Start-Process powershell -Credential $Credential -WorkingDirectory 'C:\Windows\System32'
}
Catch
{
Write-Warning $Error[0]
}
$HexPass = ""
$value = ""
$Credential = ""
Remove-Item $getfile
