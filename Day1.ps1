$TXTinput = Get-Content -Path "$($PSScriptRoot)\input1.txt"
$value = 50
$numOfZeros = 0
$part1Zeros = 0
$startValue = 50
$startZero = 0
$rotateAmount = 0
foreach ($row in $TXTinput)
{
    $startValue = $value
    $startZero = $numOfZeros
    switch ($row[0]) {
        "L" { $rotateAmount = 0 - $row.Substring(1) }
        Default { $rotateAmount = $row.Substring(1) }
    }
    $numOfZeros += [Math]::Floor([Math]::Abs(($rotateAmount / 100)))
    $value += ($rotateAmount % 100)

    if($value -eq 0){
        $numOfZeros += 1
    }
    while (($value -lt 0) -or ($value -gt 99))
    {
        if($value -lt  0)
        {
            $value += 100
            if ($startValue -ne 0){
                $numOfZeros += 1
            }

        }
        if($value -gt 99)
        {
            $value -= 100
            $numOfZeros += 1

        }
    }
    if($value -eq 0){
        $part1Zeros += 1
    }

    if(($numOfZeros - $startZero) -ne 0)
    {
        #write-host "$($row)`t= $($value)`t+ $($numOfZeros - $startZero) Zeros"
    }
    else {
        #write-host "$($row)`t= $($value)"
    } #>
    if(($rotateAmount % 100) -eq -1 -and $startValue -ne 50){
        #write-host "$($startValue) $($row) = $($value) : /$([Math]::Floor([Math]::Abs(($rotateAmount / 100)))) : %$(($rotateAmount % 100)) = $($startValue+($rotateAmount % 100))  : $($numOfZeros - $startZero) Zeros"
    }
}
    write-host "Number of Zeros : $($numOfZeros)"
    write-host "Number of P1 Zeros : $($part1Zeros)"
