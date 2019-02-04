From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/5] lib: arm: Use UART address from
 generated config.h
Date: Mon, 4 Feb 2019 15:40:35 +0100
Message-ID: <20190204144035.msssfasqwdwderi7@kamzik.brq.redhat.com>
References: <20190204134412.47877-1-alexandru.elisei@arm.com>
 <20190204134412.47877-2-alexandru.elisei@arm.com>
 <20190204140001.tollipaxeiom2ug6@kamzik.brq.redhat.com>
 <a421f3ac-e607-b2d6-fa24-282406dcea77@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8C714A399
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 09:40:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FTWUvJuquV0X for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 09:40:41 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8C6C4A38A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 09:40:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <a421f3ac-e607-b2d6-fa24-282406dcea77@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 04, 2019 at 02:17:05PM +0000, Alexandru Elisei wrote:
> On 2/4/19 2:00 PM, Andrew Jones wrote:
> > On Mon, Feb 04, 2019 at 01:44:08PM +0000, Alexandru Elisei wrote:
> >> Generate lib/config.h when configuring kvm-unit-tests. The file is empty
> >> for all architectures except for arm and arm64, where it is used to store
> >> the UART base address. This removes the hardcoded address from lib/arm/io.c
> >> and provides a mechanism for using different UART addresses in the future.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  configure    | 17 +++++++++++++++++
> >>  Makefile     |  2 +-
> >>  lib/arm/io.c | 12 ++++++------
> >>  .gitignore   |  1 +
> >>  4 files changed, 25 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/configure b/configure
> >> index df8581e3a906..b4732c6c04e4 100755
> >> --- a/configure
> >> +++ b/configure
> >> @@ -198,3 +198,20 @@ ENVIRON_DEFAULT=$environ_default
> >>  ERRATATXT=errata.txt
> >>  U32_LONG_FMT=$u32_long
> >>  EOF
> >> +
> >> +cat <<EOF > lib/config.h
> >> +#ifndef CONFIG_H
> >> +#define CONFIG_H 1
> >> +/*
> >> + * Generated file. DO NOT MODIFY.
> >> + *
> >> + */
> >> +EOF
> >> +if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
> >> +cat <<EOF >> lib/config.h
> >> +
> >> +#define CONFIG_UART_EARLY_BASE 0x09000000
> >> +
> >> +EOF
> >> +fi
> >> +echo "#endif" >> lib/config.h
> >> diff --git a/Makefile b/Makefile
> >> index e9f02272e156..643af05678ad 100644
> >> --- a/Makefile
> >> +++ b/Makefile
> >> @@ -115,7 +115,7 @@ libfdt_clean:
> >>  	$(LIBFDT_objdir)/.*.d
> >>  
> >>  distclean: clean libfdt_clean
> >> -	$(RM) lib/asm config.mak $(TEST_DIR)-run msr.out cscope.* build-head
> >> +	$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.* build-head
> >>  	$(RM) -r tests logs logs.old
> >>  
> >>  cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/asm-generic
> >> diff --git a/lib/arm/io.c b/lib/arm/io.c
> >> index d2c1a07c19ee..e84a5c89fcb1 100644
> >> --- a/lib/arm/io.c
> >> +++ b/lib/arm/io.c
> >> @@ -11,6 +11,7 @@
> >>  #include <libcflat.h>
> >>  #include <devicetree.h>
> >>  #include <chr-testdev.h>
> >> +#include <config.h>
> >>  #include <asm/spinlock.h>
> >>  #include <asm/io.h>
> >>  
> >> @@ -18,6 +19,7 @@
> >>  
> >>  extern void halt(int code);
> >>  
> >> +static struct spinlock uart_lock;
> >>  /*
> >>   * Use this guess for the pl011 base in order to make an attempt at
> >>   * having earlier printf support. We'll overwrite it with the real
> >> @@ -25,10 +27,8 @@ extern void halt(int code);
> >>   * the address we expect QEMU's mach-virt machine type to put in
> >>   * its generated device tree.
> >>   */
> >> -#define UART_EARLY_BASE 0x09000000UL
> >> -
> >> -static struct spinlock uart_lock;
> >> -static volatile u8 *uart0_base = (u8 *)UART_EARLY_BASE;
> >> +#define UART_EARLY_BASE (u8 *)(unsigned long)CONFIG_UART_EARLY_BASE
> >> +static volatile u8 *uart0_base = UART_EARLY_BASE;
> >>  
> >>  static void uart0_init(void)
> >>  {
> >> @@ -58,10 +58,10 @@ static void uart0_init(void)
> >>  
> >>  	uart0_base = ioremap(base.addr, base.size);
> >>  
> >> -	if (uart0_base != (u8 *)UART_EARLY_BASE) {
> >> +	if (uart0_base != UART_EARLY_BASE) {
> >>  		printf("WARNING: early print support may not work. "
> >>  		       "Found uart at %p, but early base is %p.\n",
> >> -			uart0_base, (u8 *)UART_EARLY_BASE);
> >> +			uart0_base, UART_EARLY_BASE);
> >>  	}
> >>  }
> >>  
> >> diff --git a/.gitignore b/.gitignore
> >> index 2405a8087ae5..483f7c7a09ea 100644
> >> --- a/.gitignore
> >> +++ b/.gitignore
> >> @@ -10,6 +10,7 @@ patches
> >>  cscope.*
> >>  *.swp
> >>  /lib/asm
> >> +/lib/config.h
> >>  /config.mak
> >>  /*-run
> >>  /msr.out
> >> -- 
> >> 2.17.0
> >>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> Thank you for taking the time to review the patches!
> 
> What is my next step?
>

Wait for Paolo or Radim to merge :-)  I've added them to CC.

drew
