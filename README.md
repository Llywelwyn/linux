# dotfiles for linux

`setup.sh` contains a `files` variable. any files listed will be removed 
from `~` and replaced with a symlink to the file located inside the repo.


when listing files, don't include the preceding dot. this is just to make
it less annoying when modifying the repo

e.g.
if you want to include `~/.bashrc`, it should be at the root of wherever 
the repository was cloned to, and named `bashrc`. running `setup.sh` will
then back-up `~/.bashrc` to a dated backup folder in `~`, and create a
symlink in its place pointed at `{REPO_DIRECTORY}/bashrc`

`setup.sh` only needs to be run once to set up the initial symlinks. as
long as the link exists, any time the file is modified in this repo it
will be proliferated automatically
