#include <iostream>
#include <cmath>
#include <iomanip>      
#include <vector>
#include <chrono> 
#include <tuple>
#include <sstream>
#include <string>
#include <random>

std::tuple<std::vector<int>,int> escolhe_alunos(std::vector<std::vector<int>>& prefs, std::tuple<std::vector<int>,int>& melhor, int & n_alunos){
   
  int satisfacao_atual,choice_a1,choice_a2,satisfacao_buff;
  std::vector<int> aluno_projeto(n_alunos, -1); // não escolheu projeto ainda
  aluno_projeto = std::get<0>(melhor);
  satisfacao_atual = std::get<1>(melhor);
  
  for(int i = 0; i<n_alunos;i++){

    aluno_projeto = std::get<0>(melhor);
    satisfacao_atual = std::get<1>(melhor);

    // satisfacao_buff = satisfacao_atual;
    choice_a1 = aluno_projeto[i];

    for(int j = 0; j<n_alunos;j++){

      aluno_projeto = std::get<0>(melhor);
      satisfacao_buff = satisfacao_atual;

      choice_a2 = aluno_projeto[j];

      if(choice_a1!=choice_a2 and j!=i){

        satisfacao_buff -= prefs[i][choice_a1];
        satisfacao_buff -= prefs[j][choice_a2];

        aluno_projeto[i] = choice_a2;
        aluno_projeto[j] = choice_a1;

        satisfacao_buff += prefs[i][choice_a2];
        satisfacao_buff += prefs[j][choice_a1];

        if (satisfacao_buff>satisfacao_atual){

          std::get<0>(melhor) = aluno_projeto;
          std::get<1>(melhor) = satisfacao_buff;

          melhor = escolhe_alunos(prefs, melhor,n_alunos);

          return melhor;
        }
      }
    }
  }
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

    std::vector<int> aluno_projeto(n_alunos, -1); // não escolheu projeto ainda
    std::tuple<std::vector<int>,int> melhor ;
    std::tuple<std::vector<int>,int> rando ;
    std::tuple<std::vector<int>,int> buff ;

    int iter = 0;
    int seed = 0;

    if(const char* aaenv = std::getenv("ITER"))
      iter = atoi(aaenv);
    
    else 
      iter = 100000;

    if(const char* aenv = std::getenv("SEED"))
      seed = atoi(aenv);
    
    else 
      seed = 0;

    std::mt19937 eng(seed); // seed the generator
    std::uniform_int_distribution<> distr(0, n_projetos-1); // define the ran
    int choice;
    int satisfacao_atual;
    bool f= true;

    for(int k=0;k<iter;k++){
      std::vector<int> vagas(n_projetos, 3);  // 3 vagas por projeto
      satisfacao_atual = 0;

      for(int n = 0; n<n_alunos;n++){
        choice = distr(eng);

        if(vagas[choice]>0){   // projeto tem vaga!
          vagas[choice] -= 1;
          aluno_projeto[n] = choice;
          satisfacao_atual+=prefs[n][choice];
        }
        else
          n--;
      }
      if(f){
        //Para rodar o Jupyter comentar a parte a seguir:
        std::cerr << "Inicial " <<satisfacao_atual;
        for (auto i=aluno_projeto.begin(); i!= aluno_projeto.end(); i++){
            std::cerr << " " << *i ;
        }
        std::cerr << "\n";

        f=false;
      }
      std::get<0>(rando) = aluno_projeto;
      std::get<1>(rando) = satisfacao_atual;      

      buff = escolhe_alunos(prefs, rando,n_alunos);

      if( std::get<1>(melhor)< std::get<1>(buff)){
        melhor=buff;

        //Para rodar o Jupyter comentar a parte a seguir:
        std::cerr << "Iteracao " << std::get<1>(melhor);
        for (auto i=std::get<0>(melhor).begin(); i!= std::get<0>(melhor).end(); i++){
            std::cerr << " " << *i ;
        }
        std::cerr << "\n";
      }
    }
    //Para rodar o Jupyter comentar a parte a seguir:
    std::cout <<std::get<1>(melhor) << " 0\n";
    for (auto i=std::get<0>(melhor).begin(); i!= std::get<0>(melhor).end(); i++){
      std::cout <<  *i << " ";
    }
    
    auto end = std::chrono::high_resolution_clock::now();    
    auto dur = end - begin;
    auto ms = std::chrono::duration_cast<std::chrono::microseconds>(dur).count();
    //Para rodar o Jupyter descomentar a parte a seguir:
    std::cout << "\n" << ms;
 
}