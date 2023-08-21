SET scriptPath=%~dp0

ECHO %scriptPath%
SET removePath=%scriptPath:*\Rikishi-Sumo=%
ECHO %removePath%

Echo We dont want: [%removePath%]

::Now remove the rest of the path from the original string
CALL SET "correctPath=%%scriptPath:%removePath%=%%"
CD %correctPath%

ECHO Get-Location

@REM git add .
@REM git stash save "Stashed things before get_latest"
@REM git fetch
@REM git checkout dev
@REM git remote add template https://github.com/Ocacho-Games/Home-Godot
@REM git fetch --all
@REM git pull -X theirs template main --allow-unrelated-histories
@REM git remote remove template

@REM Pushing changes
@REM git push origin dev