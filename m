From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 26/28] ARM: KVM: Remove unused hyp_pc field
Date: Tue, 9 Feb 2016 19:39:01 +0100
Message-ID: <20160209183901.GC5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-27-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 592F749790
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:32:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tG19OwbctyXm for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 13:32:36 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0D084976C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 13:32:35 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id g62so186362148wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2016 10:38:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454583645-10144-27-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:43AM +0000, Marc Zyngier wrote:
> This field was never populated, and the panic code already
> does something similar. Delete the related code.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_emulate.h | 5 -----
>  arch/arm/include/asm/kvm_host.h    | 1 -
>  arch/arm/kernel/asm-offsets.c      | 1 -
>  arch/arm/kvm/handle_exit.c         | 5 -----
>  4 files changed, 12 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
> index f710616..8a8c6de 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -108,11 +108,6 @@ static inline phys_addr_t kvm_vcpu_get_fault_ipa(struct kvm_vcpu *vcpu)
>  	return ((phys_addr_t)vcpu->arch.fault.hpfar & HPFAR_MASK) << 8;
>  }
>  
> -static inline unsigned long kvm_vcpu_get_hyp_pc(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu->arch.fault.hyp_pc;
> -}
> -
>  static inline bool kvm_vcpu_dabt_isvalid(struct kvm_vcpu *vcpu)
>  {
>  	return kvm_vcpu_get_hsr(vcpu) & HSR_ISV;
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index daf6a71..19e9aba 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -85,7 +85,6 @@ struct kvm_vcpu_fault_info {
>  	u32 hsr;		/* Hyp Syndrome Register */
>  	u32 hxfar;		/* Hyp Data/Inst. Fault Address Register */
>  	u32 hpfar;		/* Hyp IPA Fault Address Register */
> -	u32 hyp_pc;		/* PC when exception was taken from Hyp mode */
>  };
>  
>  /*
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 1f24c32..27d0581 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -175,7 +175,6 @@ int main(void)
>    DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
>    DEFINE(CPU_CTXT_GP_REGS,	offsetof(struct kvm_cpu_context, gp_regs));
>    DEFINE(GP_REGS_USR,		offsetof(struct kvm_regs, usr_regs));
> -  DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
>  #endif
>    BLANK();
>  #ifdef CONFIG_VDSO
> diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> index 3ede90d..5377d753 100644
> --- a/arch/arm/kvm/handle_exit.c
> +++ b/arch/arm/kvm/handle_exit.c
> @@ -147,11 +147,6 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	switch (exception_index) {
>  	case ARM_EXCEPTION_IRQ:
>  		return 1;
> -	case ARM_EXCEPTION_UNDEFINED:
> -		kvm_err("Undefined exception in Hyp mode at: %#08lx\n",
> -			kvm_vcpu_get_hyp_pc(vcpu));
> -		BUG();
> -		panic("KVM: Hypervisor undefined exception!\n");
>  	case ARM_EXCEPTION_DATA_ABORT:
>  	case ARM_EXCEPTION_PREF_ABORT:
>  	case ARM_EXCEPTION_HVC:
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
