From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v8 13/17] KVM: arm64: read initial LPI pending table
Date: Tue, 12 Jul 2016 12:33:34 +0100
Message-ID: <152d1107-febf-3aa4-ab85-e6cc8c8aa840@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-14-andre.przywara@arm.com> <5783CE67.2070202@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 049C249B7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 07:27:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id glhzdFZjiCTw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jul 2016 07:27:01 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 922FB49B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jul 2016 07:27:01 -0400 (EDT)
In-Reply-To: <5783CE67.2070202@arm.com>
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

On 11/07/16 17:50, Marc Zyngier wrote:
> On 05/07/16 12:23, Andre Przywara wrote:
>> The LPI pending status for a GICv3 redistributor is held in a table
>> in (guest) memory. To achieve reasonable performance, we cache this
>> data in our struct vgic_irq. The initial pending state must be read
>> from guest memory upon enabling LPIs for this redistributor.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-its.c | 81 ++++++++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h     |  6 ++++
>>  2 files changed, 87 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> index 1e2e649..29bb4fe 100644
>> --- a/virt/kvm/arm/vgic/vgic-its.c
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -93,6 +93,81 @@ struct its_itte {
>>  		list_for_each_entry(itte, &(dev)->itt_head, itte_list)
>>  
>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
>> +#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
> 
> 52 bits again. Pick a side!
> 
>> +
>> +static int vgic_its_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
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
>> +	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry) {
>> +		if (kref_get_unless_zero(&irq->refcount)) {
>> +			intids[i] = irq->intid;
>> +			vgic_put_irq_locked(kvm, irq);
> 
> This is ugly. You know you're not going to free the irq, since it was at
> least one when you did kref_get_unless_zero(). Why not doing a simple
> kref_put (possibly in a macro so that you can hide the dummy release
> function)?

I think I don't need the get and put at all, which would allow to
totally drop the vgic_put_irq_locked version:
1) We have the lpi_list_lock, so if we find the IRQ in the list, it's
still valid (we free it only after having it removed).
2) It can't be removed without dropping the lock.
3) We just store the number, not the pointer.
4) An LPI can be unmapped anyway after we dropped the lock and before we
actually use the copy. We take care of that already by calling get again
and coping with a NULL return.

So is it feasible to remove the get and put here completely or is that
dodgy since we technically use the reference?
Shall I document that one doesn't need get and put if holding the
lpi_list_lock?

Cheers,
Andre.
