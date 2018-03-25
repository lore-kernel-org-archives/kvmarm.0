From: Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH v2 0/7] KASan for arm
Date: Mon, 26 Mar 2018 10:28:30 +1030
Message-ID: <CACPK8XemuC+uACYp=tP1gJ8=9k-S69saebOLmq8nrZtqPxWRjw@mail.gmail.com>
References: <20180318125342.4278-1-liuwenliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180318125342.4278-1-liuwenliang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Abbott Liu <liuwenliang@huawei.com>
Cc: Russell King <linux@armlinux.org.uk>, aryabinin@virtuozzo.com, Marc Zyngier <marc.zyngier@arm.com>, kstewart@linuxfoundation.org, Greg KH <gregkh@linuxfoundation.org>, Florian Fainelli <f.fainelli@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Afzal Mohammed <afzal.mohd.ma@gmail.com>, alexander.levin@verizon.com, glider@google.com, dvyukov@google.com, Christoffer Dall <christoffer.dall@linaro.org>, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, Philippe Ombredanne <pombredanne@nexb.com>, ard.biesheuvel@linaro.org, vladimir.murzin@arm.com, nicolas.pitre@linaro.org, Thomas Gleixner <tglx@linutronix.de>, thgarnie@google.com, dhowells@redhat.com, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 18 March 2018 at 23:23, Abbott Liu <liuwenliang@huawei.com> wrote:

>    These patches add arch specific code for kernel address sanitizer
> (see Documentation/kasan.txt).

Thanks for implementing this. I gave the series a spin on an ASPEED
ast2500 (ARMv5) system with aspeed_g5_defconfig.

It found a bug in the NCSI code (https://github.com/openbmc/linux/issues/146).

Tested-by: Joel Stanley <joel@jms.id.au>

Cheers,

Joel
