#include <iostream>
#include <cmath>
#include <iomanip>      
#include <vector>
#include <chrono> 
#include <sstream>
#include <string>
#include <thrust/count.h>
#include <thrust/device_vector.h>
#include <thrust/device_ptr.h>
#include <thrust/execution_policy.h>
#include <thrust/functional.h>
#include <thrust/transform_reduce.h>
#include <thrust/random.h>
#include <thrust/random/uniform_real_distribution.h>
#include <thrust/extrema.h>
#include <thrust/device_ptr.h>

struct escolhe_alunos {
    int n_alunos,index,n_choices,seed,n_projetos;
    int *prefs,*aluno_projeto;

    escolhe_alunos (int *prefs,int *aluno_projeto,int n_projetos,int n_alunos,int n_choices,int seed): prefs(prefs),
                                                                               aluno_projeto(aluno_projeto),
                                                                               n_projetos(n_projetos),
                                                                               n_alunos(n_alunos),
                                                                               n_choices(n_choices),
                                                                               seed(seed)
                                                                               {};

    __device__ __host__
    int operator()(const int &i) {
      int choice_a1,choice_a2;

      int t=0;
      int melhor = 0;
      int satisfacao_atual= 0;
      bool flag =true;

      thrust::default_random_engine rng(i+26);
      thrust::uniform_int_distribution<int> distr(0,n_alunos-1);
      
      for(int p =n_alunos*i;p<(n_alunos*(i+1));p+=n_projetos){
        for (int j = 0; j < n_projetos; j++){
          aluno_projeto[p+j]= j;
        }
        t++;      
      }
      aluno_projeto[n_alunos*i]=0;

      for(int j=n_alunos*i;j<(n_alunos*(i+1));j++){
        index = distr(rng)+n_alunos*i;

        choice_a1 = aluno_projeto[j];
        choice_a2 = aluno_projeto[index];

        aluno_projeto[j] = choice_a2;
        aluno_projeto[index] = choice_a1;
      }

      for(int j=0;j<n_alunos;j++){
        satisfacao_atual+=prefs[(j*n_projetos)+aluno_projeto[j+n_alunos*i]];
      }

      melhor=satisfacao_atual;

      while (flag){
        flag = false;
      
        for(int j=0;j<n_alunos;j++){

          for(int k = 0; k<n_alunos;k++){
            satisfacao_atual = melhor;
            choice_a2 = aluno_projeto[k+n_alunos*i];
            choice_a1 = aluno_projeto[j+n_alunos*i];
            
            if(choice_a1!=choice_a2 and j!=k){
              satisfacao_atual-=prefs[(j*n_projetos)+choice_a1];
              satisfacao_atual-=prefs[(k*n_projetos)+choice_a2];

              satisfacao_atual+=prefs[(j*n_projetos)+choice_a2];
              satisfacao_atual+=prefs[(k*n_projetos)+choice_a1];

              if(satisfacao_atual>melhor){
                aluno_projeto[j+n_alunos*i] = choice_a2;
                aluno_projeto[k+n_alunos*i] = choice_a1;   
                melhor = satisfacao_atual;
                
                flag = true;
              }
            }
          }
        }
      }
      return  melhor;
    }
};

int main(){
    auto begin = std::chrono::high_resolution_clock::now();    

    int n,n_alunos,n_projetos,n_choices;
    thrust::device_vector<int> input, projs; //host?

    int iter = 0;
    int seed = 0;
    int c = 0;
    int melhor = 0;
    int in,ln;

    std::string p;

    if(const char* aaenv = std::getenv("ITER"))
      iter = atoi(aaenv);
    
    else 
      iter = 100000;

    if(const char* aenv = std::getenv("SEED"))
      seed = atoi(aenv);
    
    else 
      seed = 0;

    getline( std::cin, p);
    std::istringstream ss(p);

    while(ss >> n) {
      input.push_back(n);
    }
    
    n_alunos = input[0];
    n_projetos = input[1];
    n_choices = input[2];

    thrust::device_vector<int> prefs(n_alunos*n_projetos, -1);
    thrust::device_vector<int> aluno_projeto(n_alunos*iter, -1); // não escolheu projeto ainda
    thrust::device_vector<int> sat(iter, -1);
    int head = 0;

    for (int i=0; i< n_alunos; i++){        
        getline(std::cin, p);
        std::istringstream ss(p);
        projs.clear();

        while(ss >> n) {
            projs.push_back(n);
        }

        for(int j = 0; j < n_choices; j++){           
            prefs[(i*n_projetos)+projs[j]] = pow(n_choices - j, 2);
            head++;
        }
    }

    thrust::counting_iterator<int> i(0);
    escolhe_alunos refs(thrust::raw_pointer_cast(prefs.data()),
                        thrust::raw_pointer_cast(aluno_projeto.data()),
                        n_projetos,n_alunos,n_choices,seed);
                        
    thrust::transform(i, i+sat.size(), sat.begin(),refs);

    // Para roddar os testes do Jupyter, comente as linhas abaixo
    for (int i=0; i<iter; i++){
      if(sat[i]>melhor){
        melhor = sat[i];
        in =i;
      }
    } 
  //Para rodar o Jupyter comentar a parte a seguir:
    std::cout  <<melhor<< " 1\n";

    for (auto i=aluno_projeto.begin(); i!= aluno_projeto.end(); i++){
      if(c%n_alunos==0 and c!=0){
        ln++;
      }

      if(ln==in){
        std::cout << *i <<" " ;
        
      }
      c++;
    }
    std::cerr << "\n";

    auto end = std::chrono::high_resolution_clock::now();    
    auto dur = end - begin;
    auto ms = std::chrono::duration_cast<std::chrono::microseconds>(dur).count();
    //Para rodar o Jupyter descomentar a parte a seguir:
    // std::cout << "\n" << ms;}

