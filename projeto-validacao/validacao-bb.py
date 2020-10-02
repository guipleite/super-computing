import sys
from grading_utils import IOTest, TestConfiguration

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Uso: ./validacao-bb executavel')
        sys.exit(-1)
    
    tests = TestConfiguration.from_pattern('entradas', 'in_bb')
    t = IOTest(sys.argv[1], tests)
    t.main()
