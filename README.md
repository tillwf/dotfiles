###Init

#### Install Git

```bash
sudo apt-get install git
```

#### Clone dotfiles

```bash
git clone http://github.com/tillmd/dotfiles
```

### Applications

#### From file

```bash
for i in `cat applications`; do sudo apt-get install -y $i ; done
```

#### Using Ansible

Install Ansible:

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

```bash
ansible-playbook ansible/main.yml
```

### Configuration

#### Sublime Text

Copy Preference File

Copy Keymap File

Install packages :

 - GitGutter
 - Brogrammer Theme
 - MarkDownExtended


### Environement

#### Credential


```bash
scp -p $TW_PORT $TW_USER@$TW_URL:env/.* ~/.
```

#### Pem files


```bash
scp -p $TW_PORT $TW_USER@$TW_URL:pem/*.pem ~/.ssh/.
```


### Clone repository

#### SSH Github key generation

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Extra Configuration

#### Gnome Extensions

 - [Alternate Tab](https://extensions.gnome.org/extension/15/alternatetab/)
 - [Hide Top Bar](https://extensions.gnome.org/extension/545/hide-top-bar/)
 - [Hot-Corn-Dog](https://extensions.gnome.org/extension/309/hot-corn-dog/)
 - [Mailnag](https://extensions.gnome.org/extension/886/mailnag/)
 - [Pixel Saver](https://extensions.gnome.org/extension/723/pixel-saver/)
 - [Put Windows](https://extensions.gnome.org/extension/39/put-windows/)
