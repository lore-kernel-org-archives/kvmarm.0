From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Disallow Active+Pending for level
 interrupts
Date: Thu, 15 Mar 2018 11:24:18 +0100
Message-ID: <7bd9dd38-f3a6-aef4-7fcd-015ef79a49ae@redhat.com>
References: <20180314183744.30889-1-marc.zyngier@arm.com>
 <c0ac2636-4143-98d3-5eb3-1e9098d0e056@redhat.com>
 <64703cb4-96c8-abd0-8e75-6e65b6721e5c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BD6403FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 06:17:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6t1zsqxgNywo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 06:16:51 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9F47402D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 06:16:51 -0400 (EDT)
In-Reply-To: <64703cb4-96c8-abd0-8e75-6e65b6721e5c@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>, Shunyong Yang <shunyong.yang@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 15/03/18 11:01, Marc Zyngier wrote:
> Hi Eric,
> 
> On 15/03/18 09:31, Auger Eric wrote:
>> Hi Marc,
>> On 14/03/18 19:37, Marc Zyngier wrote:
>>> It was recently reported that VFIO mediated devices, and anything
>>> that VFIO exposes as level interrupts, do no strictly follow the
>>> expected logic of such interrupts as it only lowers the input
>>> line when the guest has EOId the interrupt at the GIC level, rather
>>> than when it Acked the interrupt at the device level.
>>>
>>> THe GIC's Active+Pending state is fundamentally incompatible with
>>> this behaviour, as it prevents KVM from observing the EOI, and in
>>> turn results in VFIO never dropping the line. This results in an
>>> interrupt storm in the guest, which it really never expected.
>>>
>>> As we cannot really change VFIO to follow the strict rules of level
>>> signalling, let's forbid the A+P state altogether, as it is in the
>>> end only an optimization. It ensures that we will transition via
>>> an invalid state, which we can use to notify VFIO of the EOI.
>>>
>>> Reported-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
>>> Tested-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-v2.c | 47 +++++++++++++++++++++++++++------------------
>>>  virt/kvm/arm/vgic/vgic-v3.c | 47 +++++++++++++++++++++++++++------------------
>>>  2 files changed, 56 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>>> index 29556f71b691..9356d749da1d 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>>> @@ -153,8 +153,35 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>>>  {
>>>  	u32 val = irq->intid;
>>> +	bool allow_pending = true;
>>>  
>>> -	if (irq_is_pending(irq)) {
>>> +	if (irq->active)
>>> +		val |= GICH_LR_ACTIVE_BIT;
>>> +
>>> +	if (irq->hw) {
>>> +		val |= GICH_LR_HW;
>>> +		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
>>> +		/*
>>> +		 * Never set pending+active on a HW interrupt, as the
>>> +		 * pending state is kept at the physical distributor
>>> +		 * level.
>>> +		 */
>>> +		if (irq->active)
>>> +			allow_pending = false;
>>> +	} else {
>>> +		if (irq->config == VGIC_CONFIG_LEVEL) {
>>> +			val |= GICH_LR_EOI;
>>> +
>>> +			/*
>>> +			 * Software resampling doesn't work very well
>>> +			 * if we allow P+A, so let's not do that.
>>> +			 */
>>> +			if (irq->active)
>>> +				allow_pending = false;
>>> +		}
>>> +	}
>>> +
>>> +	if (allow_pending && irq_is_pending(irq)) {
>>>  		val |= GICH_LR_PENDING_BIT;
>> Can't we have this no luck unlikely scenario where soft_pending and LR
>> state A on flush? In such case, on fold we are going to reset the
>> pending_latch as we considered disappearance of LR P meant the
>> soft_pending was acked. But P now is no more logged in LR concurrently
>> with A.
> 
> Good point. We can now only clear the latch when we're back to an
> invalid state. How about this (untested):

> 
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 9356d749da1d..8427586760fc 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -105,12 +105,9 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> -		 * Always regenerate the pending state.
>  		 */
> -		if (irq->config == VGIC_CONFIG_LEVEL) {
> -			if (!(val & GICH_LR_PENDING_BIT))
> -				irq->pending_latch = false;
> -		}
> +		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
> +			irq->pending_latch = false;
>  
>  		/*
>  		 * Level-triggered mapped IRQs are special because we only
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 6b484575cafb..dd984f726805 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -96,12 +96,9 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>  
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> -		 * Always regenerate the pending state.
>  		 */
> -		if (irq->config == VGIC_CONFIG_LEVEL) {
> -			if (!(val & ICH_LR_PENDING_BIT))
> -				irq->pending_latch = false;
> -		}
> +		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
> +			irq->pending_latch = false;
when deactivating the IRQ, we both lower the line and remove the A state
at the same time. However isn't the pending_latch supposed to stay,
independently on the line level, as long as we don't CPENDR or handle
its P->A->invalid usual cycle?

Thanks

Eric
>  
>  		/*
>  		 * Level-triggered mapped IRQs are special because we only
> 
> Thanks,
> 
> 	M.
> 
