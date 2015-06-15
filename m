From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 6/8] arm: prepare for instantiating different IRQ chip
 devices
Date: Mon, 15 Jun 2015 11:46:45 +0100
Message-ID: <557EAD15.2050906@arm.com>
References: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
 <1433493473-4002-7-git-send-email-andre.przywara@arm.com>
 <55787213.30002@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C59B854FE2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 06:35:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yKris1vGzaDc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2015 06:35:58 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87ADC54FE1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2015 06:35:58 -0400 (EDT)
In-Reply-To: <55787213.30002@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "penberg@kernel.org" <penberg@kernel.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 06/10/2015 06:21 PM, Marc Zyngier wrote:
> On 05/06/15 09:37, Andre Przywara wrote:
>> Extend the vGIC handling code to potentially deal with different IRQ
>> chip devices instead of hard-coding the GICv2 in.
>> We extend most vGIC functions to take a type parameter, but still put
>> GICv2 in at the top for the time being.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
...
>> @@ -26,21 +26,37 @@ static int gic__create_device(struct kvm *kvm)
>>  	};
>>  	struct kvm_device_attr dist_attr = {
>>  		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
>> -		.attr	= KVM_VGIC_V2_ADDR_TYPE_DIST,
>>  		.addr	= (u64)(unsigned long)&dist_addr,
>>  	};
>>  
>> +	switch (type) {
>> +	case IRQCHIP_GICV2:
>> +		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
>> +		break;
>> +	default:
>> +		return -ENODEV;
>> +	}
>> +
>>  	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &gic_device);
>>  	if (err)
>>  		return err;
>>  
>>  	gic_fd = gic_device.fd;
>>  
>> -	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
>> +	switch (type) {
>> +	case IRQCHIP_GICV2:
>> +		dist_attr.attr = KVM_VGIC_V2_ADDR_TYPE_DIST;
> 
> You could move the structure patching in the first switch statement.
> 
>> +		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
>> +		break;
>> +	default:
>> +		return -ENODEV;
> 
> This default cannot be reached, as you've already caught the weird stuff
> above.

Tell that the compiler, not me ;-)
Will check if dropping IRQCHIP_DEFAULT will appease the compiler.

....

>> @@ -131,15 +156,26 @@ static int gic__init_gic(struct kvm *kvm)
>>  }
>>  late_init(gic__init_gic)
>>  
>> -void gic__generate_fdt_nodes(void *fdt, u32 phandle)
>> +void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
>>  {
>> +	const char *compatible;
>>  	u64 reg_prop[] = {
>> -		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
>> -		cpu_to_fdt64(ARM_GIC_CPUI_BASE), cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
>> +		cpu_to_fdt64(ARM_GIC_DIST_BASE),
>> +		cpu_to_fdt64(ARM_GIC_DIST_SIZE),
>> +		cpu_to_fdt64(ARM_GIC_CPUI_BASE),
>> +		cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
>>  	};
> 
> Any particular reason for this change? I found the original more readable...

80 characters. I will revert this.

Fixed the rest.

Thanks!
Andre.
