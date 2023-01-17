local status_ok, runit = pcall(require, "runit")
if not status_ok then
  return
end

local xsolution_cpp_modules = { "xnet", "xlog", "chrono", "xtimer" }
local xsolution_py_modules = { "xhttp", "xserver" }

for _, module in ipairs(xsolution_cpp_modules) do
  runit.setup({
    project = {
      [module] = {
        config = [[
          Dispatch cd ~/work/xbuild &&
          cmake -DXSOLUTION_WITH_ALL=1 -DXSOLUTION_LOCAL_ALL=1
          -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=./install
          ../xcodebase/xsolution ]],
        build = [[ Dispatch cd ~/work/xbuild && make -j8 ]],
        test = [[ Dispatch cd ~/work/xbuild && make -j8 test ]],
        install = [[ Dispatch cd ~/work/xbuild && make -j8 install ]],
      },
    },
  })
end

for _, module in ipairs(xsolution_py_modules) do
  runit.setup({
    project = {
      [module] = {
        install = "Dispatch cd ~/work/xbuild/_deps/" .. module .. "-build && make -j8 install",
      },
    },
  })
end
