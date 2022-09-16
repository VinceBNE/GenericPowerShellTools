param
(
   [alias("i")]
   [string]$inputfile = $(read-host -Prompt "Enter the full path to the list of the CSV input file")
)

$maxrun = 20000
$actualrun = 0
$pinginterval = 2

Do {

Import-Csv $inputfile | ForEach-Object {

    $Ping = Test-Connection -Count 1 -ComputerName $_.hostname
    ForEach ($Result in $Ping) {
      If ($Result.ResponseTime -lt 5) {
        $Result | Select-Object -Property Address,ResponseTime | Write-Host -BackgroundColor DarkGreen
      }
      If ( ($Result.ResponseTime -ge 10) -and ($Result.ResponseTime -lt 50) ) {
        $Result | Select-Object -Property Address,ResponseTime | Write-Host -BackgroundColor Blue
      }
      
    }

}

$actualrun++

Start-Sleep ($pinginterval)
Clear-Host
Write-Host "Task is running - task number $actualrun - next ping test will start in $pinginterval seconds"
Write-Host ""


} while ($actualrun -lt $maxrun)

