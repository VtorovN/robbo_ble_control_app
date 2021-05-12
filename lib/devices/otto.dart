import 'command.dart';

class Device {
  Set<Command> _commands = new Set<Command>();
  Command _currentCommand;

  Device() {
    // TODO: make constructor
  }

  void runCommand(String commandID) { // or name?
    // TODO: find command and run
  }
}