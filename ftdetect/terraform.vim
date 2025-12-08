au BufRead,BufNewFile * if &ft == 'tf' | set ft=terraform | endif

au BufRead,BufNewFile * if &ft == 'tf' | set ft=terraform | endif

au BufRead,BufNewFile *.tfvars.sops setlocal ft=terraform
