From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 24/33] irqchip/gic-v3-its: Add VPE scheduling
Date: Mon, 19 Jun 2017 10:34:40 +0100
Message-ID: <bfd2a70f-4495-cc30-8745-100966ae2d0d@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
 <c5351eb6-54be-1bf1-a49e-35304e40ec6b@redhat.com>
 <dd1f709f-8d4b-69bf-eaf3-f290bfe37536@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dd1f709f-8d4b-69bf-eaf3-f290bfe37536@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shankerd@codeaurora.org, Auger Eric <eric.auger@redhat.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Coming back to this after spending too long doing something else...

On 16/03/17 21:41, Shanker Donthineni wrote:
> Hi Eric,
> 
> 
> On 03/16/2017 04:23 PM, Auger Eric wrote:
>> Hi,
>>
>> On 17/01/2017 11:20, Marc Zyngier wrote:
>>> When a VPE is scheduled to run, the corresponding redistributor must
>>> be told so, by setting VPROPBASER to the VM's property table, and
>>> VPENDBASER to the vcpu's pending table.
>>>
>>> When scheduled out, we preserve the IDAI and PendingLast bits. The
>>> latter is specially important, as it tells the hypervisor that
>>> there are pending interrupts for this vcpu.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  drivers/irqchip/irq-gic-v3-its.c   | 57 ++++++++++++++++++++++++++++++++++
>>>  include/linux/irqchip/arm-gic-v3.h | 63 ++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 120 insertions(+)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>>> index 598e25b..f918d59 100644
>>> --- a/drivers/irqchip/irq-gic-v3-its.c
>>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>>> @@ -143,6 +143,7 @@ static DEFINE_IDA(its_vpeid_ida);
>>>  
>>>  #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
>>>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>>> +#define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>>>  
>>>  static struct its_collection *dev_event_to_col(struct its_device *its_dev,
>>>  					       u32 event)
>>> @@ -2039,8 +2040,64 @@ static const struct irq_domain_ops its_domain_ops = {
>>>  	.deactivate		= its_irq_domain_deactivate,
>>>  };
>>>  
>>> +static int its_vpe_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
>>> +{
>>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>>> +	struct its_cmd_info *info = vcpu_info;
>>> +	u64 val;
>>> +
>>> +	switch (info->cmd_type) {
>>> +	case SCHEDULE_VPE:
>>> +	{
>>> +		void * __iomem vlpi_base = gic_data_rdist_vlpi_base();
>>> +
>>> +		/* Schedule the VPE */
>>> +		val  = virt_to_phys(page_address(vpe->its_vm->vprop_page)) &
>>> +			GENMASK_ULL(51, 12);
>>> +		val |= (LPI_NRBITS - 1) & GICR_VPROPBASER_IDBITS_MASK;
>>> +		val |= GICR_VPROPBASER_RaWb;
>>> +		val |= GICR_VPROPBASER_InnerShareable;
>>> +		gits_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
>>> +
>>> +		val  = virt_to_phys(page_address(vpe->vpt_page)) & GENMASK(51, 16);
>>> +		val |= GICR_VPENDBASER_WaWb;
>>> +		val |= GICR_VPENDBASER_NonShareable;
>>> +		val |= GICR_PENDBASER_PendingLast;
>> don't you want to restore the vpe->pending_last here? anyway I
>> understand this will force the HW to read the LPI pending table.
> 
> It's not a good idea to set PendLast bit always. There is no
> correctness issue but causes a huge impact on the system performance.
> No need to read pending table contents from memory if no VLPI are
> pending on vPE that is being scheduled.

Good idea or not, I don't believe you have a choice. You can be sure you
have pending VLPIs, but you cannot be sure you have none, as you can
easily race against the doorbell interrupt when entering the guest.

That's why we only use pending_last as a hint to tell the hypervisor
that the guest has a pending interrupt. You cannot use it as a hint to
the redistributor that it has no VLPIs.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
