From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 14/54] KVM: arm/arm64: vgic-new: Implement virtual IRQ
 injection
Date: Thu, 5 May 2016 15:43:28 +0100
Message-ID: <572B5C10.4040900@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-15-git-send-email-andre.przywara@arm.com>
 <57293844.1060802@linaro.org> <572B2D88.3050504@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <572B2D88.3050504@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Tom Hanson <thomas.hanson@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/05/16 12:24, Andre Przywara wrote:
> Hi Tom,
> 
> thanks for looking at the patches!
> 
> On 04/05/16 00:46, Tom Hanson wrote:
>> On 04/28/2016 10:45 AM, Andre Przywara wrote:
>> ...
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index fb45537..92b78a0 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -19,8 +19,31 @@
>> ... 
>>> +/*
>>> + * Locking order is always:
>>> + *   vgic_cpu->ap_list_lock
>>> + *     vgic_irq->irq_lock
>>> + *
>>> + * (that is, always take the ap_list_lock before the struct vgic_irq
>>> lock).
>>> + *
>>> + * When taking more than one ap_list_lock at the same time, always
>>> take the
>>> + * lowest numbered VCPU's ap_list_lock first, so:
>>> + *   vcpuX->vcpu_id < vcpuY->vcpu_id:
>>> + *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
>>> + *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
>>> + */
>>
>> The code would be safer and easier to maintain in the long run if there
>> were functions provided which implement these 2 rules.  Something along
>> the line of:
>>
>>   void vgic_lock_aplist_irq(spinlock_t ap_list_lock, spinlock_t irq_lock){
>>       spin_lock(ap_list_lock);
>>       spin_lock(irq_lock);
>>   }
> 
> The idea isn't too bad indeed.
> I see that we could use that in vgic_queue_irq_unlock() and
> vgic_mmio_write_sactive().
> But as Marc mentioned in a conversation yesterday we will have a mixture
> of wrapped locks and open coded lock sequences. See for instance
> vgic_prune_ap_list(), where we have the sequence, but we can't use
> vgic_lock_aplist_irq() because the IRQ lock is taken inside the loop
> while the ap_list_lock is taken once outside of it.
> 
> Marc, Christoffer, what is your opinion here?

I don't mind switching to these more "high level" primitives, but I'm
slightly worried that whoever starts using them will not consider that
they are quite heavy and not always required.

But maybe it is worth a try.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
