From: Jintack Lim <jintack.lim@linaro.org>
Subject: Re: [RFC PATCH v2 04/38] KVM: arm/arm64: Check if nested
 virtualization is in use
Date: Tue, 1 Aug 2017 10:07:40 -0400
Message-ID: <CAHyh4xi0hQE2kxOY78_25GwRsCCjMwOt0Lj=Jv1Vs1LdTUO+pQ@mail.gmail.com>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-5-git-send-email-jintack.lim@linaro.org> <20170730195949.GF5176@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170730195949.GF5176@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Jonathan Corbet <corbet@lwn.net>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, Daniel Lezcano <daniel.lezcano@linaro.org>, david.daney@cavium.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>, stefan@hello-penguin.com, Andy Gross <andy.gross@linaro.org>, wcohen@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, lkm
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Jul 30, 2017 at 3:59 PM, Christoffer Dall <cdall@linaro.org> wrote:
> On Tue, Jul 18, 2017 at 11:58:30AM -0500, Jintack Lim wrote:
>> Nested virtualizaion is in use only if all three conditions are met:
>> - The architecture supports nested virtualization.
>> - The kernel parameter is set.
>> - The userspace uses nested virtualiztion feature.
>>
>> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
>> ---
>>  arch/arm/include/asm/kvm_host.h   | 11 +++++++++++
>>  arch/arm64/include/asm/kvm_host.h |  2 ++
>>  arch/arm64/kvm/nested.c           | 17 +++++++++++++++++
>>  virt/kvm/arm/arm.c                |  4 ++++
>>  4 files changed, 34 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 00b0f97..7e9e6c8 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -303,4 +303,15 @@ static inline int __init kvmarm_nested_cfg(char *buf)
>>  {
>>       return 0;
>>  }
>> +
>> +static inline int init_nested_virt(void)
>> +{
>> +     return 0;
>> +}
>> +
>> +static inline bool nested_virt_in_use(struct kvm_vcpu *vcpu)
>> +{
>> +     return false;
>> +}
>> +
>>  #endif /* __ARM_KVM_HOST_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 6df0c7c..86d4b6c 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -387,5 +387,7 @@ static inline void __cpu_init_stage2(void)
>>  }
>>
>>  int __init kvmarm_nested_cfg(char *buf);
>> +int init_nested_virt(void);
>> +bool nested_virt_in_use(struct kvm_vcpu *vcpu);
>>
>>  #endif /* __ARM64_KVM_HOST_H__ */
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index 79f38da..9a05c76 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -24,3 +24,20 @@ int __init kvmarm_nested_cfg(char *buf)
>>  {
>>       return strtobool(buf, &nested_param);
>>  }
>> +
>> +int init_nested_virt(void)
>> +{
>> +     if (nested_param && cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
>> +             kvm_info("Nested virtualization is supported\n");
>> +
>> +     return 0;
>> +}
>> +
>> +bool nested_virt_in_use(struct kvm_vcpu *vcpu)
>> +{
>> +     if (nested_param && cpus_have_const_cap(ARM64_HAS_NESTED_VIRT)
>> +         && test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features))
>> +             return true;
>
> you could initialize a bool in init_nested_virt which you then check
> here to avoid duplicating the logic.

I can make a bool to check the kernel param and the capability. The
third one is per VM given by the userspace, so we don't know it when
we initialize the host hypervisor. We can potentially have a bool in
kvm_vcpu_arch or kvm_arch to cache the whole three conditions, if that
sounds ok.

>
>> +
>> +     return false;
>> +}
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 1c1c772..36aae3a 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1478,6 +1478,10 @@ int kvm_arch_init(void *opaque)
>>       if (err)
>>               goto out_err;
>>
>> +     err = init_nested_virt();
>> +     if (err)
>> +             return err;
>> +
>>       err = init_subsystems();
>>       if (err)
>>               goto out_hyp;
>> --
>> 1.9.1
>>
