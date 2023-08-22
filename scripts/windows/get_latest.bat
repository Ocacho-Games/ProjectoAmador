SET scriptPath=%~dp0

ECHO %scriptPath%
SET removePath=%scriptPath:*\Rikishi-Sumo=%
ECHO %removePath%

Echo We dont want: [%removePath%]

::Now remove the rest of the path from the original string
CALL SET "correctPath=%%scriptPath:%removePath%=%%"
CD %correctPath%

git add .
git stash save "Stashed things before get_latest"
git fetch
git checkout dev
git remote add template https://github.com/Ocacho-Games/Home-Godot
git fetch --all

FOR /F %%A IN ('DIR /B') DO (
    IF %%A == godot (
        CD %%A
        FOR /F %%B IN ('DIR /B') DO (
            IF %%B != project.godot (
                git checkout template/main %%B
            )
        )
        CD ..
    )
    ELSE
    (
        git checkout template/main %%A
    )
)

@REM git pull -X theirs template main --allow-unrelated-histories
@REM git remote remove template

@REM Pushing changes
@REM git push origin dev