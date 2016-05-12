From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 36/55] KVM: arm/arm64: vgic-new: Add GICv3 IROUTER
 register handlers
Date: Thu, 12 May 2016 15:00:47 +0100
Message-ID: <57348C8F.6080409@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-37-git-send-email-andre.przywara@arm.com>
 <20160512122119.GH27623@cbox> <57347925.2030902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA4A49B30
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 09:57:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6-supf-fGLG1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 May 2016 09:57:17 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B7949B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 May 2016 09:57:17 -0400 (EDT)
In-Reply-To: <57347925.2030902@arm.com>
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

On 12/05/16 13:37, Marc Zyngier wrote:
> On 12/05/16 13:21, Christoffer Dall wrote:
>> On Fri, May 06, 2016 at 11:45:49AM +0100, Andre Przywara wrote:
>>> Since GICv3 supports much more than the 8 CPUs the GICv2 ITARGETSR
>>> register can handle, the new IROUTER register covers the whole range
>>> of possible target (V)CPUs by using the same MPIDR that the cores
>>> report themselves.
>>> In addition to translating this MPIDR into a vcpu pointer we store
>>> the originally written value as well. The architecture allows to
>>> write any values into the register, which must be read back as written.
>>>
>>> Since we don't support affinity level 3, we don't need to take care
>>> about the upper word of this 64-bit register, which simplifies the
>>> handling a bit.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>> Changelog RFC..v1:
>>> - fold in and simplify vgic_v3_irq_change_affinity
>>>
>>> Changelog v1 .. v2:
>>> - adapt to new MMIO framework
>>>
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 65 +++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 64 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> index 48fba9c..3bcc2c4 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -86,6 +86,69 @@ static u32 compress_mpidr(unsigned long mpidr)
>>>  	return ret;
>>>  }
>>>  
>>> +static unsigned long decompress_mpidr(u32 value)
>>> +{
>>> +	unsigned long mpidr;
>>> +
>>> +	mpidr  = ((value >>  0) & 0xFF) << MPIDR_LEVEL_SHIFT(0);
>>> +	mpidr |= ((value >>  8) & 0xFF) << MPIDR_LEVEL_SHIFT(1);
>>> +	mpidr |= ((value >> 16) & 0xFF) << MPIDR_LEVEL_SHIFT(2);
>>> +	mpidr |= (u64)((value >> 24) & 0xFF) << MPIDR_LEVEL_SHIFT(3);
>>> +
>>> +	return mpidr;
>>> +}
>>> +
>>> +static unsigned long vgic_mmio_read_irouter(struct kvm_vcpu *vcpu,
>>> +					    gpa_t addr, unsigned int len)
>>> +{
>>> +	int intid = (addr & 0x1fff) / 8;
>>> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
>>> +	unsigned long mpidr;
>>> +
>>> +	if (!irq)
>>> +		return 0;
>>> +
>>> +	mpidr = decompress_mpidr(irq->mpidr);
>>
>> I'm unsure here; do we ned a READ_ONCE() in lieu taking the lock or are
>> we guaranteed that this is a single memory access even with compiler
>> inlining etc.?
> 
> I can't imagine the compiler being stupid enough to read this multiple
> times, but better safe than sorry. +1 for READ_ONCE().
> 
>>
>>> +	return extract_bytes(mpidr, addr & 7, len);
>>> +}
>>> +
>>> +static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>> +				    gpa_t addr, unsigned int len,
>>> +				    unsigned long val)
>>> +{
>>> +	int intid = (addr & 0x1fff) / 8;
>>> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid);
>>> +	unsigned long mask = 0xffffffff;	/* upper word is WI */
>>> +	u64 mpidr;
>>> +
>>> +	if (!irq)
>>> +		return;
>>> +
>>> +	/*
>>> +	 * There are only two supported options:
>>> +	 * (1) aligned 64-bit access
>>> +	 * (2) aligned 32-bit access
>>> +	 *
>>> +	 * TODO: make this check generic and move it to dispatch_...()
>>> +	 */
>>> +	if (len != 4 && len != 8)
>>> +		return;
>>> +
>>> +
>>> +	/* The upper word is WI for us since we don't implement Aff3. */
>>> +	if (addr & 4)
>>> +		return;
>>> +
>>> +	spin_lock(&irq->irq_lock);
>>> +
>>> +	mpidr = decompress_mpidr(irq->mpidr);
>>> +	mpidr = (mpidr & ~mask) | (val & mask);
>>> +	irq->mpidr = compress_mpidr(mpidr);
>>> +	irq->target_vcpu = kvm_mpidr_to_vcpu(vcpu->kvm, mpidr);
>>
>> this is weird because it doesn't preserve read-as-written semantics but
>> allows a guest to write something into the RES0 field and read that back
>> in the Aff3 field...

Technically Aff3 is not RES0, even if the A3V bit is cleared.
The A3V bit just disables Aff3 on the CPU interface side, specifically
for ICC_SGI0R_EL1 & friends.
I think we agreed some time ago that we have to support read-as-written
for this register and don't forward this IRQ if the MPIDR is not valid,
as the spec demands.

> I don't see how we get this RES0/Aff3 mixup, but I can see other issues:
> 
>>> +	unsigned long mask = 0xffffffff;	/* upper word is WI */
> 
> followed by:
> 
>>> +	mpidr = (mpidr & ~mask) | (val & mask);
> 
> is not going to preserve the top bits on 32bit (assuming we could
> perform a 64bit access on 32bit, but still).

Which would be fixed by making mask a u64?

> Also, the mask preserves
> the IRM bit, which is wrong (we don't support 1-of-n distribution).

Agreed on this.

> 
> Why don't we just have
> 
> 	mpidr = val & GENMASK_ULL(23, 0);
> 
> and let's be done with it? I must be missing something about this whole
> Aff3 thing...

Well, this would be a simple solution if we don't have to preserve bogus
MPIDRs.
The spec is a bit vague here:
"For each interrupt, a GIC implementation might support fewer than 256
values for an affinity level. In this case, some bits of the
corresponding affinity level field might be RO."

Not sure if this can apply to _all_ bits of an affinity level or not.

I think the key question is: do we need to preserve any MPIDR value
written into this register?

Cheers,
Andre.
