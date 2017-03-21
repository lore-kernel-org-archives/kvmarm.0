From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 4/9] KVM: arm/arm64: vgic: Get rid of unnecessary
 process_maintenance operationjjjj
Date: Tue, 21 Mar 2017 13:26:52 +0000
Message-ID: <3c813d9d-001d-03d9-3c4f-31ae8f25a45e@arm.com>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-5-cdall@linaro.org>
 <0da4b9c8-8631-e0f0-0ead-e9f65746b529@arm.com> <20170321122644.GD15920@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170321122644.GD15920@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 12:26, Christoffer Dall wrote:
> On Tue, Mar 21, 2017 at 11:36:19AM +0000, Marc Zyngier wrote:
>> On 20/03/17 10:58, Christoffer Dall wrote:
>>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>>
>>> Since we always read back the LRs that we wrote to the guest and the
>>> MISR and EISR registers simply provide a summary of the configuration of
>>> the bits in the LRs, there is really no need to read back those status
>>> registers and process them.  We can might as well just signal the
>>> notifyfd when folding the LR state and save some cycles in the process.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-v2.c | 55 ++++++++++-----------------------------------
>>>  virt/kvm/arm/vgic/vgic-v3.c | 47 +++++++++++---------------------------
>>>  virt/kvm/arm/vgic/vgic.c    |  8 +++----
>>>  virt/kvm/arm/vgic/vgic.h    |  4 ++--
>>>  4 files changed, 31 insertions(+), 83 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>>> index dfe6e5e..0172754 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>>> @@ -22,20 +22,6 @@
>>>  
>>>  #include "vgic.h"
>>>  
>>> -/*
>>> - * Call this function to convert a u64 value to an unsigned long * bitmask
>>> - * in a way that works on both 32-bit and 64-bit LE and BE platforms.
>>> - *
>>> - * Warning: Calling this function may modify *val.
>>> - */
>>> -static unsigned long *u64_to_bitmask(u64 *val)
>>> -{
>>> -#if defined(CONFIG_CPU_BIG_ENDIAN) && BITS_PER_LONG == 32
>>> -	*val = (*val >> 32) | (*val << 32);
>>> -#endif
>>> -	return (unsigned long *)val;
>>> -}
>>> -
>>
>> Getting rid of u64_to_bitmask makes me feel slightly better...
>>
>>>  static inline void vgic_v2_write_lr(int lr, u32 val)
>>>  {
>>>  	void __iomem *base = kvm_vgic_global_state.vctrl_base;
>>> @@ -51,38 +37,10 @@ void vgic_v2_init_lrs(void)
>>>  		vgic_v2_write_lr(i, 0);
>>>  }
>>>  
>>> -void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
>>> +void vgic_v2_clear_uie(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
>>> -
>>> -	if (cpuif->vgic_misr & GICH_MISR_EOI) {
>>> -		u64 eisr = cpuif->vgic_eisr;
>>> -		unsigned long *eisr_bmap = u64_to_bitmask(&eisr);
>>> -		int lr;
>>> -
>>> -		for_each_set_bit(lr, eisr_bmap, kvm_vgic_global_state.nr_lr) {
>>> -			u32 intid = cpuif->vgic_lr[lr] & GICH_LR_VIRTUALID;
>>> -
>>> -			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
>>> -
>>> -			/* Only SPIs require notification */
>>> -			if (vgic_valid_spi(vcpu->kvm, intid))
>>> -				kvm_notify_acked_irq(vcpu->kvm, 0,
>>> -						     intid - VGIC_NR_PRIVATE_IRQS);
>>> -		}
>>> -	}
>>> -
>>> -	/* check and disable underflow maintenance IRQ */
>>>  	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
>>> -
>>> -	/*
>>> -	 * In the next iterations of the vcpu loop, if we sync the
>>> -	 * vgic state after flushing it, but before entering the guest
>>> -	 * (this happens for pending signals and vmid rollovers), then
>>> -	 * make sure we don't pick up any old maintenance interrupts
>>> -	 * here.
>>> -	 */
>>> -	cpuif->vgic_eisr = 0;
>>>  }
>>>  
>>>  void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
>>> @@ -92,6 +50,12 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
>>>  	cpuif->vgic_hcr |= GICH_HCR_UIE;
>>>  }
>>>  
>>> +static bool lr_signals_eoi_mi(u32 lr_val)
>>> +{
>>> +	return !(lr_val & GICH_LR_STATE) && (lr_val & GICH_LR_EOI) &&
>>> +	       !(lr_val & GICH_LR_HW);
>>> +}
>>> +
>>>  /*
>>>   * transfer the content of the LRs back into the corresponding ap_list:
>>>   * - active bit is transferred as is
>>> @@ -109,6 +73,11 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  		u32 intid = val & GICH_LR_VIRTUALID;
>>>  		struct vgic_irq *irq;
>>>  
>>> +		/* Notify fds when the guest EOI'ed a level-triggered SPI */
>>> +		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
>>> +			kvm_notify_acked_irq(vcpu->kvm, 0,
>>> +					     intid - VGIC_NR_PRIVATE_IRQS);
>>> +
>>>  		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
>>>  
>>>  		spin_lock(&irq->irq_lock);
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index 3d7796c..7880c5c 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -21,42 +21,9 @@
>>>  
>>>  #include "vgic.h"
>>>  
>>> -void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>>> +void vgic_v3_clear_uie(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>>> -	u32 model = vcpu->kvm->arch.vgic.vgic_model;
>>> -
>>> -	if (cpuif->vgic_misr & ICH_MISR_EOI) {
>>> -		unsigned long eisr_bmap = cpuif->vgic_eisr;
>>> -		int lr;
>>> -
>>> -		for_each_set_bit(lr, &eisr_bmap, kvm_vgic_global_state.nr_lr) {
>>> -			u32 intid;
>>> -			u64 val = cpuif->vgic_lr[lr];
>>> -
>>> -			if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>> -				intid = val & ICH_LR_VIRTUAL_ID_MASK;
>>> -			else
>>> -				intid = val & GICH_LR_VIRTUALID;
>>> -
>>> -			WARN_ON(cpuif->vgic_lr[lr] & ICH_LR_STATE);
>>> -
>>> -			/* Only SPIs require notification */
>>> -			if (vgic_valid_spi(vcpu->kvm, intid))
>>> -				kvm_notify_acked_irq(vcpu->kvm, 0,
>>> -						     intid - VGIC_NR_PRIVATE_IRQS);
>>> -		}
>>> -
>>> -		/*
>>> -		 * In the next iterations of the vcpu loop, if we sync
>>> -		 * the vgic state after flushing it, but before
>>> -		 * entering the guest (this happens for pending
>>> -		 * signals and vmid rollovers), then make sure we
>>> -		 * don't pick up any old maintenance interrupts here.
>>> -		 */
>>> -		cpuif->vgic_eisr = 0;
>>> -	}
>>> -
>>>  	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
>>>  }
>>>  
>>> @@ -67,6 +34,12 @@ void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>>>  	cpuif->vgic_hcr |= ICH_HCR_UIE;
>>>  }
>>>  
>>> +static bool lr_signals_eoi_mi(u64 lr_val)
>>> +{
>>> +	return !(lr_val & ICH_LR_STATE) && (lr_val & ICH_LR_EOI) &&
>>> +	       !(lr_val & ICH_LR_HW);
>>> +}
>>> +
>>>  void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>>> @@ -82,6 +55,12 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  			intid = val & ICH_LR_VIRTUAL_ID_MASK;
>>>  		else
>>>  			intid = val & GICH_LR_VIRTUALID;
>>> +
>>> +		/* Notify fds when the guest EOI'ed a level-triggered IRQ */
>>> +		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
>>> +			kvm_notify_acked_irq(vcpu->kvm, 0,
>>> +					     intid - VGIC_NR_PRIVATE_IRQS);
>>> +
>>>  		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
>>>  		if (!irq)	/* An LPI could have been unmapped. */
>>>  			continue;
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index 1436c2e..f5b3c25 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -527,12 +527,12 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>>>  	spin_unlock(&vgic_cpu->ap_list_lock);
>>>  }
>>>  
>>> -static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
>>> +static inline void vgic_clear_uie(struct kvm_vcpu *vcpu)
>>>  {
>>>  	if (kvm_vgic_global_state.type == VGIC_V2)
>>> -		vgic_v2_process_maintenance(vcpu);
>>> +		vgic_v2_clear_uie(vcpu);
>>>  	else
>>> -		vgic_v3_process_maintenance(vcpu);
>>> +		vgic_v3_clear_uie(vcpu);
>>>  }
>>>  
>>>  static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
>>> @@ -642,7 +642,7 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>>  	if (unlikely(!vgic_initialized(vcpu->kvm)))
>>>  		return;
>>>  
>>> -	vgic_process_maintenance_interrupt(vcpu);
>>> +	vgic_clear_uie(vcpu);
>>>  	vgic_fold_lr_state(vcpu);
>>
>> nit: If you moved vgic_*_clear_uie() into vgic_*_fold_lr_state, you
>> could get rid of this call, extra prototypes, and save yourself the
>> extra check. Not a big deal though.
>>
> 
> I thought about this, but the problem is that strictly speaking, you
> don't need to consume any LRs to set the underflow, you just need enough
> in the AP list, and it's theoretically possible that you have nr_lrs+1
> interrupts in the AP list which have all been migrated away.

But isn't that a problem we already have, independently of reworking the
above?

> So, it would require something like this including a rework in
> flush_lr_state to work with the following patch which only calls
> vgic_fold_lr_state when there are in fact anything live in LRs:
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index e5cf930..4b1feef 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -601,10 +601,8 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>  
>  	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
>  
> -	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr) {
> -		vgic_set_underflow(vcpu);
> +	if (compute_ap_list_depth(vcpu) > kvm_vgic_global_state.nr_lr)
>  		vgic_sort_ap_list(vcpu);
> -	}
>  
>  	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>  		spin_lock(&irq->irq_lock);
> @@ -623,8 +621,12 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>  next:
>  		spin_unlock(&irq->irq_lock);
>  
> -		if (count == kvm_vgic_global_state.nr_lr)
> +		if (count == kvm_vgic_global_state.nr_lr) {
> +			if (!list_is_last(&irq->ap_list,
> +					  &vgic_cpu->ap_list_head))
> +				vgic_set_underflow(vcpu);
>  			break;
> +		}
>  	}
>  
>  	vcpu->arch.vgic_cpu.used_lrs = count;
> 
> What do you think?

I think this deserves a patch of its own. Also, how about renaming
clear_uie to clear_underflow?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
