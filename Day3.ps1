$TXTinput = Get-Content -Path "$($PSScriptRoot)\input3.txt"
$RunningSum = 0
[Int32[]]$digit = 0..12
[Int32[]]$index = 0..12
$NumberOfDigits = 12
$index[0] = -1
foreach ($row in $TXTinput)
{
    $temp = [int32]0
    $temp2 = [int32]0
    $bank = $row.ToCharArray()


    for($eye = 1; $eye -le $NumberOfDigits; $eye += 1){
        for($j = 9; $j -ge 0; $j -= 1){
            for($i = $index[$eye-1]+1; $i -lt $bank.length-($NumberOfDigits-$eye); $i += 1){
                $temp = $bank[$i]
                $temp = $temp -join ""
                $temp2 = $j
                $temp2 = $temp2 -join ""
                if($temp -eq $temp2){
                    $index[$eye] = $i
                    $digit[$eye] = $j
                    $i = $bank.length + 1
                    $j = -1
                }
                #write-host "$($eye)/$($NumberOfDigits) ($($j)) $($i)=$($bank[$i]) | $($index[$eye-1]+1)~$($bank.length-($NumberOfDigits-$eye))"
            }
        }
    }
    <#
        $index[2] = $bank.Length
        $digit[2] = [int32]$bank[$bank.Length]
        for($j = $index[1]+1; $j -le $bank.length; $j += 1){
            $temp = $bank[$j]
            $temp = $temp -join ""
            $temp2 = $n
            $temp2 = $temp2 -join ""
            if($temp -eq $temp2){
                $digit[2] = $n
                $index[2] = $j
                $j = $bank.length + 1
                $n = -1
            }
        }
    }
    #>
    $RunningSum += [int64](($digit -join "").Substring(1,$NumberOfDigits))
    write-host "$($row) | $([int64](($digit -join '').Substring(1,$NumberOfDigits)))"
    #$Part1_Sum += (($digit[1] * 10) + $digit[2])
}
write-host "SUM TOTAL = $($RunningSum)"