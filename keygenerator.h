#ifndef KEYGENERATOR_H
#define KEYGENERATOR_H

#include <QObject>
#include <QString>
#include <QStringList>

// Simple QML object to generate SSH key pairs by calling ssh-keygen.

class KeyGenerator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QStringList types READ types NOTIFY typesChanged)
    Q_PROPERTY(QString filename READ filename WRITE setFilename NOTIFY filenameChanged)
    Q_PROPERTY(QString passphrase READ filename WRITE setPassphrase NOTIFY passphraseChanged)

public:
    KeyGenerator();
    ~KeyGenerator();

    QString type();
    void setType(const QString &t);

    QStringList types();

    QString filename();
    void setFilename(const QString &f);

    QString passphrase();
    void setPassphrase(const QString &p);

public slots:
    void generateKey();

signals:
    void typeChanged();
    void typesChanged();
    void filenameChanged();
    void passphraseChanged();
    void keyGenerated(bool success);

private:
    QString _type;
    QString _filename;
    QString _passphrase;
    QStringList _types;
};
#endif
