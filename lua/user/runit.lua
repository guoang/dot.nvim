local status_ok, runit = pcall(require, "runit")
if not status_ok then
  return
end

local xsolution_cpp_modules = {
  "xnet",
  "xlog",
  "chrono",
  "xtimer",
  "cpython",
  "mimalloc",
  "xsolution",
  "msgpack_python",
}
local xsolution_py_modules = { "xhttp", "xserver", "pyrc", "sop" }

for _, module in ipairs(xsolution_cpp_modules) do
  runit.setup({
    project = {
      [module] = {
        config = "cd ~/work/xbuild && "
          .. "cmake -DXSOLUTION_WITH_ALL=1 -DXSOLUTION_LOCAL_ALL=1 "
          .. "-DCMAKE_BUILD_TYPE=RelWithDebInfo "
          .. "-DCMAKE_INSTALL_PREFIX=./install ../xcodebase/xsolution",
        build = [[ cd ~/work/xbuild/_deps/${__proj_name__}-build && make -j8 ]],
        test = [[ cd ~/work/xbuild/_deps/${__proj_name__}-build && make -j8 test ]],
        install = [[ cd ~/work/xbuild/_deps/${__proj_name__}-build && make -j8 install ]],
        all = { "#build", "#install" },
      },
    },
  })
end

for _, module in ipairs(xsolution_py_modules) do
  runit.setup({
    project = {
      [module] = {
        install = "cd ~/work/xbuild/_deps/${__proj_name__}-build && make -j8 install",
        all = { "#install" },
      },
    },
  })
end

runit.setup({
  ft = {
    python = {
      test = "~/work/xbuild/install/RelWithDebInfo/Darwin-arm64/unpacked/bin/python ${__file_path__}",
      all = { "#test" },
    },
  },
})
