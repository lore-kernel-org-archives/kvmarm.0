From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 10/17] arm64: KVM: vgic-v2: Do not save an LR known to
 be empty
Date: Thu, 3 Mar 2016 00:08:15 +0100
Message-ID: <20160302230815.GD9634@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-11-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455727249-24752-11-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 04:40:42PM +0000, Marc Zyngier wrote:
> On exit, any empty LR will be signaled in GICH_ELRSR*. Which
> means that we do not have to save it, and we can just clear
> its state in the in-memory copy.
> 
> Take this opportunity to move the LR saving code into its
> own function.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v2-sr.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> index c281374..3dbbc6b 100644
> --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> @@ -85,6 +85,25 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
>  #endif
>  }
>  
> +static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
> +{
> +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> +	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
> +	int i;
> +
> +	for (i = 0; i < nr_lr; i++) {
> +		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
> +			continue;
> +
> +		if (cpu_if->vgic_elrsr & (1UL << i)) {
> +			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
> +			continue;
> +		}
> +
> +		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
> +	}
> +}
> +
>  /* vcpu is already in the HYP VA space */
>  void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  {
> @@ -92,12 +111,10 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
>  	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
> -	int i, nr_lr;
>  
>  	if (!base)
>  		return;
>  
> -	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
>  	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
>  
>  	if (vcpu->arch.vgic_cpu.live_lrs) {
> @@ -105,10 +122,7 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  
>  		save_maint_int_state(vcpu, base);
>  		save_elrsr(vcpu, base);
> - 
> -		for (i = 0; i < nr_lr; i++)
> -			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
> -				cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
> +		save_lrs(vcpu, base);
>  
>  		writel_relaxed(0, base + GICH_HCR);
>  
> -- 
> 2.1.4
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
