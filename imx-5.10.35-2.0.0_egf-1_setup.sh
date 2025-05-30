# === Warning ===================================================================================================================

# !!! The commands in the script use options (e.g. "-y", "--batch --yes") in order not to require user intervention when      !!!
# !!! installing components or anything else. If you want to have control over the commands to be executed, remove the above  !!!
# !!! options.                                                                                                                !!!


# === Environment variables =====================================================================================================

# === Variables to be modified by the user ===
UBUNTU_USER="${USER}"
GIT_USERNAME="username"
GIT_USER_EMAIL="user@email"
PROG_DIR="${HOME}/project"

# === Variables related to manifests ===
GIT_REPO_DOWNLOADS_URL="http://commondatastorage.googleapis.com/git-repo-downloads/repo"
MANIFEST_NXP="imx-5.10.35-2.0.0.xml"
BRANCH_NXP_VERSIONE="imx-linux-hardknott"
NXP_MANIFEST_REPO="https://github.com/nxp-imx/imx-manifest"
MANIFEST_EGF="imx-5.10.35-2.0.0_egf-1.xml"
EGF_MANIFEST_REPO="manifests"
EGF_MANIFEST_REV="6befffc6bdca7edfda9573286f2f9f28c3b759ba"
YOCTO_DISTRO_IMAGE_NAME="egf-image-qt5-0533"

# === Prerequisites =============================================================================================================

# === Update and utilities ===
sudo apt-get -y update
sudo apt-get -y install git
sudo snap install curl

# === Folders ===
mkdir -p $PROG_DIR
cd $PROG_DIR
mkdir yocto-input; mkdir yocto-output; mkdir downloads
cd $PROG_DIR/yocto-input


# === Repo ======================================================================================================================

git config --global color.ui true
git config --global user.name $GIT_USERNAME
git config --global user.email $GIT_USER_EMAIL
if [ ! -f ~/bin/repo ]; then
   echo "Installing repo..."
   mkdir ~/bin
   curl $GIT_REPO_DOWNLOADS_URL > ~/bin/repo
   chmod a+x ~/bin/repo
   export PATH=$PATH:~/bin
fi

python3 ~/bin/repo init -u $NXP_MANIFEST_REPO -b $BRANCH_NXP_VERSIONE -m $MANIFEST_NXP

cd .repo/manifests

wget https://raw.githubusercontent.com/elettronicagf/$EGF_MANIFEST_REPO/$EGF_MANIFEST_REV/$MANIFEST_EGF
cd ../..
python3 ~/bin/repo init -m $MANIFEST_EGF

python3 ~/bin/repo sync


# === Docker ====================================================================================================================

mv docker-builder ..
cd ../docker-builder/

sudo apt-get -y install ca-certificates gnupg
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -a -G docker $UBUNTU_USER

sg docker -c "cd $PROG_DIR/docker-builder \
&& export YOCTO_DISTRO_IMAGE_NAME=$YOCTO_DISTRO_IMAGE_NAME && ./docker_image_build.sh \
&& export PROG_DIR=$PROG_DIR && ./docker_run.sh"
