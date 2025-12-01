ps -ef | rg aria2c | rg -v rg | awk '{print $2}' | xargs kill -9
