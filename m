From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 3/5] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Wed, 10 Feb 2016 15:22:12 +0000
Message-ID: <56BB55A4.5020608@arm.com>
References: <1454950049-741-1-git-send-email-julien.grall@arm.com>
 <1454950049-741-4-git-send-email-julien.grall@arm.com>
 <20160209204914.GE5171@cbox> <56BB46DC.7080202@arm.com>
 <56BB4D2A.1030903@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56BB4D2A.1030903@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 10/02/16 14:46, Marc Zyngier wrote:
> On 10/02/16 14:19, Julien Grall wrote:
>> On 09/02/16 20:49, Christoffer Dall wrote:
>>>> +static void __init gic_acpi_setup_kvm_info(void)
>>>> +{
>>>> +	gic_v2_kvm_info.type = GIC_V2;
>>>> +
>>>> +	gic_v2_kvm_info.maint_irq = acpi_register_gsi(NULL,
>>>> +						      acpi_data.maint_irq,
>>>> +						      acpi_data.maint_irq_mode,
>>>> +						      ACPI_ACTIVE_HIGH);
>>>> +	gic_v2_kvm_info.vctrl_base = acpi_data.vctrl_base;
>>>> +	if (gic_v2_kvm_info.vctrl_base)
>>>> +		gic_v2_kvm_info.vctrl_size = SZ_8K;
>>>> +
>>>> +	gic_v2_kvm_info.vcpu_base = acpi_data.vcpu_base;
>>>> +	if (gic_v2_kvm_info.vcpu_base)
>>>> +		gic_v2_kvm_info.vcpu_size = SZ_8K;
>>>
>>> why are the sizes hard-coded to 8K in this case?
>>
>> The MADT only provides the base addresses and not the size. The default
>> value has been chosen based on the GICv2 spec (ARM IHI 0048B.b)
>> 	* GICV: See 5.5
>> 	* GICH: I can't find again the section about it. But the example
>> bindings in
>> Documents/devicetree/bindings/interrupt-controller/arm,gic.txt uses 8K.
>>
>> I will add a comment in the code explaining where the 8K come from.
>
> The GICH size can be found in the GIC400 TRM:
>
> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0471b/CHDBJDCB.html
>
> The first 4kB are banked per CPU, while the next 4kB are exposing all
> CPUs, each in a 512 bytes window. We don't give a damn about the second
> page, but hey, it is there...
>
> Of course, this is GIC400, not the architecture spec. So maybe
> considering a 4kB size would be better, just in case someone is
> braindead enough to produce another GICv2 implementation without the
> aliases...

Ok, I will change the GICH to 4KB in the next version.

Cheers,

-- 
Julien Grall
