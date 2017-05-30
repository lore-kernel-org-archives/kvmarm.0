From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/10] KVM: arm/arm64: vgic: Implement forwarding setting
Date: Tue, 30 May 2017 14:17:39 +0100
Message-ID: <534fb830-4b38-e146-ed77-d64b7c6a8c22@arm.com>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-10-git-send-email-eric.auger@redhat.com>
 <877f14lp76.fsf@arm.com> <9192256c-157b-2112-b8ef-e7815ad14e7d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F8E408EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 May 2017 09:13:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OxlwlS1LbvSQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 May 2017 09:13:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4A0405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 May 2017 09:13:49 -0400 (EDT)
In-Reply-To: <9192256c-157b-2112-b8ef-e7815ad14e7d@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On 30/05/17 13:54, Auger Eric wrote:
> Hi,
> 
> On 25/05/2017 21:19, Marc Zyngier wrote:
>> On Wed, May 24 2017 at 10:13:22 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
>>> Implements kvm_vgic_[set|unset]_forwarding.
>>>
>>> Handle low-level VGIC programming and consistent irqchip
>>> programming.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>
>>> ---
>>> ---
>>>  include/kvm/arm_vgic.h   |   5 +++
>>>  virt/kvm/arm/vgic/vgic.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 110 insertions(+)
>>>
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index 695ebc7..7ddac8a 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -343,4 +343,9 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
>>>   */
>>>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
>>>  
>>> +int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int irq,
>>> +			    unsigned int virt_irq);
>>> +void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int irq,
>>> +			       unsigned int virt_irq);
>>
>> nit: the name of the variables do not match that of the function
>> definition, and are much clearer there.
>>
>>> +
>>>  #endif /* __KVM_ARM_VGIC_H */
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index aa0618c..c2add8d 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -17,6 +17,8 @@
>>>  #include <linux/kvm.h>
>>>  #include <linux/kvm_host.h>
>>>  #include <linux/list_sort.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/irq.h>
>>>  
>>>  #include "vgic.h"
>>>  
>>> @@ -771,3 +773,106 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
>>>  	return map_is_active;
>>>  }
>>>  
>>> +/**
>>> + * kvm_vgic_set_forwarding - Set IRQ forwarding
>>> + *
>>> + * @kvm: kvm handle
>>> + * @host_irq: the host linux IRQ
>>> + * @vintid: the virtual INTID
>>> + *
>>> + * This function must be called when the IRQ is not active:
>>> + * ie. not active at GIC level and not currently under injection
>>> + * into the guest using the unforwarded mode. The physical IRQ must
>>> + * be disabled and all vCPUs must have been exited and prevented
>>> + * from being re-entered.
>>> + */
>>> +int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
>>> +			    unsigned int vintid)
>>> +{
>>> +	struct kvm_vcpu *vcpu;
>>> +	struct vgic_irq *irq;
>>> +	struct irq_desc *desc;
>>> +	struct irq_data *data;
>>> +	unsigned int pintid;
>>> +	int ret = 0;
>>> +
>>> +
>>> +	kvm_debug("%s host linux irq=%d vintid=%d\n",
>>> +		  __func__, host_irq, vintid);
>>> +
>>> +	if (!vgic_valid_spi(kvm, vintid))
>>> +		return 0;
>>> +
>>> +	/* find the INTID corresponding to @host_irq */
>>> +	desc = irq_to_desc(host_irq);
>>> +	if (!desc) {
>>> +		kvm_err("%s: no interrupt descriptor\n", __func__);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	data = irq_desc_get_irq_data(desc);
>>> +	while (data->parent_data)
>>> +		data = data->parent_data;
>>> +
>>> +	pintid = data->hwirq;
>>> +
>>> +	irq = vgic_get_irq(kvm, NULL, vintid);
>>> +
>>> +	spin_lock(&irq->irq_lock);
>>> +
>>> +	vcpu = irq->target_vcpu;
>>> +
>>> +	if (!vcpu) {
>>> +		ret = -EAGAIN;
>>> +		goto unlock;
>>> +	}
>>> +
>>> +	irq_set_vcpu_affinity(host_irq, vcpu);
>>> +
>>> +	irq->hw = true;
>>> +	irq->hwintid = pintid;
>>> +	irq->host_irq = host_irq;
>>
>> This feels like a duplication of kvm_vgic_map_phys_irq(), specially if
>> you move the pintid discovery there. Can we somehow unify them?
> Sure. At the beginning it was just a matter of irq_lock I did not want
> to release.
> 
> I was somehow embarrassed by the vcpu param of irq_set_vcpu_affinity.
> Shall we really test target_vcpu. The actual value is unused for SPI so
> shouldn't we simply use something != NULL.

I guess that for the time being, this would be good enough. But GICv4
requires some actual tracking of the affinity, so we may have to bite
the bullet already, and decide that the interrupt is always affine to a
vcpu.

Does this have any userspace visible impact?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
