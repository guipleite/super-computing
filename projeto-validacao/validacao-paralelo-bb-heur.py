from grading_utils import PerformanceTest, TestConfiguration, RepeaterTest
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print('Uso: ./validacao-exaustivo executavel')
        sys.exit(-1)

    tests_bb = TestConfiguration.from_pattern('entradas', 'in_bb', check_stderr=False, time_limit=0.5)
    tests_heur = TestConfiguration.from_pattern('entradas', 'in_heur', check_stderr=False, time_limit=1.0)
    tests_heur['entradas/in_heur_33_11_5'].time_limit = 75
    tests = {}
    tests.update(tests_bb)
    tests.update(tests_heur)

    t = PerformanceTest(sys.argv[1], tests)
    t.main()

    teste_repetido = TestConfiguration.from_file('entradas/in_heur_30_10_6', 'entradas/out_heur_30_10_6', check_stderr=False)
    r = RepeaterTest(sys.argv[1], teste_repetido, 10)
    r.main()

