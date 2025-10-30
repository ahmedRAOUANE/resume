# LaTeX Resume

This repository contains my professional resume written in LaTeX. The project includes a small build helper (`build.ps1`) that compiles the LaTeX source and renames the generated PDF to include the semantic version defined in `resume.tex`.

## Prerequisites

Before building, install the following:

- A LaTeX distribution that provides `pdflatex` (for example: TeX Live, MiKTeX, or MacTeX).
- On Windows: PowerShell (the script uses native PowerShell; the repository includes `build.ps1`).
- Ensure `pdflatex` is on your PATH so the scripts can run it from the project root.

Optional tools:

- `make` (only if you add or restore a `Makefile` and run from WSL, Git Bash, or other Unix-like shells). This repo currently uses `build.ps1`.

## How the build helper works

The included `build.ps1` extracts a semantic version from `resume.tex` and renames the output PDF. It expects a line in `resume.tex` like:

```tex
\newcommand{\version}{v1.2.3}
```

If that line is present, running the build script will produce a file named `ahmed-resume-v1.2.3.pdf` (the `v1.2.3` part comes from your `\version` value).

## Building on Windows (PowerShell)

1. Open PowerShell and change to the project directory (where `resume.tex` lives).

2. run the command on powershell
```powershell
.//build.ps1
```

3. On success you should see:

```
Created ahmed-resume-v1.2.3.pdf
```

Notes:

- `build.ps1` runs `pdflatex` twice to resolve cross-references and table-of-contents entries.
- If the script cannot extract the version it will exit with an error explaining that it expects a `\newcommand{\version}{...}` line.
- If `pdflatex` is not found, install a LaTeX distribution and ensure `pdflatex` is on PATH.

## Building on Unix-like systems (optional)

If you prefer using `make` from WSL/Git Bash/MSYS, you can create or restore a `Makefile` that:

- extracts the version from `resume.tex` (same format as above),
- runs `pdflatex` twice,
- renames/moves `resume.pdf` to the versioned filename.

This repository currently uses `build.ps1` for native Windows builds.

## Troubleshooting

- "Could not extract version": Open `resume.tex` and add or correct the line that defines `\version` (see example above).
- "pdflatex not found": Install a LaTeX distribution and ensure `pdflatex` is reachable from the shell you're using.
- Check the generated `.log` file (e.g., `resume.log`) for LaTeX compilation errors.

## Files

- `resume.tex` — main LaTeX source (tracked)
- `build.ps1` — Windows PowerShell build helper (tracked)
- `.gitignore` — ignores build artifacts and temporary LaTeX files

## License

Feel free to use this repository as a template or starting point for your own resume. Do not copy personal content verbatim without permission.