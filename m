From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v6 06/18] kvm: arm/arm64: Allow arch specific
 configurations for VM
Date: Sat, 29 Sep 2018 09:30:41 +0100
Message-ID: <95c89f16-df03-a57b-e373-42cf65769912@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
 <20180926163258.20218-7-suzuki.poulose@arm.com>
 <fbca190b-473b-5dee-67be-c724392fd297@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fbca190b-473b-5dee-67be-c724392fd297@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, eric.auger@redhat.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 09/28/2018 06:27 PM, Marc Zyngier wrote:
> Hi Suzuki,
> 
> On 26/09/18 17:32, Suzuki K Poulose wrote:
>> Allow the arch backends to perform VM specific initialisation.
>> This will be later used to handle IPA size configuration and per-VM
>> VTCR configuration on arm64.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@kernel.org>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm/include/asm/kvm_host.h   | 7 +++++++
>>   arch/arm64/include/asm/kvm_host.h | 2 ++
>>   arch/arm64/kvm/reset.c            | 7 +++++++
>>   virt/kvm/arm/arm.c                | 5 +++--
>>   4 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h 
>> b/arch/arm/include/asm/kvm_host.h
>> index 3ad482d2f1eb..72d46418e1ef 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -354,4 +354,11 @@ static inline void kvm_vcpu_put_sysregs(struct 
>> kvm_vcpu *vcpu) {}
>>   struct kvm *kvm_arch_alloc_vm(void);
>>   void kvm_arch_free_vm(struct kvm *kvm);
>> +static inline int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
> 
> This is a bit of a nit, but VM is a bit of an overloaded term in this 
> context. Given what we do in the following patch (moving the global 
> stage-2 init to be on a per VM -- virtual machine), I'd like to rename 
> this to something less ambiguous.
> 
> How about kvm_arm_config_stage2? Or something along those lines?

I had something similar in the earlier versions, where we supported
the "IPA" size for both arm and arm64. But since we restricted this
feature to arm64, I changed the name to make it more generic to
let the archs parse the "vm_type" parameter which could potentially have
more bits defined, not just the IPA size. Hence the change. On arm64, we
only use it for stage2 configuration and on arm32 we make sure the type
is empty.

> 
> No need to respin the series on this account, we can address it in a 
> separate patch. But I think it would help understanding what is done where.
> 

As such I am fine with suggestion.

Cheers
Suzuki
