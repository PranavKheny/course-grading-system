# Ruby on Rails Project: course-grading-system
Ruby on Rails Project to Manage Student Graders for Ohio State University CSE department to assign undergrads to the right course sections for grading.
OSU Course Grading System
The OSU Course Grading System is a Ruby on Rails web application designed to streamline the process of assigning undergraduate graders to course sections within the Ohio State University (OSU) CSE department. This system simplifies coordination, reduces administrative overhead, and ensures efficient grader allocation through a user-friendly interface.

Features
User Authentication & Authorization: Secure login/logout for Students, Instructors, and Admins. Role-based access control, with Admin approval required for Instructor/Admin accounts. Users can specify their availability.

Course & Section Management: Displays detailed course and section information, including schedules and grader requirements.

Student Functionality: Students can submit grader applications for specific courses, indicating course preferences for consideration.

Instructor Functionality: Verified Instructors can recommend students for grader positions.

Admin Functionality: Admins have comprehensive control over the course catalog (add, edit, delete, API reload) and can approve/deny student grader applications, as well as manage Instructor/Admin account requests.

Requirements
Ensure you have the following installed:

Ruby: Version 3.2.2

Rails: Version 7.1.3

SQLite: Version 1.4

Installation
Follow these steps to set up the application locally:

Clone the repository:

git clone <repository-url>

Install dependencies:

bundle install

Set up the database:

rails db:create db:migrate

Create default admin account:

rails db:seed

(Default Admin: admin.1@osu.edu, Password: Password123)

Start the Rails server:

rails server

Usage Guide
Account Creation: Sign up with your OSU email (name.#@osu.edu format) and select your role (Student, Instructor, or Admin). Admin approval is required for Instructor/Admin roles.

Login: Access the system via the home page.

Profile Management: Update your availability by clicking time slots in your profile and saving.

Student Applications: Students can submit grader applications by providing a phone number, selecting a course, and indicating grading assignment preferences.

Course Catalog: Browse the course catalog, with filtering options available once logged in.

Logout: Use the "Sign Out" tab to log out.

API Documentation
Course information is fetched from OSU's public APIs:

Class Search: https://class-search-api.osu.edu/v1/classes/search

Content API: https://content.osu.edu/v2/classes/search

Troubleshooting
App Unresponsive/Incorrect Behavior: If the application becomes unrecoverable due to accidental modifications, delete the local repository and re-follow the installation steps.

Email Domain Restriction: The app is designed for .osu.edu emails. This restriction can be modified in app/models/user.rb (line 9).

API Downtime: If the primary OSU Class Search API is down, you can switch the base URL in app/services/course_service.rb to https://contenttest.osu.edu/v2/classes/search.

Gems Used
devise: User authentication

rails: Ruby on Rails framework

sqlite3: Database adapter for Active Record

puma: Web server

httparty: HTTP client
