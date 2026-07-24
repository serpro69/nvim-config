local M = {}

local function state_file()
  return vim.fn.getcwd() .. "/.spring-deps.json"
end

local function read_state()
  local path = state_file()
  if vim.fn.filereadable(path) == 0 then
    return {}
  end
  local ok, data = pcall(function()
    return vim.fn.json_decode(vim.fn.readfile(path))
  end)
  if ok and data then
    return data
  end
  return {}
end

local function write_state(deps)
  vim.fn.writefile({ vim.fn.json_encode(deps) }, state_file())
end

local metadata_cache = nil

function M.fetch_metadata()
  if metadata_cache then
    return metadata_cache
  end
  local ok, json = pcall(function()
    return vim.fn.system("curl -sf https://start.spring.io/metadata/client")
  end)
  if not ok or json == "" then
    vim.notify("Failed to fetch Spring Boot metadata", vim.log.levels.ERROR)
    return nil
  end
  local ok2, metadata = pcall(vim.fn.json_decode, json)
  if not ok2 or not metadata then
    return nil
  end
  metadata_cache = metadata
  return metadata
end

function M.list_dependencies(metadata)
  local deps = {}
  if not metadata or not metadata.dependencies or not metadata.dependencies.values then
    return deps
  end
  for _, group in ipairs(metadata.dependencies.values) do
    for _, dep in ipairs(group.values or {}) do
      table.insert(deps, {
        id = dep.id,
        name = dep.name or dep.id,
        description = dep.description or "",
        group_id = dep.groupId or "org.springframework.boot",
        artifact_id = dep.artifactId or ("spring-boot-starter-" .. dep.id),
      })
    end
  end
  return deps
end

function M.save_project_deps(selected_ids, all_deps, project_dir)
  local entries = {}
  for _, d in ipairs(all_deps) do
    if vim.tbl_contains(selected_ids, d.id) then
      table.insert(entries, d)
    end
  end
  local path = (project_dir or vim.fn.getcwd()) .. "/.spring-deps.json"
  vim.fn.writefile({ vim.fn.json_encode(entries) }, path)
end

function M.add_to_pom(pom_path, deps)
  local lines = vim.fn.readfile(pom_path)
  local insert_idx = nil
  local indent = "  "
  for i, line in ipairs(lines) do
    if line:find("</dependencies>") then
      insert_idx = i - 1
    elseif insert_idx == nil and line:find("<dependency>") then
      local ws = line:match("^(%s*)<")
      if ws then
        indent = ws
      end
    end
    if insert_idx then
      break
    end
  end
  if not insert_idx then
    vim.notify("Could not find <dependencies> section in pom.xml", vim.log.levels.ERROR)
    return
  end

  local inner_indent = indent .. "  "
  local new_lines = {}
  for _, dep in ipairs(deps) do
    table.insert(new_lines, indent .. "<dependency>")
    table.insert(new_lines, inner_indent .. "<groupId>" .. dep.group_id .. "</groupId>")
    table.insert(new_lines, inner_indent .. "<artifactId>" .. dep.artifact_id .. "</artifactId>")
    table.insert(new_lines, indent .. "</dependency>")
  end

  local result = {}
  for i = 1, insert_idx do
    table.insert(result, lines[i])
  end
  for _, line in ipairs(new_lines) do
    table.insert(result, line)
  end
  for i = insert_idx + 1, #lines do
    table.insert(result, lines[i])
  end

  vim.fn.writefile(result, pom_path)
end

function M.add_to_gradle(gradle_path, deps)
  local lines = vim.fn.readfile(gradle_path)
  local insert_idx = nil
  for i, line in ipairs(lines) do
    if line:match("^%s*dependencies%s*{") then
      insert_idx = i
      break
    end
  end
  if not insert_idx then
    vim.notify("Could not find dependencies block in build.gradle", vim.log.levels.ERROR)
    return
  end

  local new_lines = {}
  for _, dep in ipairs(deps) do
    table.insert(new_lines, "  implementation '" .. dep.group_id .. ":" .. dep.artifact_id .. "'")
  end

  local result = {}
  for i = 1, insert_idx do
    table.insert(result, lines[i])
  end
  for _, line in ipairs(new_lines) do
    table.insert(result, line)
  end
  for i = insert_idx + 1, #lines do
    table.insert(result, lines[i])
  end

  vim.fn.writefile(result, gradle_path)
end

function M.add_to_build_file(build_file, build_type, deps)
  if build_type == "maven" then
    M.add_to_pom(build_file, deps)
  elseif build_type == "gradle" or build_type == "gradle-kts" then
    M.add_to_gradle(build_file, deps)
  end

  local names = {}
  for _, d in ipairs(deps) do
    table.insert(names, d.id)
  end
  vim.notify("Added " .. #deps .. " Spring Boot dependencies: " .. table.concat(names, ", "), vim.log.levels.INFO)
end

function M.select_and_add()
  local existing = read_state()

  local metadata = M.fetch_metadata()
  if not metadata then
    return
  end

  local all_deps = M.list_dependencies(metadata)
  if #all_deps == 0 then
    vim.notify("No dependencies found from Spring Initializr", vim.log.levels.WARN)
    return
  end

  local existing_ids = vim.tbl_map(function(d) return d.id end, existing)
  local available = vim.tbl_filter(function(d)
    return not vim.tbl_contains(existing_ids, d.id)
  end, all_deps)

  if #available == 0 then
    vim.notify("All available Spring Boot dependencies are already added", vim.log.levels.INFO)
    return
  end

  local selected = {}
  local function finish()
    if #selected == 0 then
      vim.notify("No dependencies selected", vim.log.levels.INFO)
      return
    end

    local selected_deps = vim.tbl_filter(function(d)
      return vim.tbl_contains(selected, d.id)
    end, all_deps)

    local build_file = vim.fn.findfile("pom.xml", ".;")
    local build_type = "maven"
    if build_file == "" then
      build_file = vim.fn.findfile("build.gradle", ".;")
      build_type = "gradle"
    end
    if build_file == "" then
      build_file = vim.fn.findfile("build.gradle.kts", ".;")
      build_type = "gradle-kts"
    end

    if build_file ~= "" then
      M.add_to_build_file(build_file, build_type, selected_deps)
    end

    for _, id in ipairs(selected) do
      table.insert(existing_ids, id)
    end
    local all_selected = {}
    for _, d in ipairs(all_deps) do
      if vim.tbl_contains(existing_ids, d.id) then
        table.insert(all_selected, d)
      end
    end
    write_state(all_selected)

    if build_file == "" then
      vim.notify("Saved " .. #selected .. " Spring Boot dependencies (no build file found)", vim.log.levels.INFO)
    end
  end

  local function pick()
    local remaining = vim.tbl_filter(function(d)
      return not vim.tbl_contains(selected, d.id)
    end, available)
    if #remaining == 0 then
      finish()
      return
    end
    local count = #selected
    local prompt = count > 0
      and string.format("Spring Dependencies (%d selected) — pick another or ESC to finish", count)
      or "Select Spring Boot dependencies (pick one, ESC when done)"
    vim.ui.select(remaining, {
      prompt = prompt,
      format_item = function(d)
        return string.format("%-25s — %s", d.id, d.description ~= "" and d.description or d.name)
      end,
    }, function(choice)
      if choice then
        table.insert(selected, choice.id)
        pick()
      else
        finish()
      end
    end)
  end

  pick()
end

function M.select_for_bootstrap(all_deps)
  local selected = {}
  local function pick()
    local remaining = vim.tbl_filter(function(d)
      return not vim.tbl_contains(selected, d.id)
    end, all_deps)
    if #remaining == 0 then
      return selected
    end
    local count = #selected
    local prompt = count > 0
      and string.format("Dependencies (%d selected) — pick another or ESC to finish", count)
      or "Select dependencies (pick one, ESC when done)"
    vim.ui.select(remaining, {
      prompt = prompt,
      format_item = function(d)
        return string.format("%-25s — %s", d.id, d.description ~= "" and d.description or d.name)
      end,
    }, function(choice)
      if choice then
        table.insert(selected, choice.id)
        pick()
      end
    end)
  end

  pick()
  return selected
end

return M
