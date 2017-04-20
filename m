From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Thu, 20 Apr 2017 12:15:19 +0200
Message-ID: <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Apr 16, 2017 at 9:52 PM, Kees Cook <keescook@chromium.org> wrote:
> Was there a conclusion to this discussion? I didn't see anything
> definitive in the thread...

No definite answer, no. My personal view now is that we should probably
merge the patches I sent, to help those that for one reason or another
use one of those ancient toolchains, but we should not go actively looking
for more problems with those compilers.

> On Fri, Dec 16, 2016 at 3:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> [Fixed linux-arm-kernel mailing list address, sorry for the duplicate,
>>  I'm not reposting all the ugly patches though, unless someone really
>>  wants them, https://lkml.org/lkml/2016/12/16/174 has a copy]
>>
>> On Friday, December 16, 2016 11:56:21 AM CET Arnd Bergmann wrote:
>>> I had some fun doing build testing with older gcc versions, building
>>> every release from 4.0 through 7.0 and running that on my randconfig
>>> setup to see what comes out.
>>>
>>> First of all, gcc-4.9 and higher is basically warning-free everywhere,
>>> although gcc-7 introduces some interesting new warnings (I have started
>>> doing patches for those as well). gcc-4.8 is probably good, too, and
>>> gcc-4.6 and 4.7 at least don't produce build failures in general, though
>>> the level of false-positive warnings increases (we could decide to turn
>>> those off for older compilers for build test purposes).
>>>
>>> In gcc-4.5 and below, dead code elimination is not as good as later,
>>> causing a couple of link errors, and some of them have no good workaround
>>> (see patch 1). It would be nice to declare that version too old, but
>>> several older distros that are still in wide use ship with compilers
>>> earlier than 4.6:
>>>
>>>  RHEL6:               gcc-4.4
>
> This appears to have support until July 31, 2018. (Though it's using a
> 2.6 kernel.)
>
>>>  Debian 6:    gcc-4.4
>
> This went fully unsupported on Feb 29, 2016.
>
>>>  Ubuntu 10.04:        gcc-4.4
>
> This went fully unsupported on Apr 30, 2015.
>
>>>  SLES11:      gcc-4.3
>
> General support ends Mar 31 2019, fully unsupported 31 Mar 2022. (And
> like RHEL6 is using a 2.6 kernel.)

Thanks for looking these up. This means we need to consider how important
build testing on SLES11 is to us in the long run. The most important scenario
I can think of for anyone would be someone that maintains an embedded
system with an x86 CPU and uses a SLES11 setup to maintain their
own distro.

In this case you typically don't want to modify your environment, but
one might want to upgrade the target kernel, and would suffer if
we break that.

>>>
>>> I have not checked in detail which version is required for
>>> each of the above.
>>>
>>> Specifically on ARM, going further makes things rather useless especially
>>> for build testing: with gcc-4.2, we lose support for ARMv7, EABI, and
>>> effectively ARMv6 (as it relies on EABI for building reliably). Also,
>>> the number of false-positive build warnings is so high that it is useless
>>> for finding actual bugs from the warnings.
>>>
>>> See the replies to this mail for 13 patches I needed to work around
>>> issues for each of the releases before 4.6. I have also submitted
>>> some separate patches for issues that I considered actual bugs
>>> uncovered by the older compilers and that should be applied regardless.
>>>
>>> The original gcc-4.3 release was in early 2008. If we decide to still
>>> support that, we probably want the first 10 quirks in this series,
>>> while gcc-4.6 (released in 2011) requires none of them.
>
> I'd be in support of raising the minimum to gcc 4.6. (I'd actually
> prefer 4.7, just to avoid some 4.6 packaging issues, and for better
> gcc plugin support.)
>
> I'm curious what gcc 4.6 binaries are common in the wild besides
> old-stable Debian (unsupported in maybe a year from now?) and 12.04
> Ubuntu (going fully unsupported in 2 weeks). It looks like 4.6 was
> used only in Fedora 15 and 16 (both EOL).

I think we are better off defining two versions: One that we know
a lot of people care about, and we actively try to make that work
well in all configurations (e.g. 4.6, 4.7 or 4.8), fixing all warnings
we run into, and an older version that we try not to break
intentionally (e.g. 3.4, 4.1 or 4.3) but that we only fix when
someone actually runs into a problem they can't work around
by upgrading to a more modern compiler.

      Arnd
