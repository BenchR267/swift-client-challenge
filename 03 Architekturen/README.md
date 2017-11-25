# Challenge: Architekturen

Die Aufgabe ist einen Github Pull-Request und Issue Tracker zu bauen. Damit man sich hier wirklich nur um die Implementation kümmert gibt es eine Boilerplate die uns das Leben erleichtert und jedem den gleichen optischen Output liefern sollte.

## Application Flow
Die App ermöglicht es für einen festgelegten Nutzernamen die App zu nutzen und durch dessen Repositories zu browsen. Wenn ein Repository ausgewählt wird werden noch einmal zusätzlich drei weitere calls abgesetzt um die detail Informationen, die Pull-Requests und die issues abzurufen. Wenn man ein Pull-Request oder ein Issue anklickt kommt man zu der jenigen HTML-Seite.

### Repository List
Lädt die Daten der Repositories von einem Nutzer und zeigt diese in einer TableView an.

**API Call**
```swift
let github = GithubAPIService()
let endpoint = GithubAPIService.Endpoint.userRepos(user: "mRs-")
github.responseDecodable(urlConvertible: endpoint) { (repos: Repositories?, response, error) in
    // DO Stuff
}
```

### Repository Details
Lädt die Detaildaten, die Issues und die Pull-Requests des ausgewählten Repository.

**API Calls**
```swift
let repositoryDetails = GithubAPIService.Endpoint.repo(fullRepoName: "mRs-/HexColors")
github.responseDecodable(urlConvertible: repositoryDetails) { (repo: Repository?, response, error) in
    // Do stuff
}
let issues = GithubAPIService.Endpoint.issues(fullReponame: "mRs-/HexColors")
github.responseDecodable(urlConvertible: issues) { (issues: Issues?, response, error) in
    // Do Stuff
}
let pullRequests = GithubAPIService.Endpoint.pullRequests(fullReponame: "mRs-/HexColors")
github.responseDecodable(urlConvertible: pullRequests) { (pullRequests: Pulls?, response, error) in
    // Do Stuff
}
```

| Architektur | Wer? |
|-----|---|
| VIPER | @schumi |
| MVVM | @bilalreffas |
| ELM | @ben |
| MVC | @marius_landwehr |
