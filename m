From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 6/8] KVM: arm/arm64: Support VGIC dist pend/active
 changes for mapped IRQs
Date: Wed, 6 Dec 2017 08:56:36 +0000
Message-ID: <1e0b036a-2319-012a-6669-7974e153b9a5@arm.com>
References: <20171204200506.3224-1-cdall@kernel.org>
 <20171204200506.3224-7-cdall@kernel.org>
 <20171205150328.gcwnt5jzmoarvetd@yury-thinkpad>
 <3cd51419-cd43-998d-f801-407b805eb9a2@arm.com>
 <20171205223900.znmruf3pfpg3pvqa@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9DC540795
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 03:53:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 48-BWI4tw2pM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 03:53:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68670406D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 03:53:27 -0500 (EST)
In-Reply-To: <20171205223900.znmruf3pfpg3pvqa@yury-thinkpad>
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
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/12/17 22:39, Yury Norov wrote:
> On Tue, Dec 05, 2017 at 04:47:46PM +0000, Marc Zyngier wrote:
>> On 05/12/17 15:03, Yury Norov wrote:
>>> On Mon, Dec 04, 2017 at 09:05:04PM +0100, Christoffer Dall wrote:
>>>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>>>
>>>> For mapped IRQs (with the HW bit set in the LR) we have to follow some
>>>> rules of the architecture.  One of these rules is that VM must not be
>>>> allowed to deactivate a virtual interrupt with the HW bit set unless the
>>>> physical interrupt is also active.
>>>>
>>>> This works fine when injecting mapped interrupts, because we leave it up
>>>> to the injector to either set EOImode==1 or manually set the active
>>>> state of the physical interrupt.
>>>>
>>>> However, the guest can set virtual interrupt to be pending or active by
>>>> writing to the virtual distributor, which could lead to deactivating a
>>>> virtual interrupt with the HW bit set without the physical interrupt
>>>> being active.
>>>>
>>>> We could set the physical interrupt to active whenever we are about to
>>>> enter the VM with a HW interrupt either pending or active, but that
>>>> would be really slow, especially on GICv2.  So we take the long way
>>>> around and do the hard work when needed, which is expected to be
>>>> extremely rare.
>>>>
>>>> When the VM sets the pending state for a HW interrupt on the virtual
>>>> distributor we set the active state on the physical distributor, because
>>>> the virtual interrupt can become active and then the guest can
>>>> deactivate it.
>>>>
>>>> When the VM clears the pending state we also clear it on the physical
>>>> side, because the injector might otherwise raise the interrupt.  We also
>>>> clear the physical active state when the virtual interrupt is not
>>>> active, since otherwise a SPEND/CPEND sequence from the guest would
>>>> prevent signaling of future interrupts.
>>>>
>>>> Changing the state of mapped interrupts from userspace is not supported,
>>>> and it's expected that userspace unmaps devices from VFIO before
>>>> attempting to set the interrupt state, because the interrupt state is
>>>> driven by hardware.
>>>>
>>>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-mmio.c | 71 +++++++++++++++++++++++++++++++++++++++----
>>>>  virt/kvm/arm/vgic/vgic.c      |  7 +++++
>>>>  virt/kvm/arm/vgic/vgic.h      |  1 +
>>>>  3 files changed, 73 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>>>> index 747b0a3b4784..8d173d99a7a4 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>>> @@ -16,6 +16,7 @@
>>>>  #include <linux/kvm.h>
>>>>  #include <linux/kvm_host.h>
>>>>  #include <kvm/iodev.h>
>>>> +#include <kvm/arm_arch_timer.h>
>>>>  #include <kvm/arm_vgic.h>
>>>>  
>>>>  #include "vgic.h"
>>>> @@ -143,10 +144,22 @@ static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
>>>>  	return vcpu;
>>>>  }
>>>>  
>>>> +/* Must be called with irq->irq_lock held */
>>>
>>> Instead of enforcing this rule in comment, you can enforce it in code:
>>>
>>> BUG_ON(!spin_is_locked(irq->irq_lock))
>>
>> Are we going to litter the kernel with such assertions? I don't think
>> that's a valuable thing to do.
> 
> That's what I agree - BUG-ifiyng is somewhat debugging technique and
> should be avoided in release code. But as I can see, in kvm code BUG()s
> are widely used:
> $ find . -name "*.c" | xargs grep -w 'BUG\|BUG_ON' | grep kvm | wc -l
> 155
> 
> So I tuned my littering detector. :)
> 
> In this patchset new BUG()s are added in patches 4 and 6. In patch 6
> BUG() has meaning of TODO:
> 
> +       if (vintid == vcpu_vtimer(vcpu)->irq.irq)
> +               timer = vcpu_vtimer(vcpu);
> +       else
> +               BUG(); /* We only map the vtimer so far */
> +
> 
> Which is far from original purpose of BUG().
> 
> If you think that BUG() is not OK in this case (and I agree with it),
> I think they should be also removed from patches 4 and 6. 6 - for sure.
There is a small, but important difference here. Your earlier suggestion
had the implication that we should check for the irq->irq_lock on all
code paths, as there is no point in only checking it in a single
function. That assertion must be true in a lot of places in the vgic
code, including places that are on the fast path.

This would turn the code into a pretty horrible mess, and bring very
little to the table (unless you consider slowing down your system to be
a feature). Also, we have better ways of detecting locking issues, such
as lockdep.

On the other hand, the BUG you quote above check for a condition that
only makes sense in this particular function.

So I'd suggest that instead of blindly counting the number of assertion,
you look at whether that makes sense at that particular point. Yes, we
probably have too many BUG_ONs, and we usually weed them after gaining
some confidence that the code is sane. For new code, a BUG_ON is a very
reassuring point that we don't hit anything unexpected.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
