import 'package:arreglapp/src/models/job_request.dart';

class JobRequestUtil {
  String getJobRequestStatus(bool myRequest, JobRequest jobRequest, {bool isSearchNewRequests = false}) {
    return myRequest ? _getJobRequestClientStatus(jobRequest) : _getJobRequestProviderStatus(jobRequest, isSearchNewRequests);
  }

  String _getJobRequestClientStatus(JobRequest jobRequest) {
    if (jobRequest.payed) {
      return "Pagado";
    } else if (jobRequest.budget != null) {
      return "Pago pendiente";
    } else if (jobRequest.userContactInfo.confirmed) {
      return "Esperando presupuesto";
    }

    return "Pendiente";
  }

  String _getJobRequestProviderStatus(JobRequest jobRequest, bool isSearchNewRequests) {
    if (jobRequest.transactionFeePayed) {
      return "En revision de pago";
    } else if (jobRequest.payed) {
      return "Comision pendiente";
    } else if (jobRequest.budget != null) {
      return "Esperando pago";
    } else if (jobRequest.userContactInfo.confirmed) {
      return "Presupuesto pendiente";
    } else if (isSearchNewRequests) {
      return "Nueva";
    }

    return "Pendiente";
  }
}
