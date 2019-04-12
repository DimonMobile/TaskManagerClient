#include "translator.h"

#include <QGuiApplication>
#include <QQmlEngine>
#include <QTranslator>
#include <QDebug>

namespace Constants {
    const QString englishFileName = "tl_en.qm";
    const QString russianFileName = "tl_ru.qm";
}

Translator::Translator(QObject *parent) : QObject(parent), m_currentTranslator(nullptr)
{

}

void Translator::translateTo(QString fileName)
{
    if (m_currentTranslator)
    {
        qApp->removeTranslator(m_currentTranslator);
        delete m_currentTranslator;
    }
    m_currentTranslator = new QTranslator;
    m_currentTranslator->load(fileName);
    qApp->installTranslator(m_currentTranslator);
    qobject_cast<QQmlEngine*>(parent())->retranslate();
}

void Translator::translateTo(qint32 index)
{
    qDebug() << index;
    switch(index)
    {
    case 0:
        translateTo(Constants::englishFileName);
        break;
    case 1:
        translateTo(Constants::russianFileName);
        break;
    }
}
