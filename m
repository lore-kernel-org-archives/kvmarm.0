From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 01/10] arm64: KVM: Use static keys for selecting the
 GIC backend
Date: Wed, 14 Sep 2016 16:47:51 +0100
Message-ID: <57D97127.3070209@arm.com>
References: <1473691764-29424-1-git-send-email-vladimir.murzin@arm.com>
 <1473691764-29424-2-git-send-email-vladimir.murzin@arm.com>
 <20160913082019.GB5680@cbox> <57D7C2AE.908@arm.com>
 <20160913092234.GA30056@cbox> <57D96AA0.2010607@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72CDA49B98
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2016 11:39:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tMLBJqDJ7Hj0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2016 11:39:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 095CC49B88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2016 11:39:07 -0400 (EDT)
In-Reply-To: <57D96AA0.2010607@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 14/09/16 16:20, Vladimir Murzin wrote:
> On 13/09/16 10:22, Christoffer Dall wrote:
>> On Tue, Sep 13, 2016 at 10:11:10AM +0100, Marc Zyngier wrote:
>>> On 13/09/16 09:20, Christoffer Dall wrote:
>>>> On Mon, Sep 12, 2016 at 03:49:15PM +0100, Vladimir Murzin wrote:
>>>>> Currently GIC backend is selected via alternative framework and this
>>>>> is fine. We are going to introduce vgic-v3 to 32-bit world and there
>>>>> we don't have patching framework in hand, so we can either check
>>>>> support for GICv3 every time we need to choose which backend to use or
>>>>> try to optimise it by using static keys. The later looks quite
>>>>> promising because we can share logic involved in selecting GIC backend
>>>>> between architectures if both uses static keys.
>>>>>
>>>>> This patch moves arm64 from alternative to static keys framework for
>>>>> selecting GIC backend. For that we embed static key into vgic_global
>>>>> and enable the key during vgic initialisation based on what has
>>>>> already been exposed by the host GIC driver.
>>>>>
>>>>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>>>>> ---
>>>>>  arch/arm64/kvm/hyp/switch.c   |   21 +++++++++++----------
>>>>>  include/kvm/arm_vgic.h        |    4 ++++
>>>>>  virt/kvm/arm/vgic/vgic-init.c |    4 ++++
>>>>>  virt/kvm/arm/vgic/vgic.c      |    2 +-
>>>>>  4 files changed, 20 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>>>> index 5a84b45..d5c4cc5 100644
>>>>> --- a/arch/arm64/kvm/hyp/switch.c
>>>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>>>> @@ -16,6 +16,8 @@
>>>>>   */
>>>>>  
>>>>>  #include <linux/types.h>
>>>>> +#include <linux/jump_label.h>
>>>>> +
>>>>>  #include <asm/kvm_asm.h>
>>>>>  #include <asm/kvm_hyp.h>
>>>>>  
>>>>> @@ -126,17 +128,13 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
>>>>>  	write_sysreg(0, vttbr_el2);
>>>>>  }
>>>>>  
>>>>> -static hyp_alternate_select(__vgic_call_save_state,
>>>>> -			    __vgic_v2_save_state, __vgic_v3_save_state,
>>>>> -			    ARM64_HAS_SYSREG_GIC_CPUIF);
>>>>> -
>>>>> -static hyp_alternate_select(__vgic_call_restore_state,
>>>>> -			    __vgic_v2_restore_state, __vgic_v3_restore_state,
>>>>> -			    ARM64_HAS_SYSREG_GIC_CPUIF);
>>>>> -
>>>>>  static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>> -	__vgic_call_save_state()(vcpu);
>>>>> +	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>>>>
>>>> It's a bit weird that we use _unlikely for GICv3 (at least if/when GICv3
>>>> hardware becomes mainstream), but as we don't have another primitive for
>>>> the 'default disabled' case, I suppose that's the best we can do.
>>>
>>> We could always revert the "likelihood" of that test once GICv3 has
>>> conquered the world. Or start patching the 32bit kernel like we do for
>>> 64bit...
>>>
>>>>
>>>>> +		__vgic_v3_save_state(vcpu);
>>>>> +	else
>>>>> +		__vgic_v2_save_state(vcpu);
>>>>> +
>>>>>  	write_sysreg(read_sysreg(hcr_el2) & ~HCR_INT_OVERRIDE, hcr_el2);
>>>>>  }
>>>>>  
>>>>> @@ -149,7 +147,10 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
>>>>>  	val |= vcpu->arch.irq_lines;
>>>>>  	write_sysreg(val, hcr_el2);
>>>>>  
>>>>> -	__vgic_call_restore_state()(vcpu);
>>>>> +	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
>>>>> +		__vgic_v3_restore_state(vcpu);
>>>>> +	else
>>>>> +		__vgic_v2_restore_state(vcpu);
>>>>>  }
>>>>>  
>>>>>  static bool __hyp_text __true_value(void)
>>>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>>>> index 19b698e..994665a 100644
>>>>> --- a/include/kvm/arm_vgic.h
>>>>> +++ b/include/kvm/arm_vgic.h
>>>>> @@ -23,6 +23,7 @@
>>>>>  #include <linux/types.h>
>>>>>  #include <kvm/iodev.h>
>>>>>  #include <linux/list.h>
>>>>> +#include <linux/jump_label.h>
>>>>>  
>>>>>  #define VGIC_V3_MAX_CPUS	255
>>>>>  #define VGIC_V2_MAX_CPUS	8
>>>>> @@ -63,6 +64,9 @@ struct vgic_global {
>>>>>  
>>>>>  	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
>>>>>  	bool			can_emulate_gicv2;
>>>>> +
>>>>> +	/* GIC system register CPU interface */
>>>>> +	struct static_key_false gicv3_cpuif;
>>>>
>>>> Documentation/static-keys.txt says that we are not supposed to use
>>>> struct static_key_false directly.  This will obviously work quite
>>>> nicely, but we could consider adding a pair of
>>>> DECLARE_STATIC_KEY_TRUE/FALSE macros that don't have the assignments,
>>>> but obviously this will need an ack from other maintainers.
>>>>
>>>> Thoughts?
>>>
>>> Grepping through the tree shows that we're not the only abusers of this
>>> (dynamic debug is far worse!). Happy to write the additional macros and
>>> submit them if nobody beats me to it.
>>>
>>>>
>>>>
>>>>>  };
>>>>>  
>>>>>  extern struct vgic_global kvm_vgic_global_state;
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>>>>> index 83777c1..14d6718 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-init.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>>>>> @@ -405,6 +405,10 @@ int kvm_vgic_hyp_init(void)
>>>>>  		break;
>>>>>  	case GIC_V3:
>>>>>  		ret = vgic_v3_probe(gic_kvm_info);
>>>>> +		if (!ret) {
>>>>> +			static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
>>>>> +			kvm_info("GIC system register CPU interface\n");
>>>>
>>>> nit: add enabled to the info message?
>>>>
>>>>> +		}
>>>>>  		break;
>>>>>  	default:
>>>>>  		ret = -ENODEV;
>>>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>>>> index e83b7fe..8a529a7 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>>>> @@ -29,7 +29,7 @@
>>>>>  #define DEBUG_SPINLOCK_BUG_ON(p)
>>>>>  #endif
>>>>>  
>>>>> -struct vgic_global __section(.hyp.text) kvm_vgic_global_state;
>>>>> +struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif = STATIC_KEY_FALSE_INIT,};
>>>>>  
>>>>>  /*
>>>>>   * Locking order is always:
>>>>> -- 
>>>>> 1.7.9.5
>>>>>
>>>>
>>>> Overall this looks really nice, as long as we're clear on the static
>>>> keys stuff.
>>>
>>> Indeed, we should get this sorted, though I'm not sure this should be a
>>> blocker for this code.
>>>
>> Agreed, let's ship it!
> 
> To make it clear, should I respin with "enabled" into the info message
> and macros for static keys?

I think we can fix the message up when applying the patches. As for the
macros, we should have a separate series that does it treewide.

Christoffer?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
