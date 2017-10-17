From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 02/20] arm64: Use physical counter for in-kernel reads
Date: Tue, 17 Oct 2017 16:33:05 +0100
Message-ID: <20171017153305.GB19711@arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F341840D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 11:32:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xNEG1YLy0OIt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 11:32:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C22EA40795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 11:32:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170923004207.22356-3-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Sat, Sep 23, 2017 at 02:41:49AM +0200, Christoffer Dall wrote:
> Using the physical counter allows KVM to retain the offset between the
> virtual and physical counter as long as it is actively running a VCPU.
> 
> As soon as a VCPU is released, another thread is scheduled or we start
> running userspace applications, we reset the offset to 0, so that
> userspace accessing the virtual timer can still read the cirtual counter
> and get the same view of time as the kernel.
> 
> This opens up potential improvements for KVM performance.
> 
> VHE kernels or kernels continuing to use the virtual timer are
> unaffected.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm64/include/asm/arch_timer.h  | 9 ++++-----
>  drivers/clocksource/arm_arch_timer.c | 3 +--
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
> index a652ce0..1859a1c 100644
> --- a/arch/arm64/include/asm/arch_timer.h
> +++ b/arch/arm64/include/asm/arch_timer.h
> @@ -148,11 +148,10 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
>  
>  static inline u64 arch_counter_get_cntpct(void)
>  {
> -	/*
> -	 * AArch64 kernel and user space mandate the use of CNTVCT.
> -	 */
> -	BUG();
> -	return 0;
> +	u64 cval;
> +	isb();
> +	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
> +	return cval;
>  }
>  
>  static inline u64 arch_counter_get_cntvct(void)
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index fd4b7f6..9b3322a 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -890,8 +890,7 @@ static void __init arch_counter_register(unsigned type)
>  
>  	/* Register the CP15 based counter if we have one */
>  	if (type & ARCH_TIMER_TYPE_CP15) {
> -		if (IS_ENABLED(CONFIG_ARM64) ||
> -		    arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> +		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)

Please can you add an is_hyp_mode_available() check here, as you suggested
last time?

http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/521542.html

Without it, I worry that the kernel timekeeper will be out of sync with the
vDSO (which uses the virtual counter) on systems where CNTVOFF is
initialised to a consistent non-zero offset and Linux was loaded at EL1.

Thanks,

Will
