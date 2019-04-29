/*****************************************************************************
 * settings.cpp
 *
 * Created: 29.04.2019 2019 by d.plotnikov
 *
 * Copyright © 2019 Dmitry Plotnikov. All rights reserved.
 *
 * This file may be distributed under the terms of GNU Public License version
 * 3 (GPL v3) as defined by the Free Software Foundation (FSF). A copy of the
 * license should have been included with this file, or the project in which
 * this file belongs to. You may also find the details of GPL v3 at:
 * http://www.gnu.org/licenses/gpl-3.0.txt
 *
 * If you have any questions regarding the use of this file, feel free to
 * contact the author of this file, or the owner of the project in which
 * this file belongs to.
*****************************************************************************/
#include "include/settings.h"

#include <QDebug>

Settings::Settings(QObject *parent) : QObject(parent)
{
}

void Settings::setToken(const QString &token)
{
    m_token = token;
}

QString Settings::token() const
{
    return m_token;
}
