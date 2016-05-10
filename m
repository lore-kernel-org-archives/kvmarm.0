From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 17/55] KVM: arm/arm64: vgic-new: Add IRQ sync/flush
 framework
Date: Tue, 10 May 2016 18:32:22 +0100
Message-ID: <57321B26.1030201@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-18-git-send-email-andre.przywara@arm.com>
 <5731FC3E.7020700@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5731FC3E.7020700@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/05/16 16:20, Eric Auger wrote:
> On 05/06/2016 12:45 PM, Andre Przywara wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Implement the framework for syncing IRQs between our emulation and
>> the list registers, which represent the guest's view of IRQs.
>> This is done in kvm_vgic_flush_hwstate and kvm_vgic_sync_hwstate,
>> which gets called on guest entry and exit.
>> The code talking to the actual GICv2/v3 hardware is added in the
>> following patches.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - split out vgic_clear_lr() from vgic_populate_lr()
>> - rename vgic_populate_lrs() to vgic_flush_lr_state()
>> - clean all LRs when the distributor is disabled
>> - use list_del() instead of list_del_init()
>> - add comments to explain the direction of sync/flush_hwstate
>> - remove unneeded BUG_ON(in_interrupt()
>>
>> Changelog v2 .. v3:
>> - remove bogus v2 specific rebase leftovers
>>
>>  include/kvm/vgic/vgic.h  |   4 +
>>  virt/kvm/arm/vgic/vgic.c | 193 +++++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h |   2 +
>>  3 files changed, 199 insertions(+)
>>
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> index 2bfb42c..5fae4a9 100644
>> --- a/include/kvm/vgic/vgic.h
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -190,6 +190,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
>>  			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
>>  
>> +bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
>> +void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
>> +void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
>> +
>>  /**
>>   * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
>>   *
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 4fb20fd..c6f8b9b 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -305,3 +305,196 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>>  {
>>  	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
>>  }
>> +
>> +/**
>> + * vgic_prune_ap_list - Remove non-relevant interrupts from the list
>> + *
>> + * @vcpu: The VCPU pointer
>> + *
>> + * Go over the list of "interesting" interrupts, and prune those that we
>> + * won't have to consider in the near future.
>> + */
>> +static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_irq *irq, *tmp;
>> +
>> +retry:
>> +	spin_lock(&vgic_cpu->ap_list_lock);
>> +
>> +	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>> +		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
>> +
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		BUG_ON(vcpu != irq->vcpu);
>> +
>> +		target_vcpu = vgic_target_oracle(irq);
>> +
>> +		if (!target_vcpu) {
>> +			/*
>> +			 * We don't need to process this interrupt any
>> +			 * further, move it off the list.
>> +			 */
>> +			list_del(&irq->ap_list);
>> +			irq->vcpu = NULL;
>> +			spin_unlock(&irq->irq_lock);
>> +			continue;
>> +		}
>> +
>> +		if (target_vcpu == vcpu) {
>> +			/* We're on the right CPU */
>> +			spin_unlock(&irq->irq_lock);
>> +			continue;
>> +		}
>> +
>> +		/* This interrupt looks like it has to be migrated. */
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +		spin_unlock(&vgic_cpu->ap_list_lock);
>> +
>> +		/*
>> +		 * Ensure locking order by always locking the smallest
>> +		 * ID first.
>> +		 */
>> +		if (vcpu->vcpu_id < target_vcpu->vcpu_id) {
>> +			vcpuA = vcpu;
>> +			vcpuB = target_vcpu;
>> +		} else {
>> +			vcpuA = target_vcpu;
>> +			vcpuB = vcpu;
>> +		}
>> +
>> +		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
>> +		spin_lock(&vcpuB->arch.vgic_cpu.ap_list_lock);
>> +		spin_lock(&irq->irq_lock);
>> +
>> +		/*
>> +		 * If the affinity has been preserved, move the
>> +		 * interrupt around. Otherwise, it means things have
>> +		 * changed while the interrupt was unlocked, and we
>> +		 * need to replay this.
>> +		 *
>> +		 * In all cases, we cannot trust the list not to have
>> +		 * changed, so we restart from the beginning.
>> +		 */
>> +		if (target_vcpu == vgic_target_oracle(irq)) {
>> +			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
>> +
>> +			list_del(&irq->ap_list);
>> +			irq->vcpu = target_vcpu;
>> +			list_add_tail(&irq->ap_list, &new_cpu->ap_list_head);
>> +		}
>> +
>> +		spin_unlock(&irq->irq_lock);
>> +		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
>> +		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
>> +		goto retry;
>> +	}
>> +
>> +	spin_unlock(&vgic_cpu->ap_list_lock);
>> +}
>> +
>> +static inline void vgic_process_maintenance_interrupt(struct kvm_vcpu *vcpu)
>> +{
>> +}
>> +
>> +static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
>> +{
>> +}
>> +
>> +/* Requires the ap_list_lock and the irq_lock to be held. */
> why is it needed to hold the ap_list lock here?
>> +static inline void vgic_populate_lr(struct kvm_vcpu *vcpu,
>> +				    struct vgic_irq *irq, int lr)
>> +{
>> +	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vcpu->arch.vgic_cpu.ap_list_lock));
> ?

Only the irq lock needs to be held for this particular function. It is
vgic_flush_lr_state that requires the ap_list lock to be held, as it is
iterating over all the interrupts for that particular vcpu.

Andre, can you please amend the comment and drop that assertion?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
