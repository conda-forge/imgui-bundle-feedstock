# Optional libraries are silently left out when they fail to build;
# make sure the package ships all of them.
# https://github.com/conda-forge/imgui-bundle-feedstock/pull/52#issuecomment-6342188164
import imgui_bundle

expected = ["rich_md", "imgui_microtex", "immvision", "implot", "implot3d",
            "imgui_node_editor", "nanovg", "im_anim"]
missing = [name for name in expected if not imgui_bundle.has_submodule(name)]
assert not missing, f"Not built: {missing}"
