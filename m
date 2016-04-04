From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Mon, 4 Apr 2016 10:14:38 +0100
Message-ID: <5702307E.2020304@arm.com>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-7-git-send-email-julien.grall@arm.com>
 <20160401101308.GB20224@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 537CA407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 05:13:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KSZzNoKjWafk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 05:13:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11683400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 05:13:27 -0400 (EDT)
In-Reply-To: <20160401101308.GB20224@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 01/04/2016 11:13, Christoffer Dall wrote:
> On Thu, Mar 24, 2016 at 05:53:40PM +0000, Julien Grall wrote:
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index 50e87e6..b5ed8be 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c

[...]

>> @@ -901,6 +904,39 @@ static int __init gic_validate_dist_version(void __iomem *dist_base)
>>   	return 0;
>>   }
>>
>> +static void __init gic_of_setup_kvm_info(struct device_node *node)
>> +{
>> +	int ret;
>> +	struct resource r;
>> +	u32 gicv_idx;
>> +
>> +	gic_v3_kvm_info.type = GIC_V3;
>> +
>> +	gic_v3_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
>> +	if (!gic_v3_kvm_info.maint_irq)
>> +		return;
>> +
>> +	if (of_property_read_u32(node, "#redistributor-regions",
>> +				 &gicv_idx))
>> +		gicv_idx = 1;
>> +
>> +	gicv_idx += 3;	/* Also skip GICD, GICC, GICH */
>> +	ret = of_address_to_resource(node, gicv_idx, &r);
>> +	if (!ret) {
>> +		if (!PAGE_ALIGNED(r.start))
>> +			pr_warn("GICV physical address 0x%llx not page aligned\n",
>> +				(unsigned long long)r.start);
>> +		else if (!PAGE_ALIGNED(resource_size(&r)))
>> +			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
>> +				(unsigned long long)resource_size(&r),
>> +				PAGE_SIZE);
>> +		else
>
> it seems like you're also checking the above items in the KVM code
> itself, so I still don't understand why we have to do this twice.
>
> My feeling here is that you want to just lookup if you have the proper
> resources to fill in the struct in the GIC driver, and fill in the
> struct with data if the firmware gave you something.
>
> It's then up to KVM to deal with its constraints, such as the resources
> being page-aligned etc.  But I suppose you could also argue that the GIC
> code knows how this hardware resource can or cannot be used and
> therefore should check it.
>
> But in any case, I don't understand why we check it more than one place?

Sorry, I forgot to remove these checks when I re-introduced them in the 
KVM code.

I will remove them in the next version.

Regards,

-- 
Julien Grall
