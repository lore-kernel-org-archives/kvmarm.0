From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] ARM: soft-reboot into same mode that we entered the kernel
Date: Tue, 13 Dec 2016 11:11:15 +0000
Message-ID: <20161213111115.GX14217@n2100.armlinux.org.uk>
References: <E1cFRAn-0003ob-HH@rmk-PC.armlinux.org.uk>
 <20161213105410.GB19985@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 141AB405D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2016 06:10:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uMHPyo331tLb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Dec 2016 06:10:22 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 654154053F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Dec 2016 06:10:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161213105410.GB19985@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 13, 2016 at 10:54:11AM +0000, Mark Rutland wrote:
> Hi,
> 
> On Fri, Dec 09, 2016 at 07:49:37PM +0000, Russell King wrote:
> > When we soft-reboot (eg, kexec) from one kernel into the next, we need
> > to ensure that we enter the new kernel in the same processor mode as
> > when we were entered, so that (eg) the new kernel can install its own
> > hypervisor - the old kernel's hypervisor will have been overwritten.
> > 
> > In order to do this, we need to pass a flag to cpu_reset() so it knows
> > what to do, and we need to modify the kernel's own hypervisor stub to
> > allow it to handle a soft-reboot.
> > 
> > As we are always guaranteed to install our own hypervisor if we're
> > entered in HYP32 mode, and KVM will have moved itself out of the way
> > on kexec/normal reboot, we can assume that our hypervisor is in place
> > when we want to kexec, so changing our hypervisor API should not be a
> > problem.
> > 
> > Tested-by: Keerthy <j-keerthy@ti.com>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> > Mark,
> > 
> > Any opinions on this?
> > 
> > Thanks.
> 
> The above sounds like the right thing to do, but I'm not familiar enough
> with the 32-bit hyp + kvm code to say much about the implementation.
> 
> Hopefully Dave, Marc, or Christoffer have thoughts.
> 
> Otherwise, I only have a couple of minor comments below.
> 
> > 
> >  arch/arm/include/asm/proc-fns.h |  4 ++--
> >  arch/arm/kernel/hyp-stub.S      | 36 ++++++++++++++++++++++++++++++------
> >  arch/arm/kernel/reboot.c        | 12 ++++++++++--
> >  arch/arm/mm/proc-v7.S           | 12 ++++++++----
> >  4 files changed, 50 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
> > index 8877ad5ffe10..f2e1af45bd6f 100644
> > --- a/arch/arm/include/asm/proc-fns.h
> > +++ b/arch/arm/include/asm/proc-fns.h
> > @@ -43,7 +43,7 @@ extern struct processor {
> >  	/*
> >  	 * Special stuff for a reset
> >  	 */
> > -	void (*reset)(unsigned long addr) __attribute__((noreturn));
> > +	void (*reset)(unsigned long addr, bool hvc) __attribute__((noreturn));
> >  	/*
> >  	 * Idle the processor
> >  	 */
> > @@ -88,7 +88,7 @@ extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
> >  #else
> >  extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte, unsigned int ext);
> >  #endif
> > -extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
> > +extern void cpu_reset(unsigned long addr, bool hvc) __attribute__((noreturn));
> >  
> >  /* These three are private to arch/arm/kernel/suspend.c */
> >  extern void cpu_do_suspend(void *);
> > diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
> > index 15d073ae5da2..cab1ac36939d 100644
> > --- a/arch/arm/kernel/hyp-stub.S
> > +++ b/arch/arm/kernel/hyp-stub.S
> > @@ -22,6 +22,9 @@
> >  #include <asm/assembler.h>
> >  #include <asm/virt.h>
> >  
> > +#define HVC_GET_VECTORS -1
> > +#define HVC_SOFT_RESTART 1
> > +
> >  #ifndef ZIMAGE
> >  /*
> >   * For the kernel proper, we need to find out the CPU boot mode long after
> > @@ -202,9 +205,18 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
> >  ENDPROC(__hyp_stub_install_secondary)
> >  
> >  __hyp_stub_do_trap:
> > -	cmp	r0, #-1
> > -	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
> > -	mcrne	p15, 4, r0, c12, c0, 0	@ set HVBAR
> > +	cmp	r0, #HVC_GET_VECTORS
> > +	bne	1f
> > +	mrc	p15, 4, r0, c12, c0, 0	@ get HVBAR
> > +	b	__hyp_stub_exit
> > +
> > +1:	teq	r0, #HVC_SOFT_RESTART
> > +	bne	1f
> > +	mov	r0, r3
> > +	bx	r0
> > +
> > +1:	mcrne	p15, 4, r0, c12, c0, 0	@ set HVBAR
> > +__hyp_stub_exit:
> >  	__ERET
> >  ENDPROC(__hyp_stub_do_trap)
> >  
> > @@ -231,14 +243,26 @@ ENDPROC(__hyp_stub_do_trap)
> >   * initialisation entry point.
> >   */
> >  ENTRY(__hyp_get_vectors)
> > -	mov	r0, #-1
> > +	mov	r0, #HVC_GET_VECTORS
> > +	__HVC(0)
> > +	ret	lr
> >  ENDPROC(__hyp_get_vectors)
> > -	@ fall through
> > +
> >  ENTRY(__hyp_set_vectors)
> > +	tst	r0, #31
> > +	bne	1f
> >  	__HVC(0)
> > -	ret	lr
> > +1:	ret	lr
> >  ENDPROC(__hyp_set_vectors)
> 
> Why the new check? This looks unrelated to the rest of the patch.

It's not unrelated.  The ARM32 hyp-stub has a total crap ABI:

- r0 = -1 => read VBAR
- r0 != -1 => write r0 to VBAR

So, this check is there to ensure that you can't do something stupid
like:
	__hyp_set_vectors(1)

and inadvertently end up invoking the restart method - the check is
there to "make room" for the new hyp call in the ABI.

It hasn't been clear what the scope of the API, or the stub ABI actually
is - nothing about that is really documented, so I didn't want to
radically redesign the stub ABI to be more sensible and risk breakage
elsewhere - especially as I'm reliant on others to test this.  (All my
32-bit platforms enter the kernel in SVC mode from the boot loader, even
those which are virtualisation-capable.)

> > +ENTRY(__hyp_soft_restart)
> > +	mov	r3, r0
> > +	mov	r0, #HVC_SOFT_RESTART
> > +	__HVC(0)
> > +	mov	r0, r3
> > +	ret	lr
> > +ENDPROC(__hyp_soft_restart)
> > +
> >  #ifndef ZIMAGE
> >  .align 2
> >  .L__boot_cpu_mode_offset:
> > diff --git a/arch/arm/kernel/reboot.c b/arch/arm/kernel/reboot.c
> > index 3fa867a2aae6..f0e3c7f1ea21 100644
> > --- a/arch/arm/kernel/reboot.c
> > +++ b/arch/arm/kernel/reboot.c
> > @@ -12,10 +12,11 @@
> >  
> >  #include <asm/cacheflush.h>
> >  #include <asm/idmap.h>
> > +#include <asm/virt.h>
> >  
> >  #include "reboot.h"
> >  
> > -typedef void (*phys_reset_t)(unsigned long);
> > +typedef void (*phys_reset_t)(unsigned long, bool);
> >  
> >  /*
> >   * Function pointers to optional machine specific functions
> > @@ -36,6 +37,7 @@ static u64 soft_restart_stack[16];
> >  static void __soft_restart(void *addr)
> >  {
> >  	phys_reset_t phys_reset;
> > +	bool hvc = false;
> >  
> >  	/* Take out a flat memory mapping. */
> >  	setup_mm_for_reboot();
> > @@ -51,7 +53,13 @@ static void __soft_restart(void *addr)
> >  
> >  	/* Switch to the identity mapping. */
> >  	phys_reset = (phys_reset_t)virt_to_idmap(cpu_reset);
> > -	phys_reset((unsigned long)addr);
> > +
> > +#ifdef CONFIG_ARM_VIRT_EXT
> > +	/* original stub should be restored by kvm */
> > +	hvc = is_hyp_mode_available();
> > +#endif
> 
> When !CONFIG_ARM_VIRT_EXT, is_hyp_mode_available() is defined so as to
> always be false, so we can drop the ifdef here.

Ok.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
