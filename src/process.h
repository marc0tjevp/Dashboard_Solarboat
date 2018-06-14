#include <QProcess>
#include <QVariant>

class Process : public QProcess {
    Q_OBJECT

public:
    Process(QObject *parent = 0) : QProcess(parent) { }

    Q_INVOKABLE void start(const QString &program) {
        QProcess::start(program);
    }
    Q_INVOKABLE void execute(const QString &program) {
        QProcess::execute(program);
    }

    Q_INVOKABLE QByteArray readAll() {
        return QProcess::readAll();
    }
};
