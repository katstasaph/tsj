# README

## Requirements
- Ruby: 2.7.5
- Rails: 7.1.2
- PostgreSQL

To initialize the database, run `rails db migrate` in the console.

# Notes

- This uses Devise for user authentication, and Pundit for role-based authorization.

# Todo:

## Features:

- Add image to WordPress post HTML, this is currently unfinished because it is not needed until January 31 really
- Post scheduling: schedule posts to go up at a certain time (can just use WordPress's API for that), and/or queue posts to go up at next available time slot (likely w/ Active Job)
- Also post scheduling: associate songs w/ day they (we hope) run, with ability to swap, like the old blurber
- Editable message to users (low hanging fruit)
- Raw HTML and/or Markdown text editor
- Notification to editors before closing if a writer has the blurb entry field open (probably needs a timeout in case someone leaves the tab open)
- Notification to writers that a post has closed while they are editing/composing a blurb (requires server sent events, probably)
- Blurb backup system
- Make the frontend actually look nice, including on mobile. in particular, the wad o' links at the top
- Automatically generate HTML for Tumblr and Cohost and any other social media platforms we may want to utilize
- "Edit all the blurbs together before posting" (did anyone ever use this)
- Recreate the writer stats page (editors and up)
- Open/close comments/rating? (low priority)
- Video and/or audio embeds in the blurber (not the highest priority, but will probably help writers)

## Improvements:

- Look further into performance, in particular whether caching is necessary beyond what is currently there (at this scale, maybe not?)
- Pagination? (do we really need this)
- Add option for editors to close a song from the index page?
- Add a toggle for drag/drop rearranging blurbs, currently it is a little annoying if you want to highlight some text to copy/paste
- Actually get rid of the image attachment feature in the rich text editor instead of just display:none on the icon
- Get this off render

## Known bugs:

- Flash messages persist in their view prior to re-rendering, this looks bad

## Other necessities:

- Make the code less of a mess, a lot of stuff is happening where it shouldn't
- Test suite 
