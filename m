From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Disallow Active+Pending for level
 interrupts
Date: Thu, 15 Mar 2018 14:37:18 +0100
Message-ID: <9ce9f9db-df11-6697-c3df-5af658b78a55@redhat.com>
References: <20180314183744.30889-1-marc.zyngier@arm.com>
 <c0ac2636-4143-98d3-5eb3-1e9098d0e056@redhat.com>
 <64703cb4-96c8-abd0-8e75-6e65b6721e5c@arm.com>
 <7bd9dd38-f3a6-aef4-7fcd-015ef79a49ae@redhat.com>
 <e01a6a87-d42f-bddf-be71-a4fc1b21ebf4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <e01a6a87-d42f-bddf-be71-a4fc1b21ebf4@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <Andre.Przywara@arm.com>, Christoffer Dall <cdall@kernel.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 15/03/18 11:36, Marc Zyngier wrote:
> On 15/03/18 10:24, Auger Eric wrote:
>> Hi Marc,
>>
>> On 15/03/18 11:01, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On 15/03/18 09:31, Auger Eric wrote:
>>>> Hi Marc,
>>>> On 14/03/18 19:37, Marc Zyngier wrote:
>>>>> It was recently reported that VFIO mediated devices, and anything
>>>>> that VFIO exposes as level interrupts, do no strictly follow the
>>>>> expected logic of such interrupts as it only lowers the input
>>>>> line when the guest has EOId the interrupt at the GIC level, rather
>>>>> than when it Acked the interrupt at the device level.
>>>>>
>>>>> THe GIC's Active+Pending state is fundamentally incompatible with
>>>>> this behaviour, as it prevents KVM from observing the EOI, and in
>>>>> turn results in VFIO never dropping the line. This results in an
>>>>> interrupt storm in the guest, which it really never expected.
>>>>>
>>>>> As we cannot really change VFIO to follow the strict rules of level
>>>>> signalling, let's forbid the A+P state altogether, as it is in the
>>>>> end only an optimization. It ensures that we will transition via
>>>>> an invalid state, which we can use to notify VFIO of the EOI.
>>>>>
>>>>> Reported-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
>>>>> Tested-by: Shunyong Yang <shunyong.yang@hxt-semitech.com>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  virt/kvm/arm/vgic/vgic-v2.c | 47 +++++++++++++++++++++++++++------------------
>>>>>  virt/kvm/arm/vgic/vgic-v3.c | 47 +++++++++++++++++++++++++++------------------
>>>>>  2 files changed, 56 insertions(+), 38 deletions(-)
>>>>>
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>>>>> index 29556f71b691..9356d749da1d 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>>>>> @@ -153,8 +153,35 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>>>>  void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>>>>>  {
>>>>>  	u32 val = irq->intid;
>>>>> +	bool allow_pending = true;
>>>>>  
>>>>> -	if (irq_is_pending(irq)) {
>>>>> +	if (irq->active)
>>>>> +		val |= GICH_LR_ACTIVE_BIT;
>>>>> +
>>>>> +	if (irq->hw) {
>>>>> +		val |= GICH_LR_HW;
>>>>> +		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
>>>>> +		/*
>>>>> +		 * Never set pending+active on a HW interrupt, as the
>>>>> +		 * pending state is kept at the physical distributor
>>>>> +		 * level.
>>>>> +		 */
>>>>> +		if (irq->active)
>>>>> +			allow_pending = false;
>>>>> +	} else {
>>>>> +		if (irq->config == VGIC_CONFIG_LEVEL) {
>>>>> +			val |= GICH_LR_EOI;
>>>>> +
>>>>> +			/*
>>>>> +			 * Software resampling doesn't work very well
>>>>> +			 * if we allow P+A, so let's not do that.
>>>>> +			 */
>>>>> +			if (irq->active)
>>>>> +				allow_pending = false;
>>>>> +		}
>>>>> +	}
>>>>> +
>>>>> +	if (allow_pending && irq_is_pending(irq)) {
>>>>>  		val |= GICH_LR_PENDING_BIT;
>>>> Can't we have this no luck unlikely scenario where soft_pending and LR
>>>> state A on flush? In such case, on fold we are going to reset the
>>>> pending_latch as we considered disappearance of LR P meant the
>>>> soft_pending was acked. But P now is no more logged in LR concurrently
>>>> with A.
>>>
>>> Good point. We can now only clear the latch when we're back to an
>>> invalid state. How about this (untested):
>>
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>>> index 9356d749da1d..8427586760fc 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>>> @@ -105,12 +105,9 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  
>>>  		/*
>>>  		 * Clear soft pending state when level irqs have been acked.
>>> -		 * Always regenerate the pending state.
>>>  		 */
>>> -		if (irq->config == VGIC_CONFIG_LEVEL) {
>>> -			if (!(val & GICH_LR_PENDING_BIT))
>>> -				irq->pending_latch = false;
>>> -		}
>>> +		if (irq->config == VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
>>> +			irq->pending_latch = false;
>>>  
>>>  		/*
>>>  		 * Level-triggered mapped IRQs are special because we only
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index 6b484575cafb..dd984f726805 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -96,12 +96,9 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  
>>>  		/*
>>>  		 * Clear soft pending state when level irqs have been acked.
>>> -		 * Always regenerate the pending state.
>>>  		 */
>>> -		if (irq->config == VGIC_CONFIG_LEVEL) {
>>> -			if (!(val & ICH_LR_PENDING_BIT))
>>> -				irq->pending_latch = false;
>>> -		}
>>> +		if (irq->config == VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
>>> +			irq->pending_latch = false;
>> when deactivating the IRQ, we both lower the line and remove the A state
>> at the same time. However isn't the pending_latch supposed to stay,
>> independently on the line level, as long as we don't CPENDR or handle
>> its P->A->invalid usual cycle?
> 
> That's not what we decided to implement initially. The main problem is
> that you cannot distinguish between a pending state because the line is
> high, or a pending level because the latch is high.
> 
> You effectively OR the two signals on injection. On exit, you can only
> clear the latch because you don't know which of the two inputs you
> really considered. In short, the latch is only a separate interrupt if
> it doesn't coincide with a "real" interrupt.
> 
> I believe this behaviour is consistent with what we have before this
> patch. Or am I missing something?
No I think you are right. We cannot distinguish between both sources here.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
