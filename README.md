# web-OCaml

Ce projet est un petit serveur web en OCaml qui peut servir des fichiers statiques et afficher un message de bienvenue.

## Comment exécuter le serveur

1. Assurez-vous d'avoir OCaml installé sur votre machine.
2. Compilez le code avec la commande suivante :
```ocamlc unix.cma main.ml -o server```

3. Exécutez le serveur avec :
```./server```

5. Accédez au serveur via un navigateur web à l'adresse `http://localhost:8080`.

## Fonctionnalités

- Affiche un message de bienvenue lorsque vous accédez au serveur.
- Peut servir des fichiers statiques depuis un répertoire.




