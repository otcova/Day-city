echo none>="current-host.txt"

git add .
git commit -a -m "+"
:last_push
git push
if %errorlevel% neq 0 goto last_push

exit