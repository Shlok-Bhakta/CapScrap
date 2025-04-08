# CapScrap 🎩✨

[![Rails Version](https://img.shields.io/badge/Rails-8-%23CC0000)](https://rubyonrails.org)
[![Heroku Deployment](https://img.shields.io/badge/Deployed-Heroku-430098)](https://heroku.com)
[![Test Coverage](https://codecov.io/gh/Shlok-Bhakta/CapScrap/branch/main/graph/badge.svg)](https://codecov.io/gh/Shlok-Bhakta/CapScrap)
[![GitHub Issues](https://img.shields.io/github/issues/Shlok-Bhakta/CapScrap)](https://github.com/Shlok-Bhakta/CapScrap/issues)

**Texas A&M's Ultimate Capstone Inventory Management System**  
Never lose track of project resources again! Built with ❤️ using Rails 8

![CapScrap Demo](https://raw.githubusercontent.com/Shlok-Bhakta/CapScrap/main/public/screenshot.png)

## Features 🚀
- **🔍 Smart Inventory Tracking** with auto-categorization
- **👥 Team Collaboration** with role-based access
- **📅 Project Timeline Visualization** using Gantt charts
- **📊 Real-time Analytics Dashboard**
- **🔔 Automated Resource Alerts**

## Tech Stack 💻
| Area          | Technologies                          |
|---------------|---------------------------------------|
| Backend       | Ruby on Rails 8, PostgreSQL          |
| Frontend      | Hotwire, StimulusJS, Tailwind CSS     |
| Deployment    | Heroku, Redis, Sidekiq                |
| Monitoring    | New Relic, Rollbar                    |

## Installation 🛠️
1. Clone repo:
```sh
git clone https://github.com/Shlok-Bhakta/CapScrap.git
cd CapScrap
```

2. Setup dependencies:
```sh
bundle install
yarn install
```

3. Configure database:
```sh
rails db:setup
```

4. Start server:
```sh
bin/dev
```

## Deployment to Heroku 🚀

### Setting Up Environment Variables
1. Create a `.env` file in the root directory with the following structure (replace with your own values):
```sh
CLIENT_ID=your_google_client_id_here
CLIENT_SECRET=your_google_client_secret_here
URL=http://localhost:3000
```

2. For production, update the URL to your Heroku app URL when deployed.

### Google OAuth Setup
1. Visit the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use existing one)
3. Go to "APIs & Services" > "Credentials"
4. Click "Create Credentials" > "OAuth client ID"
5. Select "Web application" as the application type
6. Set up authorized redirect URIs:
   - `http://localhost:3000/auth/google_oauth2/callback` (for development)
   - `https://your-app-name.herokuapp.com/auth/google_oauth2/callback` (for production)
7. Click "Create" and note down your Client ID and Client Secret
8. For detailed instructions, refer to [Google's OAuth 2.0 guide](https://developers.google.com/identity/protocols/oauth2)

### Heroku Deployment via Dashboard
1. Go to the [Heroku Dashboard](https://dashboard.heroku.com/)
2. Click "New" > "Create new app"
3. Enter a unique app name and select your region
4. In the "Resources" tab, search for "PostgreSQL" in the Add-ons section and add it to your app
5. Go to the "Settings" tab and click "Reveal Config Vars"
6. Add the following environment variables:
   - `CLIENT_ID` with your Google Client ID
   - `CLIENT_SECRET` with your Google Client Secret
   - `URL` with `https://your-app-name.herokuapp.com`
7. In the "Deploy" tab, connect your GitHub repository by pasting the GitHub URL
8. Click "Deploy Branch" to deploy your app
9. Once deployed, go to the "More" dropdown and select "Run Console"
10. Run database migrations:
```sh
rails db:migrate
```
11. Open your deployed app by clicking "Open App"

## Contributors ✨
[![GitHub Contributors](https://contrib.rocks/image?repo=Shlok-Bhakta/CapScrap)](https://github.com/Shlok-Bhakta/CapScrap/graphs/contributors)

## License 📄
Distributed under the MIT License. See `LICENSE.md` for details.

---

**Keep calm and capstone on!** 🎓⚡  