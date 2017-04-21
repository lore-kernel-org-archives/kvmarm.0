From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 21 Apr 2017 14:05:35 -0700
Message-ID: <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com> <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 21, 2017 at 1:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Apr 20, 2017 at 9:52 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Apr 20, 2017 at 3:15 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Sun, Apr 16, 2017 at 9:52 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>>> The original gcc-4.3 release was in early 2008. If we decide to still
>>>>>> support that, we probably want the first 10 quirks in this series,
>>>>>> while gcc-4.6 (released in 2011) requires none of them.
>>>>
>>>> I'd be in support of raising the minimum to gcc 4.6. (I'd actually
>>>> prefer 4.7, just to avoid some 4.6 packaging issues, and for better
>>>> gcc plugin support.)
>>>>
>>>> I'm curious what gcc 4.6 binaries are common in the wild besides
>>>> old-stable Debian (unsupported in maybe a year from now?) and 12.04
>>>> Ubuntu (going fully unsupported in 2 weeks). It looks like 4.6 was
>>>> used only in Fedora 15 and 16 (both EOL).
>>>
>>> I think we are better off defining two versions: One that we know
>>> a lot of people care about, and we actively try to make that work
>>> well in all configurations (e.g. 4.6, 4.7 or 4.8), fixing all warnings
>>> we run into, and an older version that we try not to break
>>> intentionally (e.g. 3.4, 4.1 or 4.3) but that we only fix when
>>> someone actually runs into a problem they can't work around
>>> by upgrading to a more modern compiler.
>>
>> For "working well everywhere" I feel like 4.8 is the better of those
>> three (I'd prefer 4.9). I think we should avoid 4.6 -- it seems not
>> widely used.
>
> I suspect that 4.9 might be the one that actually works best
> across architectures, and it contained some very significant
> changes. In my testing gcc-5 tends to behave very similarly
> to 4.9, and gcc-6 introduced a larger number of new warnings,
> so that would clearly be too new for a recommended version.
>
> The suggestion of 4.9 or higher is appealing as a recommendation
> because it matches what I would personally tell people:
>
> - If you have gcc-4.9 or newer and you don't rely on any newer
>   features, there is no need to upgrade
> - Wth gcc-4.8, the -Wmaybe-uninitialized warnings are now turned
>   off because they were too noisy, so upgrading is probably a good
>   idea even though the compiler is otherwise ok and in widespread
>   use
> - gcc-4.6 and 4.7 are basically usable for building kernels, but the
>   warning output is often counterproductive, and the generated
>   object code may be noticeably worse.
> - anything before gcc-4.6 is missing too many features to be
>   useful on ARM, but may still be fine on other architectures.
>
> On the other hand, there is a noticeable difference in compile
> speed, as a 5% slowdown compared to the previous release
> apparently is not considered a regression. These are the times
> I see for building ARM 'vexpress_defconfig':
>
> gcc-4.4: real 0m47.269s user 11m48.576s
> gcc-4.5: real 0m44.878s user 10m58.900s
> gcc-4.6: real 0m44.621s user 11m34.716s
> gcc-4.7: real 0m47.476s user 12m42.924s
> gcc-4.8: real 0m48.494s user 13m19.736s
> gcc-4.9: real 0m50.140s user 13m44.876s
> gcc-5.x: real 0m51.302s user 14m05.564s
> gcc-6.x: real 0m54.615s user 15m06.304s
> gcc-7.x: real 0m56.008s user 15m44.720s
>
> That is a factor of 1.5x in CPU cycles between slowest and
> fastest, so there is clearly a benefit to keeping the old versions
> around, but there is also no clear cut-off other thannoticing
> that gcc-4.4 is slower than 4.5 in this particular
> configuration.
>
>> For an old compiler... yikes. 3.4 sounds insane to me. :)
>
> That was my initial thought as well. On ARM, it clearly is
> insane, as even gcc-4.0 is unable to build any of the modern
> defconfigs (lacking -mabi=aapcs, ICE when building vsprintf.c)
> and even the patch I did to get gcc-4.1 to build is probably
> too ugly to get merged, so to build any unpatched kernel after
> linux-3.6 you need at least gcc-4.2, or even gcc-4.4 for the
> ''defconfig' (gcc-4.3 if you disable vdso).
>
> Then again, on x86, old cmpilers were claimed to be much better
> supported. I just tried it out and found that no x86 defconfig kernel
> since linux-3.2 could be built with gcc-3.4, probably not on any
> other architecture either (it cannot have forward declarations
> for inline functions and we have one in kernel/sched_fair.c).
>
> I think that would be a really good argument for requiring
> something newer ;-)
>
> The linux-4.2 x86 defconfig could still be built with gcc-4.0, but
> later kernels have several minor problems with that, and
> require at least gcc-4.3.
>
> If we are ok with this status quo, we could simply declare gcc-4.3
> the absolute minimum version for the kernel, make gcc-4.9
> the recommeded minimum version, and remove all workarounds
> for gcc-4.2 or older.

I think starting with this would be a good first step. I'm not sure
the best way to add "recommended minimum" to
Documentation/process/changes.rst hmmm

> If anyone has a good reason for gcc-4.0 through gcc-4.2, then
> we would need a small number of patches to get them back
> working with x86 defconfig.

-Kees


-- 
Kees Cook
Pixel Security
