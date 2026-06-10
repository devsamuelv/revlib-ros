cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pkgs/sparkcan/CMakeLists.txt")
    message(FATAL_ERROR "The submodule directory is empty! Please run: git submodule update --init --recursive")
endif()

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES 
      ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

project(revlib-ros VERSION 0.1.0 LANGUAGES C CXX)
add_executable(revlib-ros ${CMAKE_SOURCE_DIR}/src/main.cpp)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_srvs REQUIRED)

ament_target_dependencies(revlib-ros
  rclcpp
  std_srvs
)

add_subdirectory(${CMAKE_SOURCE_DIR}/src)

add_subdirectory(${CMAKE_SOURCE_DIR}/pkgs/sparkcan EXCLUDE_FROM_ALL)
include_directories(${CMAKE_SOURCE_DIR}/pkgs/sparkcan/include)

include_directories(src)

target_link_libraries(revlib-ros
  rclcpp::rclcpp
)

# Dont forget to add ament export include and dependcies calls from template 

include(CTest)
enable_testing()

install(TARGETS revlib-ros DESTINATION bin)

# # problematic

# ament_export_include_directories(include)
# ament_export_dependencies(image_transport rosidl_default_runtime rclcpp sensor_msgs)

# if(BUILD_TESTING)
#   find_package(ament_lint_auto REQUIRED)
#   ament_lint_auto_find_test_dependencies()
# endif()

# ament_package()