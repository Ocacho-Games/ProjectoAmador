@REM Configuring Git in order to be able to push the changes
git config --global pull.rebase false
git config --global user.name DavidOcacho
git config --global user.email david.ocacho@gmail.com

git add .
git stash save "Stashed things before get_latest"
git fetch
git checkout dev
git remote add template https://github.com/Ocacho-Games/Home-Godot
git fetch --all
git pull -X theirs template main --allow-unrelated-histories
git remote remove template

@REM Pushing changes
git push

