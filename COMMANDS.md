# Common Commands Handbook

This file collects frequently used commands for Git, DVC, Conda, and HPC.
Team members can extend it as needed.

---


## Pull from Mike's Github to build a new project
### setting your project name
```
export myproj=YOUR_PROJECT_NAME
```

### pull the repo
```
git clone https://github.com/MichaelChaoLi-cpu/MiliFrame-Template.git
mv MiliFrame-Template $myproj
cd $myproj

git remote rename origin upstream
```

### link this folder to your repo
```
export REPO_ADD_in_GITHUB=git_repo_with_tokens
```
then set remote
```
git remote add origin $REPO_ADD_in_GITHUB
git push -u origin main
```


### store your myproj in the .env
```bash
echo -n > .env
echo "myproj=$myproj" >> .env
set -a
source .env
set +a

echo $myproj # confirm

echo "PROJECT_ROOT=$(pwd)" >> .env
cat .env
```

---

## Run from scratch to build a new project
```
conda env create -f environment.yml 
conda activate $myproj ## it is recommended that use you project as the env name

pip install --upgrade pip
pip install -r requirments.txt
pip install jupytext nbconvert nbformat
pip install pre-commit
pre-commit install

pip install dvc
dvc init
```

### If HPC or Local
HPC
```
dvc remote add -d hpc /home/pj24001881/share/dvc_remote
```

Local
```
dvc remote add -d ANYTHING YOUR/DATA/LOCATION(Another Folder)
```


## Run 
```
conda env create -f environment.yml
conda activate $myproj
pip install -r requirements.txt
pre-commit install
dvc pull
```

---

## 🔹 Scripts

For building experiments
```bash
chmod +x ./scripts/end_experiment.sh
chmod +x ./scripts/begin_experiment.sh
chmod +x ./scripts/update_env.sh

# Run for a new experiment
./scripts/end_experiment.sh
./scripts/begin_experiment.sh 001

# update the env information
./scripts/update_env.sh
```

---

## 🔹 DVC

```bash
# Initialize DVC
dvc init

# Track a dataset with DVC
dvc add data/raw/big_dataset.csv
git add data/raw/big_dataset.csv.dvc .gitignore
git commit -m "track dataset"

# Push to remote (HPC store)
dvc push

# Pull from remote
dvc pull

# Reproduce pipeline
dvc repro
```

---

## 🔹 HPC (SLURM example)

```bash

```
