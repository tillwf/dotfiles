### Init

#### Install Git

```bash
sudo apt-get install git
```

#### Clone dotfiles

```bash
git clone http://github.com/tillmd/dotfiles
```

### Applications

#### Using Ansible

Install Ansible >= 2.8:

```bash
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
