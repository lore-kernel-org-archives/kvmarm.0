From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 02/20] arm64: Use physical counter for in-kernel reads
Date: Wed, 18 Oct 2017 12:00:07 +0200
Message-ID: <20171018100007.GK8326@lvm>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-3-cdall@linaro.org>
 <20171017153305.GB19711@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171017153305.GB19711@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 04:33:05PM +0100, Will Deacon wrote:
> Hi Christoffer,
> 
> On Sat, Sep 23, 2017 at 02:41:49AM +0200, Christoffer Dall wrote:
> > Using the physical counter allows KVM to retain the offset between the
> > virtual and physical counter as long as it is actively running a VCPU.
> > 
> > As soon as a VCPU is released, another thread is scheduled or we start
> > running userspace applications, we reset the offset to 0, so that
> > userspace accessing the virtual timer can still read the cirtual counter
> > and get the same view of time as the kernel.
> > 
> > This opens up potential improvements for KVM performance.
> > 
> > VHE kernels or kernels continuing to use the virtual timer are
> > unaffected.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  arch/arm64/include/asm/arch_timer.h  | 9 ++++-----
> >  drivers/clocksource/arm_arch_timer.c | 3 +--
> >  2 files changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> > index a652ce0..1859a1c 100644
> > --- a/arch/arm64/include/asm/arch_timer.h
> > +++ b/arch/arm64/include/asm/arch_timer.h
> > @@ -148,11 +148,10 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
> >  
> >  static inline u64 arch_counter_get_cntpct(void)
> >  {
> > -	/*
> > -	 * AArch64 kernel and user space mandate the use of CNTVCT.
> > -	 */
> > -	BUG();
> > -	return 0;
> > +	u64 cval;
> > +	isb();
> > +	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
> > +	return cval;
> >  }
> >  
> >  static inline u64 arch_counter_get_cntvct(void)
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > index fd4b7f6..9b3322a 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -890,8 +890,7 @@ static void __init arch_counter_register(unsigned type)
> >  
> >  	/* Register the CP15 based counter if we have one */
> >  	if (type & ARCH_TIMER_TYPE_CP15) {
> > -		if (IS_ENABLED(CONFIG_ARM64) ||
> > -		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> > +		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> 
> Please can you add an is_hyp_mode_available() check here, as you suggested
> last time?
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/521542.html
> 
> Without it, I worry that the kernel timekeeper will be out of sync with the
> vDSO (which uses the virtual counter) on systems where CNTVOFF is
> initialised to a consistent non-zero offset and Linux was loaded at EL1.
> 

Yes, will do.

Thanks,
-Christoffer
