From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 14/54] KVM: arm/arm64: vgic-new: Implement virtual IRQ
 injection
Date: Thu, 5 May 2016 12:24:56 +0100
Message-ID: <572B2D88.3050504@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-15-git-send-email-andre.przywara@arm.com>
 <57293844.1060802@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E765349B55
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 07:21:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qsUTLecNosrj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2016 07:21:46 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 808C349B3F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 07:21:46 -0400 (EDT)
In-Reply-To: <57293844.1060802@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tom Hanson <thomas.hanson@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tom,

thanks for looking at the patches!

On 04/05/16 00:46, Tom Hanson wrote:
> On 04/28/2016 10:45 AM, Andre Przywara wrote:
> ...
>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>> index fb45537..92b78a0 100644
>> --- a/virt/kvm/arm/vgic/vgic.c
>> +++ b/virt/kvm/arm/vgic/vgic.c
>> @@ -19,8 +19,31 @@
> ... 
>> +/*
>> + * Locking order is always:
>> + *   vgic_cpu->ap_list_lock
>> + *     vgic_irq->irq_lock
>> + *
>> + * (that is, always take the ap_list_lock before the struct vgic_irq
>> lock).
>> + *
>> + * When taking more than one ap_list_lock at the same time, always
>> take the
>> + * lowest numbered VCPU's ap_list_lock first, so:
>> + *   vcpuX->vcpu_id < vcpuY->vcpu_id:
>> + *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
>> + *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
>> + */
> 
> The code would be safer and easier to maintain in the long run if there
> were functions provided which implement these 2 rules.  Something along
> the line of:
> 
>   void vgic_lock_aplist_irq(spinlock_t ap_list_lock, spinlock_t irq_lock){
>       spin_lock(ap_list_lock);
>       spin_lock(irq_lock);
>   }

The idea isn't too bad indeed.
I see that we could use that in vgic_queue_irq_unlock() and
vgic_mmio_write_sactive().
But as Marc mentioned in a conversation yesterday we will have a mixture
of wrapped locks and open coded lock sequences. See for instance
vgic_prune_ap_list(), where we have the sequence, but we can't use
vgic_lock_aplist_irq() because the IRQ lock is taken inside the loop
while the ap_list_lock is taken once outside of it.

Marc, Christoffer, what is your opinion here?

> and  (borrowing from patch 16/54):
> 
>   void vgic_lock_cpu_aplist_pair(struct kvm_vcpu *vcpu1, struct kvm_vcpu
> *vcpu2){
>       struct kvm_vcpu *vcpuA, *vcpuB;
>       /*
>        * Ensure locking order by always locking the smallest
>        * ID first.
>        */
>      if (vcpu1->vcpu_id < vcpu2->vcpu_id) {
>           vcpuA = vcpu1;
>           vcpuB = vcpu2;
>       } else {
>           vcpuA = vcpu2;
>           vcpuB = vcpu1;
>       }
> 
>       spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
>       spin_lock(&vcpuB->arch.vgic_cpu.ap_list_lock);
>   }

I am not sure this is worth it. We have exactly one user of this
sequence, so I'd rather keep it and the comments there.
Also the use case is probably confined to the core VGIC code.

Cheers,
Andre.

> 
> With, of course the matching unlock functions.
> 
> Then, as long as new code calls the correct function, the order is
> always correct.  Easy to write, easy to review.  And beats the heck out
> of chasing a deadlock at some point in the future.
> 
