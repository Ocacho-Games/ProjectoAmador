set file=".gitignore"

IF NOT EXIST %file% cd ..

echo.>>.gitignore
echo *.project>>.gitignore

type .gitignore

FOR /F "delims=*" %%g IN ('FINDSTR /R /I /V ".project" .gitignore') do echo %%g>>.gitignore_aux

DEL /F .gitignore

RENAME .gitignore_aux .gitignore

@REM git add .
git stash save "Stashed things before get_latest"
git fetch
git checkout dev
git remote add template https://github.com/Ocacho-Games/Home-Godot
git fetch --all
git pull -X theirs template main --allow-unrelated-histories
git remote remove template

@REM Pushing changes
@REM git push origin dev