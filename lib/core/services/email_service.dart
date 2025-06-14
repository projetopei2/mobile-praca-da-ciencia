import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';

class EmailService {
  static final String _pracaEmail = 'projetopei22025@gmail.com';
  static final String _senderEmail = 'projetopei22025@gmail.com';
  static final String _senderPassword = 'jsse csnk tjnl ddby';

  // Envia e-mail de confirmação para o visitante
  static Future<void> sendConfirmationToVisitor({
    required String visitorEmail,
    required String visitorName,
    required DateTime selectedDate,
    required String selectedTime,
    required int quantity,
  }) async {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final formattedCreatedAt = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.now());

    final smtpServer = gmail(_senderEmail, _senderPassword);

    final message =
        Message()
          ..from = Address(_senderEmail, 'Praça da Ciência')
          ..recipients.add(visitorEmail)
          ..subject =
              'Agendamento Confirmado - $visitorName - $formattedDate $selectedTime'
          ..html = """
        <h1>Obrigado por Efetuar o Agendamento, $visitorName!</h1>
        <ul>
          <li>Dia Agendado: $formattedDate</li>
          <li>Horário: $selectedTime</li>
          <li>Agendamento criado em: $formattedCreatedAt</li>
          <li>Quantidade de pessoas: $quantity</li>
        </ul>
        <p>Seu agendamento foi marcado com sucesso!</p>
        <p>A Praça da Ciência agradece sua visita!</p>
      """;

    await send(message, smtpServer);
  }

  // Envia e-mail de confirmação para a escola
  static Future<void> sendConfirmationToEscola({
    required String escolaEmail,
    required String escolaName,
    required DateTime selectedDate,
    required String selectedTime,
    required String quantityStudants,
    required String quantityTeachers,
    required String roteiro,
  }) async {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final formattedCreatedAt = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(DateTime.now());

    final smtpServer = gmail(_senderEmail, _senderPassword);

    final message =
        Message()
          ..from = Address(_senderEmail, 'Praça da Ciência')
          ..recipients.add(escolaEmail)
          ..subject =
              'Agendamento Confirmado - $escolaName - $formattedDate $selectedTime'
          ..html = """
        <h1>Obrigado por Efetuar o Agendamento, $escolaName!</h1>
        <ul>
          <li>Dia Agendado: $formattedDate</li>
          <li>Horário: $selectedTime</li>
          <li>Agendamento criado em: $formattedCreatedAt</li>
          <li>Quantidade de alunos: $quantityStudants</li>
          <li>Quantidade de acompanhantes: $quantityTeachers</li>
          <li>Roteiro escolhido: $roteiro</li>
        </ul>
        <p>Seu agendamento foi marcado com sucesso!</p>
        <p>A Praça da Ciência agradece sua visita!</p>
      """;

    await send(message, smtpServer);
  }

  // Envia e-mail de notificação para a Praça da Ciência referente a visitante
  static Future<void> sendNotificationToPracaVisitantes({
    required String visitorName,
    required String visitorEmail,
    required String visitorPhone,
    required DateTime selectedDate,
    required String selectedTime,
    required int quantity,
    required String cep,
  }) async {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final formattedTime = DateFormat('HH:mm').format(DateTime.now());

    final smtpServer = gmail(_senderEmail, _senderPassword);

    final message =
        Message()
          ..from = Address(_senderEmail, 'Sistema de Agendamentos')
          ..recipients.add(_pracaEmail)
          ..subject =
              'Novo Agendamento - $visitorName - $formattedDate $selectedTime'
          ..html = """
        <h1>Novo Agendamento Registrado</h1>
        <h2>Detalhes do Visitante:</h2>
        <ul>
          <li><strong>Nome:</strong> $visitorName</li>
          <li><strong>E-mail:</strong> $visitorEmail</li>
          <li><strong>Telefone:</strong> $visitorPhone</li>
          <li><strong>CEP:</strong> $cep</li>
        </ul>
        
        <h2>Detalhes do Agendamento:</h2>
        <ul>
          <li><strong>Data:</strong> $formattedDate</li>
          <li><strong>Horário:</strong> $selectedTime</li>
          <li><strong>Quantidade de pessoas:</strong> $quantity</li>
          <li><strong>Registrado em:</strong> $formattedTime</li>
        </ul>
        
        <p>Este é um e-mail automático, por favor não responda.</p>
      """;

    await send(message, smtpServer);
  }

  // Envia e-mail de notificação para a Praça da Ciência referente a escolas
  static Future<void> sendNotificationToPracaEscolas({
    required String visitorName,
    required String visitorEmail,
    required String visitorPhone,
    required DateTime selectedDate,
    required String selectedTime,
    required String cep,
    required String municipio,
    required String quantityStudants,
    required String quantityTeachers,
    required String roteiro,
  }) async {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

    final smtpServer = gmail(_senderEmail, _senderPassword);

    final message =
        Message()
          ..from = Address(_senderEmail, 'Sistema de Agendamentos')
          ..recipients.add(_pracaEmail)
          ..subject =
              'Novo Agendamento - $visitorName - $formattedDate $selectedTime'
          ..html = """
        <h1>Novo Agendamento Registrado</h1>
        <h2>Detalhes da Escola:</h2>
        <ul>
          <li><strong>Nome:</strong> $visitorName</li>
          <li><strong>E-mail:</strong> $visitorEmail</li>
          <li><strong>Telefone:</strong> $visitorPhone</li>
          <li><strong>CEP:</strong> $cep</li>
          <li><strong>Município:</strong> $municipio</li>
        </ul>
        
        <h2>Detalhes do Agendamento:</h2>
        <ul>
          <li><strong>Data:</strong> $formattedDate</li>
          <li><strong>Horário:</strong> $selectedTime</li>
          <li><strong>Quantidade de alunos:</strong> $quantityStudants</li>
          <li><strong>Quantidade de acompanhantes:</strong> $quantityTeachers</li>
          <li><strong>Roteiro escolhido:</strong> $roteiro</li>
        </ul>
        
        <p>Este é um e-mail automático, por favor não responda.</p>
      """;

    await send(message, smtpServer);
  }
}
