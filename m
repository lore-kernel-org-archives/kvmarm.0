From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64 : fix vm's hanging at startup time
Date: Fri, 16 Nov 2018 10:03:11 +0000
Message-ID: <851b61b1-786b-ef64-b8c4-fe6926bdf9f9@arm.com>
References: <201811160823399069106@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201811160823399069106@zte.com.cn>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: peng.hao2@zte.com.cn, andre.przywara@arm.com
Cc: christoffer.dall@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 16/11/18 00:23, peng.hao2@zte.com.cn wrote:
>> Hi,
>>> When virtual machine starts, hang up.
>>
>> I take it you mean the *guest* hangs? Because it doesn't get a timer
>> interrupt?
>>
>>> The kernel version of guest
>>> is 4.16. Host support vgic_v3.
>>
>> Your host kernel is something recent, I guess?
>>
>>> It was mainly due to the incorrect vgic_irq's(intid=27) group value
>>> during injection interruption. when kvm_vgic_vcpu_init is called,
>>> dist is not initialized at this time. Unable to get vgic V3 or V2
>>> correctly, so group is not set.
>>
>> Mmh, that shouldn't happen with (v)GICv3. Do you use QEMU (which
>> version?) or some other userland tool?
>>
> 
> QEMU emulator version 3.0.50 .
> 
>>> group is setted to 1 when vgic_mmio_write_group is invoked at some
>>> time.
>>> when irq->group=0 (intid=27), No ICH_LR_GROUP flag was set and
>>> interrupt injection failed.
>>>
>>> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
>>> ---
>>>   virt/kvm/arm/vgic/vgic-v3.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index 9c0dd23..d101000 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -198,7 +198,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
>>> struct vgic_irq *irq, int lr) if (vgic_irq_is_mapped_level(irq) &&
>>> (val & ICH_LR_PENDING_BIT)) irq->line_level = false;
>>>
>>> -    if (irq->group)
>>> +    if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>
>> This is not the right fix, not only because it basically reverts the
>> GICv3 part of 87322099052 (KVM: arm/arm64: vgic: Signal IRQs using
>> their configured group).
>>
>> Can you try to work out why kvm_vgic_vcpu_init() is apparently called
>> before dist->vgic_model is set, also what value it has?
>> If I understand the code correctly, that shouldn't happen for a GICv3.
>>
> Even if the value of  group is correctly assigned in kvm_vgic_vcpu_init, the group is then written 0 through vgic_mmio_write_group.
>   If the interrupt comes at this time, the interrupt injection fails.
> 

Does that mean that the guest is configuring its interrupts as Group0? 
That sounds wrong, Linux should configure all it's interrupts as 
non-secure group1.

-- 
Julien Thierry
