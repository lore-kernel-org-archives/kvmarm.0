From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 10/19] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Mon, 15 Jan 2018 16:36:32 +0100
Message-ID: <20180115153632.GK21403@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A3849DDE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 10:31:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tvN5qU03HdKz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 10:31:36 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C061B49DDD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 10:31:36 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id i11so2767984wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 07:36:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-11-marc.zyngier@arm.com>
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

On Thu, Jan 04, 2018 at 06:43:25PM +0000, Marc Zyngier wrote:
> kvm_vgic_global_state is part of the read-only section, and is
> usually accessed using a PC-relative address generation (adrp + add).
> 
> It is thus useless to use kern_hyp_va() on it, and actively problematic
> if kern_hyp_va() becomes non-idempotent. On the other hand, there is
> no way that the compiler is going to guarantee that such access is
> always be PC relative.

nit: is always be

> 
> So let's bite the bullet and provide our own accessor.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_hyp.h   | 6 ++++++
>  arch/arm64/include/asm/kvm_hyp.h | 9 +++++++++
>  virt/kvm/arm/hyp/vgic-v2-sr.c    | 4 ++--
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
> index ab20ffa8b9e7..1d42d0aa2feb 100644
> --- a/arch/arm/include/asm/kvm_hyp.h
> +++ b/arch/arm/include/asm/kvm_hyp.h
> @@ -26,6 +26,12 @@
>  
>  #define __hyp_text __section(.hyp.text) notrace
>  
> +#define hyp_symbol_addr(s)						\
> +	({								\
> +		typeof(s) *addr = &(s);					\
> +		addr;							\
> +	})
> +
>  #define __ACCESS_VFP(CRn)			\
>  	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
>  
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 08d3bb66c8b7..a2d98c539023 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -25,6 +25,15 @@
>  
>  #define __hyp_text __section(.hyp.text) notrace
>  
> +#define hyp_symbol_addr(s)						\
> +	({								\
> +		typeof(s) *addr;					\
> +		asm volatile("adrp	%0, %1\n"			\
> +			     "add	%0, %0, :lo12:%1\n"		\
> +			     : "=r" (addr) : "S" (&s));			\

Can't we use adr_l here?

> +		addr;							\
> +	})
> +

I don't fully appreciate the semantics of this macro going by its name
only.  My understanding is that if you want to resolve a symbol to an
address which is mapped in hyp, then use this.  Is this correct?

If so, can we add a small comment (because I can't come up with a better
name).


>  #define read_sysreg_elx(r,nvh,vh)					\
>  	({								\
>  		u64 reg;						\
> diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
> index d7fd46fe9efb..4573d0552af3 100644
> --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
> @@ -25,7 +25,7 @@
>  static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
>  {
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> -	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
> +	int nr_lr = hyp_symbol_addr(kvm_vgic_global_state)->nr_lr;
>  	u32 elrsr0, elrsr1;
>  
>  	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
> @@ -139,7 +139,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  		return -1;
>  
>  	rd = kvm_vcpu_dabt_get_rd(vcpu);
> -	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
> +	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
>  	addr += fault_ipa - vgic->vgic_cpu_base;
>  
>  	if (kvm_vcpu_dabt_iswrite(vcpu)) {
> -- 
> 2.14.2
> 
Otherwise looks good.

Thanks,
-Christoffer
