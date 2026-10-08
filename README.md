# landing-page

The landing page for the UCF EGN 4641C (Engineering Entrepreneurship) live event
operations research: who we are, what we're studying, what the conversation looks
like, and a short form for practitioners willing to talk with us.

- `index.html` is the whole page. The form posts to the team's Apps Script web app
  (`BOOKING_ENGINE`), which emails each submission to the team inbox (`TEAM_EMAIL`).
- `team/` holds the headshots: 240px square WebP, one per person.
- `./publish.sh` checks the page (engine URL set, no stray email addresses) and
  pushes `main`, which GitHub Pages serves.
