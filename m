From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 23/55] KVM: arm/arm64: vgic-new: Add CTLR, TYPER and
 IIDR handlers
Date: Wed, 11 May 2016 14:36:20 +0100
Message-ID: <57333554.9070908@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-24-git-send-email-andre.przywara@arm.com>
 <20160511120533.GM27623@cbox> <57332AD8.6050306@arm.com>
 <20160511131556.GR27623@cbox> <57333359.3000505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A18A49B54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:32:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QLIGnNaZJrAw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:32:53 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5E149B47
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:32:52 -0400 (EDT)
In-Reply-To: <57333359.3000505@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 11/05/16 14:27, Marc Zyngier wrote:
> On 11/05/16 14:15, Christoffer Dall wrote:
>> On Wed, May 11, 2016 at 01:51:36PM +0100, Marc Zyngier wrote:
>>> On 11/05/16 13:05, Christoffer Dall wrote:
>>>> On Fri, May 06, 2016 at 11:45:36AM +0100, Andre Przywara wrote:
>>>>> From: Marc Zyngier <marc.zyngier@arm.com>
>>>>>
>>>>> Those three registers are v2 emulation specific, so their implementation
>>>>> lives entirely in vgic-mmio-v2.c. Also they are handled in one function,
>>>>> as their implementation is pretty simple.
>>>>> When the guest enables the distributor, we kick all VCPUs to get
>>>>> potentially pending interrupts serviced.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>>> ---
>>>>> Changelog RFC..v1:
>>>>> - kick VCPUs is the distributor gets enabled
>>>>> - improve comment
>>>>>
>>>>> Changelog v1 .. v2:
>>>>> - adapt to new MMIO framework
>>>>> - use switch() statements to improve readability
>>>>>
>>>>> Changelog v2 .. v3:
>>>>> - add vgic_kick_vcpus() implementation
>>>>>
>>>>>  include/linux/irqchip/arm-gic.h  |  1 +
>>>>>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 48 +++++++++++++++++++++++++++++++++++++++-
>>>>>  virt/kvm/arm/vgic/vgic.c         | 15 +++++++++++++
>>>>>  virt/kvm/arm/vgic/vgic.h         |  4 ++++
>>>>>  4 files changed, 67 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
>>>>> index be0d26f..fd05185 100644
>>>>> --- a/include/linux/irqchip/arm-gic.h
>>>>> +++ b/include/linux/irqchip/arm-gic.h
>>>>> @@ -33,6 +33,7 @@
>>>>>  
>>>>>  #define GIC_DIST_CTRL			0x000
>>>>>  #define GIC_DIST_CTR			0x004
>>>>> +#define GIC_DIST_IIDR			0x008
>>>>>  #define GIC_DIST_IGROUP			0x080
>>>>>  #define GIC_DIST_ENABLE_SET		0x100
>>>>>  #define GIC_DIST_ENABLE_CLEAR		0x180
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>>>> index 2729a22..69e96f7 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>>>>> @@ -20,9 +20,55 @@
>>>>>  #include "vgic.h"
>>>>>  #include "vgic-mmio.h"
>>>>>  
>>>>> +static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
>>>>> +					    gpa_t addr, unsigned int len)
>>>>> +{
>>>>> +	u32 value;
>>>>> +
>>>>> +	switch (addr & 0x0c) {
>>>>> +	case GIC_DIST_CTRL:
>>>>> +		value = vcpu->kvm->arch.vgic.enabled ? GICD_ENABLE : 0;
>>>>> +		break;
>>>>> +	case GIC_DIST_CTR:
>>>>> +		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>>>>> +		value = (value >> 5) - 1;
>>>>> +		value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
>>>>> +		break;
>>>>> +	case GIC_DIST_IIDR:
>>>>> +		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
>>>>> +		break;
>>>>> +	default:
>>>>> +		return 0;
>>>>> +	}
>>>>> +
>>>>> +	return extract_bytes(value, addr & 3, len);
>>>>> +}
>>>>> +
>>>>> +static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
>>>>> +				    gpa_t addr, unsigned int len,
>>>>> +				    unsigned long val)
>>>>> +{
>>>>> +	switch (addr & 0x0c) {
>>>>> +	case GIC_DIST_CTRL:
>>>>> +		if (!(addr & 1)) {
>>>>
>>>> what is this !(addr & 1) check?
>>>
>>> We check that the write includes the lowest byte of the register. But as
>>> we only have aligned accesses, it probably doesn't matter... I'll hack
>>> that away.
>>>
>> where do we check to only have aligned accesses?
> 
> Looks like a missing feature. The v2 spec says:
> 
> 4.1.4 GIC register access
> All registers support 32-bit word accesses with the access type defined
> in Table 4-1 on page 4-73 and Table 4-2 on page 4-74.
> In addition, the GICD_IPRIORITYRn, GICD_ITARGETSRn, GICD_CPENDSGIRn, and
> GICD_SPENDSGIRn registers support byte accesses.
> 
> Similar thing for v3 (8.1.3).
> 
> By the look of it, we should add checks in all accessors. I'll get onto it.

What about to tag every register in our vgic_register_region with a
possible access width and do a generic check in
dispatch_mmio_{read,write}? Then we wouldn't need to touch every handler.

Cheers,
Andre.
