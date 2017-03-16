From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [RFC PATCH 24/33] irqchip/gic-v3-its: Add VPE scheduling
Date: Thu, 16 Mar 2017 16:41:14 -0500
Message-ID: <dd1f709f-8d4b-69bf-eaf3-f290bfe37536@codeaurora.org>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
 <1484648454-21216-25-git-send-email-marc.zyngier@arm.com>
 <c5351eb6-54be-1bf1-a49e-35304e40ec6b@redhat.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1715940B5B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 17:39:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BMQhiNyxzDSj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 17:39:40 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 037D940B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 17:39:39 -0400 (EDT)
In-Reply-To: <c5351eb6-54be-1bf1-a49e-35304e40ec6b@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,


On 03/16/2017 04:23 PM, Auger Eric wrote:
> Hi,
>
> On 17/01/2017 11:20, Marc Zyngier wrote:
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
>>  drivers/irqchip/irq-gic-v3-its.c   | 57 ++++++++++++++++++++++++++++++++++
>>  include/linux/irqchip/arm-gic-v3.h | 63 ++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 120 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 598e25b..f918d59 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -143,6 +143,7 @@ static DEFINE_IDA(its_vpeid_ida);
>>  
>>  #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
>>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>> +#define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>>  
>>  static struct its_collection *dev_event_to_col(struct its_device *its_dev,
>>  					       u32 event)
>> @@ -2039,8 +2040,64 @@ static const struct irq_domain_ops its_domain_ops = {
>>  	.deactivate		= its_irq_domain_deactivate,
>>  };
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
>> +		val  = virt_to_phys(page_address(vpe->its_vm->vprop_page)) &
>> +			GENMASK_ULL(51, 12);
>> +		val |= (LPI_NRBITS - 1) & GICR_VPROPBASER_IDBITS_MASK;
>> +		val |= GICR_VPROPBASER_RaWb;
>> +		val |= GICR_VPROPBASER_InnerShareable;
>> +		gits_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
>> +
>> +		val  = virt_to_phys(page_address(vpe->vpt_page)) & GENMASK(51, 16);
>> +		val |= GICR_VPENDBASER_WaWb;
>> +		val |= GICR_VPENDBASER_NonShareable;
>> +		val |= GICR_PENDBASER_PendingLast;
> don't you want to restore the vpe->pending_last here? anyway I
> understand this will force the HW to read the LPI pending table.

It's not a good idea to set PendLast bit always. There is no correctness issue but causes a huge impact on the system performance. No need to read pending table contents from memory if no VLPI are pending on vPE that is being scheduled.

> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>
> Eric
>
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
