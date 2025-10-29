# build.ps1

# Robust build script for Windows PowerShell
# - extracts a semantic version from resume.tex (expects: \newcommand{\version}{vX.Y.Z})
# - runs pdflatex twice (helps with cross-references/toc)
# - fails with clear messages if version or pdf isn't produced

$resume = "resume.tex"
if (-not (Test-Path $resume)) {
    Write-Error "File '$resume' not found. Run this from the project root where resume.tex lives."
    exit 1
}

# Try to extract version like: \newcommand{\version}{v1.2.3}
$match = Select-String -Path $resume -Pattern '\\newcommand\{\\version\}\{(v[0-9]+\.[0-9]+\.[0-9]+)\}' -AllMatches
$version = if ($match -and $match.Matches.Count -gt 0) { $match.Matches[0].Groups[1].Value } else { $null }

if ([string]::IsNullOrEmpty($version)) {
    Write-Error "Could not extract version from $resume. Make sure you have a line like: \newcommand{\version}{v1.2.3}"
    exit 1
}

Write-Host "Building resume (version $version)..."

function Run-PDFLaTeX {
    $proc = Start-Process -FilePath "pdflatex" -ArgumentList "-interaction=nonstopmode", $resume -NoNewWindow -Wait -PassThru -ErrorAction Stop
    return $proc.ExitCode
}

# Run twice to resolve references
$ec = Run-PDFLaTeX
if ($ec -ne 0) {
    Write-Error "pdflatex failed (exit code $ec). Check the .log file for details."
    exit $ec
}

$ec = Run-PDFLaTeX
if ($ec -ne 0) {
    Write-Error "pdflatex failed on the second run (exit code $ec). Check the .log file for details."
    exit $ec
}

if (-not (Test-Path "resume.pdf")) {
    Write-Error "resume.pdf was not generated. pdflatex did not produce the file."
    exit 1
}

# for this one you can remove ahmed or replace it with anything you want
$out = "ahmed-resume-$version.pdf"
Rename-Item -Path "resume.pdf" -NewName $out -Force
Write-Host "Created $out"
