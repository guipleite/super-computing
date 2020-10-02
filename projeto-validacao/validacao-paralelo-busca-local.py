from grading_utils import PerformanceTest, TestConfiguration, RepeaterTest
import sys
from validacao_pfe import BuscaLocalParalelaTest, TestePFERepeticaoParalela

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Uso: ./validacao-exaustivo executavel')
        sys.exit(-1)

    tests = TestConfiguration.from_pattern('entradas', 'in_heur', 
        check_stderr=False, environ={'ITER': '10000'}, time_limit=2.0)

    teste_grande = TestConfiguration.from_file('entradas/in_local_72_24_5', 'entradas/out_local_72_24_5', 
        check_stderr=False, environ={'ITER': '10000'}, time_limit=5)
    tests['Grande'] = teste_grande

    t = BuscaLocalParalelaTest(sys.argv[1], tests)
    t.main()

    teste_repetido = TestConfiguration.from_file('entradas/in_local_72_24_5', 'entradas/out_local_72_24_5', check_stderr=False,
                                    environ={'ITER': '10', 'SEED': '10'})
    r = TestePFERepeticaoParalela(sys.argv[1], {'Execucao %d'%i :teste_repetido for i in range(10)})
    r.main()

