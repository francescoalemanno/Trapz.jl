
using Weave,Trapz
weave(joinpath(dirname(pathof(Trapz)), "../benchmarks", "benchmark.jmd"), out_path=joinpath(dirname(pathof(Trapz)), "../benchmarks"), doctype="github")
