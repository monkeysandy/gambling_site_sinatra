# COEN 278 Assignment 3 (23-Fall)

## Introduction

This assignment involves implementing a simple bet web application using the Sinatra web development framework. The web application allows users to place bets on a dice game and keeps track of their wins, losses, and profits.

## Concept Design

The web application follows a specific design flow:

### Welcome View

When a user visits the gambling site, they are presented with a welcome view.

### User Options

The user is given two options:
- **Logon**: Allows existing users to log in.
- **Sign Up**: Initializes the database table with user login information (plain text) for new users.

### Login View

Users can log in using their username and password. If the login is successful, they are redirected to the betting view. If the login fails, an error message is displayed.

### Betting View

In the betting view, users can place bets on a dice game by specifying the amount of money they want to bet and the number they are betting on. After placing a bet, the application displays whether the user has won or lost.

Two sets of data are displayed in this view:
- **Session Data (Right)**: These values represent the total wins, losses, and profits during the current login session. These values start at 0 after login and are saved in the session hash.
- **User Data (Bottom)**: These values represent the total wins, losses, and profits for the user since their first login. These values are retrieved from the database table and displayed at the bottom.


### Logout

When a user logs out, the application adds the session's wins and losses to the user's total values and updates the database table. The logout button clears the session and returns the user to the login page.

### See All Users (Developer's Feature)

For developers, a special route `/users` is available to view all the users in the system. This route displays a table with username, password, total wins, losses, and profits for each user. You can also delete the account here.

## Usage

1. Visit the gambling site.
2. Choose between logging in or signing up.
3. Log in with your username and password.
4. Place bets in the betting view.
5. Log out to save your session data to the database.

## Installation

1. Clone the repository.
2. Install required dependencies by `bundle install`.
3. Run the Sinatra web application by `rackup`.

## Author

Sandy Liu


