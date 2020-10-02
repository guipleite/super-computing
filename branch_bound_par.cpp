#include <iostream>
#include <cmath>
#include <iomanip>      
#include <vector>
#include <chrono> 
#include <tuple>
#include <sstream>
#include <string>
#include <omp.h>

std::tuple<std::vector<int>,int> escolhe_alunos(std::vector<std::vector<int>>& prefs, std::vector<int>& aluno_projeto, std::vector<int>& vagas, std::tuple<std::vector<int>,int>& melhor, int satisfacao_atual=0, int i=0, bool flag = false){
  if(i == aluno_projeto.size()){  // todos alunos tem projeto
    if(satisfacao_atual>std::get<1>(melhor)){
      #pragma omp critical
      {
        if(!flag){
          std::get<0>(melhor) = aluno_projeto;
          std::get<1>(melhor) = satisfacao_atual;
          flag = true;
          
          //Para rodar o Jupyter comentar a parte a seguir:
          std::cerr << "Melhor: " << satisfacao_atual;
          for (auto i=aluno_projeto.begin(); i!= aluno_projeto.end(); i++){
            std::cerr << " " << *i ;
          }
          std::cerr << "\n";
        }   
          
        if(satisfacao_atual>std::get<1>(melhor)){
          std::get<0>(melhor) = aluno_projeto;
          std::get<1>(melhor) = satisfacao_atual; 
          flag = true;

          //Para rodar o Jupyter comentar a parte a seguir:
          std::cerr << "Melhor: " << satisfacao_atual;
          for (auto i=aluno_projeto.begin(); i!= aluno_projeto.end(); i++){
            std::cerr << " " << *i ;
          }
          std::cerr << "\n";
        }
      }
    }
    
  return melhor;
  }

  int satgt = std::get<1>(melhor) < (satisfacao_atual + pow(vagas.size(), 2)*(aluno_projeto.size()-i));

  for (int proj_atual = 0; proj_atual < prefs[1].size(); proj_atual++){
    if(vagas[proj_atual]>0 and satgt){   // projeto prefs[j] tem vaga!
      vagas[proj_atual] -= 1;
      aluno_projeto[i] = proj_atual;

      if(i<2){
        #pragma omp task shared (melhor)
        escolhe_alunos(prefs, aluno_projeto, vagas, melhor, satisfacao_atual+prefs[i][proj_atual], i+1, flag);
      }
      
      else 
        escolhe_alunos(prefs, aluno_projeto, vagas, melhor, satisfacao_atual+prefs[i][proj_atual], i+1, flag);
    
      flag = true;
      
      aluno_projeto[i] = -1;
      vagas[proj_atual] += 1;
    }
  } 
  #pragma omp taskwait
  return melhor;
}

int main(){
    auto begin = std::chrono::high_resolution_clock::now();    

    std::vector<int> input, projs;
    std::string p;
    int n,n_alunos,n_projetos,n_choices;

    getline( std::cin, p);
    std::istringstream ss(p);

    while(ss >> n) {
      input.push_back(n);
    }
    
    n_alunos = input[0];
    n_projetos = input[1];
    n_choices = input[2];

    std::vector<std::vector<int>> prefs(n_alunos, std::vector<int>(n_projetos));

    for (int i=0; i< n_alunos; i++){        
      getline(std::cin, p);
      std::istringstream ss(p);
      projs.clear();

      while(ss >> n) {
        projs.push_back(n);
      }

      for(int j = 0; j < n_choices; j++){           
        prefs[i][projs[j]] = pow(n_choices - j, 2);
      }
    }

    std::vector<int> vagas(n_projetos, 3); // 3 vagas por projeto
    std::vector<int> aluno_projeto(n_alunos, -1); // não escolheu projeto ainda

    std::tuple<std::vector<int>,int> melhor ;

    #pragma omp parallel shared (melhor)
    {
      #pragma omp master
      {
        escolhe_alunos(prefs, aluno_projeto, vagas, melhor);
      }
    }

    //Para rodar o Jupyter comentar a parte a seguir:
    std::cout <<std::get<1>(melhor) << " 1\n";
    for (auto i=std::get<0>(melhor).begin(); i!= std::get<0>(melhor).end(); i++){
      std::cout <<  *i << " ";
    }
    
    auto end = std::chrono::high_resolution_clock::now();    
    auto dur = end - begin;
    auto ms = std::chrono::duration_cast<std::chrono::microseconds>(dur).count();
    //Para rodar o Jupyter descomentar a parte a seguir:
    // std::cout << "\n" << ms;
}