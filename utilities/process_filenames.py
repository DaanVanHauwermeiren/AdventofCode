#%%
from glob import glob
from os import path
import pandas as pd
import subprocess

SRC_DIR = path.abspath(path.join(path.dirname(__file__), ".."))
VENV_PY = path.join(SRC_DIR, ".venv", "bin", "python3")

# %%

pathnames = sorted(glob(path.abspath(path.join(SRC_DIR, "code", "*"))))
print(pathnames)
df = pd.DataFrame(
    index=range(len(pathnames)),
    columns=["name", "year", "day", "extension", "filepath"]
)
# %%
# process filenames
for i, pathname in enumerate(pathnames):
    # split the paths and only get the filename
    fn = pathname.split("/")[-1]
    name, year, tmp = fn.split("_")
    day, extension = tmp.split(".")
    df.loc[i] = [name, year, day, extension, pathname]
df

# TODO:
# add check for results here: files that are already processed should not be run again.



# %%
assert set(["jl", "py"]) == set(df["extension"].unique()), "Files other than .jl or .py detected."
# %%
import json
with open(path.join(SRC_DIR, "data", "solutions.json"), "r") as f:
    solutions = json.loads(f.read())
solutions

# %%
# for idx, s in df.iterrows():
idx = 0
s = df.loc[idx]
# %%
fn_data = path.join(SRC_DIR, "data", f"input_{s.year}_{s.day}.txt")
fn_data
# first simple solution checking
if s.extension == "py":
    res = system(f"{VENV_PY} {s.filepath} {fn_data}")
    # print(res)
    # assert res == solutions[s.year][s.day]
else:
    raise NotImplementedError
# %%
derp = subprocess.run([VENV_PY, s.filepath, fn_data], stdout=subprocess.PIPE)
derp
# %%
derp.stdout
# %%
