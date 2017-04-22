From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Sat, 22 Apr 2017 17:30:07 +0200
Message-ID: <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com> <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
Sender: linux-kbuild-owner@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Apr 22, 2017 at 5:10 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Fri, 21 Apr 2017, Kees Cook wrote:
>
>> > The linux-4.2 x86 defconfig could still be built with gcc-4.0, but
>> > later kernels have several minor problems with that, and
>> > require at least gcc-4.3.
>> >
>> > If we are ok with this status quo, we could simply declare gcc-4.3
>> > the absolute minimum version for the kernel, make gcc-4.9
>> > the recommeded minimum version, and remove all workarounds
>> > for gcc-4.2 or older.
>>
>> I think starting with this would be a good first step. I'm not sure
>> the best way to add "recommended minimum" to
>> Documentation/process/changes.rst hmmm
>
>  FWIW for some reasons (mainly the ability to avoid NPTL) I have stuck to
> GCC 4.1.2 with some MIPS configurations and I've had no issues with that
> compiler up to Linux 4.6.0, which is the last kernel version I have tried
> with that compiler so far.  I could check if anything has regressed since
> then I suppose.

Interesting. This is also the same version that Geert mentioned using
on m68k. I've tried some more x86 and mips builds now and found:

- x86 defconfig broke because the i915 driver relies on gcc-4.3 behavior
  for alignment attributes as of a few kernel versions ago for the sw_fence
  mechanism:
drivers/gpu/drm/i915/intel_display.c:14571: error: alignment may not
be specified for 'intel_atomic_commit_ready'

- With gcc-4.0 I also get a couple of BUILD_BUG_ON() triggering for
  correct code that it doesn't always consider compile-time constant (on all
  architectures), this is from x86 defconfig starting around linux-4.3:
mm/built-in.o: In function `do_set_pmd':
memory.c:(.text+0x34df5): undefined reference to `__compiletime_assert_3157'
drivers/built-in.o: In function `cea_mode_alternate_timings':
drm_edid.c:(.text+0x10858a): undefined reference to `__compiletime_assert_2641'

- gcc-4.0 has been broken for all MIPS configurations (but no other arch) since
  commit 51b97e354ba9 ("kernel: use the gnu89 standard explicitly") in 3.18,
  the problem still exists in stable/linux-3.18.y and mainline but would be
  trivial to fix with a oneline patch if anyone had noticed this before me.
arch/mips/kernel/vmlinux.lds.S:110:1: error: pasting "initcall0" and
"." does not give a valid preprocessing token

- The interprocedural optimization changes in gcc-4.3 mean that the
  object code is a bit different, and we no longer expect the pre-gcc-4.3
  behavior. This mostly results in warnings (e.g. maybe-uninitialized or
  section mismatch) when the compiler and/or linker lacks the
  information to see that the code is actually correct. On x86 I only
  got one failure with gcc-4.1, on mips-gcc-4.1 I got this and a few
  more depending on configuration:
mm/built-in.o: In function `create_huge_pmd':
memory.c:(.text+0x34e71): undefined reference to `do_huge_pmd_anonymous_page'

The last one is the key here I think. The linker warnings and errors we
run into here are all fairly easy to fix, but we will keep running into new
ones since evidently nobody does regular builds checking for them, and
they can appear randomly based on configuration for otherwise
acceptable code. Today, most configurations I tried were broken because
of this, and if things worked for you, you were either lucky that you didn't
run into the same bugs (or that Geert fixed the ones you would have hit)
or you had patches on top to work around them already.

Based on what I found so far, gcc-4 can be pretty much ruled out from
being the minimum version based on the number of failures I got.
It's much better than 3.4 but much worse than 4.1 or 4.2 which seem
fixable on MIPS and x86 at least, and may or may not work depending
on configuration. So the best two possible (but conflicting) answers I
have are

a) There are known users on gcc-4.1, and we never break things that
    work for users, so gcc-4.1 (or possibly 4.0 if a user shows up) would
    be the minimum version.
b) gcc-4.1 and 4.2 have too many problems, so users are better off
    when we tell them to upgrade to something newer, and a minimum
    version of gcc-4.3 has fewer surprises. We should remove all
    workarounds for pre-gcc-4.3 compilers and just force a build error
    message.

      Arnd
