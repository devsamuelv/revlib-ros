cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES 
      ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

project(revlib-ros VERSION 0.1.0 LANGUAGES C CXX)
add_executable(revlib-ros ${CMAKE_SOURCE_DIR}/src/main.cpp)

find_package(fmt REQUIRED)
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)

add_subdirectory(${CMAKE_SOURCE_DIR}/src)

include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(src)
target_include_directories(revlib-ros PRIVATE ${CMAKE_SOURCE_DIR}/REVLib-cpp-2026.0.5-headers/rev)

target_link_libraries(revlib-ros
  rclcpp::rclcpp
)
target_link_libraries(revlib-ros fmt::fmt)

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