# 🚀 Push to GitHub - Quick Guide

## ⚠️ Important: Git Installation Required

Git is not currently installed on your system. You need to install it first.

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

### After Installation

**Restart your terminal/IDE** to use Git commands.

---

## 🚀 Step 2: Push to GitHub

### Option A: Use Setup Script (Windows)

1. **Run Setup Script**
   ```bash
   setup_git.bat
   ```

2. **Follow the prompts**
   - Script will initialize repository
   - Add all files
   - Make initial commit
   - Set up remote

3. **Push to GitHub**
   ```bash
   git push -u origin main
   ```

### Option B: Manual Commands

After Git is installed, run these commands:

```bash
# Navigate to project directory
cd C:\Estato

# Initialize git repository
git init

# Add all files
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

## 🔒 Step 3: Verify Sensitive Files are Excluded

**Before pushing, verify these files are NOT committed:**

```bash
git status
```

You should NOT see:
- ❌ `backend/.env`
- ❌ `backend/YOUR_ENV_FILE.txt`
- ❌ Any files with Supabase keys

**If you see these files:**
- Check `.gitignore` includes them
- Remove from staging: `git reset HEAD backend/.env`
- Verify they're ignored: `git check-ignore backend/.env`

---

## 🔐 Step 4: GitHub Authentication

### Option 1: Personal Access Token (Recommended)

1. **Create Token**
   - Go to: [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
   - Click "Generate new token" → "Generate new token (classic)"
   - Name: `Estato Repo Access`
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again)

2. **Use Token**
   - When prompted for password, paste the token instead
   - Username: Your GitHub username

### Option 2: SSH Keys

1. **Generate SSH Key**
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ```
   - Press Enter to accept default location
   - Enter a passphrase (optional)

2. **Add to GitHub**
   - Copy public key:
     ```bash
     cat ~/.ssh/id_ed25519.pub
     ```
   - Go to: [GitHub Settings → SSH and GPG keys](https://github.com/settings/keys)
   - Click "New SSH key"
   - Title: `Estato Development`
   - Paste the key
   - Click "Add SSH key"

3. **Change Remote to SSH**
   ```bash
   git remote set-url origin git@github.com:WebNovaCrew/Estato.git
   ```

---

## 📋 Step 5: Create GitHub Repository

If you haven't created the repository yet:

1. **Go to GitHub**
   - Visit: [https://github.com](https://github.com)
   - Login to your account

2. **Create New Repository**
   - Click "+" icon → "New repository"
   - Repository name: `Estato`
   - Description: "Real Estate Property Listing App with Supabase Backend"
   - Visibility: Public or Private
   - **DO NOT** initialize with README, .gitignore, or license
   - Click "Create repository"

3. **Repository URL**
   - Copy the HTTPS URL: `https://github.com/WebNovaCrew/Estato.git`

---

## ✅ Step 6: Verify Push

After pushing:

1. **Check GitHub Repository**
   - Visit: `https://github.com/WebNovaCrew/Estato`
   - Verify all files are there
   - Verify `.env` files are **NOT** there

2. **Verify .gitignore is Working**
   - Check that `backend/.env` is not visible
   - Check that `backend/YOUR_ENV_FILE.txt` is not visible
   - Check that sensitive files are excluded

---

## 🐛 Troubleshooting

### "git: command not found"
- Install Git first (see Step 1)
- Restart terminal after installation

### "fatal: not a git repository"
- Make sure you're in the project directory
- Run `git init` first

### "fatal: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/WebNovaCrew/Estato.git
```

### "Permission denied" or "Authentication failed"
- Use Personal Access Token instead of password
- Or set up SSH keys
- Check GitHub credentials

### ".env file is being committed"
- Check `.gitignore` includes `.env`
- Remove from git: `git rm --cached backend/.env`
- Commit the removal: `git commit -m "Remove .env file"`
- Verify: `git check-ignore backend/.env`

### "fatal: refusing to merge unrelated histories"
```bash
git pull origin main --allow-unrelated-histories
```

---

## 📚 Common Git Commands

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

# Check what files are ignored
git check-ignore -v backend/.env
```

---

## 🛡️ Security Checklist

Before pushing, verify:

- [ ] `.env` files are in `.gitignore`
- [ ] `YOUR_ENV_FILE.txt` is in `.gitignore`
- [ ] No Supabase keys in committed files
- [ ] No API keys in committed files
- [ ] No passwords in committed files
- [ ] `backend/node_modules/` is ignored
- [ ] Build files are ignored

---

## 🎉 Success!

Once pushed successfully:

1. ✅ Code is backed up on GitHub
2. ✅ Can collaborate with team
3. ✅ Can deploy from GitHub
4. ✅ Version control enabled
5. ✅ Sensitive files protected

---

## 📞 Need Help?

See detailed guides:
- [GIT_SETUP.md](GIT_SETUP.md) - Complete Git setup guide
- [backend/README.md](backend/README.md) - Backend documentation

---

**Last Updated:** November 4, 2025

