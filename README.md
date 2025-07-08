# README

## Requirements
- Ruby: 3.1.0
- Rails: 7.1.2
- PostgreSQL
- Redis

To initialize the database, run `rails db migrate` in the console.

# Notes

- Major gems: Devise for user authentication, Pundit for role-based authorization, Sidekiq for concurrent edit checking.

# Todo:

## Features:

- Automated post scheduling: instead of choosing a time to schedule, enqueue posts to go up at next available time slot (likely w/ Active Job)
- Add a visible schedule table to the announcement panel, like the old blurber had, with ability to edit
- Raw HTML and/or Markdown text editor
- Notification to writers that a post has closed while they are editing/composing a blurb
- Automatically schedule cross-post to social media (Bluesky, Tumblr, ???) upon scheduling
- Recreate the writer stats page (separate views for writers vs. editors and up)
- Editor-only announcement field (to coordinate in blurber with future editors), either on index or associated w/ songs
- Video and/or audio embeds in the blurber (not the highest priority, but will probably help writers)
- Automatically add audio links to Spotify playlist, and clear the playlist on month rollover

## Improvements:

- Improve the frontend UI, particularly for mobile (priorities: blurbs by user, admin panel)
- Strip excess divs that the rich text editor produces
- Add option for editors to close a song from the index page
- Add a toggle for drag/drop rearranging blurbs, currently it is a little annoying if you want to highlight some text to copy/paste
- Actually get rid of the image attachment feature in the rich text editor instead of just display:none on the icon
- "Edit all the blurbs together before posting" (did anyone ever use this)
- Improve test coverage
- Get this off render

## Known bugs

See Issues tab for full list.
