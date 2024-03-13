## Readme

- Build with Xcode 15.1
- On app first launch, loading headlines will fail, because no source has been selected. In real project we can fetch source first, or make better prompt. In this demo keep as is due to time constraint. After selecting source on the Sources tab, click reload on Headlines tab should correctly loading the news.
- After change source, can manually click the refresh button on top right corner of Headlines tab to reload.
- Once open a news, click the star button on top right corner to save/unsave.
- After save/unsave news, the list on Saved tab will automatically refresh to reflect the change.
- I noticed many news are loading quite slow, but didn't add progress bar on the news screen due to time constraint.
- No source control included as there is no requirement, also to keep project small. In real project should always use source control.
