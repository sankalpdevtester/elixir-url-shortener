# Elixir URL Shortener
[![Language](https://img.shields.io/badge/language-elixir-orange.svg)](https://elixir-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## What it does
The Elixir URL Shortener is a simple service that allows users to shorten long URLs and access the original URL via a unique shortened link. It provides a convenient way to share links without having to deal with lengthy URLs. The service also includes features such as URL analytics and error handling.

## Features
* Shorten URLs
* Redirect to original URL
* URL analytics
* Error handling
* API documentation

## Requirements
* Elixir 1.13.4
* Phoenix Framework 1.7.2
* Ecto 3.9.1
* PostgreSQL 14.2

## Installation
To install the dependencies, run the following command:
```bash
mix deps.get
```
This will fetch all the required dependencies for the project.

## Usage
To start the server, run the following command:
```bash
mix phx.server
```
This will start the Phoenix server, and you can access the URL shortener service at [http://localhost:4000](http://localhost:4000).

Example usage:
```bash
# Shorten a URL
curl -X POST -H "Content-Type: application/json" -d '{"url": "https://www.example.com"}' http://localhost:4000/api/shorten

# Response
{"short_url": "http://localhost:4000/s/abc123"}

# Access the original URL
curl -X GET http://localhost:4000/s/abc123

# Redirects to the original URL
```
## Environment Variables
| Variable | Description |
| --- | --- |
| `DATABASE_URL` | The URL of the PostgreSQL database |
| `PORT` | The port number to start the server on |
| `SECRET_KEY_BASE` | The secret key base for encryption |

## Project Structure
```markdown
.
├── config
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   └── test.exs
├── lib
│   ├── elixir_url_shortener
│   │   ├── application.ex
│   │   ├── repo.ex
│   │   └── router.ex
│   ├── elixir_url_shortener_web
│   │   ├── controllers
│   │   ├── models
│   │   ├── routers
│   │   ├── templates
│   │   └── views
│   └── mix.exs
├── mix.exs
├── mix.lock
├── priv
│   └── repo
├── test
│   ├── elixir_url_shortener
│   │   ├── test_helper.exs
│   │   └── url_shortener_test.exs
│   └── test_helper.exs
└── README.md
```
## Contributing
Contributions are welcome! To contribute, please fork the repository, make your changes, and submit a pull request. Please ensure that your changes are tested and follow the existing coding style.

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.