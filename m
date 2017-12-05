From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 6/8] KVM: arm/arm64: Support VGIC dist pend/active
 changes for mapped IRQs
Date: Tue, 5 Dec 2017 16:47:46 +0000
Message-ID: <3cd51419-cd43-998d-f801-407b805eb9a2@arm.com>
References: <20171204200506.3224-1-cdall@kernel.org>
 <20171204200506.3224-7-cdall@kernel.org>
 <20171205150328.gcwnt5jzmoarvetd@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3128D49D20
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 11:44:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wI3b09MeAzqz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Dec 2017 11:44:41 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4BF440EA6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 11:44:41 -0500 (EST)
In-Reply-To: <20171205150328.gcwnt5jzmoarvetd@yury-thinkpad>
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
To: Yury Norov <ynorov@caviumnetworks.com>, Christoffer Dall <cdall@kernel.org>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 05/12/17 15:03, Yury Norov wrote:
> On Mon, Dec 04, 2017 at 09:05:04PM +0100, Christoffer Dall wrote:
>> From: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> For mapped IRQs (with the HW bit set in the LR) we have to follow some
>> rules of the architecture.  One of these rules is that VM must not be
>> allowed to deactivate a virtual interrupt with the HW bit set unless the
>> physical interrupt is also active.
>>
>> This works fine when injecting mapped interrupts, because we leave it up
>> to the injector to either set EOImode==1 or manually set the active
>> state of the physical interrupt.
>>
>> However, the guest can set virtual interrupt to be pending or active by
>> writing to the virtual distributor, which could lead to deactivating a
>> virtual interrupt with the HW bit set without the physical interrupt
>> being active.
>>
>> We could set the physical interrupt to active whenever we are about to
>> enter the VM with a HW interrupt either pending or active, but that
>> would be really slow, especially on GICv2.  So we take the long way
>> around and do the hard work when needed, which is expected to be
>> extremely rare.
>>
>> When the VM sets the pending state for a HW interrupt on the virtual
>> distributor we set the active state on the physical distributor, because
>> the virtual interrupt can become active and then the guest can
>> deactivate it.
>>
>> When the VM clears the pending state we also clear it on the physical
>> side, because the injector might otherwise raise the interrupt.  We also
>> clear the physical active state when the virtual interrupt is not
>> active, since otherwise a SPEND/CPEND sequence from the guest would
>> prevent signaling of future interrupts.
>>
>> Changing the state of mapped interrupts from userspace is not supported,
>> and it's expected that userspace unmaps devices from VFIO before
>> attempting to set the interrupt state, because the interrupt state is
>> driven by hardware.
>>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>>  virt/kvm/arm/vgic/vgic-mmio.c | 71 +++++++++++++++++++++++++++++++++++++++----
>>  virt/kvm/arm/vgic/vgic.c      |  7 +++++
>>  virt/kvm/arm/vgic/vgic.h      |  1 +
>>  3 files changed, 73 insertions(+), 6 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index 747b0a3b4784..8d173d99a7a4 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/kvm.h>
>>  #include <linux/kvm_host.h>
>>  #include <kvm/iodev.h>
>> +#include <kvm/arm_arch_timer.h>
>>  #include <kvm/arm_vgic.h>
>>  
>>  #include "vgic.h"
>> @@ -143,10 +144,22 @@ static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
>>  	return vcpu;
>>  }
>>  
>> +/* Must be called with irq->irq_lock held */
> 
> Instead of enforcing this rule in comment, you can enforce it in code:
> 
> BUG_ON(!spin_is_locked(irq->irq_lock))

Are we going to litter the kernel with such assertions? I don't think
that's a valuable thing to do.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
