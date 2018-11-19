From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64 : fix vm's hanging at startup time
Date: Mon, 19 Nov 2018 09:26:03 +0000
Message-ID: <c259e853-3d0c-1046-f576-fe28ead58ee8@arm.com>
References: <851b61b1-786b-ef64-b8c4-fe6926bdf9f9@arm.com>
 <201811171058376326562@zte.com.cn> <20181119091020.ejplmzkzo4jd72md@salmiak>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12ED34A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 04:26:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e0yVJKE30bAf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Nov 2018 04:26:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 823824A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 04:26:07 -0500 (EST)
In-Reply-To: <20181119091020.ejplmzkzo4jd72md@salmiak>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, peng.hao2@zte.com.cn
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, ard.bieshseuvel@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 19/11/2018 09:10, Mark Rutland wrote:
> On Sat, Nov 17, 2018 at 10:58:37AM +0800, peng.hao2@zte.com.cn wrote:
>>> On 16/11/18 00:23, peng.hao2@zte.com.cn wrote:
>>>>> Hi,
>>>>>> When virtual machine starts, hang up.
>>>>>
>>>>> I take it you mean the *guest* hangs? Because it doesn't get a timer
>>>>> interrupt?
>>>>>
>>>>>> The kernel version of guest
>>>>>> is 4.16. Host support vgic_v3.
>>>>>
>>>>> Your host kernel is something recent, I guess?
>>>>>
>>>>>> It was mainly due to the incorrect vgic_irq's(intid=27) group value
>>>>>> during injection interruption. when kvm_vgic_vcpu_init is called,
>>>>>> dist is not initialized at this time. Unable to get vgic V3 or V2
>>>>>> correctly, so group is not set.
>>>>>
>>>>> Mmh, that shouldn't happen with (v)GICv3. Do you use QEMU (which
>>>>> version?) or some other userland tool?
>>>>>
>>>>
>>>> QEMU emulator version 3.0.50 .
>>>>
>>>>>> group is setted to 1 when vgic_mmio_write_group is invoked at some
>>>>>> time.
>>>>>> when irq->group=0 (intid=27), No ICH_LR_GROUP flag was set and
>>>>>> interrupt injection failed.
>>>>>>
>>>>>> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
>>>>>> ---
>>>>>>   virt/kvm/arm/vgic/vgic-v3.c | 2 +-
>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>>>>> index 9c0dd23..d101000 100644
>>>>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>>>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>>>>> @@ -198,7 +198,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
>>>>>> struct vgic_irq *irq, int lr) if (vgic_irq_is_mapped_level(irq) &&
>>>>>> (val & ICH_LR_PENDING_BIT)) irq->line_level = false;
>>>>>>
>>>>>> -    if (irq->group)
>>>>>> +    if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>>>>
>>>>> This is not the right fix, not only because it basically reverts the
>>>>> GICv3 part of 87322099052 (KVM: arm/arm64: vgic: Signal IRQs using
>>>>> their configured group).
>>>>>
>>>>> Can you try to work out why kvm_vgic_vcpu_init() is apparently called
>>>>> before dist->vgic_model is set, also what value it has?
>>>>> If I understand the code correctly, that shouldn't happen for a GICv3.
>>>>>
>>>> Even if the value of  group is correctly assigned in kvm_vgic_vcpu_init, the group is then written 0 through vgic_mmio_write_group.
>>>>   If the interrupt comes at this time, the interrupt injection fails.
>>>
>>> Does that mean that the guest is configuring its interrupts as Group0?
>>> That sounds wrong, Linux should configure all it's interrupts as
>>> non-secure group1.
>>
>> no, I think that uefi dose this, not linux.
>> 1. kvm_vgic_vcpu_init 
>> 2. vgic_create 
>> 3. kvm_vgic_dist_init 
>> 4.vgic_mmio_write_group: uefi as guest, write group=0
>> 5.vgic_mmio_write_group: linux as guest, write group=1
> 
> Is this the same issue fixed by EDK2 commit:
> 
> 66127011a544b90e ("ArmPkg/ArmGicDxe ARM: fix encoding for GICv3 interrupt acknowledge")
> 
> ... where EDK2 would try to use IAR0 rather than IAR1?
> 
> The commit messages notes this lead to a boot-time hang.

I doubt it. The EDK2 bug resulted in no interrupt being delivered due to
the group being set to 1, and the interrupt being acknowledged through
the Group0 accessor. Also, this was a 32bit special, and 64bit EDK2 was
just fine.

What Peng describes here is the guest writing the group as 0, which
doesn't make much sense (I certainly don't see EDK2 doing that).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
