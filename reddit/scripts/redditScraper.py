#! usr/bin/python3
import praw
import pandas as pd
import datetime as datetime
from RedditAPI import accinfo

info = accinfo()
count = 0

reddit = praw.Reddit(client_id=info[0], client_secret=info[1], user_agent=info[2], username=info[3], password=info[4])

posts_dict = { "date":[], "platform":[], "url":[], "title":[], "body":[], "author":[], "num_comments":[], "ups":[] }
subr_list = ['matlab', 'neuro', 'learnprogramming', 'EngineeringStudents', 'ProgrammerHumor', 'AskEngineers', 'engineering', 'programming', 'math', 'ElectricalEngineering', 'MachineLearning', 'ControlTheory', 'ECE', 'arduino', 'Julia', 'engineeringmemes', 'Physics', 'computervision', 'datascience', 'neuroscience', 'AskProgramming', 'learnmachinelearning', 'learnmath', 'AskAcademia', 'MATLABAssignment', 'MATLABhate', 'matlab_octave', 'MatlabMasterRace', 'matlabpros']

for subr in subr_list:
	print(subr)
	for submission in reddit.subreddit(subr).search('matlab', limit=1000):
		count+=1
		posts_dict["date"].append(submission.created)
		posts_dict["platform"].append("Reddit")
		posts_dict["url"].append(submission.url)
		posts_dict["title"].append(submission.title)
		posts_dict["body"].append(submission.selftext)
		posts_dict["author"].append(submission.author.name)
		posts_dict["num_comments"].append(submission.num_comments)
		posts_dict["ups"].append(submission.ups)
		print(count)
		print(submission.title)

	for submission in reddit.subreddit(subr).search('simulink', limit=1000):
		count+=1
		posts_dict["date"].append(submission.created)
		posts_dict["platform"].append("Reddit")
		posts_dict["url"].append(submission.url)
		posts_dict["title"].append(submission.title)
		posts_dict["body"].append(submission.selftext)
		posts_dict["author"].append(submission.author.name)
		posts_dict["num_comments"].append(submission.num_comments)
		posts_dict["ups"].append(submission.ups)
		print(count)
		print(submission.title)

	for submission in reddit.subreddit(subr).search('mathworks', limit=1000):
		count+=1
		posts_dict["date"].append(submission.created)
		posts_dict["platform"].append("Reddit")
		posts_dict["url"].append(submission.url)
		posts_dict["title"].append(submission.title)
		posts_dict["body"].append(submission.selftext)
		posts_dict["author"].append(submission.author.name)
		posts_dict["num_comments"].append(submission.num_comments)
		posts_dict["ups"].append(submission.ups)
		print(count)
		print(submission.title)

	for submission in reddit.subreddit(subr).search('polyscape', limit=1000):
		count+=1
		posts_dict["date"].append(submission.created)
		posts_dict["platform"].append("Reddit")
		posts_dict["url"].append(submission.url)
		posts_dict["title"].append(submission.title)
		posts_dict["body"].append(submission.selftext)
		posts_dict["author"].append(submission.author.name)
		posts_dict["num_comments"].append(submission.num_comments)
		posts_dict["ups"].append(submission.ups)
		print(count)
		print(submission.title)


	for submission in reddit.subreddit(subr).search('simscape', limit=1000):
		count+=1
		posts_dict["date"].append(submission.created)
		posts_dict["platform"].append("Reddit")
		posts_dict["url"].append(submission.url)
		posts_dict["title"].append(submission.title)
		posts_dict["body"].append(submission.selftext)
		posts_dict["author"].append(submission.author.name)
		posts_dict["num_comments"].append(submission.num_comments)
		posts_dict["ups"].append(submission.ups)
		print(count)
		print(submission.title)
		

posts_data = pd.DataFrame(posts_dict)
posts_data.to_csv(r'./redditDatafinal.csv')