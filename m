From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 3/4] kvm: arm/arm64: vgic-v3: add ICH_AP[01]Rn
 accessors for GICv3
Date: Tue, 8 Aug 2017 14:10:39 +0100
Message-ID: <64cf86c6-ef43-df08-dddc-fd815251b48a@arm.com>
References: <1500287012-16996-1-git-send-email-wanghaibin.wang@huawei.com>
 <1500287012-16996-4-git-send-email-wanghaibin.wang@huawei.com>
 <877eywbvwb.fsf@arm.com> <5989B642.2030004@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5E5440CE9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 09:09:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6OhnzD6fkPeB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 09:09:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EED149C28
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 09:09:12 -0400 (EDT)
In-Reply-To: <5989B642.2030004@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/08/17 14:01, wanghaibin wrote:
> On 2017/7/25 19:25, Marc Zyngier wrote:
> 
>> On Mon, Jul 17 2017 at  6:23:31 pm BST, wanghaibin <wanghaibin.wang@huawei.com> wrote:
>>> This patch is used for GICv2 on GICv3.
>>>
>>> About GICV_APRn hardware register access,the SPEC says:
>>> When System register access is enabled for EL2, these registers access
>>> ICH_AP1Rn_EL2, and all active priorities for virtual machines are held
>>> in ICH_AP1Rn_EL2 regardless of interrupt group.
>>>
>>> For GICv3 hardware, we access the active priorities from ICH_AP1Rn_EL2
>>> in this scene.
>>>
>>> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-mmio.c | 12 ++++++++++++
>>>  virt/kvm/arm/vgic/vgic-v3.c   | 20 ++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>>>  3 files changed, 34 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>>> index f6f3681..3b648a7 100644
>>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>> @@ -456,14 +456,26 @@ static int match_region(const void *key, const void *elt)
>>>  
>>>  void vgic_set_apr(struct kvm_vcpu *vcpu, u32 idx, u32 val)
>>>  {
>>> +	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
>>> +
>>>  	if (kvm_vgic_global_state.type == VGIC_V2)
>>>  		vgic_v2_set_apr(vcpu, idx, val);
>>> +	else {
>>
>> Coding style.
> 
> 
> Will fix.
> 
> Thanks
> 
>>
>>> +		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
>>> +			vgic_v3_set_apr(vcpu, 1, idx, val);
>>> +	}
>>>  }
>>>  
>>>  u32 vgic_get_apr(struct kvm_vcpu *vcpu, u32 idx)
>>>  {
>>> +	u32 vgic_model = vcpu->kvm->arch.vgic.vgic_model;
>>> +
>>>  	if (kvm_vgic_global_state.type == VGIC_V2)
>>>  		return vgic_v2_get_apr(vcpu, idx);
>>> +	else {
>>
>> Same here.
>>
>>> +		if (vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
>>> +			return vgic_v3_get_apr(vcpu, 1, idx);
>>> +	}
>>>  
>>>  	return 0;
>>>  }
>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>> index 030248e..da40681 100644
>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>> @@ -156,6 +156,26 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>>>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = 0;
>>>  }
>>>  
>>> +void vgic_v3_set_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx, u32 val)
>>> +{
>>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>>> +
>>> +	if (group)
>>> +		cpu_if->vgic_ap1r[idx] = val;
>>> +	else
>>> +		cpu_if->vgic_ap0r[idx] = val;
>>> +}
>>> +
>>> +u32 vgic_v3_get_apr(struct kvm_vcpu *vcpu, u8 group, u32 idx)
>>> +{
>>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>>> +
>>> +	if (group)
>>> +		return cpu_if->vgic_ap1r[idx];
>>> +	else
>>> +		return cpu_if->vgic_ap0r[idx];
>>> +}
>>> +
>>
>> How do we ensure that these APRs are even valid? We can have anything
>> from 5 to 7 bits of preemption, and thus 1 to 4 APRs. The rest is
>> UNDEFined.
> 
> 
> Sorry, Marc, I can't follow you.
> 
> Do you suspect that an undefined APR register(implemented by ICH_VTR_EL2.PRIbits) will be accessed here?

Two implementations may not implement the same number of PRIbits. But
you seem to allow userspace to save/restore them, even if that doesn't
make sense.

> This code just access the soft vgic_ap[0,1]r structure, and I notice that, this structure saved the hardware
> APRn info under the constraint of ICH_VTR_EL2.PREbits implemented when save the vcpu content. the soft vgic_ap[0,1]r
> structure will keep 0 value when the hw APRn UNDEFined.

Yes, but userspace should be aware of this constraint, and access
register that cannot be used on this implementation.

To summarize, you need to be consistent. Something that cannot be used
for the guest shouldn't be available to userspace either.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
