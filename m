From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v9 13/17] KVM: arm64: read initial LPI pending table
Date: Thu, 14 Jul 2016 11:16:11 +0100
Message-ID: <f8d720a5-0afe-cd3b-6d33-5ec1addd5bf4@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-14-andre.przywara@arm.com> <57875C92.7000004@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2F649B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 06:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YkaeI0xV706b for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2016 06:09:33 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB5D49B1A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2016 06:09:32 -0400 (EDT)
In-Reply-To: <57875C92.7000004@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 14/07/16 10:34, Marc Zyngier wrote:
> On 13/07/16 02:59, Andre Przywara wrote:
>> The LPI pending status for a GICv3 redistributor is held in a table
>> in (guest) memory. To achieve reasonable performance, we cache the
>> pending bit in our struct vgic_irq. The initial pending state must be
>> read from guest memory upon enabling LPIs for this redistributor.
>> As we can't access the guest memory while we hold the lpi_list spinlock,
>> we create a snapshot of the LPI list and iterate over that.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 91 ++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h     |  6 +++
>>  2 files changed, 97 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 4fc830c..f400ef1 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -63,6 +63,90 @@ struct its_itte {
>>  };
>>  
>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>> +#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
>> +
>> +/*
>> + * Create a snapshot of the current LPI list, so that we can enumerate all
>> + * LPIs without holding any lock.
>> + * Returns the array length and puts the kmalloc'ed array into intid_ptr.
>> + */
>> +static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +	struct vgic_irq *irq;
>> +	u32 *intids;
>> +	int irq_count = dist->lpi_list_count, i = 0;
>> +
>> +	/*
>> +	 * We use the current value of the list length, which may change
>> +	 * after the kmalloc. We don't care, because the guest shouldn't
>> +	 * change anything while the command handling is still running,
>> +	 * and in the worst case we would miss a new IRQ, which one wouldn't
>> +	 * expect to be covered by this command anyway.
>> +	 */
>> +	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL);
>> +	if (!intids)
>> +		return -ENOMEM;
>> +
>> +	spin_lock(&dist->lpi_list_lock);
>> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>> +		/* We don't need to "get" the IRQ, as we hold the list lock. */
>> +		intids[i] = irq->intid;
>> +		if (i++ == irq_count)
>> +			break;
> 
> So I can perfectly rewrite this as:
> 
> 		if (i == irq_count)
> 			break;
> 		i++;
> 
> Do you now see the bug and how you are performing out of bound accesses?

Ouch!

> 
>> +	}
>> +	spin_unlock(&dist->lpi_list_lock);
>> +
>> +	*intid_ptr = intids;
>> +	return irq_count;
>> +}
>> +
>> +/*
>> + * Scan the whole LPI pending table and sync the pending bit in there
>> + * with our own data structures. This relies on the LPI being
>> + * mapped before.
>> + */
>> +static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>> +{
>> +	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
>> +	struct vgic_irq *irq;
>> +	u8 pendmask;
>> +	int ret = 0;
>> +	u32 *intids;
>> +	int nr_irqs, i;
>> +
>> +	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, &intids);
>> +	if (nr_irqs < 0)
>> +		return nr_irqs;
>> +
>> +	for (i = 0; i < nr_irqs; i++) {
>> +		int byte_offset, bit_nr;
>> +		int last_byte_offset = -1;
> 
> Nice try. But by keeping the last_byte_offset inside the loop, you've
> made sure that it is reset to -1 on each iteration. Wall <- head.

Ouch again.

Thanks for catching those! Fixed.

Cheers,
Andre.
