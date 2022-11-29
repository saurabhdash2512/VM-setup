sudo apt-get update
sudo apt-get upgrade
gcloud init
gcloud auth application-default login
sudo apt install git build-essential wget tmux
ssh-keygen -t ed25519 -C "saurabh@cohere.com" # github email
eval "$(ssh-agent -s)"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
gh auth login
gh auth refresh -h github.com -s admin:public_key
gh ssh-key add ~/.ssh/id_ed25519.pub
cd ..
git clone git@github.com:cohere-ai/tif.git
git clone git@github.com:cohere-ai/fastertransformer_backend.git
