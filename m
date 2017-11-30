From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 37/37] KVM: arm/arm64: Avoid VGICv3 save/restore on VHE
 with no IRQs
Date: Thu, 30 Nov 2017 21:33:30 +0300
Message-ID: <20171130183330.x7jc6m2yffcxcvkz@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-38-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-38-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:41PM +0200, Christoffer Dall wrote:
> We can finally get completely rid of any calls to the VGICv3
> save/restore functions when the AP lists are empty on VHE systems.  This
> requires carefully factoring out trap configuration from saving and
> restoring state, and carefully choosing what to do on the VHE and
> non-VHE path.
> 
> One of the challenges is that we cannot save/restore the VMCR lazily
> because we can only write the VMCR when ICC_SRE_EL1.SRE is cleared when
> emulating a GICv2-on-GICv3, since otherwise all Group-0 interrupts end
> up being delivered as FIQ.
> 
> To solve this problem, and still provide fast performance in the fast
> path of exiting a VM when no interrupts are pending (which also
> optimized the latency for actually delivering virtual interrupts coming
> from physical interrupts), we orchestrate a dance of only doing the
> activate/deactivate traps in vgic load/put for VHE systems (which can
> have ICC_SRE_EL1.SRE cleared when running in the host), and doing the
> configuration on every round-trip on non-VHE systems.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_hyp.h   |   2 +
>  arch/arm/kvm/hyp/switch.c        |   8 ++-
>  arch/arm64/include/asm/kvm_hyp.h |   2 +
>  arch/arm64/kvm/hyp/switch.c      |   8 ++-
>  virt/kvm/arm/hyp/vgic-v3-sr.c    | 116 +++++++++++++++++++++++++--------------
>  virt/kvm/arm/vgic/vgic-v3.c      |   6 ++
>  virt/kvm/arm/vgic/vgic.c         |   7 +--
>  7 files changed, 101 insertions(+), 48 deletions(-)

[...]

> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index ed5da75..34d71d2 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -208,15 +208,15 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
> -	u64 val;
>  
>  	/*
>  	 * Make sure stores to the GIC via the memory mapped interface
> -	 * are now visible to the system register interface.
> +	 * are now visible to the system register interface when reading the
> +	 * LRs, and when reading back the VMCR on non-VHE systems.
>  	 */
> -	if (!cpu_if->vgic_sre) {
> -		dsb(st);
> -		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
> +	if (used_lrs || !has_vhe()) {
> +		if (!cpu_if->vgic_sre)
> +			dsb(st);
>  	}

Nit:
	if ((used_lrs || !has_vhe()) && !cpu_if->vgic_sre)
		dsb(st);

>  
>  	if (used_lrs) {
> @@ -225,7 +225,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  
>  		elrsr = read_gicreg(ICH_ELSR_EL2);
>  
> -		write_gicreg(0, ICH_HCR_EL2);
> +		write_gicreg(cpu_if->vgic_hcr & ~ICH_HCR_EN, ICH_HCR_EL2);
>  
>  		for (i = 0; i < used_lrs; i++) {
>  			if (elrsr & (1 << i))
> @@ -235,18 +235,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  
>  			__gic_v3_set_lr(0, i);
>  		}
> -	} else {
> -		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
> -			write_gicreg(0, ICH_HCR_EL2);
> -	}
> -
> -	val = read_gicreg(ICC_SRE_EL2);
> -	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
> -
> -	if (!cpu_if->vgic_sre) {
> -		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> -		isb();
> -		write_gicreg(1, ICC_SRE_EL1);
>  	}
>  }
>  
> @@ -256,6 +244,31 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
>  	int i;
>  
> +	if (used_lrs) {
> +		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
> +
> +		for (i = 0; i < used_lrs; i++)
> +			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
> +	}
> +
> +	/*
> +	 * Ensure that writes to the LRs, and on non-VHE systems ensure that
> +	 * the write to the VMCR in __vgic_v3_activate_traps(), will have
> +	 * reached the (re)distributors. This ensure the guest will read the
> +	 * correct values from the memory-mapped interface.
> +	 */
> +	if (used_lrs || !has_vhe()) {
> +		if (!cpu_if->vgic_sre) {
> +			isb();
> +			dsb(sy);
> +		}
> +	}

And here

> +}
> +
