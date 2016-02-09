From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 3/5] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Tue, 9 Feb 2016 11:23:55 +0000
Message-ID: <56B9CC4B.90403@arm.com>
References: <1454950049-741-1-git-send-email-julien.grall@arm.com>
 <1454950049-741-4-git-send-email-julien.grall@arm.com>
 <56B8DEB8.4010509@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56B8DEB8.4010509@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/02/16 18:30, Marc Zyngier wrote:
> Julien,

Hi Marc,

> On 08/02/16 16:47, Julien Grall wrote:

[...]

>> +static void __init gic_of_setup_kvm_info(struct device_node *node)
>> +{
>> +	int ret;
>> +	struct resource r;
>> +	unsigned int irq;
>> +
>> +	gic_v2_kvm_info.type = GIC_V2;
>> +
>> +	irq = irq_of_parse_and_map(node, 0);
>> +	if (!irq)
>> +		gic_v2_kvm_info.maint_irq = -1;
>
> Please don't do that. 0 *is* the value for an invalid interrupt, and
> this is what you should expose here. Same for GICv3.

I decided to use -1, because the function acpi_register_gsi is returning 
a negative value when an error occurred.

AFAICT, returning 0 would be a valid value for acpi_register_gsi.

>> +	else
>> +		gic_v2_kvm_info.maint_irq = irq;
>> +
>> +	ret = of_address_to_resource(node, 2, &r);
>> +	if (!ret) {
>> +		gic_v2_kvm_info.vctrl_base = r.start;
>> +		gic_v2_kvm_info.vctrl_size = resource_size(&r);
>> +	}
>> +
>> +	ret = of_address_to_resource(node, 3, &r);
>> +	if (!ret) {
>> +		if (!PAGE_ALIGNED(r.start))
>> +			pr_warn("GICV physical address 0x%llx not page aligned\n",
>> +				(unsigned long long)r.start);
>> +		else if (!PAGE_ALIGNED(resource_size(&r)))
>> +			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
>> +				(unsigned long long)resource_size(&r),
>> +				PAGE_SIZE);
>> +		else {
>> +			gic_v2_kvm_info.vcpu_base = r.start;
>> +			gic_v2_kvm_info.vcpu_size = resource_size(&r);
>
> This tends to make me think that this should actually be a proper
> resource, and not a set of arbitrary fields.

I will give a look.

[..]

>> @@ -1270,6 +1338,12 @@ gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
>>   		return -EINVAL;
>>
>>   	cpu_phy_base = gic_cpu_base;
>> +	acpi_data.maint_irq = processor->vgic_interrupt;
>> +	acpi_data.maint_irq_mode = (processor->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
>> +				    ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
>> +	acpi_data.vctrl_base = processor->gich_base_address;
>> +	acpi_data.vcpu_base = processor->gicv_base_address;
>> +
>
> Maybe you can now move all the ACPI data into this acpi_data structure?
> This would allow for slightly less clutter...

Good idea, I will do it in the next version.

[...]

>
> Thanks,

Regards,

-- 
Julien Grall
