Examples to go along with my Steemit article, [Elm: Commands and Subscriptions and Ports. Oh My!](https://steemit.com/elm/@billstclair/elm-commands-and-subscriptions-and-ports-oh-my).

You can try ```csp.elm``` as follows:

```
cd .../elm-csp
elm reactor
```

Then aim your web browser at:

```
http://localhost:8000
```

And click on ```csp.elm```.

You can NOT successully run ```cps2.elm``` from reactor. You must compile it into JavaScript:

```
cd .../elm-csp
elm make csp2.elm --output csp2.js
```

And then open ```index.html``` in your browser (or click on it in the reactor home page).
