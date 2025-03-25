## What is this?

These is Security, module of Triops/Workspace.

## How does it work?

This will be called via Triops/Workspace which will later function as an additional module. Security is used to re-exec from Triops/Workspace to be protected with a pseudonym from Double SHA256 and applies to SAMP

## What does not work?

This module will not work without calling `source` bash shell from Triops/Workspace. and if not called then a fatal error will occur when the script/function in the Server does not exist