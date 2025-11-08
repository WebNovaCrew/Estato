# 🔧 Git Setup Instructions

## ⚠️ Important: Git Not Installed

Git is not currently installed on your system. Follow these steps to set it up:

---

## 📥 Step 1: Install Git

### Windows

1. **Download Git**
   - Visit: [https://git-scm.com/download/win](https://git-scm.com/download/win)
   - Download the installer
   - Run the installer
   - Use default settings (click Next through all prompts)

2. **Verify Installation**
   - Open a new PowerShell/CMD window
   - Run: `git --version`
   - Should see: `git version 2.x.x`

### Mac

1. **Install via Homebrew**
   ```bash
   brew install git
   ```

2. **Or Download Installer**
   - Visit: [https://git-scm.com/download/mac](https://git-scm.com/download/mac)

### Linux

```bash
sudo apt-get update
sudo apt-get install git
```

---

## 🔐 Step 2: Configure Git

1. **Set Your Name**
   ```bash
   git config --global user.name "Your Name"
   ```

2. **Set Your Email**
   ```bash
   git config --global user.email "your.email@example.com"
   ```

---

## 🚀 Step 3: Initialize Repository and Push to GitHub

### Option A: Using Provided Commands

After Git is installed, run these commands in order:

```bash
# Navigate to project directory
cd C:\Estato

# Create README if it doesn't exist
echo "# Estato" >> README.md

# Initialize git repository
git init

# Add README
git add README.md

# Make first commit
git commit -m "first commit"

# Rename branch to main
git branch -M main

# Add remote repository
git remote add origin https://github.com/WebNovaCrew/Estato.git

# Push to GitHub
git push -u origin main
```

### Option B: Complete Setup (Recommended)

```bash
# Navigate to project directory
cd C:\Estato

# Initialize git repository
git init

# Add all files (except those in .gitignore)
git add .

# Make first commit
git commit -m "Initial commit: Estato Real Estate App with Supabase backend"

# Rename branch to main
git branch -M main

# Add remote repository
git remote add origin https://github.com/WebNovaCrew/Estato.git

# Push to GitHub
git push -u origin main
```

---

## 🔒 Step 4: Verify Sensitive Files are Excluded

Before pushing, verify these files are NOT in the repository:

- ✅ `backend/.env` (should be ignored)
- ✅ `backend/YOUR_ENV_FILE.txt` (should be ignored)
- ✅ Any files containing Supabase keys

**Check what will be committed:**
```bash
git status
```

You should NOT see `.env` files in the output.

---

## 📋 Step 5: Create GitHub Repository

If you haven't created the GitHub repository yet:

1. **Go to GitHub**
   - Visit: [https://github.com](https://github.com)
   - Login to your account

2. **Create New Repository**
   - Click "+" icon → "New repository"
   - Repository name: `Estato`
   - Description: "Real Estate Property Listing App"
   - Visibility: Public or Private
   - **DO NOT** initialize with README, .gitignore, or license
   - Click "Create repository"

3. **Copy Repository URL**
   - Copy the HTTPS URL: `https://github.com/WebNovaCrew/Estato.git`

---

## ✅ Step 6: Push to GitHub

Run the commands from Step 3 to push your code.

---

## 🛡️ Security Checklist

Before pushing, make sure:

- [ ] `.env` files are in `.gitignore`
- [ ] `YOUR_ENV_FILE.txt` is in `.gitignore`
- [ ] No Supabase keys in committed files
- [ ] No API keys in committed files
- [ ] No passwords in committed files
- [ ] `backend/node_modules/` is ignored
- [ ] Build files are ignored

---

## 🔍 Verify Repository

After pushing:

1. **Check GitHub Repository**
   - Visit: `https://github.com/WebNovaCrew/Estato`
   - Verify all files are there
   - Verify `.env` files are NOT there

2. **Verify .gitignore is Working**
   - Check that sensitive files are not in the repository
   - Check that `backend/.env` is not visible

---

## 📝 Common Git Commands

```bash
# Check status
git status

# Add files
git add .

# Commit changes
git commit -m "Your commit message"

# Push to GitHub
git push

# Pull from GitHub
git pull

# Check remote
git remote -v

# View commit history
git log
```

---

## 🐛 Troubleshooting

### "git: command not found"
- Install Git first (see Step 1)
- Restart terminal after installation

### "fatal: not a git repository"
- Make sure you're in the project directory
- Run `git init` first

### "fatal: remote origin already exists"
- Remove existing remote: `git remote remove origin`
- Add again: `git remote add origin https://github.com/WebNovaCrew/Estato.git`

### "Permission denied"
- Check GitHub credentials
- Use GitHub Personal Access Token instead of password
- Or use SSH keys

### "fatal: refusing to merge unrelated histories"
- Use: `git pull origin main --allow-unrelated-histories`

---

## 🔐 GitHub Authentication

### Option 1: Personal Access Token

1. **Create Token**
   - GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token
   - Select scopes: `repo`
   - Copy token

2. **Use Token**
   - When prompted for password, use the token instead

### Option 2: SSH Keys

1. **Generate SSH Key**
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ```

2. **Add to GitHub**
   - Copy public key: `cat ~/.ssh/id_ed25519.pub`
   - GitHub → Settings → SSH and GPG keys → New SSH key
   - Paste key and save

3. **Change Remote to SSH**
   ```bash
   git remote set-url origin git@github.com:WebNovaCrew/Estato.git
   ```

---

## 📚 Next Steps

After pushing to GitHub:

1. ✅ Code is backed up on GitHub
2. ✅ Can collaborate with team
3. ✅ Can deploy from GitHub
4. ✅ Version control enabled

---

## ⚠️ Important Notes

1. **Never commit .env files** - They contain sensitive keys
2. **Never commit passwords** - Use environment variables
3. **Never commit API keys** - Keep them secure
4. **Always check .gitignore** - Before committing

---

**Last Updated:** November 4, 2025

