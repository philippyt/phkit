[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("sync", "init", "list")]
    [string]$Command,

    [Parameter(Position = 1)]
    [string]$Template = "general",

    [string]$Target = (Get-Location).Path,

    [string[]]$Rules = @(),

    [switch]$ClaudePointer,

    [switch]$Force
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Invoke-Sync {
    $AgentsSource = Join-Path $RepoRoot "AGENTS.md"
    $SkillsSource = Join-Path $RepoRoot "skills"

    $GlobalInstructionTargets = @(
        (Join-Path $HOME ".codex\AGENTS.md"),
        (Join-Path $HOME ".claude\CLAUDE.md"),
        (Join-Path $HOME ".gemini\GEMINI.md"),
        (Join-Path $HOME ".config\opencode\AGENTS.md")
    )

    foreach ($dest in $GlobalInstructionTargets) {
        $parent = Split-Path -Parent $dest
        if (-not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Copy-Item -Path $AgentsSource -Destination $dest -Force
        Write-Host "synced AGENTS.md -> $dest"
    }

    $SkillRoots = @(
        (Join-Path $HOME ".agents\skills"),
        (Join-Path $HOME ".claude\skills"),
        (Join-Path $HOME ".codex\skills")
    )

    $skillDirs = Get-ChildItem -Path $SkillsSource -Directory
    foreach ($root in $SkillRoots) {
        if (-not (Test-Path $root)) {
            New-Item -ItemType Directory -Path $root -Force | Out-Null
        }
        foreach ($dir in $skillDirs) {
            $destDir = Join-Path $root $dir.Name
            if (Test-Path $destDir) {
                Remove-Item -Path $destDir -Recurse -Force
            }
            Copy-Item -Path $dir.FullName -Destination $destDir -Recurse -Force
        }
        Write-Host "synced $($skillDirs.Count) skills -> $root"
    }
}

function Invoke-Init {
    $templatePath = Join-Path $RepoRoot "templates\$Template.md"
    if (-not (Test-Path $templatePath)) {
        throw "unknown template '$Template'. run '.\scripts\phkit.ps1 list' to see available templates."
    }

    if (-not (Test-Path $Target)) {
        New-Item -ItemType Directory -Path $Target -Force | Out-Null
    }

    $outPath = Join-Path $Target "AGENTS.md"
    if ((Test-Path $outPath) -and -not $Force) {
        throw "$outPath already exists. pass -Force to overwrite."
    }

    $parts = [System.Collections.Generic.List[string]]::new()
    $parts.Add((Get-Content -Path $templatePath -Raw).TrimEnd())

    # PowerShell splits comma-separated CLI args into an array; also handle a single comma-delimited string.
    $flatRules = $Rules | ForEach-Object { $_ -split "," } | Where-Object { $_.Trim() -ne "" }
    foreach ($rule in $flatRules) {
        $name = $rule.Trim()
        $rulePath = Join-Path $RepoRoot "rules\$name.md"
        if (-not (Test-Path $rulePath)) {
            throw "unknown rule '$name'. run '.\scripts\phkit.ps1 list' to see available rules."
        }
        $parts.Add((Get-Content -Path $rulePath -Raw).TrimEnd())
    }

    $content = ($parts -join "`n`n") + "`n"
    Set-Content -Path $outPath -Value $content -Encoding UTF8 -NoNewline
    Write-Host "wrote $outPath"

    if ($ClaudePointer) {
        $claudePath = Join-Path $Target "CLAUDE.md"
        if ((Test-Path $claudePath) -and -not $Force) {
            throw "$claudePath already exists. pass -Force to overwrite."
        }
        Set-Content -Path $claudePath -Value "@AGENTS.md`n" -Encoding UTF8 -NoNewline
        Write-Host "wrote $claudePath"
    }
}

function Invoke-List {
    Write-Host "templates:"
    Get-ChildItem -Path (Join-Path $RepoRoot "templates") -Filter "*.md" | ForEach-Object {
        Write-Host "  $($_.BaseName)"
    }
    Write-Host "rules:"
    Get-ChildItem -Path (Join-Path $RepoRoot "rules") -Filter "*.md" | ForEach-Object {
        Write-Host "  $($_.BaseName)"
    }
    Write-Host "skills:"
    Get-ChildItem -Path (Join-Path $RepoRoot "skills") -Directory | ForEach-Object {
        Write-Host "  $($_.Name)"
    }
}

switch ($Command) {
    "sync" { Invoke-Sync }
    "init" { Invoke-Init }
    "list" { Invoke-List }
}
