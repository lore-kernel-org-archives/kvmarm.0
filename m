From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/11] KVM: arm/arm64: vgic: Prevent userspace
 injection of a mapped interrupt
Date: Tue, 4 Aug 2015 15:45:09 +0200
Message-ID: <20150804134509.GB29335@cbox>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
 <1437753309-17989-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437753309-17989-10-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 24, 2015 at 04:55:07PM +0100, Marc Zyngier wrote:
> Virtual interrupts mapped to a HW interrupt should only be triggered
> from inside the kernel. Otherwise, you could end up confusing the
> kernel (and the GIC's) state machine.
> 
> Rearrange the injection path so that kvm_vgic_inject_irq is
> used for non-mapped interrupts, and kvm_vgic_inject_mapped_irq is
> used for mapped interrupts. The latter should only be called from
> inside the kernel (timer, VFIO).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h |  2 +
>  virt/kvm/arm/vgic.c    | 99 ++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 70 insertions(+), 31 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 7306b4b..f6bfd79 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -351,6 +351,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  			bool level);
> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> +			       struct irq_phys_map *map, bool level);
>  void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 3f7b690..e40ef70 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1533,7 +1533,8 @@ static int vgic_validate_injection(struct kvm_vcpu *vcpu, int irq, int level)
>  }
>  
>  static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
> -				  unsigned int irq_num, bool level)
> +				   struct irq_phys_map *map,
> +				   unsigned int irq_num, bool level)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct kvm_vcpu *vcpu;
> @@ -1541,6 +1542,9 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  	int enabled;
>  	bool ret = true, can_inject = true;
>  
> +	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
> +		return -EINVAL;
> +
>  	spin_lock(&dist->lock);
>  
>  	vcpu = kvm_get_vcpu(kvm, cpuid);
> @@ -1603,14 +1607,42 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
>  out:
>  	spin_unlock(&dist->lock);
>  
> -	return ret ? cpuid : -EINVAL;
> +	if (!ret) {

don't you mean if (ret) here?  hint: ret is a bool

> +		/* kick the specified vcpu */
> +		kvm_vcpu_kick(kvm_get_vcpu(kvm, cpuid));
> +	}
> +
> +	return 0;

isn't this a change in the internal API?
Before, we would return -EINVAL when ret is false.  Not sure if this
has any consequences though?

> +}
> +
> +static int vgic_lazy_init(struct kvm *kvm)
> +{
> +	int ret = 0;
> +
> +	if (unlikely(!vgic_initialized(kvm))) {
> +		/*
> +		 * We only provide the automatic initialization of the VGIC
> +		 * for the legacy case of a GICv2. Any other type must
> +		 * be explicitly initialized once setup with the respective
> +		 * KVM device call.
> +		 */
> +		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
> +			return -EBUSY;
> +
> +		mutex_lock(&kvm->lock);
> +		ret = vgic_init(kvm);
> +		mutex_unlock(&kvm->lock);
> +	}
> +
> +	return ret;
>  }
>  
>  /**
>   * kvm_vgic_inject_irq - Inject an IRQ from a device to the vgic
>   * @kvm:     The VM structure pointer
>   * @cpuid:   The CPU for PPIs
> - * @irq_num: The IRQ number that is assigned to the device
> + * @irq_num: The IRQ number that is assigned to the device. This IRQ
> + *           must not be mapped to a HW interrupt.
>   * @level:   Edge-triggered:  true:  to trigger the interrupt
>   *			      false: to ignore the call
>   *	     Level-sensitive  true:  activates an interrupt
> @@ -1623,39 +1655,44 @@ out:
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
>  			bool level)
>  {
> -	int ret = 0;
> -	int vcpu_id;
> -
> -	if (unlikely(!vgic_initialized(kvm))) {
> -		/*
> -		 * We only provide the automatic initialization of the VGIC
> -		 * for the legacy case of a GICv2. Any other type must
> -		 * be explicitly initialized once setup with the respective
> -		 * KVM device call.
> -		 */
> -		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -		mutex_lock(&kvm->lock);
> -		ret = vgic_init(kvm);
> -		mutex_unlock(&kvm->lock);
> +	struct irq_phys_map *map;
> +	int ret;
>  
> -		if (ret)
> -			goto out;
> -	}
> +	ret = vgic_lazy_init(kvm);
> +	if (ret)
> +		return ret;
>  
> -	if (irq_num >= min(kvm->arch.vgic.nr_irqs, 1020))
> +	map = vgic_irq_map_search(kvm_get_vcpu(kvm, cpuid), irq_num);
> +	if (map)
>  		return -EINVAL;
>  
> -	vcpu_id = vgic_update_irq_pending(kvm, cpuid, irq_num, level);
> -	if (vcpu_id >= 0) {
> -		/* kick the specified vcpu */
> -		kvm_vcpu_kick(kvm_get_vcpu(kvm, vcpu_id));
> -	}
> +	return vgic_update_irq_pending(kvm, cpuid, NULL, irq_num, level);
> +}
>  
> -out:
> -	return ret;
> +/**
> + * kvm_vgic_inject_mapped_irq - Inject a physically mapped IRQ to the vgic
> + * @kvm:     The VM structure pointer
> + * @cpuid:   The CPU for PPIs
> + * @map:     Pointer to a irq_phys_map structure describing the mapping
> + * @level:   Edge-triggered:  true:  to trigger the interrupt
> + *			      false: to ignore the call
> + *	     Level-sensitive  true:  activates an interrupt
> + *			      false: deactivates an interrupt

just noticed this unfortunate use of the words 'activate/deactivate'
here, which is not true, it just raises/lowers the input signal...

> + *
> + * The GIC is not concerned with devices being active-LOW or active-HIGH for
> + * level-sensitive interrupts.  You can think of the level parameter as 1
> + * being HIGH and 0 being LOW and all devices being active-HIGH.
> + */
> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid,
> +			       struct irq_phys_map *map, bool level)
> +{
> +	int ret;
> +
> +	ret = vgic_lazy_init(kvm);
> +	if (ret)
> +		return ret;
> +
> +	return vgic_update_irq_pending(kvm, cpuid, map, map->virt_irq, level);
>  }
>  
>  static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> -- 
> 2.1.4
> 

Thanks,
-Christoffer
