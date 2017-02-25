# Project 4, 5 - *Twitter*

**Twitter** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **30** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] Retweeting and favoriting should increment the retweet and favorite count.

**update for assignment 5**
- [x] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] Profile page:
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline: Tapping on a user image should bring up that user's profile page
- [x] Compose Page: User can compose a new tweet by tapping on a compose button.
The following **optional** features are implemented:

- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] User can pull to refresh.
- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [x] Pulling down the profile page should blur and resize the header image.
- [x] Account switching
   - [x] Long press on tab bar to bring up Account view with animation
   - [] Tap account to switch to
   - [x] Include a plus button to Add an Account
   - [x] Swipe to delete an account


The following **additional** features are implemented:

- [x] List anything else that you can get done to improve the app functionality!
- [x] Use custom presentation for presenting view controller to improve user experiece (slide in and out)
- [x] Log out implmented
- [x] Animate icons changes after retweet and favor
- [x] Added tabbar 
- [x] Added media to tweet
- [x] Added Following, Edit Profile button based upon the relationship with the profile user
- [x] Added Followers in user's profile
- [x] Added Followings in user's profile
- [x] Notification Center
- [x] Messages
- [x] Profile links in user's profile using WebView
- [x] Implemnted web view progressing bar
- [x] Style mentioneds, hashTags, links using NSAttributedString
- [x] Added media filter in the user's profile(see only the tweets with media)
- [x] Added the likes filter showing the tweets that the user likes
- [x] Added Media preview in the and zoom
- [x] Implmented the Twitter introduction scale effect











Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Add tab bar, notification, profile scene, etc
2. Load media and add attributed string for hash tag, link, etc

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/kesongxie/CodePath-Week4-5-Twitter/blob/master/Twitter/Gif%20Demo/Twitter-update.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Twitter API, Model, etc 

## License

    Copyright [2017] [Kesong Xie]
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
