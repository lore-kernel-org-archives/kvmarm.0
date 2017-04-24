From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 16:13:46 +0200
Message-ID: <CAK8P3a3o_r6z25Sm5iceWTo4OopiKP8MdBSvSctRvtUp4UFaCQ@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
 <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
 <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
 <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
 <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com> <CAMuHMdUOv-sn9vDei0qPaRe19faYJGZ1zo1X==JDyFWJW3x5=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUOv-sn9vDei0qPaRe19faYJGZ1zo1X==JDyFWJW3x5=A@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 24, 2017 at 12:17 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Apr 24, 2017 at 11:44 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Sun, Apr 23, 2017 at 10:13 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Sat, Apr 22, 2017 at 5:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> My main motivation for keep on using gcc-4.1 is that it gives many warnings
>>> that were disabled in later gcc versions.  I do look at all new warnings, and
>>> send patches when they are real bugs, or are trivial to silence.
>>
>> What kind of warnings do you see that disappeared with later versions?
>> Do you know what caused them to disappear in later versions (different
>> optimization decisions, warning getting disabled by default but still available
>> for turning on manually, ...)? Do you know if the disabled warnings are
>> still there in gcc-4.3 (I can try it out if you give me examples)?
>
> Mostly the "may be used uninitialized" warnings. I believe they were disabled
> in gcc-4.3 (4.2?) and later due to too many false positives, which is not an
> issue for me, as I look at differences.
> They were re-enabled lately (with much less false-positives), that's why you
> see them, and fix them.

Linus added -Wno-maybe-uninitialized a while ago, and I think only gcc-4.8
and higher were affected by that, as earlier versions only understand
-Wuninitialized (meaning both "definitely uninitialized" and "might be
uninitialized". The latest state is that gcc-4.9 enables all uninitialized
warnings and I try to fix them for all known compilers, gcc-4.8
disables -Wmaybe-uninitialized unless you build with "make W=2".

On gcc-4.9 and higher, we also don't enable -Wmaybe-unintialized when
certain configuration options are set that cause extra false positives,
but it's still enabled with W=2.

I actually think it would be a good idea to also disable -Wuninitialized
for gcc-4.7 and earlier unless you ask for W2. That would get us
much closer to a clean build, but still give you the chance to see the
warnings if you really want to.

> For example, do you see the warning fixed by commit 1b8c1012142d8322
> ("drivers: net: xgene: Simplify xgene_enet_setup_mss() to kill warning")
> with gcc-4.3? Yes, that was a false positive.

I see this one until gcc-4.8 if I build with W=2 to turn the warning back on.

> Or see commit cc4a7ffe02c95f53 ("spi: fsl-lpspi: Pre-initialize ret in
> fsl_lpspi_transfer_one_msg()"). That one was a real bug.
>
> I don't see that in any of the kisskb build logs, and they use gcc-4.2.4 for
> avr32. So having gcc-4.2 or gcc-4.3 in a farm won't help.

Also here: I see the warning on ARM with all versions from gcc-4.1 through
4.8 (with W=1), but not any higher versions including 7.0.1. If I mark
fsl_lpspi_transfer_one as 'noinline', I see it on all versions, which is a bit
odd. It might be worth opening a gcc bug report for that. I tried the
'noinline' as I suspected gcc might be smart enough to figure out that
the list is never empty, but I later noticed that it has no way of knowing
that even without the 'noinline' flag.

> And as long as I find real bugs this way, I'd like to continue doing it.

I've tested all the architectures I mentioned earlier that were around 10
years ago (aside from ia64, I could not build gcc successfully) with
linux-4.3 (arbitrarily picked, this was the version in which x86 and mips
no longer built with gcc-4.1), and built a defconfig with both gcc-4.9
(which I had around from earlier testing) and with gcc-4.1/4.3:

          gcc-4.1  gcc-4.3  gcc-4.9
alpha  failed    success success
arm    failed     success success
cris     failed     success success
frv       failed     failed    success
m32r  success success success
m68k  success success success
mips   failed     failed     success
parisc success success success
powerpc failed failed    success
s390    failed    failed    success
sh        failed    success success
x86      failed    success success

I'd conclude that nobody aside from you sends bugfixes for 4.1,
or has done so in a while. I have the logs available if you want,
but there isn't really much surprising: we get the same link error
as on mips and x86 on some additional architectures, powerpc
and s390 use features that weren't available and frv hits an ICE.

We could define the minimum compiler to be gcc-4.3 on all architectures
except m68k (and possibly parisc, certainly nobody cares about
m32r enough), where it would be gcc-4.1, to reflect what is actually
already the case.

        Arnd
