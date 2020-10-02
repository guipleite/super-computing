from grading_utils import IOTest, TestConfiguration
from validacao_pfe import TestePFEExaustivo
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Uso: ./validacao-exaustivo executavel')
        sys.exit(-1)

    tests = TestConfiguration.from_pattern('entradas', 'in_exaustivo')
    t = TestePFEExaustivo(sys.argv[1], tests)
    t.main()
