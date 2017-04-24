From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 11:44:26 +0200
Message-ID: <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 862F640DA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 05:41:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kyzogHL-PLzB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Apr 2017 05:41:41 -0400 (EDT)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
 [209.85.223.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5785840D91
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 05:41:40 -0400 (EDT)
Received: by mail-io0-f176.google.com with SMTP id r16so179716410ioi.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 02:44:28 -0700 (PDT)
In-Reply-To: <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, "Maciej W. Rozycki" <macro@linux-mips.org>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Apr 23, 2017 at 10:13 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Arnd,
>
> On Sat, Apr 22, 2017 at 5:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Based on what I found so far, gcc-4 can be pretty much ruled out from
>> being the minimum version based on the number of failures I got.
>> It's much better than 3.4 but much worse than 4.1 or 4.2 which seem
>> fixable on MIPS and x86 at least, and may or may not work depending
>> on configuration. So the best two possible (but conflicting) answers I
>> have are
>>
>> a) There are known users on gcc-4.1, and we never break things that
>>     work for users, so gcc-4.1 (or possibly 4.0 if a user shows up) would
>>     be the minimum version.
>> b) gcc-4.1 and 4.2 have too many problems, so users are better off
>>     when we tell them to upgrade to something newer, and a minimum
>>     version of gcc-4.3 has fewer surprises. We should remove all
>>     workarounds for pre-gcc-4.3 compilers and just force a build error
>>     message.
>
> If there's no real good reason (brokenness) to deprecate gcc-4.1, I would not
> do it.I guess most people using old compilers know what they're doing.

What I'm trying to find out first is whether "people regularly using 10+
year old compilers for the latest kernels" is a strict subset of "people in
Geert's household".

Given that none of the three architectures I looked at (arm, mips, x86)
has successfully built any defconfig for a few years, it's quite possible
that it's just you ;-) The other architectures that were around 10 years
ago (so they might have someone who still has old toolchain binaries)
and that still exist today are alpha, cris, frv, ia64, m32r, parisc, powerpc,
s390, sh, sparc and xtensa. The first six are similar to m68k in that the
hardware is mostly obsolete and the ports are kept around to support
those old systems that might also use ancient toolchains, or new
toolchains may be unmaintained or buggy, which could be a reason
to keep 4.1 supported or at least try to find out if 4.1 (or even any other
version) still works at all.

> My main motivation for keep on using gcc-4.1 is that it gives many warnings
> that were disabled in later gcc versions.  I do look at all new warnings, and
> send patches when they are real bugs, or are trivial to silence.

What kind of warnings do you see that disappeared with later versions?
Do you know what caused them to disappear in later versions (different
optimization decisions, warning getting disabled by default but still available
for turning on manually, ...)? Do you know if the disabled warnings are
still there in gcc-4.3 (I can try it out if you give me examples)?

> Lately the usefulness has been decreasing, as you've been too aggressively
> killing compiler warnings with recent gcc versions (which became better) ;-)
> Hence if I detected a new warning with a point or an rc release, it usually
> means the code was never in nex (ugh)t, or the maintainer ignored your patch.
>
> I could easily switch to v4.9 from kernel.org crosstool, though, but then I
> would loose all those warnings.

If gcc-4.3 produces similarly useful warnings, we could think about integrating
gcc-4.3 into kernelci.org build reports as an option, and fix up all
the existing
warnings we get with that. I wouldn't want to do that with gcc-4.1 though as
the older versions have relatively random behavior.

One particular feature I'd like to use that requires a newer compiler is being
able to control warnings per function liker glibc does, using e.g.
 '_Pragma("GCC diagnostic disable \"-Woverride-init\"")'. Once we have that,
we could turn on a couple of additional warnings that are generally useful
but also warn about code that intentionally does something that would
trigger the warning.

> BTW, below is the diff I use to avoid an ICE.
> After that, it builds and (test)boots fine on ARAnyM ;-)

I guess this means that even your builds require extra patches and you
can't strictly build a defconfig and expect that to work ;-)

      Arnd
