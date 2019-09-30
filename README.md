tiny-desk
==============

What is it?
--------------

*Tiny-desk* is a small script which enables to use workspaces in your *bash* shell. 

**Workspaces** are understanded as a set of bash functions, aliases, environmental variables defined only inside project. It can be usefull when you move to some directories very often, you need add some directories for ***PATH*** or ***LD_PRELOAD***.
After workspace deactivation all changes are reverted.

Functionalities
-----------------

Script provides following functions now:

* *td_show* - shows available workspaces
* *td_activate* ***WORKSPACE_NAME*** - enable workspace and move user to worskpace home directory
* *td_deactivate* - revert environment changes applied by workspace
* *td_refresh* - reload workspace configuration
* *td_update* - reload tidy-desk script
* *td_home* - change directory to main workspace directory
* *td_changedir* - change directory and if it is a workspace activate it

Configuration
-------------------

Installation process is rather simple. You have to clone repo and add to your .bashrc file
the line: 

> *export TINY_DESK_WORKSPACES*="***WORKSPACES_CONFIG_DIR***" 

> *export TINY_DESK_INSTALL_DIR*="***TINY_DESK_INSTALL_DIR***"

> *source $TINY_DESK_INSTALL_DIR/tiny_desk.sh*

Minimal workspace configuration defines/redefines following environmental variables:

| Environment variable   | Definition                   |
|------------------------|------------------------------|
| **WORKSPACE_NAME**     | String with worskpace name   |
| **S**                  | Workspace home directory     |
| **B**                  | Workspace build directory    |
| **BRANCH**             | Git branch                   |
| **WORKSPACE_CONFIG**   | Path to custom configuration |

Each workspace configuration sources specific *per-project* configuration with non-default variables and functions. This custom configuration should contain *reset_environment* function which unset exports, aliases and functions.

### Template for minimal configuration

The name of minimal configuration must have prefix *workspace_* and extension *\*.sh* ie. minimal configuration for project *my_project* should be named as *worskpace_my_project.sh*

```bash
export WORKSPACE_NAME="my_project"

export BRANCH="$( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"

export PS1='\[\e[32m\]| \u  |\[\e[m\] \[\e[33m\]$WORKSPACE_NAME > $BRANCH\[\e[m\] \[\e[33m\])\[\e[m\] \[\033[01;34m\]\w\[\033[00m\] $ '

# DEFAULT DIRECTORIES
export S="$HOME/Repo/my_project"

export B="$S/build/"

# SPECIFIC FUNCTIONS
source "$TINY_DESK_WORKSPACES/my_project_specific.sh"
```

### Example for ***my_project*** specific configuration

``` bash
export CRYPTO_LIB="openssl"

function @@config()
{
    start_dir="$PWD"
    cd "$S"
    python3 configure.py
    cd "$start_dir"
}

function @@build()
{
    start_dir="$PWD"
    cd "$S"
    make -j8
    cd "$start_dir"
}

function @@test()
{
    start_dir="$PWD"
    cd "$S"
    ./googleunittest
    cd "$start_dir"
}

function @@clean()
{
    start_dir="$PWD"
    cd "$S"
    rm -rf build
    cd "$startdir"
}

function reset_environment()
{
    unset CRYPTO_LIB
    unset -f @@config
    unset -f @@build
    unset -f @@test
    unset -f @@clean
}
```

Sugestions
-------------

The commands names are a little bit long - I'd prefer to use aliasses like that:

| Alias name | Alias value     |
|------------|-----------------|
| @@cd       | td_cd           |
| @@u        | td_update       |
| @@r        | td_refresh      |
| @@a        | td_activate     |
| @@d        | td_deactivate   |
| @@~        | td_home         |
