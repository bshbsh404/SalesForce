class PluginException implements Exception{
  final String errorCode;
  final String errorMessage;
  final String stcktrcStr;
  PluginException(this.errorCode,this.errorMessage,this.stcktrcStr);
}