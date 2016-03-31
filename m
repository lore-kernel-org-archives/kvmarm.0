From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 28/45] KVM: arm/arm64: vgic-new: Add GICv3 SGI system
 register trap handler
Date: Thu, 31 Mar 2016 14:07:55 +0200
Message-ID: <20160331120755.GE4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-29-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-29-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:51AM +0000, Andre Przywara wrote:
> In contrast to GICv2 SGIs in a GICv3 implementation are not triggered
> by a MMIO write, but with a system register write. KVM knows about
> that register already, we just need to implement the handler and wire
> it up to the core KVM/ARM code.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/kvm/vgic/vgic.h       |   8 ++++
>  virt/kvm/arm/vgic/vgic_mmio.c | 101 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index a8262c7..ab5fcc7 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -202,6 +202,14 @@ bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
>  
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> +void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
> +#else
> +static inline void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
> +{
> +}
> +#endif
> +
>  /**
>   * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
>   *
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 44fdba5..7eb6b93 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -1139,4 +1139,105 @@ int vgic_register_redist_regions(struct kvm *kvm, gpa_t redist_base_address)
>  
>  	return ret;
>  }
> +
> +/*
> + * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
> + * generation register ICC_SGI1R_EL1) with a given VCPU.
> + * If the VCPU's MPIDR matches, return the level0 affinity, otherwise
> + * return -1.
> + */
> +static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
> +{
> +	unsigned long affinity;
> +	int level0;
> +
> +	/*
> +	 * Split the current VCPU's MPIDR into affinity level 0 and the
> +	 * rest as this is what we have to compare against.
> +	 */
> +	affinity = kvm_vcpu_get_mpidr_aff(vcpu);
> +	level0 = MPIDR_AFFINITY_LEVEL(affinity, 0);
> +	affinity &= ~MPIDR_LEVEL_MASK;
> +
> +	/* bail out if the upper three levels don't match */
> +	if (sgi_aff != affinity)
> +		return -1;
> +
> +	/* Is this VCPU's bit set in the mask ? */
> +	if (!(sgi_cpu_mask & BIT(level0)))
> +		return -1;
> +
> +	return level0;
> +}
> +
> +#define SGI_AFFINITY_LEVEL(reg, level) \
> +	((((reg) & ICC_SGI1R_AFFINITY_## level ##_MASK) \
> +	>> ICC_SGI1R_AFFINITY_## level ##_SHIFT) << MPIDR_LEVEL_SHIFT(level))

wholy crap?  What is this?  Yikes, this is already in the kernel.  Oh
well, I'm not going to try to understand it again then.

> +
> +/**
> + * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
> + * @vcpu: The VCPU requesting a SGI
> + * @reg: The value written into the ICC_SGI1R_EL1 register by that VCPU
> + *
> + * With GICv3 (and ARE=1) CPUs trigger SGIs by writing to a system register.
> + * This will trap in sys_regs.c and call this function.
> + * This ICC_SGI1R_EL1 register contains the upper three affinity levels of the
> + * target processors as well as a bitmask of 16 Aff0 CPUs.
> + * If the interrupt routing mode bit is not set, we iterate over all VCPUs to
> + * check for matching ones. If this bit is set, we signal all, but not the
> + * calling VCPU.
> + */
> +void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_vcpu *c_vcpu;
> +	u16 target_cpus;
> +	u64 mpidr;
> +	int sgi, c;
> +	int vcpu_id = vcpu->vcpu_id;
> +	bool broadcast;
> +
> +	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
> +	broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
> +	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
> +	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
> +	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
> +	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
> +
> +	/*
> +	 * We iterate over all VCPUs to find the MPIDRs matching the request.
> +	 * If we have handled one CPU, we clear it's bit to detect early

s/it's/its/

> +	 * if we are already finished. This avoids iterating through all
> +	 * VCPUs when most of the times we just signal a single VCPU.
> +	 */
> +	kvm_for_each_vcpu(c, c_vcpu, kvm) {
> +		struct vgic_irq *irq;
> +
> +		/* Exit early if we have dealt with all requested CPUs */
> +		if (!broadcast && target_cpus == 0)
> +			break;
> +
> +		/* Don't signal the calling VCPU */
> +		if (broadcast && c == vcpu_id)
> +			continue;
> +
> +		if (!broadcast) {
> +			int level0;
> +
> +			level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
> +			if (level0 == -1)
> +				continue;
> +
> +			/* remove this matching VCPU from the mask */
> +			target_cpus &= ~BIT(level0);
> +		}
> +
> +		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->pending = true;
> +
> +		vgic_queue_irq(vcpu->kvm, irq);
> +	}

eventually I suspect we should implement a linear time 'give me a vcpu
based on this mpidr' lookup function, but this should be fine for now.

> +}
>  #endif
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
