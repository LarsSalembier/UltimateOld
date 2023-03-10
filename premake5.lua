workspace "Ultimate"
	architecture "x64"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Ultimate"
	location "Ultimate"
	kind "SharedLib"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"ULT_PLATFORM_WINDOWS",
			"ULT_BUILD_DLL"
		}

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}

	filter "configurations:Debug"
		defines "ULT_DEBUG"
		symbols "On"

	filter "configurations:Release"
		defines "ULT_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "ULT_DIST"
		optimize "On"


project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Ultimate/vendor/spdlog/include",
		"Ultimate/src"
	}

	links
	{
		"Ultimate"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines
		{
			"ULT_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "ULT_DEBUG"
		symbols "On"

	filter "configurations:Release"
		defines "ULT_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "ULT_DIST"
		optimize "On"
