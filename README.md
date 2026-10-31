# azure-bicep-infrastructure


Azure Bicep Infrastructure Lab
Présentation
Ce projet est un laboratoire personnel destiné à apprendre l'administration Linux, Git, GitHub, Azure CLI, Bicep, Terraform et Docker.

L'environnement permet d'écrire le code dans Visual Studio Code sous Windows, tout en exécutant les commandes dans une machine virtuelle Ubuntu Server à travers une connexion SSH.

Architecture de l'environnement
Windows
│
├── Visual Studio Code
├── Extension Remote - SSH
└── Interface graphique
        │
        │ SSH
        ▼
Ubuntu Server
│
├── Git
├── Azure CLI
├── Bicep CLI
├── Terraform
├── Docker Engine
└── Fichiers du projet
        │
        ▼
Microsoft Azure
│
├── Resource Groups
├── Virtual Networks
├── Subnets
├── Network Security Groups
├── Virtual Machines
└── autres ressources Azure
Où les commandes sont-elles exécutées ?
Lorsque Visual Studio Code affiche une connexion comme :

SSH: 192.168.159.130
et que le terminal affiche :

moussa@server:~$
les commandes sont exécutées dans Ubuntu Server.

Par exemple :

sudo apt install git
installe Git dans la machine virtuelle Linux, et non dans Windows.

Lorsque le terminal affiche plutôt :

PS C:\Users\Moussa>
les commandes sont exécutées directement dans Windows.

Informations du système Linux
Afficher la distribution Linux :

cat /etc/os-release
Afficher l'architecture du processeur :

uname -m
Afficher le nom de la machine :

hostname
Afficher l'utilisateur actuel :

whoami
Afficher l'adresse IP :

ip addr
Mise à jour du système
Mettre à jour la liste des paquets :

sudo apt update
Installer les mises à jour disponibles :

sudo apt upgrade -y
Installer les outils système utiles :

sudo apt install -y curl wget unzip ca-certificates gnupg lsb-release jq
Vérification des outils
Git
git --version
command -v git
Azure CLI
az version
command -v az
Bicep CLI
az bicep version
Terraform
terraform --version
command -v terraform
Docker
docker --version
docker compose version
command -v docker
État du service Docker
systemctl is-active docker
systemctl is-enabled docker
docker ps
Vérification automatique
for tool in git az terraform docker; do
    if command -v "$tool" > /dev/null 2>&1; then
        echo "[OK] $tool est installé : $(command -v "$tool")"
    else
        echo "[ABSENT] $tool n'est pas installé"
    fi
done
Gestion des paquets Ubuntu
Afficher tous les paquets installés avec APT :

apt list --installed
Rechercher les principaux outils :

apt list --installed 2>/dev/null | grep -E "git|azure-cli|terraform|docker"
Afficher les logiciels installés avec Snap :

snap list
Structure du projet
azure-bicep-infrastructure/
├── 01-fundamentals/
├── 01-resource-group/
├── 02-virtual-network/
├── 03-subnets/
├── 04-network-security-group/
├── 05-public-ip/
├── 06-network-interface/
├── 07-virtual-machine/
├── 08-load-balancer/
├── 09-vm-scale-set/
├── .gitignore
├── LICENSE
└── README.md
Rôle des outils
Outil	Rôle
Visual Studio Code	Écrire et modifier les fichiers
SSH	Se connecter à Ubuntu Server
Git	Gérer les versions locales du code
GitHub	Héberger et partager le dépôt distant
Azure CLI	Administrer les ressources Azure
Bicep	Décrire l'infrastructure Azure sous forme de code
Terraform	Déployer une infrastructure multicloud sous forme de code
Docker	Construire et exécuter des conteneurs
Ubuntu Server	Fournir l'environnement Linux d'exécution et d'administration
Workflow Git et GitHub
1. Vérifier l'état du dépôt
git status
2. Voir les modifications
git diff
3. Ajouter le README à la zone de préparation
git add README.md
4. Vérifier la zone de préparation
git status
5. Créer un commit
git commit -m "docs: document Linux and Azure development environment"
6. Envoyer le commit vers GitHub
git push origin main
7. Afficher l'historique
git log --oneline --graph --decorate --all
Workflow résumé
Modifier un fichier
      │
      ▼
git status
      │
      ▼
git diff
      │
      ▼
git add README.md
      │
      ▼
git commit -m "message"
      │
      ▼
git push origin main
      │
      ▼
GitHub
Principe important
Visual Studio Code est l'interface utilisée pour travailler.

Le terminal indique la machine sur laquelle les commandes sont réellement exécutées :

moussa@server:~$      = Ubuntu Server
PS C:\Users\Moussa>  = Windows
Une installation réalisée depuis le terminal SSH est installée dans Ubuntu Server.

Une installation réalisée depuis PowerShell local est installée dans Windows.