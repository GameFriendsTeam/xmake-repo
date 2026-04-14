package("fishnet")
    set_homepage("https://github.com/GameFriendsTeam/FishNet")
    set_description("Fishnet networking library")
    set_license("MIT")

    add_urls("https://github.com/GameFriendsTeam/FishNet.git")

    add_versionfiles("versions/versions.txt")

    add_configs("bedrock", {description = "Include Minecraft Bedrock extension", default = false, type = "boolean"})

    if is_plat("windows") then
        add_syslinks("ws2_32", "iphlpapi")
    elseif is_plat("linux") then
        add_syslinks("pthread")
    end

    on_install("windows", "linux", "macosx", function (package)
        local configs = {
            "--examples=n"
        }
        if package:config("bedrock") then
            table.insert(configs, "--bedrock=y")
        end
        import("package.tools.xmake").install(package, configs)
    end)
package_end()
