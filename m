From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 21/26] KVM: arm/arm64: GICv4: Hook vPE scheduling into
 vgic flush/sync
Date: Tue, 7 Nov 2017 23:14:29 +0100
Message-ID: <07aa9cea-830b-d515-293e-b128e296c7d0@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-22-marc.zyngier@arm.com>
 <e4acdd9f-417d-c293-b754-07324a063c11@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e4acdd9f-417d-c293-b754-07324a063c11@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 07/11/2017 22:54, Auger Eric wrote:
> Hi Marc,
> 
> On 27/10/2017 16:28, Marc Zyngier wrote:
>> The redistributor needs to be told which vPE is about to be run,
>> and tells us whether there is any pending VLPI on exit.
>>
>> Let's add the scheduling calls to the vgic flush/sync functions,
>> allowing the VLPIs to be delivered to the guest.
>>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-v4.c | 39 +++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.c    |  4 ++++
>>  virt/kvm/arm/vgic/vgic.h    |  2 ++
>>  3 files changed, 45 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>> index 1a2f2fcdfa67..d7fe610bb1f5 100644
>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>> @@ -131,6 +131,45 @@ void vgic_v4_teardown(struct kvm *kvm)
>>  	its_vm->vpes = NULL;
>>  }
>>  
>> +int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
>> +{
>> +	if (!vgic_supports_direct_msis(vcpu->kvm))
>> +		return 0;
>> +
>> +	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false);
>> +}
>> +
>> +int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
>> +{
>> +	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
>> +	int err;
>> +
>> +	if (!vgic_supports_direct_msis(vcpu->kvm))
>> +		return 0;
>> +
>> +	/*
>> +	 * Before making the VPE resident, make sure the redistributor
>> +	 * corresponding to our current CPU expects us here. See the
>> +	 * doc in drivers/irqchip/irq-gic-v4.c to understand how this
>> +	 * turns into a VMOVP command at the ITS level.
>> +	 */
> I don't get the above comment. Don't you set the affinity of the
> doorbell irq below?
Forget that one. I now recall the trick and see its_vpe_set_affinity()

Eric
> 
> Thanks
> 
> Eric
>> +	err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
>> +	if (err)
>> +		return err;
>> +
>> +	err = its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, true);
>> +	if (err)
>> +		return err;
>> +
>> +	/*
>> +	 * Now that the VPE is resident, let's get rid of a potential
>> +	 * doorbell interrupt that would still be pending.
>> +	 */
>> +	err = irq_set_irqchip_state(irq, IRQCHIP_STATE_PENDING, false);
>> +
>> +	return err;
>> +}
>> +
>>  static struct vgic_its *vgic_get_its(struct kvm *kvm,
>>  				     struct kvm_kernel_irq_routing_entry *irq_entry)
>>  {
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index 0691a2250949..71ca0ff1b35a 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -709,6 +709,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>  
>> +	WARN_ON(vgic_v4_sync_hwstate(vcpu));
>> +
>>  	/* An empty ap_list_head implies used_lrs == 0 */
>>  	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
>>  		return;
>> @@ -721,6 +723,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>  /* Flush our emulation state into the GIC hardware before entering the guest. */
>>  void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>>  {
>> +	WARN_ON(vgic_v4_flush_hwstate(vcpu));
>> +
>>  	/*
>>  	 * If there are no virtual interrupts active or pending for this
>>  	 * VCPU, then there is no work to do and we can bail out without
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index c4105f613f57..9cafb61b79af 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -243,5 +243,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
>>  bool vgic_supports_direct_msis(struct kvm *kvm);
>>  int vgic_v4_init(struct kvm *kvm);
>>  void vgic_v4_teardown(struct kvm *kvm);
>> +int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu);
>> +int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu);
>>  
>>  #endif
>>
