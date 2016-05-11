From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 23/55] KVM: arm/arm64: vgic-new: Add CTLR, TYPER and
 IIDR handlers
Date: Wed, 11 May 2016 13:47:16 +0100
Message-ID: <573329D4.5030508@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-24-git-send-email-andre.przywara@arm.com>
 <20160511120533.GM27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A958C49B34
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 08:44:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FvZh4Q7s5CAn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 08:44:01 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1325F499A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 08:44:00 -0400 (EDT)
In-Reply-To: <20160511120533.GM27623@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hej,

On 11/05/16 13:05, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:36AM +0100, Andre Przywara wrote:
>> From: Marc Zyngier <marc.zyngier@arm.com>
>>
>> Those three registers are v2 emulation specific, so their implementation
>> lives entirely in vgic-mmio-v2.c. Also they are handled in one function,
>> as their implementation is pretty simple.
>> When the guest enables the distributor, we kick all VCPUs to get
>> potentially pending interrupts serviced.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - kick VCPUs is the distributor gets enabled
>> - improve comment
>>
>> Changelog v1 .. v2:
>> - adapt to new MMIO framework
>> - use switch() statements to improve readability
>>
>> Changelog v2 .. v3:
>> - add vgic_kick_vcpus() implementation
>>
>>  include/linux/irqchip/arm-gic.h  |  1 +
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 48 +++++++++++++++++++++++++++++++++++++++-
>>  virt/kvm/arm/vgic/vgic.c         | 15 +++++++++++++
>>  virt/kvm/arm/vgic/vgic.h         |  4 ++++
>>  4 files changed, 67 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
>> index be0d26f..fd05185 100644
>> --- a/include/linux/irqchip/arm-gic.h
>> +++ b/include/linux/irqchip/arm-gic.h
>> @@ -33,6 +33,7 @@
>>  
>>  #define GIC_DIST_CTRL			0x000
>>  #define GIC_DIST_CTR			0x004
>> +#define GIC_DIST_IIDR			0x008
>>  #define GIC_DIST_IGROUP			0x080
>>  #define GIC_DIST_ENABLE_SET		0x100
>>  #define GIC_DIST_ENABLE_CLEAR		0x180
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index 2729a22..69e96f7 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -20,9 +20,55 @@
>>  #include "vgic.h"
>>  #include "vgic-mmio.h"
>>  
>> +static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
>> +					    gpa_t addr, unsigned int len)
>> +{
>> +	u32 value;
>> +
>> +	switch (addr & 0x0c) {
>> +	case GIC_DIST_CTRL:
>> +		value = vcpu->kvm->arch.vgic.enabled ? GICD_ENABLE : 0;
>> +		break;
>> +	case GIC_DIST_CTR:
>> +		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>> +		value = (value >> 5) - 1;
>> +		value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
>> +		break;
>> +	case GIC_DIST_IIDR:
>> +		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +
>> +	return extract_bytes(value, addr & 3, len);
>> +}
>> +
>> +static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
>> +				    gpa_t addr, unsigned int len,
>> +				    unsigned long val)
>> +{
>> +	switch (addr & 0x0c) {
>> +	case GIC_DIST_CTRL:
>> +		if (!(addr & 1)) {
> 
> what is this !(addr & 1) check?

Mmmh, interesting. The original idea was that we care only about the
lowest significant byte. I guess this was somehow lost in translation
when Marc reworked the function. I think it should at least read:
"if (!(addr & 3))" to match the switch mask, otherwise for instance a
byte write to address 2 triggers the if branch as well.

I will fix the mask to 3 and add a comment.

Thanks,
Andre.


> 
>> +			struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +			bool was_enabled = dist->enabled;
>> +
>> +			dist->enabled = val & GICD_ENABLE;
>> +			if (!was_enabled && dist->enabled)
>> +				vgic_kick_vcpus(vcpu->kvm);
>> +		}
>> +		break;
>> +	case GIC_DIST_CTR:
>> +	case GIC_DIST_IIDR:
>> +		/* Nothing to do */
>> +		return;
>> +	}
>> +}
>> +
>>  static const struct vgic_register_region vgic_v2_dist_registers[] = {
>>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 12),
>> +		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
>>  		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index c3dbcf3..5355de6 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -544,3 +544,18 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>>  
>>  	return pending;
>>  }
>> +
>> +void vgic_kick_vcpus(struct kvm *kvm)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	int c;
>> +
>> +	/*
>> +	 * We've injected an interrupt, time to find out who deserves
>> +	 * a good kick...
>> +	 */
>> +	kvm_for_each_vcpu(c, vcpu, kvm) {
>> +		if (kvm_vgic_vcpu_pending_irq(vcpu))
>> +			kvm_vcpu_kick(vcpu);
>> +	}
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index fd9acaa..cf62015 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -16,11 +16,15 @@
>>  #ifndef __KVM_ARM_VGIC_NEW_H__
>>  #define __KVM_ARM_VGIC_NEW_H__
>>  
>> +#define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
>> +#define IMPLEMENTER_ARM		0x43b
>> +
>>  #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
>>  
>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>>  			      u32 intid);
>>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>> +void vgic_kick_vcpus(struct kvm *kvm);
>>  
>>  void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
>>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
>> -- 
>> 2.7.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
