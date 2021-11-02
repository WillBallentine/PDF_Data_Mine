Start-Process powershell.exe -Verb RunAs {

    function convert-PDFtoText {
        param(
            [Parameter(Mandatory=$true)][string]$file
        )
        Add-Type -Path "C:\ps\itextsharp.dll"
        $pdf = New-Object iTextSharp.text.pdf.pdfreader -ArgumentList $file
        for ($page = 1; $page -le $pdf.NumberOfPages; $page++){
            $text=[iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($pdf,$page)
            Write-Output $text
        }
        $pdf.Close()
    }


    $content = Read-Host "What are we looking for?: "
    $file1 = Read-Host "Path to search: "
    
    Get-Childitem -Path $file1 -Recurse -Filter *.pdf | ForEach-Object { convert-PDFtoText $_.FullName } | Out-File "C:\ps\bulk.txt"



    Select-String -Path C:\ps\bulk.txt -Pattern $content | Out-File "C:\ps\select.csv"
    Select-String -Path C:\ps\bulk.txt -Pattern $content | Out-File "C:\ps\selectbackup.txt"



    Start-Sleep -Seconds 60
}
