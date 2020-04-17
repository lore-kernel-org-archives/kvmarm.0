Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E49C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 16:48:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB63120771
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 16:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB63120771
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EABA4B153;
	Fri, 17 Apr 2020 12:48:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MgaQ7UuGt4qT; Fri, 17 Apr 2020 12:48:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C614B189;
	Fri, 17 Apr 2020 12:48:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EB454B153
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 12:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jjYLEUtUIaN8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 12:48:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D30874B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 12:48:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64671C14;
 Fri, 17 Apr 2020 09:48:37 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A5553F6C4;
 Fri, 17 Apr 2020 09:48:35 -0700 (PDT)
Subject: Re: [PATCH v2 4/6] KVM: arm: vgic-v2: Only use the virtual state when
 userspace accesses pending bits
To: Marc Zyngier <maz@kernel.org>
References: <20200417083319.3066217-1-maz@kernel.org>
 <20200417083319.3066217-5-maz@kernel.org>
 <4133d5f2-ed0e-9c4a-8a66-953fb6bf6e70@arm.com> <20200417134140.0a901749@why>
From: James Morse <james.morse@arm.com>
Message-ID: <7b001ee4-0a8e-d79c-1be4-563dab4ca452@arm.com>
Date: Fri, 17 Apr 2020 17:48:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200417134140.0a901749@why>
Content-Language: en-GB
Cc: Julien Grall <julien@xen.org>, kvm@vger.kernel.org,
 Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 17/04/2020 13:41, Marc Zyngier wrote:
> On Fri, 17 Apr 2020 12:22:10 +0100 James Morse <james.morse@arm.com> wrote:
>> On 17/04/2020 09:33, Marc Zyngier wrote:
>>> There is no point in accessing the HW when writing to any of the
>>> ISPENDR/ICPENDR registers from userspace, as only the guest should
>>> be allowed to change the HW state.
>>>
>>> Introduce new userspace-specific accessors that deal solely with
>>> the virtual state. Note that the API differs from that of GICv3,
>>> where userspace exclusively uses ISPENDR to set the state. Too
>>> bad we can't reuse it.  

>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>>> index 6e30034d1464..f1927ae02d2e 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>> @@ -321,6 +321,27 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,  
>>
>>> +int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
>>> +				gpa_t addr, unsigned int len,
>>> +				unsigned long val)
>>> +{
>>> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>>> +	int i;
>>> +	unsigned long flags;
>>> +
>>> +	for_each_set_bit(i, &val, len * 8) {
>>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);  
>>
>> vgic_mmio_write_spending() has:
>> |	/* GICD_ISPENDR0 SGI bits are WI *
>>
>> and bales out early. Is GIC_DIST_PENDING_SET the same register?
>> (If so, shouldn't that be true for PPI too?)
> 
> Hmmm. It's a bit more complicated (surprisingly).
> 
> Yes, the SGI pending bits are WI from the guest perspective (as
> required by the spec).

> But we still need to be able to restore them
> from userspace, and I bet 82e40f558de56 ("KVM: arm/arm64: vgic-v2:
> Handle SGI bits in GICD_I{S,C}PENDR0 as WI") has broken migration with
> GICv2 (if you migrated with a pending SGI, you cannot restore it...).

Fun! It looks like the ioctl() would succeed, but nothing happened. Once you restart the
guest one CPU may wait forever for the victim to respond.


> Now, there is still a bug here, in the sense that we need to indicate
> which vcpu is the source of the SGI (this is a GICv2-special).
> Unfortunately, we don't have a way to communicate this architecturally.
> The only option we have is to make it up (as a self-SGI, for example).
> But this is pretty broken at the architectural level TBH.
> On the other hand, PPIs are just fine.

Yup, wrong spec, I was looking at the same register in GICv3! It looks like the GICv3 text
is there because those registers live in the redistributor instead... duh!


>>> @@ -390,6 +411,26 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,  
>>
>>> +int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
>>> +				gpa_t addr, unsigned int len,
>>> +				unsigned long val)
>>> +{
>>> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>>> +	int i;
>>> +	unsigned long flags;
>>> +
>>> +	for_each_set_bit(i, &val, len * 8) {
>>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);  
>>
>> Same dumb question about GICD_ICPENDR0!?
> 
> Not dumb at all! Given that we previously allowed this to be accessed
> from userspace (well, before we broke it again), it should be able to
> clear *something*. If we adopt the self-SGI behaviour as above, we will
> get away with it.
> 
> Here's what I'm proposing to add to this patch, together with a
> Fixes: 82e40f558de56 ("KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI")
> 
> Nobody is using GICv2, obviously... :-/

> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index f1927ae02d2e..974cdcf2f232 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c

> @@ -334,6 +322,15 @@ int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  		irq->pending_latch = true;
> +
> +		/*
> +		 * GICv2 SGIs are terribly broken. We can't restore
> +		 * the source of the interrupt, so just pick the vcpu
> +		 * itself as the source...

Makes sense, this way you can't have an SGI coming from an offline CPU!


> +		 */
> +		if (is_vgic_v2_sgi(vcpu, irq))
> +			irq->source |= BIT(vcpu->vcpu_id);
> +
>  		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>  
>  		vgic_put_irq(vcpu->kvm, irq);

> @@ -423,7 +415,22 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> -		irq->pending_latch = false;
> +		/*
> +		 * More fun with GICv2 SGIs! If we're clearing one of them
> +		 * from userspace, which source vcpu to clear?  Let's pick
> +		 * the target vcpu itself (consistent whith the way we
> +		 * populate them on the ISPENDR side), and only clear the
> +		 * pending state if no sources are left (insert expletive
> +		 * here).

But I'm not so sure about this. Doesn't this mean that user-space can't clear pending-SGI?
Only if its pending due to self-SGI. I'm not sure when user-space would want to do this,
so it may not matter.

Using ffs() you could clear the lowest pending source, I assume if its pending, there is
likely only one source. If not, user-space can eventually clear pending SGI with at most
nr-vcpu calls ... and ffs() could double up as the missing expletive!

(but if user-space never actually does this, then we should do the simplest thing)


> +		 */
> +		if (is_vgic_v2_sgi(vcpu, irq)) {
> +			irq->source &= ~BIT(vcpu->vcpu_id);
> +			if (!irq->source)
> +				irq->pending_latch = false;
> +		} else {
> +			irq->pending_latch = false;
> +		}
> +
>  		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  
>  		vgic_put_irq(vcpu->kvm, irq);

Otherwise looks good to me,


Thanks,

James

[0]
https://static.docs.arm.com/ihi0069/f/IHI0069F_gic_architecture_specification_v3_and_v4.1.pdf
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
