# Getting path in which the batch file is located
scriptPath="$(dirname "$(readlink -f "$0")")"
echo "Script directory: $scriptPath"

echo $scriptPath | sed 's/\(Rikishi-Sumo\).*/\1/g'

git config --global --add safe.directory Z:/Ocacho/Rikishi-Sumo

branchName=$(git rev-parse --abbrev-ref HEAD)

echo $branchName

# Adding all possible changes and stashing them
git add .
git stash save "Stashed things before get_latest"
git fetch
# Moving to main branch
git checkout main
git pull origin main
# Adding the new remote that points to the template repository
git remote add template https://github.com/Ocacho-Games/Home-Godot
git fetch --all

# Iterate through folders and files and take changes from template unless file is project.godot
shopt -s extglob
shopt -s dotglob

for file in * ; do
    if [[ $file == "godot" ]]
    then
        cd $file
        for subfile in * ; do
            if [[ $subfile != "project.godot" ]]
            then
                git checkout template/main $subfile ;
            fi
        done
        cd ..
    else
        git checkout template/main $file ;
    fi
done

# Pushing changes
git add .
git commit -m "Updating repository from template"
git push origin main

# Removing the template remote from local repository
git remote remove template

# Getting back to initial state
git checkout $branchName
git stash pop 0