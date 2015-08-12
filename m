From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/6] irqchip: GIC: Convert to EOImode == 1
Date: Wed, 12 Aug 2015 14:31:47 +0100
Message-ID: <55CB4AC3.6040400@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
 <1436447951-22357-3-git-send-email-marc.zyngier@arm.com>
 <55C9BD24.10708@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A6A5ABF4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 09:18:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NCgVLcl4PM4h for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Aug 2015 09:18:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE7E25ABE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Aug 2015 09:18:44 -0400 (EDT)
In-Reply-To: <55C9BD24.10708@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Jiang Liu <jiang.liu@linux.intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 11/08/15 10:15, Eric Auger wrote:
> Hi Marc,
> On 07/09/2015 03:19 PM, Marc Zyngier wrote:
>> So far, GICv2 has been used in with EOImode == 0. The effect of this
>> mode is to perform the priority drop and the deactivation of the
>> interrupt at the same time.
>>
>> While this works perfectly for Linux (we only have a single priority),
>> it causes issues when an interrupt is forwarded to a guest, and when
>> we want the guest to perform the EOI itself.
>>
>> For this case, the GIC architecture provides EOImode == 1, where:
>> - A write to the EOI register drops the priority of the interrupt and leaves
>> it active. Other interrupts at the same priority level can now be taken,
>> but the active interrupt cannot be taken again
>> - A write to the DIR marks the interrupt as inactive, meaning it can
>> now be taken again.
>>
>> We only enable this feature when booted in HYP mode and that
>> the device-tree reporte
> reported
>  a suitable CPU interface. Observable behaviour
>> should remain unchanged.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic.c       | 32 +++++++++++++++++++++++++++++---
>>  include/linux/irqchip/arm-gic.h |  4 ++++
>>  2 files changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 8d7e1c8..e264675 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -46,6 +46,7 @@
>>  #include <asm/irq.h>
>>  #include <asm/exception.h>
>>  #include <asm/smp_plat.h>
>> +#include <asm/virt.h>
>>  
>>  #include "irq-gic-common.h"
>>  #include "irqchip.h"
>> @@ -82,6 +83,8 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>>  #define NR_GIC_CPU_IF 8
>>  static u8 gic_cpu_map[NR_GIC_CPU_IF] __read_mostly;
>>  
>> +static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
>> +
>>  #ifndef MAX_GIC_NR
>>  #define MAX_GIC_NR	1
>>  #endif
>> @@ -164,7 +167,10 @@ static void gic_unmask_irq(struct irq_data *d)
>>  
>>  static void gic_eoi_irq(struct irq_data *d)
>>  {
>> -	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
>> +	if (static_key_true(&supports_deactivate))
>> +		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
>> +	else
>> +		writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
>>  }
>>  
>>  static int gic_irq_set_irqchip_state(struct irq_data *d,
>> @@ -272,11 +278,15 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>>  		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
>>  
>>  		if (likely(irqnr > 15 && irqnr < 1021)) {
> shouldn't we have < 1020?

Looks like you have unearthed a very long standing (though not fatal)
bug - I can trace it back to 2005 and the inclusion of the Realview
support (see include/asm-arm/arch-realview/entry-macro.S in 8ad68bbf for
the details).

It may be that the original GIC didn't make number 1020 a special one,
though the earliest spec I have access to (GICv1) is already making 1020
a reserved interrupt number. And looking at the pre-existing code
(arch/arm/common/gic.c), 1020 seems to already be considered an invalid
number.

CC-ing Catalin, as he was the one who introduced it... ;-) Unless he
says otherwise, I'll cook a patch for that.

>> +			if (static_key_true(&supports_deactivate))
>> +				writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
>>  			handle_domain_irq(gic->domain, irqnr, regs);
> why don't we handle the returned value of handle_domain_irq as we do in
> GICv3?

Because I wrote the GICv3 code with my paranoia hat on... This really
should never fail.

>>  			continue;
>>  		}
>>  		if (irqnr < 16) {
>>  			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
>> +			if (static_key_true(&supports_deactivate))
>> +				writel_relaxed(irqstat, cpu_base + GIC_CPU_DEACTIVATE);
>>  #ifdef CONFIG_SMP
>>  			handle_IPI(irqnr, regs);
>>  #endif
>> @@ -358,7 +368,11 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
>>  static void gic_cpu_if_up(void)
>>  {
>>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
>> -	u32 bypass = 0;
>> +	u32 bypass;
>> +	u32 mode = 0;
>> +
>> +	if (static_key_true(&supports_deactivate))
>> +		mode = GIC_CPU_CTRL_EOImodeNS;
>>  
>>  	/*
>>  	* Preserve bypass disable bits to be written back later
>> @@ -366,7 +380,7 @@ static void gic_cpu_if_up(void)
>>  	bypass = readl(cpu_base + GIC_CPU_CTRL);
>>  	bypass &= GICC_DIS_BYPASS_MASK;
>>  
>> -	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
>> +	writel_relaxed(bypass | mode | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
>>  }
>>  
>>  
>> @@ -986,6 +1000,9 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>>  		register_cpu_notifier(&gic_cpu_notifier);
>>  #endif
>>  		set_handle_irq(gic_handle_irq);
>> +		pr_info ("GIC: Using EOImode == %d\n",
>> +			 static_key_true(&supports_deactivate));
>> +
>>  	}
>>  
>>  	gic_dist_init(gic);
>> @@ -1001,6 +1018,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>>  {
>>  	void __iomem *cpu_base;
>>  	void __iomem *dist_base;
>> +	struct resource cpu_res;
>>  	u32 percpu_offset;
>>  	int irq;
>>  
>> @@ -1013,6 +1031,11 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>>  	cpu_base = of_iomap(node, 1);
>>  	WARN(!cpu_base, "unable to map gic cpu registers\n");
>>  
>> +	of_address_to_resource(node, 1, &cpu_res);
>> +	if (!gic_cnt &&
>> +	    (!is_hyp_mode_available() || resource_size(&cpu_res) < SZ_8K))
> I don't understand why we check this size?
> in GICv1 EOIMode necessarily is 0, right? is it related?

This is indeed related. For a GIC to support EOIMode==1, you need to
have access to the DIR register, which has the good idea of being
located on a separate 4k page, making the size of the CPU interface 8k
in total. Anything smaller means you don't have a DIR register.

It is worth noticing that most of the DTS files containing a reference
to GICv2 are wrong, and are only exposing a 4k CPU interface. These
platforms won't be able to use this feature until they are fixed.
Basically anything with an A7/A15/A53/A57/X-Gene.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
