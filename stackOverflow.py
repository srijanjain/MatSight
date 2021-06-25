from stackapi import StackAPI
import csv

SITE = StackAPI('stackoverflow')
SITE.page_size = 100
SITE.max_pages = 100
data = SITE.fetch('questions', tagged='matlab', sort='creation')

questions = data['items']

# now we will open a file for writing
data_file = open('creation.csv', 'w')

# create the csv writer object
csv_writer = csv.writer(data_file)

# Counter variable used for writing
# headers to the CSV file
count = 0

for item in questions:
    if count == 0:

        # Writing headers of CSV file
        header = item.keys()
        csv_writer.writerow(header)
        count += 1

    # Writing data of CSV file
    csv_writer.writerow(item.values())

data_file.close()
