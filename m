From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 1/7] arm64: Use physical counter for in-kernel reads
Date: Fri, 6 Jan 2017 11:53:01 +0100
Message-ID: <20170106105301.GB27758@cbox>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
 <20161210204712.21830-2-christoffer.dall@linaro.org>
 <5e820613-f9f3-0035-b145-0e22e9bcfeca@arm.com>
 <20170106100049.GB21089@cbox>
 <89b4c1c1-3c6a-b7a1-cbcb-93a64812ebff@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2CD7405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 05:51:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zQnWWuhFSElM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Jan 2017 05:51:27 -0500 (EST)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66FAC405D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Jan 2017 05:51:26 -0500 (EST)
Received: by mail-lf0-f45.google.com with SMTP id x140so44312239lfa.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 Jan 2017 02:53:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <89b4c1c1-3c6a-b7a1-cbcb-93a64812ebff@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 06, 2017 at 10:38:49AM +0000, Marc Zyngier wrote:
> On 06/01/17 10:00, Christoffer Dall wrote:
> > Hi Marc,
> > 
> > On Thu, Jan 05, 2017 at 06:11:14PM +0000, Marc Zyngier wrote:
> >> [adding the arm64 maintainers, plus Mark as arch timer maintainer]
> > 
> > Right, sorry, I should have done that already.
> > 
> >>
> >> On 10/12/16 20:47, Christoffer Dall wrote:
> >>> Using the physical counter allows KVM to retain the offset between the
> >>> virtual and physical counter as long as it is actively running a VCPU.
> >>>
> >>> As soon as a VCPU is released, another thread is scheduled or we start
> >>> running userspace applications, we reset the offset to 0, so that VDSO
> >>> operations can still read the virtual counter and get the same view of
> >>> time as the kernel.
> >>>
> >>> This opens up potential improvements for KVM performance.
> >>>
> >>> VHE kernels or kernels using the virtual timer are unaffected by this.
> >>>
> >>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>> ---
> >>>  arch/arm64/include/asm/arch_timer.h  | 6 ++++--
> >>>  drivers/clocksource/arm_arch_timer.c | 2 +-
> >>>  2 files changed, 5 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> >>> index eaa5bbe..cec2549 100644
> >>> --- a/arch/arm64/include/asm/arch_timer.h
> >>> +++ b/arch/arm64/include/asm/arch_timer.h
> >>> @@ -139,11 +139,13 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
> >>>  
> >>>  static inline u64 arch_counter_get_cntpct(void)
> >>>  {
> >>> +	u64 cval;
> >>>  	/*
> >>>  	 * AArch64 kernel and user space mandate the use of CNTVCT.
> >>>  	 */
> >>> -	BUG();
> >>> -	return 0;
> >>> +	isb();
> >>> +	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
> >>> +	return cval;
> >>>  }
> >>>  
> >>>  static inline u64 arch_counter_get_cntvct(void)
> >>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> >>> index 73c487d..a5b0789 100644
> >>> --- a/drivers/clocksource/arm_arch_timer.c
> >>> +++ b/drivers/clocksource/arm_arch_timer.c
> >>> @@ -597,7 +597,7 @@ static void __init arch_counter_register(unsigned type)
> >>>  
> >>>  	/* Register the CP15 based counter if we have one */
> >>>  	if (type & ARCH_CP15_TIMER) {
> >>> -		if (IS_ENABLED(CONFIG_ARM64) || arch_timer_uses_ppi == VIRT_PPI)
> >>> +		if (arch_timer_uses_ppi == VIRT_PPI || is_kernel_in_hyp_mode())
> >>
> >> Why do we have this is_kernel_in_hyp_mode clause? I can't think of any
> >> reason for a VHE kernel to use the virtual counter at all...
> >>
> > 
> > Good question.  I think I just didn't want to change behavior from the
> > existing functionality mre than necessary.
> > 
> > Note that on a VHE kernel this will be the EL2 virtual counter, not the
> > EL1 virtual counter, due to the register redirection.  Are the virtual
> > and physical EL2 counters always equivalent on a VHE system?
> 
> Yes, they are. CNTVOFF_EL2 is ignored in that case, and you get an extra
> interrupt for the new EL2 virtual timer as well.
> 

ok, in that case I suppose I can just check for arch_timer_uses_ppi ==
VIRT_PPI and be done with it.

Thanks,
-Christoffer
