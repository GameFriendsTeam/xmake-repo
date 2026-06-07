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
        local configs = {}
        if package:config("bedrock") then
            table.insert(configs, "--bedrock=y")
        end
        import("package.tools.xmake").install(package, configs)
        
        if package:config("bedrock") and os.isdir("include-bedrock") then
            os.cp("include-bedrock/*", package:installdir("include"))
        end
    end)
    on_test(function (package)
        local test_code = [[
            #include <fishnet/FishClient.h>
            void test() {
                fishnet::FishClient client;
            }
        ]]
        assert(package:check_cxxsnippets({test = test_code}, {configs = {languages = "c++20"}}))

        if package:config("bedrock") then
            local bedrock_test_code = [[
                #include <fishnet/bedrock/BedrockClient.h>
                void test() {
                    fishnet::bedrock::BedrockClient client;
                }
            ]]
            assert(package:check_cxxsnippets({test = bedrock_test_code}, {configs = {languages = "c++20"}}))
        end
    end)
package_end()
