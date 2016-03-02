From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 09/17] arm64: KVM: vgic-v2: Move GICH_ELRSR saving to
 its own function
Date: Thu, 3 Mar 2016 00:08:11 +0100
Message-ID: <20160302230811.GC9634@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455727249-24752-10-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 04:40:41PM +0000, Marc Zyngier wrote:
> In order to make the saving path slightly more readable and
> prepare for some more optimizations, let's more the GICH_ELRSR

s/more/move/

> saving to its own function.
> 
> No functional change.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> index 1bda5ce..c281374 100644
> --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> @@ -66,6 +66,25 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
>  #endif
>  }
>  
> +static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
> +{
> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> +	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
> +	u32 elrsr0, elrsr1;
> +
> +	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
> +	if (unlikely(nr_lr > 32))
> +		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
> +	else
> +		elrsr1 = 0;
> +
> +#ifdef CONFIG_CPU_BIG_ENDIAN
> +	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
> +#else
> +	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
> +#endif
> +}
> +
>  /* vcpu is already in the HYP VA space */
>  void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  {
> @@ -73,7 +92,6 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>  	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
> -	u32 elrsr0, elrsr1;
>  	int i, nr_lr;
>  
>  	if (!base)
> @@ -83,22 +101,10 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
>  
>  	if (vcpu->arch.vgic_cpu.live_lrs) {
> -		elrsr0 = readl_relaxed(base + GICH_ELRSR0);
> -		cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
> -
> -		if (unlikely(nr_lr > 32)) {
> -			elrsr1 = readl_relaxed(base + GICH_ELRSR1);
> -		} else {
> -			elrsr1 = 0;
> -		}
> -
> -#ifdef CONFIG_CPU_BIG_ENDIAN
> -		cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
> -#else
> -		cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
> -#endif
> +		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
>  
>  		save_maint_int_state(vcpu, base);
> +		save_elrsr(vcpu, base);
>   
>  		for (i = 0; i < nr_lr; i++)
>  			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
> -- 
> 2.1.4
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
