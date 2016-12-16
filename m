From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 16 Dec 2016 21:34:49 +0100
Message-ID: <CAMuHMdWnLeT=j1nXmr4ezV+o9aOu0OvM0X-gq5coBJvsJ8uOGw@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <CAMuHMdUa4j8nxrW=fSJQZok3=mW-FWZWHR=cYS2R0gQUeGHgmQ@mail.gmail.com>
 <3679707.TKdvBNIRe2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <3679707.TKdvBNIRe2@wuerfel>
Sender: linux-kbuild-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,

On Fri, Dec 16, 2016 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday, December 16, 2016 4:54:33 PM CET Geert Uytterhoeven wrote:
>> On Fri, Dec 16, 2016 at 11:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > Specifically on ARM, going further makes things rather useless especially
>> > for build testing: with gcc-4.2, we lose support for ARMv7, EABI, and
>> > effectively ARMv6 (as it relies on EABI for building reliably). Also,
>> > the number of false-positive build warnings is so high that it is useless
>> > for finding actual bugs from the warnings.
>>
>> If you start with that activity now, there's indeed a massive amount of
>> warnings to look into.
>> However, I've been build testing various configs with m68k-linux-gnu-gcc-4.1.2
>> and looking at the compiler warnings for years, so I only have to look
>> at new warnings.
>
> What's the reason for sticking with gcc-4.1? Does this actually work better
> for you than a more recent version, or is it just whatever you installed
> when you started the build testing?

It's just the cross compiler I built .debs of a long time ago.
As long as it works, I see no reason to upgrade, especially as long as I see
warnings for bugs that no one else is seeing. But lately you started beating
me with newer gccs ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
