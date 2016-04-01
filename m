From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Fri, 1 Apr 2016 11:25:08 +0100
Message-ID: <56FE4C84.5040504@arm.com>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-7-git-send-email-julien.grall@arm.com>
 <20160401101308.GB20224@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A390E49B1D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 06:24:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pR80Uphh5acv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 06:24:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E36D40F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 06:24:06 -0400 (EDT)
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
To: Christoffer Dall <christoffer.dall@linaro.org>, Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On 01/04/16 11:13, Christoffer Dall wrote:
> On Thu, Mar 24, 2016 at 05:53:40PM +0000, Julien Grall wrote:
>> Fill up the recently introduced gic_kvm_info with the hardware
>> information used for virtualization.
>>
>> Signed-off-by: Julien Grall <julien.grall@arm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>
>> ---
>>     Changes in v4:
>>         - Change the flow to call gic_kvm_set_info only when all the
>>         mandatory information are valid.
>>         - Remove unecessary code in ACPI parsing (the virtual control
>>         interface doesn't exist for GICv3).
>>         - Rework commit message
>>         - Rework the ACPI support as it didn't collect hardware info for
>>         virtualization when there is more than 1 redistributor region
>>
>>     Changes in v3:
>>         - Add ACPI support
>>
>>     Changes in v2:
>>         - Use 0 rather than a negative value to know when the maintenance IRQ
>>         is not present.
>>         - Use resource for vcpu and vctrl
>> ---
>>  drivers/irqchip/irq-gic-v3.c           | 123 ++++++++++++++++++++++++++++++++-
>>  include/linux/irqchip/arm-gic-common.h |   1 +
>>  2 files changed, 123 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index 50e87e6..b5ed8be 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/slab.h>
>>  
>>  #include <linux/irqchip.h>
>> +#include <linux/irqchip/arm-gic-common.h>
>>  #include <linux/irqchip/arm-gic-v3.h>
>>  
>>  #include <asm/cputype.h>
>> @@ -56,6 +57,8 @@ struct gic_chip_data {
>>  static struct gic_chip_data gic_data __read_mostly;
>>  static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
>>  
>> +static struct gic_kvm_info gic_v3_kvm_info;
>> +
>>  #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
>>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>>  #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
>> @@ -901,6 +904,39 @@ static int __init gic_validate_dist_version(void __iomem *dist_base)
>>  	return 0;
>>  }
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

That's definitely a KVM limitation more than anything else. I had
patches to deal with that, and could revive them... So the check should
IMO only occur at the KVM level, not in the GIC driver.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
