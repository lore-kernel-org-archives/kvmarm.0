From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 19:30:09 +0100 (BST)
Message-ID: <alpine.LFD.2.20.1704241908260.32200@eddie.linux-mips.org>
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
 <alpine.LFD.2.20.1704241249350.32200@eddie.linux-mips.org>
 <CAK8P3a03BTEBgz87k_dhJuqzOYQm_S5FFDrFgcBAE5FCH-e=dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AEE240D71
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 14:27:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hO9gBTYPdvq5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Apr 2017 14:27:22 -0400 (EDT)
Received: from cvs.linux-mips.org (eddie.linux-mips.org [148.251.95.138])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E79640D6E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Apr 2017 14:27:22 -0400 (EDT)
Received: from localhost.localdomain ([127.0.0.1]:60118 "EHLO
 localhost.localdomain" rhost-flags-OK-OK-OK-OK)
 by eddie.linux-mips.org with ESMTP id S23993893AbdDXSaJ2x0nm (ORCPT
 <rfc822;kvmarm@lists.cs.columbia.edu>);
 Mon, 24 Apr 2017 20:30:09 +0200
In-Reply-To: <CAK8P3a03BTEBgz87k_dhJuqzOYQm_S5FFDrFgcBAE5FCH-e=dQ@mail.gmail.com>
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
Cc: linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 24 Apr 2017, Arnd Bergmann wrote:

> I later tried all mips defconfigs with linux-4.3 and they all failed
> with gcc-4.1.3
> but built fine with gcc-4.9. I've now tried decstation_defconfig in 4.8-rc11,
> and this is what I see for gcc-4.1.3
> 
> make O=build/mips/decstation_defconfig/ -skj30
> CC=/home/arnd/cross-gcc/bin/mips-linux-gcc-4.1.3\ ARCH=mips -f
> Makefile CROSS_COMPILE=/home/arnd/cross-gcc/bin/mips-linux-
> /git/arm-soc/fs/dcache.c: In function '__d_move':
> /git/arm-soc/fs/dcache.c:2773: warning: 'n' may be used uninitialized
> in this function
> /git/arm-soc/fs/dcache.c: In function 'd_splice_alias':
> /git/arm-soc/fs/dcache.c:2529: warning: 'n' may be used uninitialized
> in this function
> /git/arm-soc/fs/dcache.c: In function 'd_add':
> /git/arm-soc/fs/dcache.c:2529: warning: 'n' may be used uninitialized
> in this function
> /git/arm-soc/mm/page-writeback.c: In function 'balance_dirty_pages_ratelimited':
> /git/arm-soc/mm/page-writeback.c:1627: warning: 'writeback' is used
> uninitialized in this function
> /git/arm-soc/mm/page-writeback.c:1628: warning: 'filepages' is used
> uninitialized in this function
> /git/arm-soc/mm/page-writeback.c:1628: warning: 'headroom' is used
> uninitialized in this function
> /git/arm-soc/mm/page-writeback.c: In function 'wb_over_bg_thresh':
> /git/arm-soc/mm/page-writeback.c:1956: warning: 'filepages' is used
> uninitialized in this function
> /git/arm-soc/mm/page-writeback.c:1956: warning: 'headroom' is used
> uninitialized in this function
> /git/arm-soc/net/core/flow_dissector.c: In function '__skb_flow_dissect':
> /git/arm-soc/net/core/flow_dissector.c:272: warning: 'vlan' may be
> used uninitialized in this function
> /git/arm-soc/fs/splice.c: In function 'iter_file_splice_write':
> /git/arm-soc/fs/splice.c:716: warning: 'ret' may be used uninitialized
> in this function
> /git/arm-soc/net/core/dev.c: In function 'validate_xmit_skb_list':
> /git/arm-soc/net/core/dev.c:3003: warning: 'tail' may be used
> uninitialized in this function
> /git/arm-soc/kernel/printk/printk.c: In function 'devkmsg_sysctl_set_loglvl':
> /git/arm-soc/kernel/printk/printk.c:161: warning: 'old' may be used
> uninitialized in this function
> /git/arm-soc/kernel/time/ntp.c: In function 'ntp_validate_timex':
> /git/arm-soc/kernel/time/ntp.c:707: warning: comparison is always
> false due to limited range of data type
> /git/arm-soc/kernel/time/ntp.c:709: warning: comparison is always
> false due to limited range of data type
> /git/arm-soc/kernel/time/timekeeping.c: In function
> 'get_device_system_crosststamp':
> /git/arm-soc/kernel/time/timekeeping.c:1084: warning:
> 'cs_was_changed_seq' may be used uninitialized in this function
> /git/arm-soc/net/sunrpc/xdr.c: In function 'xdr_stream_decode_string_dup':
> /git/arm-soc/include/linux/sunrpc/xdr.h:409: warning: 'len' may be
> used uninitialized in this function
> /git/arm-soc/crypto/drbg.c: In function 'drbg_kcapi_random':
> /git/arm-soc/crypto/drbg.c:1865: internal compiler error: Segmentation fault
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://gcc.gnu.org/bugs.html> for instructions.
> /git/arm-soc/scripts/Makefile.build:300: recipe for target
> 'crypto/drbg.o' failed
> 
> So it still fails, but only because of one compiler error that I can avoid by
> disabling that driver, and you probably use a slightly patched compiler
> version that doesn't have this particular bug, or it was a regression between
> gcc-4.1.2 and 4.1.3.

 Umm, I didn't build modules, sorry, because I don't usually use them with 
those systems.  However I have completed this step now and it also worked 
just fine:

$ ls -la crypto/drbg.o
-rw-r--r--  1 macro macro 14096 Apr 24 18:59 crypto/drbg.o
$ file crypto/drbg.o
crypto/drbg.o: ELF 32-bit LSB MIPS-I relocatable, MIPS, version 1 (SYSV), not stripped
$ 

so you are likely right that either I have a patch applied to my 4.1.2 
build that has somehow fixed the ICE or it is a 4.1.3 regression (or a bad 
patch in your 4.1.3 build).

 BTW I do see these `may be used uninitialized' warnings just as Geert 
does and even have a local patch, which I have neglected to submit, for a 
64-bit configuration (`decstation_defconfig' is 32-bit) where in a single 
place -Werror turns it into a build failure.  I do not consider it a big 
issue though, and might even wrap that patch up and submit sometime.

  Maciej
