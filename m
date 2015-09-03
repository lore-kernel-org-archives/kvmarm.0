From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/2] arm/arm64: KVM: Improve kvm_exit tracepoint
Date: Thu, 3 Sep 2015 17:29:50 +0100
Message-ID: <55E8757E.5020803@arm.com>
References: <1440942922-23955-1-git-send-email-christoffer.dall@linaro.org>
 <1440942922-23955-3-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D04564169C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ks0HhEJ4g3rx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2015 12:28:11 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB484141D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 12:28:10 -0400 (EDT)
In-Reply-To: <1440942922-23955-3-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 30/08/15 14:55, Christoffer Dall wrote:
> The ARM architecture only saves the exit class to the HSR (ESR_EL2 for
> arm64) on synchronous exceptions, not on asynchronous exceptions like an
> IRQ.  However, we only report the exception class on kvm_exit, which is
> confusing because an IRQ looks like it exited at some PC with the same
> reason as the previous exit.  Add a lookup table for the exception index
> and prepend the kvm_exit tracepoint text with the exception type to
> clarify this situation.
> 
> Also resolve the exception class (EC) to a human-friendly text version
> so the trace output becomes immediately usable for debugging this code.

That patch just proved very useful for me, especially since the encoding
of .EC is different between ARM & ARM64, so thanks for that!

But still there is HSR.EC reported for asynchronous exceptions, which is
confusing, so I wonder if it would be worth to have two tracepoints to
just report the PC for async exits and .EC and PC for traps?
I guess it would be neater to have this differentiation in the
TRACE_EVENT macro invocation, but I reckon it is not powerful enough?

Also this patch is independent from both the first one and the reworked
arch timer series. I see your intention of pushing your arch timer
series through ;-), but I suggest to make this patch separate and add
1/2 to the arch timer series.

Cheers,
Andre.

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_arm.h   | 20 ++++++++++++++++++++
>  arch/arm/kvm/arm.c               |  2 +-
>  arch/arm/kvm/trace.h             | 10 +++++++---
>  arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
>  4 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
> index d995821..dc641dd 100644
> --- a/arch/arm/include/asm/kvm_arm.h
> +++ b/arch/arm/include/asm/kvm_arm.h
> @@ -218,4 +218,24 @@
>  #define HSR_DABT_CM		(1U << 8)
>  #define HSR_DABT_EA		(1U << 9)
>  
> +#define kvm_arm_exception_type	\
> +	{0, "RESET" }, 		\
> +	{1, "UNDEFINED" },	\
> +	{2, "SOFTWARE" },	\
> +	{3, "PREF_ABORT" },	\
> +	{4, "DATA_ABORT" },	\
> +	{5, "IRQ" },		\
> +	{6, "FIQ" },		\
> +	{7, "HVC" }
> +
> +#define HSRECN(x) { HSR_EC_##x, #x }
> +
> +#define kvm_arm_exception_class \
> +	HSRECN(UNKNOWN), HSRECN(WFI), HSRECN(CP15_32), HSRECN(CP15_64), \
> +	HSRECN(CP14_MR), HSRECN(CP14_LS), HSRECN(CP_0_13), HSRECN(CP10_ID), \
> +	HSRECN(JAZELLE), HSRECN(BXJ), HSRECN(CP14_64), HSRECN(SVC_HYP), \
> +	HSRECN(HVC), HSRECN(SMC), HSRECN(IABT), HSRECN(IABT_HYP), \
> +	HSRECN(DABT), HSRECN(DABT_HYP)
> +
> +
>  #endif /* __ARM_KVM_ARM_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 102a4aa..ffec2f2 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -606,7 +606,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 * guest time.
>  		 */
>  		kvm_guest_exit();
> -		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> +		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>  
>  		/*
>  		 * We must sync the timer state before the vgic state so that
> diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
> index 0ec3539..c25a885 100644
> --- a/arch/arm/kvm/trace.h
> +++ b/arch/arm/kvm/trace.h
> @@ -25,21 +25,25 @@ TRACE_EVENT(kvm_entry,
>  );
>  
>  TRACE_EVENT(kvm_exit,
> -	TP_PROTO(unsigned int exit_reason, unsigned long vcpu_pc),
> -	TP_ARGS(exit_reason, vcpu_pc),
> +	TP_PROTO(int idx, unsigned int exit_reason, unsigned long vcpu_pc),
> +	TP_ARGS(idx, exit_reason, vcpu_pc),
>  
>  	TP_STRUCT__entry(
> +		__field(	int,		idx		)
>  		__field(	unsigned int,	exit_reason	)
>  		__field(	unsigned long,	vcpu_pc		)
>  	),
>  
>  	TP_fast_assign(
> +		__entry->idx			= idx;
>  		__entry->exit_reason		= exit_reason;
>  		__entry->vcpu_pc		= vcpu_pc;
>  	),
>  
> -	TP_printk("HSR_EC: 0x%04x, PC: 0x%08lx",
> +	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
> +		  __print_symbolic(__entry->idx, kvm_arm_exception_type),
>  		  __entry->exit_reason,
> +		  __print_symbolic(__entry->exit_reason, kvm_arm_exception_class),
>  		  __entry->vcpu_pc)
>  );
>  
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 7605e09..ffb86bf 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -197,4 +197,20 @@
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
>  
> +#define kvm_arm_exception_type	\
> +	{0, "IRQ" }, 		\
> +	{1, "TRAP" }
> +
> +#define ECN(x) { ESR_ELx_EC_##x, #x }
> +
> +#define kvm_arm_exception_class \
> +	ECN(UNKNOWN), ECN(WFx), ECN(CP15_32), ECN(CP15_64), ECN(CP14_MR), \
> +	ECN(CP14_LS), ECN(FP_ASIMD), ECN(CP10_ID), ECN(CP14_64), ECN(SVC64), \
> +	ECN(HVC64), ECN(SMC64), ECN(SYS64), ECN(IMP_DEF), ECN(IABT_LOW), \
> +	ECN(IABT_CUR), ECN(PC_ALIGN), ECN(DABT_LOW), ECN(DABT_CUR), \
> +	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
> +	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
> +	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
> +	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
> +
>  #endif /* __ARM64_KVM_ARM_H__ */
> 
