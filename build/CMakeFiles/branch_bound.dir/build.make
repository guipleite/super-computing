# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.13

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/guipleite/Documents/P1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/guipleite/Documents/P1/build

# Include any dependencies generated for this target.
include CMakeFiles/branch_bound.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/branch_bound.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/branch_bound.dir/flags.make

CMakeFiles/branch_bound.dir/branch_bound.cpp.o: CMakeFiles/branch_bound.dir/flags.make
CMakeFiles/branch_bound.dir/branch_bound.cpp.o: ../branch_bound.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/guipleite/Documents/P1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/branch_bound.dir/branch_bound.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/branch_bound.dir/branch_bound.cpp.o -c /home/guipleite/Documents/P1/branch_bound.cpp

CMakeFiles/branch_bound.dir/branch_bound.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/branch_bound.dir/branch_bound.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/guipleite/Documents/P1/branch_bound.cpp > CMakeFiles/branch_bound.dir/branch_bound.cpp.i

CMakeFiles/branch_bound.dir/branch_bound.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/branch_bound.dir/branch_bound.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/guipleite/Documents/P1/branch_bound.cpp -o CMakeFiles/branch_bound.dir/branch_bound.cpp.s

# Object files for target branch_bound
branch_bound_OBJECTS = \
"CMakeFiles/branch_bound.dir/branch_bound.cpp.o"

# External object files for target branch_bound
branch_bound_EXTERNAL_OBJECTS =

branch_bound: CMakeFiles/branch_bound.dir/branch_bound.cpp.o
branch_bound: CMakeFiles/branch_bound.dir/build.make
branch_bound: CMakeFiles/branch_bound.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/guipleite/Documents/P1/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable branch_bound"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/branch_bound.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/branch_bound.dir/build: branch_bound

.PHONY : CMakeFiles/branch_bound.dir/build

CMakeFiles/branch_bound.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/branch_bound.dir/cmake_clean.cmake
.PHONY : CMakeFiles/branch_bound.dir/clean

CMakeFiles/branch_bound.dir/depend:
	cd /home/guipleite/Documents/P1/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/guipleite/Documents/P1 /home/guipleite/Documents/P1 /home/guipleite/Documents/P1/build /home/guipleite/Documents/P1/build /home/guipleite/Documents/P1/build/CMakeFiles/branch_bound.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/branch_bound.dir/depend

