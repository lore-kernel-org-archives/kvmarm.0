From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 24/33] irqchip/gic-v3-its: Add VPE scheduling
Date: Mon, 19 Jun 2017 16:23:07 +0100
Message-ID: <77aad819-463b-3afa-c439-474cc15b6993@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
 <fffc9c09-47b3-2c40-4610-d266fee4f0fd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D94A640A69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:18:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wNF3uC4lurUh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jun 2017 11:18:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 814CE40A66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jun 2017 11:18:40 -0400 (EDT)
In-Reply-To: <fffc9c09-47b3-2c40-4610-d266fee4f0fd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: shankerd@codeaurora.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 14/02/17 00:13, Shanker Donthineni wrote:
> Hi Marc,
> 
> 
> On 01/17/2017 04:20 AM, Marc Zyngier wrote:
>> When a VPE is scheduled to run, the corresponding redistributor must
>> be told so, by setting VPROPBASER to the VM's property table, and
>> VPENDBASER to the vcpu's pending table.
>>
>> When scheduled out, we preserve the IDAI and PendingLast bits. The
>> latter is specially important, as it tells the hypervisor that
>> there are pending interrupts for this vcpu.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c   | 57
>> ++++++++++++++++++++++++++++++++++
>>   include/linux/irqchip/arm-gic-v3.h | 63
>> ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 120 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 598e25b..f918d59 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -143,6 +143,7 @@ static DEFINE_IDA(its_vpeid_ida);
>>   
>>   #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
>>   #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>> +#define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() +
>> SZ_128K)
>>   
>>   static struct its_collection *dev_event_to_col(struct its_device
>> *its_dev,
>>   					       u32 event)
>> @@ -2039,8 +2040,64 @@ static const struct irq_domain_ops its_domain_ops =
>> {
>>   	.deactivate		= its_irq_domain_deactivate,
>>   };
>>   
>> +static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>> +{
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +	struct its_cmd_info *info = vcpu_info;
>> +	u64 val;
>> +
>> +	switch (info->cmd_type) {
>> +	case SCHEDULE_VPE:
>> +	{
>> +		void * __iomem vlpi_base = gic_data_rdist_vlpi_base();
>> +
>> +		/* Schedule the VPE */
>> +		val  = virt_to_phys(page_address(vpe->its_vm->vprop_page))
>> &
>> +			GENMASK_ULL(51, 12);
>> +		val |= (LPI_NRBITS - 1) & GICR_VPROPBASER_IDBITS_MASK;
>> +		val |= GICR_VPROPBASER_RaWb;
>> +		val |= GICR_VPROPBASER_InnerShareable;
>> +		gits_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
>> +
>> +		val  = virt_to_phys(page_address(vpe->vpt_page)) &
>> GENMASK(51, 16);
>> +		val |= GICR_VPENDBASER_WaWb;
>> +		val |= GICR_VPENDBASER_NonShareable;
>> +		val |= GICR_PENDBASER_PendingLast;
> Why always enabling PendingLast bit? You are keeping the pending last 
> bit in vpe->pending_last but not used here.

As I mentioned separately, this is wrong. You can race against an
interrupt being delivered and tell the redist that the pending table is
empty while there is actually something there.

>> +		val |= vpe->idai ? GICR_PENDBASER_IDAI : 0;
>> +		val |= GICR_PENDBASER_Valid;
> What is the status of the virtual CPU interface (ICH_HCR_EL2.En) at the 
> time of changing vPE state to resident? I believe the GICR will start 

That's not specified yet, and left to the hypervisor to decide. Yes, I
know that this is my left hand not knowing what my right hand is doing,
but I don't want to set things in stone at this stage.

> processing a pending table immediately after setting V=1 and with valid 
> PHYS address, GICR signals a virtual IRQ to virtual CPU if it has 
> outstanding interrupts. With my understanding of GIC spec, a virtual CPU 
> interface must be enabled before setting GICR_VPENDBASERR.Valid=1. 
> Otherwise, it leads to flooded vSet and Release messages between GICR 
> and CPU interface.
> 
> You can find Vset details in section 'A.4.18 VSet (IRI)' of GIC spec.
> 
> The CPU interface must Release an interrupt, ensuring that V == 1, if it 
> cannot handle the interrupt for either of the
> following reasons:
>       The interrupt group is disabled. This includes when the VM 
> interface is disabled, that is, when
> GICH_HCR.En or ICH_HCR.En, as appropriate, is cleared to 0.

I know that. But we also need to compensate for the time it take to read
the pending table. My current plan is to write to VPENDBASER as part of
the vgic setup, and let ICH_HCR_EL2.En be flipped on the normal path.

And frankly, who gives a damn if the redistributor and cpu-if are
playing ping-pong? At this stage, interrupts are disabled and we can't
handle anything...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
