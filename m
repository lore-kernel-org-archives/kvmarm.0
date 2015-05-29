From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH V1 4/5] kvm: arm64: Implement ACPI probing code for GICv2
Date: Fri, 29 May 2015 09:34:43 -0500
Message-ID: <55687903.9090205@redhat.com>
References: <1432791274-15242-1-git-send-email-wei@redhat.com> <1432791274-15242-5-git-send-email-wei@redhat.com> <20150529140658.GC2749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150529140658.GC2749@localhost.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, a.spyridakis@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu



On 05/29/2015 09:06 AM, Andrew Jones wrote:
> On Thu, May 28, 2015 at 01:34:33AM -0400, Wei Huang wrote:
>> This patches enables ACPI support for KVM virtual GICv2. KVM parses
>> ACPI table for virt GIC related information and initializes resources.
>>
>> Signed-off-by: Alexander Spyridaki <a.spyridakis@virtualopensystems.com>
>> Signed-off-by: Wei Huang <wei@redhat.com>
>> ---
>>  virt/kvm/arm/vgic-v2.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 48 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
>> index 711de82..01ce8a3 100644
>> --- a/virt/kvm/arm/vgic-v2.c
>> +++ b/virt/kvm/arm/vgic-v2.c
>> @@ -264,6 +264,53 @@ int vgic_v2_acpi_probe(struct acpi_madt_generic_interrupt *vgic_acpi,
>>  		       const struct vgic_ops **ops,
>>  		       const struct vgic_params **params)
>>  {
>> -	return -EINVAL;
>> +	struct vgic_params *vgic = &vgic_v2_params;
>> +	int irq_mode, ret;
>> +
>> +	/* IRQ trigger mode */
>> +	irq_mode = (vgic_acpi->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
>> +		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
>> +	vgic->maint_irq = acpi_register_gsi(NULL, vgic_acpi->vgic_interrupt,
>> +					    irq_mode, ACPI_ACTIVE_HIGH);
>> +	if (!vgic->maint_irq) {
>> +		kvm_err("Cannot register VGIC ACPI maintenance irq\n");
>> +		ret = -ENXIO;
>> +		goto out;
>> +	}
>> +
>> +	/* GICH resource */
>> +	vgic->vctrl_base = ioremap(vgic_acpi->gich_base_address, SZ_8K);
>> +	if (!vgic->vctrl_base) {
>> +		kvm_err("cannot ioremap GICH memory\n");
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	vgic->nr_lr = readl_relaxed(vgic->vctrl_base + GICH_VTR);
>> +	vgic->nr_lr = (vgic->nr_lr & 0x3f) + 1;
>> +
>> +	ret = create_hyp_io_mappings(vgic->vctrl_base,
>> +				     vgic->vctrl_base + SZ_8K,
>> +				     vgic_acpi->gich_base_address);
>> +	if (ret) {
>> +		kvm_err("Cannot map GICH into hyp\n");
>> +		goto out;
>> +	}
>> +
>> +	vgic->vcpu_base = vgic_acpi->gicv_base_address;
>> +	vgic->can_emulate_gicv2 = true;
>> +	kvm_register_device_ops(&kvm_arm_vgic_v2_ops, KVM_DEV_TYPE_ARM_VGIC_V2);
>> +
>> +	kvm_info("GICH base=0x%llx, GICV base=0x%llx, IRQ=%d\n",
>> +		 (unsigned long long)vgic_acpi->gich_base_address,
>> +		 (unsigned long long)vgic_acpi->gicv_base_address,
>> +		 vgic->maint_irq);
>> +
>> +	vgic->type = VGIC_V2;
> 
> we're missing max_gic_vcpus here
> 
> 	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;

Yes. Will fix in the next spin.

-Wei

> 
>> +	*ops = &vgic_v2_ops;
>> +	*params = vgic;
>> +
>> +out:
>> +	return ret;
>>  }
>>  #endif /* CONFIG_ACPI */
>> -- 
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
