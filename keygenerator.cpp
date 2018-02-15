#include <QFile>
#include <QProcess>
#include "keygenerator.h"

KeyGenerator::KeyGenerator()
    : _type("rsa"), _types{"dsa", "ecdsa", "rsa", "rsa1"}
{
}

KeyGenerator::~KeyGenerator()
{
}

QString KeyGenerator::type()
{
    return _type;
}

void KeyGenerator::setType(const QString &t)
{
    // Check for valid type.
    if (!_types.contains(t))
        return;

    if (t != _type) {
        _type = t;
        emit typeChanged();
    }
}

QStringList KeyGenerator::types()
{
    return _types;
}

QString KeyGenerator::filename()
{
    return _filename;
}

void KeyGenerator::setFilename(const QString &f)
{
    if (f != _filename) {
        _filename = f;
        emit filenameChanged();
    }
}

QString KeyGenerator::passphrase()
{
    return _passphrase;
}

void KeyGenerator::setPassphrase(const QString &p)
{
    if (p != _passphrase) {
        _passphrase = p;
        emit passphraseChanged();
    }
}

void KeyGenerator::generateKey()
{
    // Sanity check on arguments
    if (_type.isEmpty() or _filename.isEmpty() or
        (_passphrase.length() > 0 and _passphrase.length() < 5)) {
        emit keyGenerated(false);
        return;
    }

    // Remove key file if it already exists
    if (QFile::exists(_filename)) {
        QFile::remove(_filename);
    }

    // Execute ssh-keygen -t type -N passphrase -f keyfileq
    QProcess *proc = new QProcess;
    QString prog = "ssh-keygen";
    QStringList args{"-t", _type, "-N", _passphrase, "-f", _filename};
    proc->start(prog, args);
    proc->waitForFinished();
    emit keyGenerated(proc->exitCode() == 0);
    delete proc;
}
