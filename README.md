#XCode Compile Commands

This is a WIP. The goal of this project is provide `compile_commands.json` output for XCode-only projects and workspaces (i.e. those not using using CMake or other tools). This is useful for those who wish to use syntax checking or code completion outside of xcode (e.g. with vim).

It works by intercepting calls to clang, dumping the compile commands and then forwarding to clang to let the build continue. This probably only works with C-family languages (Swift probably won't work)

# Installation

There are two ways to install this. 

1. If it's not too intrusive to do so, point the `CC` xcode environment variable to the interceptor script and modify that to forward to xcode's copy of clang. If you want to keep the project configuration changes local consider using `git update-index --skip-worktree <project file>` .

2. You can replace xcode's clang with the script directly. Rename `clang` to `.clang` and move the script to the same directory, naming it `clang`. The script is currently setup to use this method.

# Tip
You can use the command
`xcodebuild -find clang` to find the location of xcode's copy of clang.
