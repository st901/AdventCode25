$TXTinput = Get-Content -Path "$($PSScriptRoot)\input5.txt"
$numRanges = 0
$numValues = 0
for ($i = 0; $i -lt $TXTinput.Count; $i++) {
    if($TXTinput[$i] -eq ''){
        $numRanges = $i
        $numValues = $TXTinput.Count - ($i+1)
        break
    }
}
$rangeStart = New-Object 'object[]' $numRanges
$rangeEnd   = New-Object 'object[]' $numRanges
$values     = New-Object 'object[]' $numValues
$fresh      = New-Object 'object[]' $numValues
for ($i = 0; $i -lt $numRanges; $i++) {
    #write-host $TXTinput[$i]
    $rangeStart[$i] = [Int64]$TXTinput[$i].Substring(0,$TXTinput[$i].IndexOf("-"))
    $rangeEnd[$i]   = [Int64]$TXTinput[$i].Substring($TXTinput[$i].IndexOf("-")+1)
    write-host "$($rangeStart[$i]) : $($rangeEnd[$i])"
}
for ($i = $numRanges+1; $i -lt $TXTinput.Count; $i++) {
    $values[($i-($numRanges+1))] = [Int64]$TXTinput[$i]
    #write-host $TXTinput[$i]
}
write-host "$($numRanges) Ranges; $($numValues) Ingredients"
for ($i = 0; $i -lt $numValues; $i++) {
    $fresh[$i] = $false
    for ($j = 0; $j -lt $numRanges; $j++) {
        if(($values[$i] -ge $rangeStart[$j]) -and ($values[$i] -le $rangeEnd[$j])){
            $fresh[$i] = $true
            break
        }
    }
}
$numFresh = 0
for ($i = 0; $i -lt $numValues; $i++) {
    #write-host "$($values[$i]) : $($fresh[$i])"
    if ($fresh[$i] -eq $true){
            $numFresh += 1
    }
}
write-host "$($numFresh) out of $($numValues) Ingredients are Fresh"

<#
# This ended up being incredibly inefficient :P
$freshValues = [System.Collections.Generic.List[int64]]::new()
for ($i = 0; $i -lt $numRanges; $i++) {
    write-host "Range #$($i)/$($numRanges) : Adding $((($rangeEnd[$i])-($rangeStart[$i]))) Fresh Values"
    for ($j = $rangeStart[$i]; $j -le $rangeEnd[$i]; $j++) {
        $freshValues.Add($j)
    }
}
$freshValues = $freshValues | Sort-Object | Get-Unique 
Write-Host $freshValues
Write-Host "A Total of $($freshValues.Count) Kinds of Ingredients are considered Fresh"
#>

$newRangeStart = @() + $rangeStart
$newRangeEnd = @() + $rangeEnd
$freshValueTotal = 0
$global:timeloop = $false
$startsIn = $false
$endsIn = $false
do {
    $startTotal = $freshValueTotal
    for ($i = 0; $i -lt $numRanges; $i++) {
        for ($j = 0; $j -lt $numRanges; $j++) {
            if($i -ne $j){
                $startsIn = $false
                    
                $endsIn = $false
                if(($newRangeStart[$i] -ge $newRangeStart[($j)]) -and ($newRangeStart[$i] -le $newRangeEnd[($j)])){
                    $newRangeStart[$i] = ($newRangeStart[($j)])
                    $startsIn = $true
                }
                if(($newRangeEnd[$i] -ge $newRangeStart[($j)]) -and ($newRangeEnd[$i] -le $newRangeEnd[($j)])){
                    $newRangeEnd[$i] = ($newRangeEnd[($j)])
                    $endsIn = $true
                }
                if($startsIn -and $endsIn){
                    $newRangeStart[$i] = 0
                    $newRangeEnd[$i] = -1
                }
                elseif ($startsIn -and -not $endsIn){
                    $newRangeStart[$i] = $newRangeStart[$j]
                }
                elseif (-not $startsIn -and $endsIn){
                    $newRangeEnd[$i] = $newRangeEnd[$j]
                }
            }

        }
        #Write-Host "$($newRangeStart[$i]) : $($newRangeEnd[$i])"
    }
    $freshValueTotal = 0
    for ($i = 0; $i -lt $numRanges; $i++) {
        $freshValueTotal += ($newRangeEnd[$i] - $newRangeStart[$i]+1)
        Write-Host "$($newRangeStart[$i]) :`t$($newRangeEnd[$i])`t Adds $(($newRangeEnd[$i] - $newRangeStart[$i]+1)) new Values"
    }
    Write-Host "Total Fresh Ingredients : $($startTotal) / $($freshValueTotal)"
    if($startTotal -ne $freshValueTotal){
        $global:timeloop = $true
    }
    else{
        $global:timeloop = $false
    }
}while($global:timeloop -eq $true)
Write-Host "Total Fresh Ingredients : $($freshValueTotal)"
# bless this mess 🙏