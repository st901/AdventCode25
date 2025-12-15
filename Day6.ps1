$TXTinput       = Get-Content -Path "$($PSScriptRoot)\input6.txt"
$numTerms = $TXTinput.count-1
$numOperations = $TXTinput[-1].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries).count
$terms          = New-Object 'object[,]' $numOperations, $numTerms # 2D array to represent an unknown number of terms in one-dimension, for any number of expressions in the other dimension
$operations     = New-Object 'object[]'  $numOperations  # simple array to represent any number of expressions in one dimension
$answers        = New-Object 'object[]'  $numOperations   # eventual array that will store answers to the expressions in the previous two arrays.
$operations = $TXTinput[-1].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
for ($i = 0; $i -lt $numTerms; $i++) {
    for ($j = 0; $j -lt $numOperations; $j++) {
        $terms[$j,$i] = $TXTinput[$i].Split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)[$j]
    }
}
for ($i = 0; $i -lt $numOperations; $i++) {
    $answers[$i] = 0
    if($operations[$i] -eq "*"){
        $answers[$i] = 1
    }
    for ($j = 0; $j -lt $numTerms; $j++) {
        if ($operations[$i] -eq "+") {
            $answers[$i] += $terms[$i,$j]
        }
        elseif ($operations[$i] -eq "*") {
            $answers[$i] *= $terms[$i,$j]
        }
        elseif ($operations[$i] -eq "-") {
            $answers[$i] -= $terms[$i,$j]
        }
        elseif (($operations[$i] -eq "/") -and ($j -eq 0)) {
            $answers[$i] = $terms[$i,$j]
        }
        elseif (($operations[$i] -eq "/") -and ($j -ne 0)) {
            $answers[$i] /= $terms[$i,$j]
        }
    }
}
$totalAll = 0
for ($i = 0; $i -lt $numOperations; $i++) {
    $totalAll += $answers[$i]
}
#$terms
write-host "Sum of all Part1 Answers : $($totalAll)"

# Start of Part 2 :(
$operationLength = New-Object 'object[]'  $numOperations # Array to hold the number of terms per operation.
$temp = (($TXTinput[-1] -replace "\s","@") -replace "\*","+").Substring(1) + "@"
$operationLength = ($temp.split("+",$numOperations))
for ($i = 0; $i -lt $numOperations; $i++) {
    $operationLength[$i] = ($operationLength[$i].Length)
}
$newTermsWithWhitespace = New-Object 'object[,]' $numOperations, $numTerms # 2D array to represent an unknown number of terms in one-dimension, for any number of expressions in the other dimension
$newTerms               = New-Object 'object[,]' $numOperations, ($operationLength | Measure-Object -Maximum).Maximum # 2D array to represent an unknown number of terms in one-dimension, for any number of expressions in the other dimension
$newAnswers             = New-Object 'object[]'  $numOperations   # eventual array that will store answers to the expressions in the previous two arrays.
# I can reuse the operations, as that hasn't changed from part 1
for ($i = 0; $i -lt $numTerms; $i++) {
    $working = $TXTinput[$i]
    for ($j = 0; $j -lt $numOperations; $j++) {
        $newTermsWithWhitespace[$j,$i] = $working.Substring(0,([int]$operationLength[$j]))
        if($j -ne ($numOperations-1)){
            $working = $working.remove(0,(([int]$operationLength[$j])+1))
        }
    }
}
#$newTermsWithWhitespace
for ($i = 0; $i -lt $numOperations; $i++) {

    for ($j = 0; $j -lt $operationLength[$i]; $j++) {
        $temp = ""
        for ($k = 0; $k -lt $numTerms; $k++) {
            $temp += ($newTermsWithWhitespace[$i,$k])[$j]
            #($newTermsWithWhitespace[$i,$k])[$j]
        }
        $newTerms[$i,$j] = [int]$temp
    }
}
for ($i = 0; $i -lt $numOperations; $i++) {
    $newAnswers[$i] = 0
    if($operations[$i] -eq "*"){
        $newAnswers[$i] = 1
    }
    for ($j = 0; $j -lt $operationLength[$i]; $j++) {
        if ($operations[$i] -eq "+") {
            $newAnswers[$i] += $newTerms[$i,$j]
        }
        elseif ($operations[$i] -eq "*") {
            $newAnswers[$i] *= $newTerms[$i,$j]
        }
        elseif ($operations[$i] -eq "-") {
            $newAnswers[$i] -= $newTerms[$i,$j]
        }
        elseif (($operations[$i] -eq "/") -and ($j -eq 0)) {
            $newAnswers[$i] = $newTerms[$i,$j]
        }
        elseif (($operations[$i] -eq "/") -and ($j -ne 0)) {
            $newAnswers[$i] /= $newTerms[$i,$j]
        }
    }
}
$totalAll = 0
for ($i = 0; $i -lt $numOperations; $i++) {
    $totalAll += $newAnswers[$i]
}
#$newTerms
$newAnswers
write-host "Sum of all Part2 Answers : $($totalAll)"
# 3263827 < 5328571 <