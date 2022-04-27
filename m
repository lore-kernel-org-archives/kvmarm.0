Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C66C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 01:39:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FFAD410DA;
	Tue, 26 Apr 2022 21:39:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kM7CUNVOh1YO; Tue, 26 Apr 2022 21:39:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919344B1EF;
	Tue, 26 Apr 2022 21:39:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2A04B1D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 21:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DKOx8fE9Q5I1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 21:39:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 768404B11A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 21:39:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651023560;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Mv2PG0J16u04IOE7IzppCh3+OrinjhIx5rulSiUSyN4=;
 b=Xtx8RlM6pPtV8NOBncrhsqJcu/3Tg4JLNZfUytZFWK9r1pZk5bcq0HUhmLlFjGgq9z15Jp
 VWHxz/5XISLUDf9088kOihAmSykIxNec61lupeFWGgIiBAZnW/TvLm7Ty5KFeQvdetsaBP
 4nkc8ogCm0NgCe27kFtd5JUQIIuWmN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-WznQarsDP92TVFdxSRKtzg-1; Tue, 26 Apr 2022 21:39:03 -0400
X-MC-Unique: WznQarsDP92TVFdxSRKtzg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF98729ABA19;
 Wed, 27 Apr 2022 01:39:02 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 78B0A1468F20;
 Wed, 27 Apr 2022 01:38:55 +0000 (UTC)
Subject: Re: [PATCH v6 2/9] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
To: Raghavendra Rao Ananta <rananta@google.com>
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-3-rananta@google.com>
 <bbaf7dcf-e776-49df-7a12-04b45e4af881@redhat.com>
 <CAJHc60w6YngA7iz=mUfjAEjQdwjG_pj2T9Cpd21xzU1Y_APCwQ@mail.gmail.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <5d8beda7-f7f7-dc1f-79b9-b12314c6d603@redhat.com>
Date: Wed, 27 Apr 2022 09:38:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAJHc60w6YngA7iz=mUfjAEjQdwjG_pj2T9Cpd21xzU1Y_APCwQ@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Raghavendra,

On 4/27/22 12:44 AM, Raghavendra Rao Ananta wrote:
> On Mon, Apr 25, 2022 at 11:34 PM Gavin Shan <gshan@redhat.com> wrote:
>> On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
>>> KVM regularly introduces new hypercall services to the guests without
>>> any consent from the userspace. This means, the guests can observe
>>> hypercall services in and out as they migrate across various host
>>> kernel versions. This could be a major problem if the guest
>>> discovered a hypercall, started using it, and after getting migrated
>>> to an older kernel realizes that it's no longer available. Depending
>>> on how the guest handles the change, there's a potential chance that
>>> the guest would just panic.
>>>
>>> As a result, there's a need for the userspace to elect the services
>>> that it wishes the guest to discover. It can elect these services
>>> based on the kernels spread across its (migration) fleet. To remedy
>>> this, extend the existing firmware pseudo-registers, such as
>>> KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
>>> for all the hypercall services available.
>>>
>>> These firmware registers are categorized based on the service call
>>> owners, but unlike the existing firmware pseudo-registers, they hold
>>> the features supported in the form of a bitmap.
>>>
>>> During the VM initialization, the registers are set to upper-limit of
>>> the features supported by the corresponding registers. It's expected
>>> that the VMMs discover the features provided by each register via
>>> GET_ONE_REG, and write back the desired values using SET_ONE_REG.
>>> KVM allows this modification only until the VM has started.
>>>
>>> Some of the standard features are not mapped to any bits of the
>>> registers. But since they can recreate the original problem of
>>> making it available without userspace's consent, they need to
>>> be explicitly added to the case-list in
>>> kvm_hvc_call_default_allowed(). Any function-id that's not enabled
>>> via the bitmap, or not listed in kvm_hvc_call_default_allowed, will
>>> be returned as SMCCC_RET_NOT_SUPPORTED to the guest.
>>>
>>> Older userspace code can simply ignore the feature and the
>>> hypercall services will be exposed unconditionally to the guests,
>>> thus ensuring backward compatibility.
>>>
>>> In this patch, the framework adds the register only for ARM's standard
>>> secure services (owner value 4). Currently, this includes support only
>>> for ARM True Random Number Generator (TRNG) service, with bit-0 of the
>>> register representing mandatory features of v1.0. Other services are
>>> momentarily added in the upcoming patches.
>>>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_host.h | 12 ++++
>>>    arch/arm64/include/uapi/asm/kvm.h |  9 +++
>>>    arch/arm64/kvm/arm.c              |  1 +
>>>    arch/arm64/kvm/guest.c            |  8 ++-
>>>    arch/arm64/kvm/hypercalls.c       | 94 +++++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/psci.c             | 13 +++++
>>>    include/kvm/arm_hypercalls.h      |  6 ++
>>>    include/kvm/arm_psci.h            |  2 +-
>>>    8 files changed, 142 insertions(+), 3 deletions(-)
>>>
>>
>> Some nits as below, please consider to improve if you need another
>> respin.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 94a27a7520f4..df07f4c10197 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
>>>    struct kvm_arch_memory_slot {
>>>    };
>>>
>>> +/**
>>> + * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
>>> + *
>>> + * @std_bmap: Bitmap of standard secure service calls
>>> + */
>>> +struct kvm_smccc_features {
>>> +     unsigned long std_bmap;
>>> +};
>>> +
>>
>> s/Descriptor/Descriptor of
>>
> Nice catch!
> 
>>>    struct kvm_arch {
>>>        struct kvm_s2_mmu mmu;
>>>
>>> @@ -150,6 +159,9 @@ struct kvm_arch {
>>>
>>>        u8 pfr0_csv2;
>>>        u8 pfr0_csv3;
>>> +
>>> +     /* Hypercall features firmware registers' descriptor */
>>> +     struct kvm_smccc_features smccc_feat;
>>>    };
>>>
>>>    struct kvm_vcpu_fault_info {
>>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>>> index c1b6ddc02d2f..0b79d2dc6ffd 100644
>>> --- a/arch/arm64/include/uapi/asm/kvm.h
>>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>>> @@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
>>>    #define KVM_ARM64_SVE_VLS_WORDS     \
>>>        ((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
>>>
>>> +/* Bitmap feature firmware registers */
>>> +#define KVM_REG_ARM_FW_FEAT_BMAP             (0x0016 << KVM_REG_ARM_COPROC_SHIFT)
>>> +#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)              (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
>>> +                                             KVM_REG_ARM_FW_FEAT_BMAP |      \
>>> +                                             ((r) & 0xffff))
>>> +
>>> +#define KVM_REG_ARM_STD_BMAP                 KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
>>> +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0                0
>>> +
>>>    /* Device Control API: ARM VGIC */
>>>    #define KVM_DEV_ARM_VGIC_GRP_ADDR   0
>>>    #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS      1
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 523bc934fe2f..a37fadbd617e 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>        kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>>>
>>>        set_default_spectre(kvm);
>>> +     kvm_arm_init_hypercalls(kvm);
>>>
>>>        return ret;
>>>    out_free_stage2_pgd:
>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>>> index 0d5cca56cbda..8c607199cad1 100644
>>> --- a/arch/arm64/kvm/guest.c
>>> +++ b/arch/arm64/kvm/guest.c
>>> @@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>
>>>        switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>>>        case KVM_REG_ARM_CORE:  return get_core_reg(vcpu, reg);
>>> -     case KVM_REG_ARM_FW:    return kvm_arm_get_fw_reg(vcpu, reg);
>>> +     case KVM_REG_ARM_FW:
>>> +     case KVM_REG_ARM_FW_FEAT_BMAP:
>>> +             return kvm_arm_get_fw_reg(vcpu, reg);
>>>        case KVM_REG_ARM64_SVE: return get_sve_reg(vcpu, reg);
>>>        }
>>>
>>> @@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>
>>>        switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>>>        case KVM_REG_ARM_CORE:  return set_core_reg(vcpu, reg);
>>> -     case KVM_REG_ARM_FW:    return kvm_arm_set_fw_reg(vcpu, reg);
>>> +     case KVM_REG_ARM_FW:
>>> +     case KVM_REG_ARM_FW_FEAT_BMAP:
>>> +             return kvm_arm_set_fw_reg(vcpu, reg);
>>>        case KVM_REG_ARM64_SVE: return set_sve_reg(vcpu, reg);
>>>        }
>>>
>>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>>> index fa6d9378d8e7..df55a04d2fe8 100644
>>> --- a/arch/arm64/kvm/hypercalls.c
>>> +++ b/arch/arm64/kvm/hypercalls.c
>>> @@ -58,6 +58,48 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>>>        val[3] = lower_32_bits(cycles);
>>>    }
>>>
>>> +static bool kvm_arm_fw_reg_feat_enabled(unsigned long *reg_bmap, unsigned long feat_bit)
>>> +{
>>> +     return test_bit(feat_bit, reg_bmap);
>>> +}
>>> +
>>
>> Might be worhty to be 'inline'. This function would be called
>> frequently.
>>
> I was hoping the compiler would optimize it for us as needed.
> 

Yeah, GCC is smart enough. It could be compiled to inline function
even it's not specified explicitly. I guess __always_inline can be
used here. However, it seems __always_inline isn't used broadly in
kvm/arm64 scope. Anyway, it's not a big deal in this specific case :)

>>> +static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>>> +{
>>> +     switch (func_id) {
>>> +     /*
>>> +      * List of function-ids that are not gated with the bitmapped feature
>>> +      * firmware registers, and are to be allowed for servicing the call by default.
>>> +      */
>>> +     case ARM_SMCCC_VERSION_FUNC_ID:
>>> +     case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
>>> +     case ARM_SMCCC_HV_PV_TIME_FEATURES:
>>> +     case ARM_SMCCC_HV_PV_TIME_ST:
>>> +     case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
>>> +     case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>>> +     case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>>> +             return true;
>>> +     default:
>>> +             return kvm_psci_func_id_is_valid(vcpu, func_id);
>>> +     }
>>> +}
>>> +
>>> +static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
>>> +{
>>> +     struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
>>> +
>>> +     switch (func_id) {
>>> +     case ARM_SMCCC_TRNG_VERSION:
>>> +     case ARM_SMCCC_TRNG_FEATURES:
>>> +     case ARM_SMCCC_TRNG_GET_UUID:
>>> +     case ARM_SMCCC_TRNG_RND32:
>>> +     case ARM_SMCCC_TRNG_RND64:
>>> +             return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
>>> +                                             KVM_REG_ARM_STD_BIT_TRNG_V1_0);
>>> +     default:
>>> +             return kvm_hvc_call_default_allowed(vcpu, func_id);
>>> +     }
>>> +}
>>> +
>>>    int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>    {
>>>        u32 func_id = smccc_get_function(vcpu);
>>> @@ -65,6 +107,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>        u32 feature;
>>>        gpa_t gpa;
>>>
>>> +     if (!kvm_hvc_call_allowed(vcpu, func_id))
>>> +             goto out;
>>> +
>>>        switch (func_id) {
>>>        case ARM_SMCCC_VERSION_FUNC_ID:
>>>                val[0] = ARM_SMCCC_VERSION_1_1;
>>> @@ -155,6 +200,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>                return kvm_psci_call(vcpu);
>>>        }
>>>
>>> +out:
>>>        smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>>>        return 1;
>>>    }
>>> @@ -164,8 +210,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>>>        KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>>>        KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>>>        KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
>>> +     KVM_REG_ARM_STD_BMAP,
>>>    };
>>>
>>> +void kvm_arm_init_hypercalls(struct kvm *kvm)
>>> +{
>>> +     struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
>>> +
>>> +     smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
>>> +}
>>> +
>>>    int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>>>    {
>>>        return ARRAY_SIZE(kvm_arm_fw_reg_ids);
>>> @@ -237,6 +291,7 @@ static int get_kernel_wa_level(u64 regid)
>>>
>>>    int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>    {
>>> +     struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
>>>        void __user *uaddr = (void __user *)(long)reg->addr;
>>>        u64 val;
>>>
>>> @@ -249,6 +304,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>        case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>>                val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
>>>                break;
>>> +     case KVM_REG_ARM_STD_BMAP:
>>> +             val = READ_ONCE(smccc_feat->std_bmap);
>>> +             break;
>>>        default:
>>>                return -ENOENT;
>>>        }
>>> @@ -259,6 +317,40 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>        return 0;
>>>    }
>>>
>>> +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>>> +{
>>> +     int ret = 0;
>>> +     struct kvm *kvm = vcpu->kvm;
>>> +     struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
>>> +     unsigned long *fw_reg_bmap, fw_reg_features;
>>> +
>>> +     switch (reg_id) {
>>> +     case KVM_REG_ARM_STD_BMAP:
>>> +             fw_reg_bmap = &smccc_feat->std_bmap;
>>> +             fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
>>> +             break;
>>> +     default:
>>> +             return -ENOENT;
>>> +     }
>>> +
>>> +     /* Check for unsupported bit */
>>> +     if (val & ~fw_reg_features)
>>> +             return -EINVAL;
>>> +
>>> +     mutex_lock(&kvm->lock);
>>> +
>>> +     /* Return -EBUSY if the VM (any vCPU) has already started running. */
>>> +     if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
>>> +             ret = -EBUSY;
>>> +             goto out;
>>> +     }
>>> +
>>> +     WRITE_ONCE(*fw_reg_bmap, val);
>>> +out:
>>> +     mutex_unlock(&kvm->lock);
>>> +     return ret;
>>> +}
>>> +
>>>    int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>    {
>>>        void __user *uaddr = (void __user *)(long)reg->addr;
>>> @@ -337,6 +429,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>                        return -EINVAL;
>>>
>>>                return 0;
>>> +     case KVM_REG_ARM_STD_BMAP:
>>> +             return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
>>>        default:
>>>                return -ENOENT;
>>>        }
>>> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
>>> index 346535169faa..67d1273e8086 100644
>>> --- a/arch/arm64/kvm/psci.c
>>> +++ b/arch/arm64/kvm/psci.c
>>> @@ -436,3 +436,16 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>>>                return -EINVAL;
>>>        }
>>>    }
>>> +
>>> +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id)
>>> +{
>>> +     /* PSCI 0.1 doesn't comply with the standard SMCCC */
>>> +     if (kvm_psci_version(vcpu) == KVM_ARM_PSCI_0_1)
>>> +             return (func_id == KVM_PSCI_FN_CPU_OFF || func_id == KVM_PSCI_FN_CPU_ON);
>>> +
>>> +     if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
>>> +             ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
>>> +             return true;
>>> +
>>> +     return false;
>>> +}
>>> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
>>> index 5d38628a8d04..499b45b607b6 100644
>>> --- a/include/kvm/arm_hypercalls.h
>>> +++ b/include/kvm/arm_hypercalls.h
>>> @@ -6,6 +6,11 @@
>>>
>>>    #include <asm/kvm_emulate.h>
>>>
>>> +/* Last valid bits of the bitmapped firmware registers */
>>> +#define KVM_REG_ARM_STD_BMAP_BIT_MAX         0
>>> +
>>> +#define KVM_ARM_SMCCC_STD_FEATURES           GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
>>> +
>>
>> s/bits of/bit of
>>
> Great catch again!
> 
>>>    int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>>>
>>>    static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
>>> @@ -42,6 +47,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>>>
>>>    struct kvm_one_reg;
>>>
>>> +void kvm_arm_init_hypercalls(struct kvm *kvm);
>>>    int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
>>>    int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>>>    int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>>> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
>>> index 6e55b9283789..c47be3e26965 100644
>>> --- a/include/kvm/arm_psci.h
>>> +++ b/include/kvm/arm_psci.h
>>> @@ -36,7 +36,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
>>>        return KVM_ARM_PSCI_0_1;
>>>    }
>>>
>>> -
>>>    int kvm_psci_call(struct kvm_vcpu *vcpu);
>>> +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id);
>>>
>>>    #endif /* __KVM_ARM_PSCI_H__ */
>>>
>>
>> Thanks,
>> Gavin
>>
> 
> Thanks for the review, Gavin.
> 

No worries :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
