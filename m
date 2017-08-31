From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 51/59] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Thu, 31 Aug 2017 09:19:15 +0100
Message-ID: <8b7c5a40-96b5-591f-a31f-b96fb03f507f@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-52-marc.zyngier@arm.com> <20170828181855.GM24649@cbox>
 <6d825d0f-eb99-8c9f-77f7-ab313e17a2cd@arm.com> <20170830205828.GN24522@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D231440CE9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 04:17:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OJqnOt44dEJc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Aug 2017 04:17:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF0F40C5A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Aug 2017 04:17:08 -0400 (EDT)
In-Reply-To: <20170830205828.GN24522@cbox>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/08/17 21:58, Christoffer Dall wrote:
> On Wed, Aug 30, 2017 at 04:36:06PM +0100, Marc Zyngier wrote:
>> On 28/08/17 19:18, Christoffer Dall wrote:
>>> On Mon, Jul 31, 2017 at 06:26:29PM +0100, Marc Zyngier wrote:
>>>> When a vPE is not running, a VLPI being made pending results in a
>>>> doorbell interrupt being delivered. Let's handle this interrupt
>>>> and update the pending_last flag that indicates that VLPIs are
>>>> pending. The corresponding vcpu is also kicked into action.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-v4.c | 34 ++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 34 insertions(+)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
>>>> index 534d3051a078..6af3cde6d7d4 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-v4.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-v4.c
>>>> @@ -21,6 +21,19 @@
>>>>  
>>>>  #include "vgic.h"
>>>>  
>>>> +static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
>>>> +{
>>>> +	struct kvm_vcpu *vcpu = info;
>>>> +
>>>> +	if (!kvm_vgic_vcpu_pending_irq(vcpu)) {
>>>> +		vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
>>>> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>>> +		kvm_vcpu_kick(vcpu);
>>>> +	}
>>>
>>> Can this ever fire while vgic_v4_init() is running and before te rest of
>>> the system has been properly initialized with some entertaining results
>>> to follow?  (I'm not sure if spurious doorbell non-resident vPE
>>> interrupts is a thing or not).
>>
>> It could if you only had this patch. The following patch makes sure that
>> the interrupt does not get enabled at request time, meaning it will only
>> get enabled when the vcpu will eventually block.
>>
>> And yes, spurious doorbells are a real thing. And they suck.
>>
> 
> Ah, my abilities to forward read on a patch series are quite poor.
Not quite. It indicates that the patch split is a bit wrong, and that

	irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);

should really be in this patch and not the following one.

I'll fix that as I rebase the whole thing.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
