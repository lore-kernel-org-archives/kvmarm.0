From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v6 21/27] KVM: arm/arm64: Add hook for arch-specific KVM
 initialisation
Date: Wed, 27 Mar 2019 15:23:02 +0000
Message-ID: <5bc3eecc-3991-179a-4eca-f661aaada920@arm.com>
References: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
 <1553017938-710-22-git-send-email-Dave.Martin@arm.com>
 <5e0bdb27-4140-0e53-e15c-369a51e9f744@arm.com>
 <20190327104117.GU3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190327104117.GU3567@e103592.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 27/03/2019 10:41, Dave Martin wrote:
> On Wed, Mar 27, 2019 at 10:07:17AM +0000, Julien Thierry wrote:
>> Hi Dave,
>>
>> On 19/03/2019 17:52, Dave Martin wrote:
>>> This patch adds a kvm_arm_init_arch_resources() hook to perform
>>> subarch-specific initialisation when starting up KVM.
>>>
>>> This will be used in a subsequent patch for global SVE-related
>>> setup on arm64.
>>>
>>> No functional change.
>>>
>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>> ---
>>>  arch/arm/include/asm/kvm_host.h   | 2 ++
>>>  arch/arm64/include/asm/kvm_host.h | 2 ++
>>>  virt/kvm/arm/arm.c                | 4 ++++
>>>  3 files changed, 8 insertions(+)
>>>
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index 770d732..a49ee01 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -53,6 +53,8 @@
>>>  
>>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>>  
>>> +static inline int kvm_arm_init_arch_resources(void) { return 0; }
>>> +
>>>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>>>  int __attribute_const__ kvm_target_cpu(void);
>>>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 205438a..3e89509 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -58,6 +58,8 @@
>>>  
>>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>>  
>>> +static inline int kvm_arm_init_arch_resources(void) { return 0; }
>>> +
>>>  int __attribute_const__ kvm_target_cpu(void);
>>>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>>  int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 99c3738..c69e137 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>>> @@ -1664,6 +1664,10 @@ int kvm_arch_init(void *opaque)
>>>  	if (err)
>>>  		return err;
>>>  
>>> +	err = kvm_arm_init_arch_resources();
>>> +	if (err)
>>> +		return err;
>>> +
>>
>> Nit: Does this need to be the very first thing we do for arch
>> initialization?
>>
>> In the same function I see a call to init_common_resources(), so I
>> would've pictured kvm_arm_init_arch_resources() being called close to it
>> (either right before or right after).
> 
> With git format-patch -U4 (so, one extra line of context):
> 
> @@ -1663,8 +1663,12 @@ int kvm_arch_init(void *opaque)
>         err = init_common_resources();
>         if (err)
>                 return err;
> 
> +       err = kvm_arm_init_arch_resources();
> +       if (err)
> +               return err;
> +
> 
> Does that answer your concern?
> 

Ah yes, sorry for the noise! Disregard my comment :) .

Thanks,

Julien

> I'm guessing we might at some point find we have to move this call if we
> add more code into kvm_arm_init_arch_resources(), but for now there is
> no dependency between the SVE init stuff and anything else here.  So
> the it doesn't matter exactly when we call it today, so long as it is
> called before anyone can start creating vcpus.
> 
>> Otherwise:
>>
>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> 
> I'll wait for your response before applying this.
> 
> Thanks
> ---Dave
> 

-- 
Julien Thierry
