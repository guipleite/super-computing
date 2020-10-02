import sys
from grading_utils import ProgramTest, IOTest, TestConfiguration
from validacao_pfe import *

class TestePFEHeuristico(ProgramTest, SolucaoValidaMixin, SatisfacaoOtimaMixin):
    pass

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Uso: ./validacao-bb executavel')
        sys.exit(-1)
    
    tests = TestConfiguration.from_pattern('entradas', 'in_bb',  
        check_stderr=False, time_limit=2.0)

    tests_heur = TestConfiguration.from_pattern('entradas', 'in_heur', check_stderr=False)
    tests_heur['entradas/in_heur_24_8_6'].time_limit = 1.5
    tests_heur['entradas/in_heur_27_9_5'].time_limit = 4
    tests_heur['entradas/in_heur_30_10_6'].time_limit = 2
    tests_heur['entradas/in_heur_33_11_5'].time_limit = 300
    tests.update(tests_heur)
    t = TestePFEHeuristico(sys.argv[1], tests)
    t.main()
