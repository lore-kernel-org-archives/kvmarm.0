From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Sun, 16 Apr 2017 12:52:33 -0700
Message-ID: <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <3302470.IDcDrWa0u6@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Was there a conclusion to this discussion? I didn't see anything
definitive in the thread...

Notes below...

On Fri, Dec 16, 2016 at 3:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> [Fixed linux-arm-kernel mailing list address, sorry for the duplicate,
>  I'm not reposting all the ugly patches though, unless someone really
>  wants them, https://lkml.org/lkml/2016/12/16/174 has a copy]
>
> On Friday, December 16, 2016 11:56:21 AM CET Arnd Bergmann wrote:
>> I had some fun doing build testing with older gcc versions, building
>> every release from 4.0 through 7.0 and running that on my randconfig
>> setup to see what comes out.
>>
>> First of all, gcc-4.9 and higher is basically warning-free everywhere,
>> although gcc-7 introduces some interesting new warnings (I have started
>> doing patches for those as well). gcc-4.8 is probably good, too, and
>> gcc-4.6 and 4.7 at least don't produce build failures in general, though
>> the level of false-positive warnings increases (we could decide to turn
>> those off for older compilers for build test purposes).
>>
>> In gcc-4.5 and below, dead code elimination is not as good as later,
>> causing a couple of link errors, and some of them have no good workaround
>> (see patch 1). It would be nice to declare that version too old, but
>> several older distros that are still in wide use ship with compilers
>> earlier than 4.6:
>>
>>  RHEL6:               gcc-4.4

This appears to have support until July 31, 2018. (Though it's using a
2.6 kernel.)

>>  Debian 6:    gcc-4.4

This went fully unsupported on Feb 29, 2016.

>>  Ubuntu 10.04:        gcc-4.4

This went fully unsupported on Apr 30, 2015.

>>  SLES11:      gcc-4.3

General support ends Mar 31 2019, fully unsupported 31 Mar 2022. (And
like RHEL6 is using a 2.6 kernel.)

>> With gcc-4.3, we need a couple of workaround patches beyond the problem
>> mentioned above, more configuration options are unavailable and we get
>> a significant number of false-positive warnings, but it's not much worse
>> than gcc-4.5 otherwise.
>>
>> These are the options I had to disable to get gcc-4.3 randconfig builds
>> working:
>>
>>  CONFIG_HAVE_GCC_PLUGINS

This needs gcc 4.5, with 4.7 preferred.

>>  CONFIG_CC_STACKPROTECTOR_STRONG

Introduced in gcc 4.9.

>>  CONFIG_ARM_SINGLE_ARMV7M
>>  CONFIG_THUMB2_KERNEL
>>  CONFIG_KERNEL_MODE_NEON
>>  CONFIG_VDSO
>>  CONFIG_FUNCTION_TRACER (with CONFIG_FRAME_POINTER=n)
>>
>> I have not checked in detail which version is required for
>> each of the above.
>>
>> Specifically on ARM, going further makes things rather useless especially
>> for build testing: with gcc-4.2, we lose support for ARMv7, EABI, and
>> effectively ARMv6 (as it relies on EABI for building reliably). Also,
>> the number of false-positive build warnings is so high that it is useless
>> for finding actual bugs from the warnings.
>>
>> See the replies to this mail for 13 patches I needed to work around
>> issues for each of the releases before 4.6. I have also submitted
>> some separate patches for issues that I considered actual bugs
>> uncovered by the older compilers and that should be applied regardless.
>>
>> The original gcc-4.3 release was in early 2008. If we decide to still
>> support that, we probably want the first 10 quirks in this series,
>> while gcc-4.6 (released in 2011) requires none of them.

I'd be in support of raising the minimum to gcc 4.6. (I'd actually
prefer 4.7, just to avoid some 4.6 packaging issues, and for better
gcc plugin support.)

I'm curious what gcc 4.6 binaries are common in the wild besides
old-stable Debian (unsupported in maybe a year from now?) and 12.04
Ubuntu (going fully unsupported in 2 weeks). It looks like 4.6 was
used only in Fedora 15 and 16 (both EOL).

-Kees

-- 
Kees Cook
Pixel Security
