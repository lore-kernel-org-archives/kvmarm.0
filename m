From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 19:29:13 +0200
Message-ID: <CAK8P3a03BTEBgz87k_dhJuqzOYQm_S5FFDrFgcBAE5FCH-e=dQ@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
 <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
 <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
 <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
 <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com> <alpine.LFD.2.20.1704241249350.32200@eddie.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1704241249350.32200@eddie.linux-mips.org>
Sender: linux-arch-owner@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 24, 2017 at 6:53 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Mon, 24 Apr 2017, Arnd Bergmann wrote:
>
>> > If there's no real good reason (brokenness) to deprecate gcc-4.1, I would not
>> > do it.I guess most people using old compilers know what they're doing.
>>
>> What I'm trying to find out first is whether "people regularly using 10+
>> year old compilers for the latest kernels" is a strict subset of "people in
>> Geert's household".
>
> Well I do not live with Geert TBH.

Sorry about that, you had mentioned that you had used it recently, which should
have weighed more than my own results.

>     Linux 4.11-rc8
> $ /usr/bin/time make ARCH=mips CROSS_COMPILE=mipsel-linux- decstation_defconfig vmlinux >/dev/null 2>&1
> 1014.19user 71.47system 19:33.24elapsed 92%CPU (0avgtext+0avgdata
> 0maxresident)k18764inputs+242504outputs (704major+9549837minor)pagefaults 0swaps
> $ mipsel-linux-gcc --version
> gcc (GCC) 4.1.2
> Copyright (C) 2006 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> $
>
> Methinks it builds just fine.

I must have done something wrong:

I tried a few defconfigs with a latest kernel and compiler and they all failed,
found linux-4.3 to be the first version that was broken for all of them
(most with a link time error, some with missing gcc features)

I later tried all mips defconfigs with linux-4.3 and they all failed
with gcc-4.1.3
but built fine with gcc-4.9. I've now tried decstation_defconfig in 4.8-rc11,
and this is what I see for gcc-4.1.3

make O=build/mips/decstation_defconfig/ -skj30
CC=/home/arnd/cross-gcc/bin/mips-linux-gcc-4.1.3\ ARCH=mips -f
Makefile CROSS_COMPILE=/home/arnd/cross-gcc/bin/mips-linux-
/git/arm-soc/fs/dcache.c: In function '__d_move':
/git/arm-soc/fs/dcache.c:2773: warning: 'n' may be used uninitialized
in this function
/git/arm-soc/fs/dcache.c: In function 'd_splice_alias':
/git/arm-soc/fs/dcache.c:2529: warning: 'n' may be used uninitialized
in this function
/git/arm-soc/fs/dcache.c: In function 'd_add':
/git/arm-soc/fs/dcache.c:2529: warning: 'n' may be used uninitialized
in this function
/git/arm-soc/mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited':
/git/arm-soc/mm/page-writeback.c:1627: warning: 'writeback' is used
uninitialized in this function
/git/arm-soc/mm/page-writeback.c:1628: warning: 'filepages' is used
uninitialized in this function
/git/arm-soc/mm/page-writeback.c:1628: warning: 'headroom' is used
uninitialized in this function
/git/arm-soc/mm/page-writeback.c: In function 'wb_over_bg_thresh':
/git/arm-soc/mm/page-writeback.c:1956: warning: 'filepages' is used
uninitialized in this function
/git/arm-soc/mm/page-writeback.c:1956: warning: 'headroom' is used
uninitialized in this function
/git/arm-soc/net/core/flow_dissector.c: In function '__skb_flow_dissect':
/git/arm-soc/net/core/flow_dissector.c:272: warning: 'vlan' may be
used uninitialized in this function
/git/arm-soc/fs/splice.c: In function 'iter_file_splice_write':
/git/arm-soc/fs/splice.c:716: warning: 'ret' may be used uninitialized
in this function
/git/arm-soc/net/core/dev.c: In function 'validate_xmit_skb_list':
/git/arm-soc/net/core/dev.c:3003: warning: 'tail' may be used
uninitialized in this function
/git/arm-soc/kernel/printk/printk.c: In function 'devkmsg_sysctl_set_loglvl':
/git/arm-soc/kernel/printk/printk.c:161: warning: 'old' may be used
uninitialized in this function
/git/arm-soc/kernel/time/ntp.c: In function 'ntp_validate_timex':
/git/arm-soc/kernel/time/ntp.c:707: warning: comparison is always
false due to limited range of data type
/git/arm-soc/kernel/time/ntp.c:709: warning: comparison is always
false due to limited range of data type
/git/arm-soc/kernel/time/timekeeping.c: In function
'get_device_system_crosststamp':
/git/arm-soc/kernel/time/timekeeping.c:1084: warning:
'cs_was_changed_seq' may be used uninitialized in this function
/git/arm-soc/net/sunrpc/xdr.c: In function 'xdr_stream_decode_string_dup':
/git/arm-soc/include/linux/sunrpc/xdr.h:409: warning: 'len' may be
used uninitialized in this function
/git/arm-soc/crypto/drbg.c: In function 'drbg_kcapi_random':
/git/arm-soc/crypto/drbg.c:1865: internal compiler error: Segmentation fault
Please submit a full bug report,
with preprocessed source if appropriate.
See <URL:http://gcc.gnu.org/bugs.html> for instructions.
/git/arm-soc/scripts/Makefile.build:300: recipe for target
'crypto/drbg.o' failed

So it still fails, but only because of one compiler error that I can avoid by
disabling that driver, and you probably use a slightly patched compiler
version that doesn't have this particular bug, or it was a regression between
gcc-4.1.2 and 4.1.3.

      Arnd
