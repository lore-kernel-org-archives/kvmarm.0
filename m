From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 22:30:52 +0200
Message-ID: <CAK8P3a0HQUqtL=9pgPEreQJaA0AksiR06B4oAwvbYnJeA-2i7w@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
 <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
 <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
 <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
 <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
 <alpine.LFD.2.20.1704241249350.32200@eddie.linux-mips.org>
 <CAK8P3a03BTEBgz87k_dhJuqzOYQm_S5FFDrFgcBAE5FCH-e=dQ@mail.gmail.com> <alpine.LFD.2.20.1704241908260.32200@eddie.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1704241908260.32200@eddie.linux-mips.org>
Sender: linux-arch-owner@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 24, 2017 at 8:30 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Mon, 24 Apr 2017, Arnd Bergmann wrote:
>
>>
>> So it still fails, but only because of one compiler error that I can avoid by
>> disabling that driver, and you probably use a slightly patched compiler
>> version that doesn't have this particular bug, or it was a regression between
>> gcc-4.1.2 and 4.1.3.
>
>  Umm, I didn't build modules, sorry, because I don't usually use them with
> those systems.  However I have completed this step now and it also worked
> just fine:
>
> $ ls -la crypto/drbg.o
> -rw-r--r--  1 macro macro 14096 Apr 24 18:59 crypto/drbg.o
> $ file crypto/drbg.o
> crypto/drbg.o: ELF 32-bit LSB MIPS-I relocatable, MIPS, version 1 (SYSV), not stripped
> $
>
> so you are likely right that either I have a patch applied to my 4.1.2
> build that has somehow fixed the ICE or it is a 4.1.3 regression (or a bad
> patch in your 4.1.3 build).

Ok.

>  BTW I do see these `may be used uninitialized' warnings just as Geert
> does and even have a local patch, which I have neglected to submit, for a
> 64-bit configuration (`decstation_defconfig' is 32-bit) where in a single
> place -Werror turns it into a build failure.  I do not consider it a big
> issue though, and might even wrap that patch up and submit sometime.

I'd recommend dropping that -Werror from mips and the other few
architectures that have it, or maybe wrapping it in a Kconfig symbol that
is disabled by default. It would also take care of
==> build/mips/bmips_be_defconfig/log <==
cc1: warnings being treated as errors
/git/arm-soc/arch/mips/bmips/setup.c:37: error: integer constant is
too large for 'long' type

As mentioned, we can also turn off the warnings by default and let
Geert turn them on again:

diff --git a/Makefile b/Makefile
index 779302695453..2528f60fb9ab 100644
--- a/Makefile
+++ b/Makefile
@@ -647,8 +647,10 @@ KBUILD_CFLAGS   += -O2
 endif
 endif

-KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0409, \
-                                  $(call
cc-disable-warning,maybe-uninitialized,))
+KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0408, \
+                                 $(call cc-disable-warning,uninitialized, \
+                                 $(call cc-ifversion, -lt, 0409, \
+                                 $(call
cc-disable-warning,maybe-uninitialized,))))

 # Tell gcc to never replace conditional load with a non-conditional one
 KBUILD_CFLAGS += $(call cc-option,--param=allow-store-data-races=0)


I've built the remaining defconfigs in the meantime (linux-4.11-rc8, gcc-4.1.3,
ARCH=mips) and got 38 builds with warnings and 20 failed builds. There are
at least six different build failures and only one ICE among them (only
in decstation_defconfig). With gcc-4.3 this is only slightly better: 18
failed build, 20 with warnings and 20 without warnings.

With linux-4.3, I saw this failure on 32 defconfigs,
and you fixed that in linux-4.7 with e49d38488515 ("MIPS: MSA: Fix a
link error on `_init_msa_upper' with older GCC"):

arch/mips/built-in.o: In function `enable_restore_fp_context':
traps.c:(.text+0xbefc): undefined reference to `_init_msa_upper'
traps.c:(.text+0xbfc0): undefined reference to `_init_msa_upper'

With gcc-4.9, all mips defconfigs now build without warnings.

For the other architectures in linux-4.11-rc8 can actually build with
sparc-gcc-4.1, afaict this was a bug that impacted all compilers up to
gcc-4.7 and a workaround was added recently. In turn, parisc-gcc-4.1
no longer works on linux-4.11, so we still have only three architectures
that can build their 'defconfig' with the old compiler, plus the majority
of the mips config files.

So while overall I still think that gcc-4.1 is rather broken, it seems that
you have it well under control on both mips and m68k. It's possible
that some other people use patched gcc-4.1 or only build special
configurations on further architectures that I found to be broken
with vanilla toolchains and the regular defconfig.

How about this approach then:

- To keep it simple, we update the README.rst to say that a minimum
  gcc-4.3 is required, while recommending gcc-4.9 for all architectures
- Support for gcc-4.0 and earlier gets removed from linux/compiler.h,
  and instead we add a summary of what I found, explaining that
  gcc-4.1 has active users on a few architectures.
- We make the Makefile show a warning once during compilation for
  gcc earlier than 4.3.

        Arnd
