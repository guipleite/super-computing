import sys
import os
import subprocess
import re
from grading_utils import ProgramTest, valid_solution, parse_input, satisfaction
from grading_utils import TestConfiguration, parse_output, RepeaterTest

from validacao_pfe import BuscaLocalTest


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Uso: ./validacao-busca-local executavel')
        sys.exit(-1)

    tests = TestConfiguration.from_pattern('entradas', 'in_local', check_stderr=False,
                                           environ={'ITER': '1', 'SEED': '10'})
    t = BuscaLocalTest(sys.argv[1], tests)
    t.main()
    
    teste_grande = TestConfiguration.from_file('entradas/in_local_72_24_5', 'entradas/out_local_72_24_5', check_stderr=False,
                                           environ={'ITER': '10', 'SEED': '1'})
    r = RepeaterTest(sys.argv[1], teste_grande, 10)
    r.main()
    


