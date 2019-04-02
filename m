From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic-v3: Retire pending interrupts on
 disabling LPIs
Date: Tue, 2 Apr 2019 14:42:23 +0200
Message-ID: <28fa0f42-f2f6-55cd-518a-bb73d1e750c5@redhat.com>
References: <20190402072431.29389-1-marc.zyngier@arm.com>
 <6ccb354f-9482-a7eb-46aa-53bf79b67299@redhat.com>
 <867ecc6bdh.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05FE44A332
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 08:42:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XUMW6wM3voVA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Apr 2019 08:42:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B0114A32E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 08:42:27 -0400 (EDT)
In-Reply-To: <867ecc6bdh.wl-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 4/2/19 10:48 AM, Marc Zyngier wrote:
> On Tue, 02 Apr 2019 09:22:29 +0100,
> Auger Eric <eric.auger@redhat.com> wrote:
>>
>> Hi Marc,
>>
>> On 4/2/19 9:24 AM, Marc Zyngier wrote:
>>> When disabling LPIs (for example on reset) at the redistributor
>>> level, it is expected that LPIs that was pending in the CPU
>>> interface are eventually retired.
>>>
>>> Currently, this is not what is happening, and these LPIs will
>>> stay in the ap_list, eventually being acknowledged by the vcpu
>>> (which didn't quite expect this behaviour).
>>>
>>> The fix is thus to retire these LPIs from the list of pending
>>> interrupts as we disable LPIs.
>>>
>>> Reported-by: Heyi Guo <guoheyi@huawei.com>
>>> Fixes: 0e4e82f154e3 ("KVM: arm64: vgic-its: Enable ITS emulation as a virtual MSI controller")
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>> Heyi,
>>>
>>> Can you please give this alternative patch a go on your setup?
>>> This should be a much better fit than my original hack.
>>>
>>> Thanks,
>>>
>>>         M.
>>>
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 +++
>>>  virt/kvm/arm/vgic/vgic.c         | 24 ++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h         |  1 +
>>>  3 files changed, 28 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index 4a12322bf7df..9f4843fe9cda 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -200,6 +200,9 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>>>  
>>>  	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
>>>  
>>> +	if (was_enabled && !vgic_cpu->lpis_enabled)
>>> +		vgic_flush_pending_lpis(vcpu);
>>> +
>>>  	if (!was_enabled && vgic_cpu->lpis_enabled)
>>>  		vgic_enable_lpis(vcpu);
>>>  }
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index 3af69f2a3866..3f429cf2f694 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -151,6 +151,30 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>>>  	kfree(irq);
>>>  }
>>>  
>>> +void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>> +	struct vgic_irq *irq, *tmp;
>>> +	unsigned long flags;
>>> +
>>> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
>> Do you need to hold the lpi_list_lock here as it is taken in vgic_put_irq.
> 
> You're right, this is absolutely silly, as it violates the rules at
> the top of this very file. Don't write that kind of patches while
> being severely jet-lagged. It should be better with this on top.
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 3f429cf2f694..191deccf60bf 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -153,13 +153,11 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  
>  void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  {
> -	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  	struct vgic_irq *irq, *tmp;
>  	unsigned long flags;
>  
> -	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> -	raw_spin_lock(&vgic_cpu->ap_list_lock);
> +	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
>  
>  	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>  		if (irq->intid >= VGIC_MIN_LPI) {
> @@ -171,8 +169,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	raw_spin_unlock(&vgic_cpu->ap_list_lock);
> -	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> +	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
>  }
>  
>  void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
> 
> 
>>> +	raw_spin_lock(&vgic_cpu->ap_list_lock);
>>> +
>>> +	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
>>> +		if (irq->intid >= VGIC_MIN_LPI) {
>>> +			raw_spin_lock(&irq->irq_lock);
>>> +			list_del(&irq->ap_list);
>>> +			irq->vcpu = NULL;
>>> +			raw_spin_unlock(&irq->irq_lock);
>>> +			vgic_put_irq(vcpu->kvm, irq);
>>> +		}
>>> +	}
>>> +
>>> +	raw_spin_unlock(&vgic_cpu->ap_list_lock);
>>> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
>> A concern I have is how does this live with
>> vgic_v3_save_pending_tables/its_sync_lpi_pending_table ctrl flow. I need
>> to trace things.
> 
> It shouldn't change a thing. The only thing this patch tries to do is
> to make sure that LPIs are not kept on the ap_list when they have been
> turned off at the redistributor level. The pending bits are still
> stored, and save/sync should work as expected (famous last words...).

Yes my concerns have gone away now :-)

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
