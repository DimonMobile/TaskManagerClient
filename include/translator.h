#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>

class QTranslator;

class Translator : public QObject
{
    Q_OBJECT
public:
    Translator(QObject *parent = nullptr);
    Q_INVOKABLE void translateTo(QString fileName);
    Q_INVOKABLE void translateTo(qint32 index);
private:
    QTranslator * m_currentTranslator;
};

#endif // TRANSLATOR_H
