
```sh
git branch
git log
git checkout --orphan tmp			# 创建孤立分支
git branch -a
git rm -rf .
git status
docker cp pages_pages_1:/opt/data/_book .
mv _book/* .
rmdir _book/
git add .
git commit -m "Initial commit"
git branch -D gh-pages				# 删除分支
git branch
git branch -m gh-pages  			# 重命名当前分支为gh-pages，如果分支名字已经存在，则需要使用-M强制重命名
git branch -a
git push -u origin gh-pages
git push -f -u origin gh-pages		# -f 强制推送
```