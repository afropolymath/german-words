# german-words

Flashcard application for learning German words

http://afropolymath.github.io/german-words

### Running the application

To run the application, navigate to the project folder and run the following command:

```sh
yarn dev
```

The project makes use of yarn for the development environment. [yarn](http://yarn.dev) is used to run the development server as well as build the scss files (using node-sass).

For compiling the Elm files, yarn triggers the `elm make` command which builds the js and html into the `/docs` folder.

### Technology

The primary technology used in the application is Elm. [Elm](http://elm.com) is a functional web programming language that is able to compile down to HTML and Javascript. Because of Elm's incredible type system and compiler, your built applications will [hardly ever]() run into arbitrary program errors like null pointers or uncaught exceptions at runtime.

Apart from Elm, we make use of SCSS for stying. These are compiled down to css using node-sass.

As mentioned before, yarn is used as a central package/task manager for the application. See [package.json](./package.json) for more details.

### Application Structure

Here's what the application structure looks like:

```sh
.
├── LICENSE
├── Makefile
├── README.md
├── assets
│   └── scss
│       └── main.scss
├── docs
│   ├── css
│   │   └── main.css
│   ├── data
│   │   ├── decks.json
│   │   └── title.txt
│   ├── index.html
│   └── js
│       └── app.js
├── elm.json
├── now.json
├── package.json
├── src
│   ├── AppTypes.elm
│   ├── Decks.elm
│   ├── Main.elm
│   ├── Ports.elm
│   ├── State.elm
│   └── views
│       ├── DeckView.elm
│       └── MainView.elm
└── yarn.lock
```

The directories you are interested in are `/src` and `/assets`. The `/src` folder contains all the Elm source files while `/assets` for now contains just the SCSS files. Ideally, image assets and other 3rd party vendor assets will also go into the assets folder.

For the Elm application, there are some standards we follow that makes things easier to manage and the code easy to follow:

- `src/State.elm` - This file contain the state definition which consist mostly of the `init` function used to initialize the state and hence the application, and the `update` method which is run everytime we make an update to the application model. Besides these functions, we also include any utility functions used by these main functions in there.
- `src/AppTypes.elm` - This file contains the definitions of all the type used in the application.
- `src/Main.elm` - This is the entry point of our application and contains the single call to the `Browser.element` function.
- `src/views/*` - This folder contains the 'views' of the applications. A view is referred to as a screen or a page in the application. This way we clearly separate out each view and it's utility functions into single files.
- `src/Ports.elm` - This file is used for defining all the functions used for Javascript Interop.
