local status_ok, fidget, spectre, be

status_ok, fidget = pcall(require, 'fidget')
if status_ok then
  fidget.setup()
end

status_ok, spectre = pcall(require, 'spectre')
if status_ok then
  spectre.setup()
end

status_ok, be = pcall(require, 'better_escape')
if status_ok then
  be.setup()
end
