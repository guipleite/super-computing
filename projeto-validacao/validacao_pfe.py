from grading_utils import ProgramTest, TestConfiguration, CheckStderrMixin, CheckOutputMixin, PerformanceTest
import numpy as np
import re

def parse_output(output):
    if not isinstance(output, list):
        output = output.split('\n')

    print([int(x) for x in output[0].split()])
    sat, opt = [int(x) for x in output[0].split()]
    attr = [int(x) for x in output[1].split()]

    return sat, opt, attr


def parse_input(input_txt):
    if not isinstance(input_txt, list):
        input_txt = input_txt.split('\n')
    n_alunos, n_projetos, n_choices = [int(p) for p in input_txt[0].split()]
    prefs = np.zeros((n_alunos, n_projetos), np.uint32)
    for i in range(n_alunos):
        projs = [int(c) for c in input_txt[i+1].split(' ')]
        for j, p in enumerate(projs):
            prefs[i, p] = pow(n_choices - j, 2)

    return prefs, n_choices


def satisfaction(attr, prefs):
    sat = 0
    for i in range(len(attr)):
        sat += prefs[i, attr[i]]
    return sat


class SolucaoValidaMixin:
    def test_solucao_valida(self, test, stdout, stderr):
        sat, opt, attr = parse_output(stdout)
        prefs, n_choices = parse_input(test.input)
        return sat == satisfaction(attr, prefs)


class SatisfacaoOtimaMixin:
    def test_satisfacao_otima(self, test, stdout, stderr):
        sat, opt, attr = parse_output(stdout)
        esat, eopt, eattr = parse_output(test.output)
        prefs, n_choices = parse_input(test.input)
        return esat == sat

class ChecaSatisfacoesStderrMixin:
    def test_checa_satisfacoes_em_stderr(self, test, stdout, stderr):
        prefs, n_choices = parse_input(test.input)

        for i, l in enumerate(stderr.split('\n')):
            if l.startswith('Melhor:') or l.startswith('Inicial') or \
               l.startswith('Iter:'):

                sat, *attr = l.split()[1:]
                sat = int(sat)
                attr = [int(i) for i in attr]
                sat_comp = 0
                for k, p in enumerate(attr):
                    sat_comp += prefs[k, p]
                if sat != sat_comp:
                    print(f'Erro na verificação da linha {i}:')
                    print(f'Satisfação lida: {sat}')
                    print(f'Satisfação real: {sat_comp}')
                    return False
        
        return True


class TestePFEExaustivo(ProgramTest, SolucaoValidaMixin, CheckStderrMixin, 
                        CheckOutputMixin, ChecaSatisfacoesStderrMixin):
    pass


class TestePFEHeuristicoParalelo(PerformanceTest, SolucaoValidaMixin, SatisfacaoOtimaMixin):
    pass


class TestePFERepeticaoParalela(ProgramTest, SolucaoValidaMixin):
    def test_mesma_satisfacao_que_anterior(self, test, stdout, stderr):
        sat, opt, attr = parse_output(stdout)
        esat, eopt, eattr = parse_output(test.output)
        prefs, n_choices = parse_input(test.input)
        
        try:
            getattr(self, 'last_test')
        except AttributeError:
            self.last_test = (sat, attr)
            return True

        equal = self.last_test[0] == sat
        self.last_test = (sat, attr)
        return equal

class SolucaoOtimoLocalMixin:
    def test_solucao_otimo_local(self, test, stdout, stderr):
        sat_atual, opt, attr_atual = parse_output(stdout)
        prefs, n_choices = parse_input(test.input)
    
        for i in range(prefs.shape[0]):
            for j in range(prefs.shape[0]):
                # NOTE: Isto está feito ruim de propósito para não entregar o algoritmo
                attr_teste = attr_atual.copy()
                attr_teste[i], attr_teste[j] = attr_teste[j], attr_teste[i]
                sat_teste = satisfaction(attr_teste, prefs)
                if sat_teste > sat_atual:
                    print('Troca entre', i, 'e', j, 'melhoraria solucao:', sat_teste)
                    return False
        
        return True
        
class BuscaLocalGPU(ProgramTest, SolucaoValidaMixin, SolucaoOtimoLocalMixin):
    pass


class BuscaLocalParalelaTest(PerformanceTest, SolucaoOtimoLocalMixin, SolucaoValidaMixin):
    pass


class BuscaLocalTest(ProgramTest, SolucaoValidaMixin, SolucaoOtimoLocalMixin):
    def test_executa_ITER_vezes(self, test, stdout, stderr):
        m = re.findall('Inicial', stderr)
        return len(m) == int(test.environ['ITER'])

    def test_solucao_sempre_melhora(self, test, stdout, stderr):
        sempre_melhora = True
        sat_atual = -1
        for l in stderr.split('\n'):
            _, sat_next, *attr_next = l.split(' ')
            sat_next = int(sat_next)
            
            if sat_next < sat_atual:
                sempre_melhora = False

            sat_atual = sat_next
        
        return sempre_melhora

