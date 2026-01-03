# Fresh Repository Setup Instructions

This document contains the steps to push Metis to a fresh repository with clean git history (no contributor history).

## Prerequisites

- New repository created: `https://github.com/uncutrush/metis.git` (should be empty)
- Current working directory: `/Users/aj/Apps/Metis/Metis`

## Steps to Push to Fresh Repository

### 1. Create Orphan Branch (Clean History)

```bash
cd /Users/aj/Apps/Metis/Metis
git checkout --orphan fresh-start
```

This creates a new branch with no commit history.

### 2. Stage All Files

```bash
git add .
```

### 3. Create Initial Commit

```bash
git commit -m "Initial commit - Metis knowledge management system"
```

### 4. Add New Remote

```bash
git remote add new-origin https://github.com/uncutrush/metis.git
```

### 5. Push to New Repository

```bash
git push -u new-origin fresh-start:main
```

This pushes the `fresh-start` branch to the `main` branch of the new repository.

## After Pushing

1. **Set main as default branch** (if needed):
   - Go to GitHub repository settings
   - Set `main` as the default branch

2. **Update local tracking**:
   ```bash
   git branch -M main
   git remote set-url origin https://github.com/uncutrush/metis.git
   git remote remove new-origin  # Clean up temporary remote
   ```

3. **Verify**:
   - Check GitHub repository - should show only 1 commit
   - Contributors section should be empty or show only you
   - All files should be present

## Notes

- The orphan branch approach creates a completely clean history
- No previous contributors will appear
- All your current code and files will be included
- The README has been updated to remove all external references

