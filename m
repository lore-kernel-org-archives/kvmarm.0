From: nick <xerofoify@gmail.com>
Subject: Re: [PATCH] kvm:arm:Fix error handling in the function vgic_v3_probe
Date: Wed, 05 Aug 2015 13:07:18 -0400
Message-ID: <55C242C6.6060200@gmail.com>
References: <1438793303-30228-1-git-send-email-xerofoify@gmail.com>
 <55C240D9.5060900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <55C240D9.5060900@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, gleb@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015-08-05 12:59 PM, Paolo Bonzini wrote:
> 
> 
> On 05/08/2015 18:48, Nicholas Krause wrote:
>> This fixes the error handling in the function vgic_v3_probe
>> for when calling the function kvm_register_device_ops to check
>> if the call to this function has returned a error code and if
>> so jump to the label out with goto to cleanup no longer required
>> resources used by the function vgic_v3_probe before returning the
>> error code from the call to kvm_register_device_ops to the caller
>> of the function vgic_v3_probe.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  virt/kvm/arm/vgic-v3.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
>> index dff0602..5102aa2 100644
>> --- a/virt/kvm/arm/vgic-v3.c
>> +++ b/virt/kvm/arm/vgic-v3.c
>> @@ -264,12 +264,16 @@ int vgic_v3_probe(struct device_node *vgic_node,
>>  	} else {
>>  		vgic->vcpu_base = vcpu_res.start;
>>  		vgic->can_emulate_gicv2 = true;
>> -		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>> -					KVM_DEV_TYPE_ARM_VGIC_V2);
>> +		ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>> +					      KVM_DEV_TYPE_ARM_VGIC_V2);
>> +		if (ret)
>> +			goto out;
>>  	}
>>  	if (vgic->vcpu_base == 0)
>>  		kvm_info("disabling GICv2 emulation\n");
>> -	kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
>> +	ret = kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
>> +	if (ret)
>> +		goto out;
>>  
>>  	vgic->vctrl_base = NULL;
>>  	vgic->type = VGIC_V3;
>>
> 
> This really should never happen.  Perhaps kvm_register_device_ops should
> instead return void, and WARN() when it currently returns an error.
> 
> Paolo
> 
Paolo,
I would like to do what you want but after tracing the callers of this function I found
this structure and wasn't sure if it can handle void function pointers.
static const struct of_device_id vgic_ids[] = {
        { .compatible = "arm,cortex-a15-gic",   .data = vgic_v2_probe, },
        { .compatible = "arm,cortex-a7-gic",    .data = vgic_v2_probe, },
        { .compatible = "arm,gic-400",          .data = vgic_v2_probe, },
        { .compatible = "arm,gic-v3",           .data = vgic_v3_probe, },
        {},
};
If this structure of function pointers can handle function pointers with a return type of 
void I will be glad to do what you request otherwise this would require a major rewrite
of kvm arm subsystem for a very simple bug fix.
Cheers,
Nick
