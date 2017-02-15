# cleaning_data_project
This is the repository containing files for the project of the Getting and cleaning data coursera class.

## The script works as follow:

1. It first retrieves the feature names from the feature.txt files.
2. Then it retrieves the activity id to activity name mapping from the activity_info.txt file.
3. It can now get the data sets (first the training, then the test set):
  1. The subject id that carried out the activity is extracted
  2. The activity id list is read and put in a variable
  3. The data set is retrieved from the disk with the column names.
  4. The subject id and activity id variables are added to the data set
  5. Activity ids are matched with their activity names which are added to the data set.
  6. Columns are filtered to keep only Mean and Standard Deviation
4. The train and test data sets are concatenated in one big data set
5. Average for each variable is calculated for each conbination of subject and acitivity.

