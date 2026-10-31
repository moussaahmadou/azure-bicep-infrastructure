
# Déployer le réseau virtuel

Le dossier ` 02-virtual-network` contient le modèle `main.bicep`, les paramètres
`dev.bicepparam` et `prod.bicepparam`, ainsi que le script `deploy.sh`.
Les paramètres de production définissent six sous-réseaux. Les plages utilisent
un espace d'adressage différent de celui de développement (`10.1.0.0/16` au lieu
de `10.0.0.0/16`).

Depuis la racine du dépôt, connectez-vous d'abord à Azure si nécessaire :

```bash
az login
```

Puis lancez le déploiement en donnant l'environnement, l'identifiant de
l'abonnement, le nom du groupe de ressources et la région de ce groupe :

```bash
bash "01-fundamentals/ 02-virtual-network/deploy.sh" \
  prod <subscription-id> <resource-group> westeurope
```

Pour le réseau de développement, remplacez `prod` par `dev`. Le script
sélectionne l'abonnement, crée le groupe de ressources s'il n'existe pas, puis
déploie le modèle avec le fichier de paramètres correspondant.

Les sous-réseaux `AzureFirewallSubnet` et `AzureBastionSubnet` ont des noms
réservés par Azure et doivent rester dédiés à ces services. Le sous-réseau
Application Gateway est également prévu comme sous-réseau dédié. Vérifiez que
`10.1.0.0/16` ne chevauche pas d'autres réseaux connectés à votre infrastructure.
Évaluez aussi si le sous-réseau `snet-test` doit réellement se trouver dans le
réseau de production.
