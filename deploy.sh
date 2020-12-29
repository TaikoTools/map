git add -a
git commit -m "deploy"
git checkout gh-pages
git merge master
nim js -d:release main.nim
git add main.js
git commit -m "deploy"
git push origin gh-pages
git checkout master