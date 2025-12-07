$TXTinput = Get-Content -Path "$($PSScriptRoot)\input2.txt" -Delimiter ","
Remove-Item "$($PSScriptRoot)\output2.txt" -ErrorAction SilentlyContinue
foreach ($row in $TXTinput){
    #write-host $row
    $start = $row.Substring(0,$row.IndexOf("-"))
    $end = $row.Substring($row.IndexOf("-")+1)
    #write-host "$($start) : $($end)"
    for($i = ([long] $start); $i -le $end; $i +=1){
        $ii = $i.ToString()
        $BadNumber = $false
        for($j = $ii.length-1; $j -ge 1; $j -= 1){
            #write-host $j
            if($ii.Length % $j -ne 0){
                #write-host $ii.Length
                continue
            }
            $maybeBad = $true
            for ($l = $j; $l -lt $ii.Length; $l += $j){
                if (([long]$ii.Substring($l,$j)) -ne ([long]$ii.Substring($l-$j,$j))) {
                    $maybeBad = $false
                    #write-host "$($ii.Substring($l,$j)) != $($ii.Substring($l-$j,$j))"
                }
            }
            if ($maybeBad){
                $BadNumber = $true
            }
        }
        if($BadNumber){
            write-host $ii
            Add-Content -path "$($PSScriptRoot)\output2.txt" -Value $ii
        }
    }
}
$TXToutput = Get-Content -Path "$($PSScriptRoot)\output2.txt" -ErrorAction SilentlyContinue

$total = 0
foreach($row in $TXToutput){
    $total += [long]$row
}
write-host "SUM : $($total)"