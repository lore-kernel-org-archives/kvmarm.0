From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 12:17:03 +0200
Message-ID: <CAMuHMdUOv-sn9vDei0qPaRe19faYJGZ1zo1X==JDyFWJW3x5=A@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de>
 <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
 <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
 <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
 <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
 <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9D141145
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 06:14:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VsR1MxmFeJtH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Apr 2017 06:14:17 -0400 (EDT)
Received: from mail-it0-f67.google.com (mail-it0-f67.google.com
 [209.85.214.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4B5740DFB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 06:14:17 -0400 (EDT)
Received: by mail-it0-f67.google.com with SMTP id z67so16009513itb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 03:17:05 -0700 (PDT)
In-Reply-To: <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, "Maciej W. Rozycki" <macro@linux-mips.org>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,

On Mon, Apr 24, 2017 at 11:44 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sun, Apr 23, 2017 at 10:13 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Sat, Apr 22, 2017 at 5:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> Based on what I found so far, gcc-4 can be pretty much ruled out from
>>> being the minimum version based on the number of failures I got.
>>> It's much better than 3.4 but much worse than 4.1 or 4.2 which seem
>>> fixable on MIPS and x86 at least, and may or may not work depending
>>> on configuration. So the best two possible (but conflicting) answers I
>>> have are
>>>
>>> a) There are known users on gcc-4.1, and we never break things that
>>>     work for users, so gcc-4.1 (or possibly 4.0 if a user shows up) would
>>>     be the minimum version.
>>> b) gcc-4.1 and 4.2 have too many problems, so users are better off
>>>     when we tell them to upgrade to something newer, and a minimum
>>>     version of gcc-4.3 has fewer surprises. We should remove all
>>>     workarounds for pre-gcc-4.3 compilers and just force a build error
>>>     message.
>>
>> If there's no real good reason (brokenness) to deprecate gcc-4.1, I would not
>> do it.I guess most people using old compilers know what they're doing.
>
> What I'm trying to find out first is whether "people regularly using 10+
> year old compilers for the latest kernels" is a strict subset of "people in
> Geert's household".

Fair enough.

>> My main motivation for keep on using gcc-4.1 is that it gives many warnings
>> that were disabled in later gcc versions.  I do look at all new warnings, and
>> send patches when they are real bugs, or are trivial to silence.
>
> What kind of warnings do you see that disappeared with later versions?
> Do you know what caused them to disappear in later versions (different
> optimization decisions, warning getting disabled by default but still available
> for turning on manually, ...)? Do you know if the disabled warnings are
> still there in gcc-4.3 (I can try it out if you give me examples)?

Mostly the "may be used uninitialized" warnings. I believe they were disabled
in gcc-4.3 (4.2?) and later due to too many false positives, which is not an
issue for me, as I look at differences.
They were re-enabled lately (with much less false-positives), that's why you
see them, and fix them.

For example, do you see the warning fixed by commit 1b8c1012142d8322
("drivers: net: xgene: Simplify xgene_enet_setup_mss() to kill warning")
with gcc-4.3? Yes, that was a false positive.

Or see commit cc4a7ffe02c95f53 ("spi: fsl-lpspi: Pre-initialize ret in
fsl_lpspi_transfer_one_msg()"). That one was a real bug.

I don't see that in any of the kisskb build logs, and they use gcc-4.2.4 for
avr32. So having gcc-4.2 or gcc-4.3 in a farm won't help.

And as long as I find real bugs this way, I'd like to continue doing it.

>> BTW, below is the diff I use to avoid an ICE.
>> After that, it builds and (test)boots fine on ARAnyM ;-)
>
> I guess this means that even your builds require extra patches and you
> can't strictly build a defconfig and expect that to work ;-)

No sane people enable GFS in defconfig, so it's not affected.

Oh wait, some mips, powerpc, s390, and tile do ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
