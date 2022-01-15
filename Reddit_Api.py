import praw

reddit = praw.Reddit(client_id="NivQ32fjBvLnDc1MXR70Kw",
                     client_secret="xBewFjWNDf78Rj_UeZk6O5eZlHe_yg",
                     user_agent="ABC")


submission = reddit.submission(url="https://www.reddit.com/r/canada/comments/s46fmw/harry_rakowski_if_we_tax_the_unvaccinated_what/")
submission.comments.replace_more(limit=10)
for comment in submission.comments.list():
    print((comment.body).replace(">",""))