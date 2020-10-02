cmake_minimum_required(VERSION 3.12)
project (P1)
find_package(OpenMP)
find_package(CUDA)

cuda_add_executable(busca_local_gpu busca_local.cu)
set_property(TARGET busca_local_gpu PROPERTY CUDA_STANDARD 11)

add_executable(branch_bound_seq branch_bound.cpp) 
target_compile_options(branch_bound_seq PUBLIC -O3)
target_compile_definitions(branch_bound_seq PUBLIC OPT)

add_executable(branch_bound_par branch_bound_par.cpp) 
target_compile_options(branch_bound_par PUBLIC -O3)
target_link_libraries(branch_bound_par PUBLIC OpenMP::OpenMP_CXX)
#target_compile_definitions(busca_local_par PUBLIC  OpenMP::OpenMP_CXX)

add_executable(busca_local_seq busca_local.cpp) 
target_compile_options(busca_local_seq PUBLIC -O3)
target_compile_definitions(busca_local_seq PUBLIC OPT)

add_executable(busca_local_par busca_local_paralel.cpp) 
target_compile_options(busca_local_par PUBLIC -O3)
target_link_libraries(busca_local_par PUBLIC OpenMP::OpenMP_CXX)
#target_compile_definitions(busca_local_par PUBLIC  OpenMP::OpenMP_CXX)

add_executable(busca_exaustiva_seq  solucao-ingenua.cpp) 
target_compile_options(busca_exaustiva_seq  PUBLIC -O3)
target_compile_definitions(busca_exaustiva_seq  PUBLIC OPT)

add_executable(busca_exaustiva_par  busca_exaustiva.cpp) 
target_compile_options(busca_exaustiva_par  PUBLIC -O3)
target_link_libraries(busca_exaustiva_par PUBLIC OpenMP::OpenMP_CXX)
#target_compile_definitions(busca_exaustiva_par PUBLIC OpenMP::OpenMP_CXX)

