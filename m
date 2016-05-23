From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3/7] KVM: arm/arm64: vgic-v2: Always resample level
 interrupts
Date: Mon, 23 May 2016 15:41:42 +0100
Message-ID: <574316A6.8030305@arm.com>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
 <1464007023-11736-4-git-send-email-marc.zyngier@arm.com>
 <20160523141937.GA9625@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160523141937.GA9625@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 23/05/16 15:19, Christoffer Dall wrote:
> On Mon, May 23, 2016 at 01:36:59PM +0100, Marc Zyngier wrote:
>> When reading back from the list registers, we need to perform
>> two actions for level interrupts:
>> 1) clear the soft-pending bit if the interrupt is not pending
>>    anymore *in the list register*
>> 2) resample the line level and propagate it to the pending state
>>
>> But these two actions linked, and we should *always* resample
> 
> were linked?

Indeed.

> 
>> the line level, no matter what state is in the list register.
>> Otherwise, we may end-up injecting spurious interrupts that
>> have been already retired.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-v2.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
>> index 8ad42c2..f659af0 100644
>> --- a/virt/kvm/arm/vgic/vgic-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
>> @@ -112,10 +112,13 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>  			}
>>  		}
>>  
>> -		/* Clear soft pending state when level IRQs have been acked */
>> -		if (irq->config == VGIC_CONFIG_LEVEL &&
>> -		    !(val & GICH_LR_PENDING_BIT)) {
>> -			irq->soft_pending = false;
>> +		/*
>> +		 * Clear soft pending state when level irqs have been acked.
>> +		 * Always resample the line level.
>> +		 */
>> +		if (irq->config == VGIC_CONFIG_LEVEL) {
>> +			if (!(val & GICH_LR_PENDING_BIT))
>> +				irq->soft_pending = false;
>>  			irq->pending = irq->line_level;
> 
> shouldn't this context line then be:
> 	irq->pending = irq->line_level || irq->soft_pending;  ??

Yes, you're right. The only case we discard the soft-pending bit is when
we know for sure that the interrupt has transitioned from pending to active.

I'll update the two patches and repost once the rest of the series has
been reviewed.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
