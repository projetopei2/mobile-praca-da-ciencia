import 'package:app_praca_ciencia/core/styles/styles.dart';
import 'package:app_praca_ciencia/presentetion/pages/map_points_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_praca_ciencia/core/widgets/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // popup das intruções de como utilizar o mapa
  void _showInformationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFF66), Color(0xFFFF9900)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30), // Espaço para o botão no topo
                      Text(
                        'Seja bem vindo (a) ao Mapa Interativo da Praça da Ciência!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Styles.fontColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'INSTRUÇÕES',
                        style: TextStyle(
                          color: Styles.fontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Clique nos ícones brilhantes para mais informações como fotos, descrição e funcionalidades dos equipamentos!\nArraste com os dedos e navegue pelo mapa.',
                        style: TextStyle(
                          color: Styles.fontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                // Botao para fechar o popup
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Styles.fontColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _setLandscapeOrientation();
    _checkAndShowDialogOnce();
  }

  void _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _checkAndShowDialogOnce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenPopup = prefs.getBool('hasSeenPopup') ?? false;

    if (!hasSeenPopup) {
      _showInformationDialog();
      await prefs.setBool('hasSeenPopup', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lista de pontos a serem exibidos no mapa
    final points = [
      MapPoint(
        id: '1',
        title: 'Gyrotec',
        xRel: 0.82,
        yRel: 0.57,
        widthFactor: 0.04,
        heightFactor: 0.18,
        text:
            'É um equipamento baseado no giro de um volante (como um pião). Quando girado rapidamente, ele demonstra a conservação do momento angular, que é a tendência de um objeto girando manter sua rotação. Ao tentar mudar sua direção, o Gyrotec resiste ao movimento, mostrando na prática como funcionam giroscópios. \n\nUsados em satélites, drones e aviões para orientação.',
        img: 'assets/images/Gyrotec.png',
        link:
            'https://drive.google.com/file/d/1Vjl6jH8u5PS_HKPcvD274E_0nLfDRrpI/view',
      ),
      MapPoint(
        id: '2',
        title: 'Gerador Manual',
        xRel: 0.413,
        yRel: 0.54,
        widthFactor: 0.04,
        heightFactor: 0.14,
        text:
            'Um dínamo é acionado manualmente por uma manivela, transformando energia mecânica em energia elétrica. A rotação do eixo movimenta ímãs e bobinas internas, gerando corrente elétrica — acendendo lâmpadas ou movendo pequenos dispositivos.\n\nDemonstra os princípios da geração de eletricidade usados em usinas e bicicletas.',
        img: 'assets/images/GeradorManual.png',
        link:
            'https://drive.google.com/file/d/1CiSq01Sz2B58eJ7B4gRwNgaZGDEVJS4e/view',
      ),
      MapPoint(
        id: '3',
        title: 'Sistema Solar',
        xRel: 0.273,
        yRel: 0.52,
        widthFactor: 0.07,
        heightFactor: 0.25,
        text:
            'Este modelo mostra os planetas girando ao redor do Sol, cada um em sua órbita. Serve para visualizar a posição, os tamanhos relativos e os movimentos dos corpos celestes. Pode incluir o movimento de rotação (em torno do próprio eixo) e translação (em torno do Sol), facilitando o entendimento do dia e noite, estações do ano e anos solares.',
        img: 'assets/images/SistemaSolar.png',
        link:
            'https://drive.google.com/file/d/1jUuyo0McRNr1XpOpLIGgiRTqwspNedh8/view',
      ),
      MapPoint(
        id: '4',
        title: 'João Bobo',
        xRel: 0.626,
        yRel: 0.51,
        widthFactor: 0.03,
        heightFactor: 0.20,
        text:
            'Boneco com peso na base, que sempre volta à posição original mesmo quando empurrado. Demonstra o centro de massa e equilíbrio estável, ajudando a entender porque alguns objetos se mantêm em pé mesmo sendo instáveis à primeira vista. Usado em bonecos “joão-bobo” e dispositivos de estabilização naval (como quilhas) usam o mesmo princípio de autoequilíbrio.',
        img: 'assets/images/Teimosinho.png',
        link:
            'https://drive.google.com/file/d/18ypPaWGv8VZepIQtCpRXMkCoVYxwUVx1/view',
      ),
      MapPoint(
        id: '5',
        title: 'Plano Inclinado',
        xRel: 0.690,
        yRel: 0.35,
        widthFactor: 0.11,
        heightFactor: 0.19,
        text:
            'Uma rampa usada para mostrar como objetos descem ou sobem com menos esforço do que se fossem erguidos verticalmente. Ilustra o conceito de força dividida em componentes. Usado em escorregadores, estradas e cadeiras de rodas.',
        img: 'assets/images/PlanoInclinado.png',
        link:
            'https://drive.google.com/file/d/1zQUtyXZu8RzWNxKLWgSvFvSb83g-uFyi/view',
      ),
      MapPoint(
        id: '6',
        title: 'Prato Giratório',
        xRel: 0.663,
        yRel: 0.48,
        widthFactor: 0.04,
        heightFactor: 0.20,
        text:
            'Uma plataforma que gira ao ser impulsionada. Mostra conceitos de inércia, rotação e centrífuga. Ao mudar a posição do corpo sobre o prato, é possível perceber o efeito da distribuição de massa na velocidade do giro. Patinadores artísticos usam essa técnica para acelerar ou desacelerar giros com simples movimentos do corpo.',
        img: 'assets/images/PratoGiratorio.png',
        link:
            'https://drive.google.com/file/d/1x02xPOpoQ8G2bZNtB067iu6LmrrAnS53/view',
      ),
      MapPoint(
        id: '7',
        title: 'Espelho de Som',
        xRel: 0.480,
        yRel: 0.35,
        widthFactor: 0.04,
        heightFactor: 0.21,
        text:
            'Consiste em superfícies côncavas que refletem ondas sonoras. Se duas pessoas falarem nos focos opostos, conseguem se ouvir mesmo a certa distância. Mostra como o som viaja em linha reta, pode ser refletido e concentrado. O mesmo princípio usado em auditórios e aparelhos auditivos.',
        img: 'assets/images/EspelhoDeSom.png',
        link:
            'https://drive.google.com/file/d/1g3A4ahmf4lA9MHbzVrz-GcP823fPN9_v/view',
      ),
      MapPoint(
        id: '8',
        title: 'Espelho de Som',
        xRel: 0.565,
        yRel: 0.47,
        widthFactor: 0.04,
        heightFactor: 0.20,
        text:
            'Consiste em superfícies côncavas que refletem ondas sonoras. Se duas pessoas falarem nos focos opostos, conseguem se ouvir mesmo a certa distância. Mostra como o som viaja em linha reta, pode ser refletido e concentrado. O mesmo princípio usado em auditórios e aparelhos auditivos.',
        img: 'assets/images/EspelhoDeSom.png',
        link:
            'https://drive.google.com/file/d/1g3A4ahmf4lA9MHbzVrz-GcP823fPN9_v/view',
      ),
      MapPoint(
        id: '9',
        title: 'Escala Musical',
        xRel: 0.478,
        yRel: 0.48,
        widthFactor: 0.037,
        heightFactor: 0.12,
        text:
            'Painel com tubos, barras ou cordas de diferentes comprimentos e tensões que, ao serem tocados, emitem sons de alturas diferentes. Mostra como o tamanho, espessura e material influenciam na frequência e no som produzido. Ajuda a entender como instrumentos musicais produzem notas. Usado em instrumentos como xilofones e flautas utilizam os mesmos princípios. Uma flauta muda o comprimento da coluna de ar para produzir notas.',
        img: 'assets/images/EscalaMusical.png',
        link:
            'https://drive.google.com/file/d/1c6iS70QTfPBtgVsDNotux2zWnXVvTkbE/view',
      ),
      MapPoint(
        id: '10',
        title: 'Espelhos Curvos',
        xRel: 0.749,
        yRel: 0.46,
        widthFactor: 0.03,
        heightFactor: 0.19,
        text:
            'Inclui espelhos côncavos (que convergem a luz) e convexos (que a espalham). Mostram como diferentes curvaturas afetam a formação, tamanho e posição das imagens. São usados em faróis, câmeras de segurança e telescópios.',
        img: 'assets/images/EspelhosCurvos.png',
        link:
            'https://drive.google.com/file/d/1vMBLekdBMeCdTTDsEQyykKc_6nBvpBUj/view',
      ),
      MapPoint(
        id: '11',
        title: 'Alavancas',
        xRel: 0.637,
        yRel: 0.23,
        widthFactor: 0.03,
        heightFactor: 0.15,
        text:
            'Sistema composto por uma barra rígida apoiada em um ponto fixo (fulcro), no qual uma força aplicada em uma extremidade gera movimento na outra. Demonstra os três tipos de alavancas (interfixa, inter-resistente e interpotente) e como a força, resistência e distância do ponto de apoio influenciam na eficiência do sistema.\n\nUsado em alicates, tesouras, alavancas hidráulicas e até catapultas usam este princípio para multiplicar forças.',
        img: 'assets/images/Alavancas.png',
        link:
            'https://drive.google.com/file/d/17GPJUEpTxsTibH4ryij7Ykxzp2x-SVwP/view?usp=drive_link',
      ),
      MapPoint(
        id: '12',
        title: 'Elevador de Mão',
        xRel: 0.512,
        yRel: 0.53,
        widthFactor: 0.03,
        heightFactor: 0.20,
        text:
            'Mostra como é possível erguer um peso com menos força usando um sistema de polias e cordas. Ao puxar a corda, a força é distribuída, reduzindo o esforço necessário.\n\nExplica o funcionamento de guindastes, elevadores e outros sistemas de elevação mecânica.',
        img: 'assets/images/ElevadorDeMao.png',
        link:
            'https://drive.google.com/file/d/1HklZKnOSrOLM_86vM6tiGHClH6IoZQvL/view?usp=drive_link',
      ),
      MapPoint(
        id: '13',
        title: 'Espelho Plano',
        xRel: 0.775,
        yRel: 0.45,
        widthFactor: 0.02,
        heightFactor: 0.13,
        text:
            'Reflete a luz em ângulo igual ao que a recebe, criando uma imagem igual ao objeto, mas invertida lateralmente.\n\nExplica como a reflexão da luz funciona no cotidiano, como nos espelhos de banheiro ou retrovisores.',
        img: 'assets/images/EspelhoPlano.png',
        link:
            'https://drive.google.com/file/d/1wjMAXBAzsv2kW8JJdT2DjNSw7BIPec4E/view?usp=drive_link',
      ),
      MapPoint(
        id: '14',
        title: 'Gangorras de Níveis',
        xRel: 0.845,
        yRel: 0.44,
        widthFactor: 0.03,
        heightFactor: 0.20,
        text:
            'Boneco com peso na base, que sempre volta à posição original mesmo quando empurrado. Demonstra o centro de massa e equilíbrio estável, ajudando a entender porque alguns objetos se mantêm em pé mesmo sendo instáveis à primeira vista.\n\nUsado em bonecos “joão-bobo” e dispositivos de estabilização naval (como quilhas) usam o mesmo princípio de autoequilíbrio.',
        img: 'assets/images/GangorrasDeNiveis.png',
        link:
            'https://drive.google.com/file/u/1/d/1NDil1CQqIHRunchhtgOAnYTPPmHvgRgh/view?usp=drive_link',
      ),
      MapPoint(
        id: '15',
        title: 'Balanços',
        xRel: 0.606,
        yRel: 0.36,
        widthFactor: 0.04,
        heightFactor: 0.18,
        text:
            'São objetos suspensos por um fio ou haste que oscilam de um lado para o outro. Mostram como a gravidade e o comprimento do fio afetam o tempo de oscilação.\n\nTambém demonstram os conceitos de energia cinética e potencial em movimento harmônico.',
        img: 'assets/images/Balancos.png',
        link:
            'https://drive.google.com/file/d/1HEkGHmtOQhxOJpnsEJJn1vedAAhfZveV/view?usp=drive_link',
      ),
      MapPoint(
        id: '16',
        title: 'Refletor de Luz Parabólico',
        xRel: 0.116,
        yRel: 0.72,
        widthFactor: 0.03,
        heightFactor: 0.15,
        text:
            'Espelho em forma de parábola que concentra as ondas em um único ponto (foco). Pode refletir luz ou som, e é usado em antenas parabólicas, refletores e equipamentos de observação astronômica. Mostra como a forma geométrica influencia na propagação das ondas.\n\nUsado em antenas parabólicas, faróis de carros e refletores astronômicos (como os de radiotelescópios) funcionam com esse princípio para concentrar sinais ou luz.',
        img: 'assets/images/RefletorParabolico.png',
        link:
            'https://drive.google.com/file/d/1PGPLDTOOM0MAXTbc9I246lzWSJ2tHfRA/view?usp=drive_link',
      ),
      MapPoint(
        id: '17',
        title: 'Relógio de Sol',
        xRel: 0.438,
        yRel: 0.280,
        widthFactor: 0.05,
        heightFactor: 0.20,
        text:
            'Funciona com uma haste (gnômon) que projeta uma sombra sobre uma base com marcações das horas. Conforme o Sol se move no céu, a posição da sombra muda. Mostra como nossos antepassados mediam o tempo com base no movimento solar. Depende da posição geográfica e da inclinação da haste em relação ao eixo da Terra.',
        img: 'assets/images/RelogioDeSol.png',
        link:
            'https://drive.google.com/file/d/1Rvez2TmpAs_GNDL74wga4BRM9INP9Ate/view?usp=drive_link',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              // Ao sair volta a tela ao normal
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
              return true;
            },
            child: InteractiveMap(
              imageAsset: 'assets/images/mapa.png',
              points: points,
              hitBoxColor: const Color.fromARGB(255, 0, 0, 0),
              onPointTap: (point) async {
                // Volta para orientação portrait antes de navegar
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MapPointInformationScreen(
                          title: point.title,
                          text: point.text,
                          img: point.img,
                          link: point.link,
                        ),
                  ),
                ).then((_) {
                  // Quando volta para o mapa, restaura orientação landscape
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                });
              },
            ),
          ),
          // Botão de voltar no canto superior esquerdo
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(12),
              ),
              onPressed: () {
                // Ao sair volta a tela ao normal
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
