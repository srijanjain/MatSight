# importing modlue
from pandas import *
  
# reading CSV file
data = read_csv("../Downloads/stackOverlow.csv", error_bad_lines=False)
d = {}
l = []
tags = data['tags'].tolist()
for tag in tags:
	text = tag[1:-1]
	text = text.split(',')
	for t in text:
		t = t.replace(" ", "")
		t = t.replace("'", "")
		if t not in d:
			d[t] = 1
for tag in d:
	l.append(tag)
print(l)
