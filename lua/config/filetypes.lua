-- NOTE: Additional Filetypes
vim.filetype.add({
  extension = {
    ["axaml"] = "xml",
    ["jinja"] = "htmldjango",
  },
  pattern = {
    -- ansible files
    [".*/main.ya?ml"] = "yaml.ansible",
    [".*/site.ya?ml"] = "yaml.ansible",
    [".*/ansible/.*%.ya?ml"] = "yaml.ansible",
    [".*/defaults/.*%.ya?ml"] = "yaml.ansible",
    [".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
    [".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
    [".*/playbook.*%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/molecule/.*%.ya?ml"] = "yaml.ansible",
    -- docker files
    [".*/.*dockerfile"] = "dockerfile",
    [".*/.*Dockerfile"] = "dockerfile",
    [".*/docker-compose%.ya?ml"] = "yaml.docker-compose",
    -- github workflow files
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})
