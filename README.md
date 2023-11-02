# Paper

Responsive Docs app, compatible with Android and Web platforms.

#### Screenshots:


<img src="https://i.ibb.co/NsgK8gf/Screenshot-from-2023-11-03-01-02-39.png" width="800" height="400">

<img src="https://i.ibb.co/hRKYCCg/ss2.png" width="800" height="400">

<img src="https://i.ibb.co/d0TYJWJ/ss3.png" width="800" height="400">


### Features
- Google Authentication
- State Persistence
- Link sharing
- Auto saving
- Collaborative Editing using SocketIo


### Project Structure
```
paper/
|- android/
|- assets/
|- build/
|- lib/
|- web/
|- server/
|- pubspec.yaml
|-README.md
```

```
lib/
|- client/
|- common/
|- constants/
|- models/
|- repository/
|- views/
|- main.dart
```





### Tech Stack
**Backend**: Nodejs, Express, MongoDB, Mongoose, SocketIO

**Frontend**: Flutter

**State Management**: Riverpod

### Setting up Server 
 <p> Go to sever folder or download the server folder from the release section </p>

1. Create a .env file and make an environment variable named MONOGOOSE_CONNECTION_STRING with a value equal to the MongoDB connection string.
2.  ``` npm i ```
3. ``` node server.js ```
