:: Getting path in which the batch file is located
SET scriptPath=%~dp0

:: Getting the last part of the path so we can remove it later
ECHO %scriptPath%
SET removePath=%scriptPath:*\Rikishi-Sumo=%
ECHO %removePath%

:: Now remove the rest of the path from the original string
CALL SET "correctPath=%%scriptPath:%removePath%=%%"
CD %correctPath%

FOR /F "tokens=*" %%g IN ('git rev-parse --abbrev-ref HEAD') do (SET branchName=%%g)

:: Adding all possible changes and stashing them
git add .
git stash save "Stashed things before get_latest"
git fetch
:: Moving to main branch
git checkout main
:: Adding the new remote that points to the template repository
git remote add template https://github.com/Ocacho-Games/Home-Godot
git fetch --all

:: Iterate through folders and files and take changes from template unless file is project.godot
FOR /F %%A IN ('DIR /B') DO (
    IF %%A == godot (
        CD %%A
        FOR /F %%B IN ('DIR /B') DO (
            IF %%B NEQ project.godot (
                git checkout template/main %%B
            )
        )
        CD ..
    ) ELSE (
        git checkout template/main %%A
    )
)

:: Removing the template remote from local repository
git remote remove template

:: Pushing changes
git push origin main

:: Getting back to initial state
git checkout %branchName%
git stash pop 0