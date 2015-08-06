From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm:arm:Fix error handling in the function vgic_v3_probe
Date: Thu, 06 Aug 2015 09:06:26 +0100
Message-ID: <55C31582.4000809@arm.com>
References: <1438793303-30228-1-git-send-email-xerofoify@gmail.com> <55C240D9.5060900@redhat.com> <55C242C6.6060200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55C242C6.6060200@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: nick <xerofoify@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Cc: "gleb@kernel.org" <gleb@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/08/15 18:07, nick wrote:
> 
> 
> On 2015-08-05 12:59 PM, Paolo Bonzini wrote:
>>
>>
>> On 05/08/2015 18:48, Nicholas Krause wrote:
>>> This fixes the error handling in the function vgic_v3_probe
>>> for when calling the function kvm_register_device_ops to check
>>> if the call to this function has returned a error code and if
>>> so jump to the label out with goto to cleanup no longer required
>>> resources used by the function vgic_v3_probe before returning the
>>> error code from the call to kvm_register_device_ops to the caller
>>> of the function vgic_v3_probe.
>>>
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>  virt/kvm/arm/vgic-v3.c | 10 +++++++---
>>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
>>> index dff0602..5102aa2 100644
>>> --- a/virt/kvm/arm/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic-v3.c
>>> @@ -264,12 +264,16 @@ int vgic_v3_probe(struct device_node *vgic_node,
>>>  	} else {
>>>  		vgic->vcpu_base = vcpu_res.start;
>>>  		vgic->can_emulate_gicv2 = true;
>>> -		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>>> -					KVM_DEV_TYPE_ARM_VGIC_V2);
>>> +		ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>>> +					      KVM_DEV_TYPE_ARM_VGIC_V2);
>>> +		if (ret)
>>> +			goto out;
>>>  	}
>>>  	if (vgic->vcpu_base == 0)
>>>  		kvm_info("disabling GICv2 emulation\n");
>>> -	kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
>>> +	ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
>>> +	if (ret)
>>> +		goto out;
>>>  
>>>  	vgic->vctrl_base = NULL;
>>>  	vgic->type = VGIC_V3;
>>>
>>
>> This really should never happen.  Perhaps kvm_register_device_ops should
>> instead return void, and WARN() when it currently returns an error.
>>
>> Paolo
>>
> Paolo,
> I would like to do what you want but after tracing the callers of this function I found
> this structure and wasn't sure if it can handle void function pointers.
> static const struct of_device_id vgic_ids[] = {
>         { .compatible = "arm,cortex-a15-gic",   .data = vgic_v2_probe, },
>         { .compatible = "arm,cortex-a7-gic",    .data = vgic_v2_probe, },
>         { .compatible = "arm,gic-400",          .data = vgic_v2_probe, },
>         { .compatible = "arm,gic-v3",           .data = vgic_v3_probe, },
>         {},
> };
> If this structure of function pointers can handle function pointers with a return type of 
> void I will be glad to do what you request otherwise this would require a major rewrite
> of kvm arm subsystem for a very simple bug fix.

Just like Paolo said, the error you report should never happen, and
would be caught by a WARN_ON() the first time anyone boots the kernel.
Also, failing to register the device ops results in not being able to
instantiate a VGIC. No harm done. I really don't understand why you want
to rewrite the probe functions.

There is plenty of things that could use a major rewrite in KVM/ARM, but
this is just not one of them.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
