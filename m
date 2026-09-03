Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9193A37F307
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 04:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788409226; cv=none; b=meg9kPjcckCoY3MUmPpa32JP5xL+p9ZP2fy1qpweNJhjlSH4nMyloGcRo51KgNp1FcyaOFPuncugjSsjMpWLIusmHjnrwebAPu5AfpC6v8hCDeLzQ9lbNDxlM5wATJmwxkrwm7ExKv7++iS8uvjoZ97BldUoQuDic0Nz6J03tnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788409226; c=relaxed/simple;
	bh=C/PK3HXag8qXRH9c8xtWWdW2fXSrtfEg8KKZFjgxe+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tco1ssPImxldXe/3cGNXziHZZexsEP53n+CVeKKKv8R5WNABdT7jmqi/+ilVzphKurfTqrM8ldh7drfoDpMppayjmKrtwf+dF4Y7dh/bAZ+3Bme8zfa0K0TjQuZ1v6pai3EKpl0QVPHXZ9/7pCWam67M7gmbVoheLCfCTraX/oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bOxjTYaD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bOxjTYaD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788409219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3P7NpmOmk2ABCw8iJwdV/KiXhnMi3Qc07wbIF+3iCtE=;
	b=bOxjTYaDHZWqBpu7TtwLXU2a9r0YSapRkixzb1IvYvRYnE72RmR8B73rAWLUcNkR6zeOI9
	2GQPtK/RCVwQB5Pxb6+cw9s180v52NdlhkOE7lmjLoQt2DVYnPTL+fxPb4loVVrlKwBHxk
	uyAq0lrj3qeru4iCgetE6CL9sprKQLw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-WGt7ASYJOveVDPlQLCqG1A-1; Thu, 03 Sep 2026 00:20:18 -0400
X-MC-Unique: WGt7ASYJOveVDPlQLCqG1A-1
X-Mimecast-MFC-AGG-ID: WGt7ASYJOveVDPlQLCqG1A_1788409217
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1c18c775eso696509a12.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 21:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788409217; x=1789014017;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3P7NpmOmk2ABCw8iJwdV/KiXhnMi3Qc07wbIF+3iCtE=;
        b=eZosa8B7o9iMCYoPgKBIPoN4Aly+HR/wz4J0Ct084PGS5VQGDzd9aXyLflQUGMbqZI
         D/0GrrCkBxCkMGovP8alFkcM1wmuq1N9RQjEVrbmgd3SmtWnRMOZjhiWyEjx8PxLbjS8
         Z2HacTpnEyvf7FthBKxUKCq/FK2OzfUEBpusw4p5gFfIGcPfvTSnnjeGm2/d8ZyYc5RV
         Ry0vqW2ceqDj0Kt0BT78Ri4S0ujdFr6EGA47auQwthzM89tCeY1LT2LwSZERS+2XeCkW
         5I+g1c1vT2Iy6avEr1yj0g+Sfx1XnZQIqgqX5uDu40fJg24cZTd75Jeu2LXFm2zUbvKk
         gSxw==
X-Forwarded-Encrypted: i=1; AKwUvBwpmoy1G3C+GK4w7mcooSOwkFQy2RUehOLkoKJVvtgBC+7LqGDYyInu7NVCPUq7PYWdD5smHgQ=@lists.linux.dev
X-Gm-Message-State: AFuF++m9FHhqV1rCxNBOO9OjDp0HxHeCusYSE19xr3+izaQSJ2L+dwSO
	Aj2mmJy/KCtQcldBuv75mdkbGu25Qlb8UsT70wmgKkG//HJkrFqwYyTkICvlzSG+4F/SpvHZMXT
	AAoxd+PE2+rCErZ15y2baCn2BiavusSwdcw4w12bs2+lEX4j0rBY/snl0gw==
X-Gm-Gg: AYBFou18eO2ldKgn8rPnId3D8ypKbTsCQsAGM4z1+Zg8FZMjHQS2rELtS1CQsOXWLnm
	d5qk80BRhSghmS3ayiKg5F4zUPO3B9ciuJpH7rY1yKHyaUqFuiNIWmQKVTFPilOlyJ2ozhA+1gX
	MHebvvrqzTyxXrv6/9AMRUWR0yZPMdE+6WrmgslrOdJKT0ovtEKqS53GZ04f87ujjH1cnwUQHt/
	ItI9Xx0SwGEJufx7PzoNtq1u+qIc/KiGOhno001tzfVSRRSaSFovGXDFSKBxaw/OuHeN68yBIv7
	9Ga9AJYXyBjp6ndCVfoQWEkLL2BUb77tzrVn+ctbPWMy8EoTK4GAVpjO0NSRfq0jI/6/8OSDhzD
	/I8BBhCBp92cAykFk3vuq1wFML6YdoYb3etXSOKEpNA==
X-Received: by 2002:a17:90b:5242:b0:381:10a3:8b10 with SMTP id 98e67ed59e1d1-39b08046aaamr3997763a91.14.1788409216769;
        Wed, 02 Sep 2026 21:20:16 -0700 (PDT)
X-Received: by 2002:a17:90b:5242:b0:381:10a3:8b10 with SMTP id 98e67ed59e1d1-39b08046aaamr3997701a91.14.1788409216155;
        Wed, 02 Sep 2026 21:20:16 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33253672941sm2617105eec.3.2026.09.02.21.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 21:20:15 -0700 (PDT)
Message-ID: <551014ec-eafc-4a63-92f1-6efcf1ca4db1@redhat.com>
Date: Thu, 3 Sep 2026 14:20:01 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 14/45] KVM: arm64: CCA: Add basic infrastructure for
 creating a realm
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-15-steven.price@arm.com>
 <c9608c82-d4ff-4c0f-8f7b-1793ed205566@redhat.com>
 <56aa7422-ded5-449c-ba62-e7e56d229587@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <56aa7422-ded5-449c-ba62-e7e56d229587@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lrn0euCVlqJq7LdeHeOfMt1sTwoMkcB6pAQWKsijWRk_1788409217
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/3/26 1:11 AM, Suzuki K Poulose wrote:
> On 01/09/2026 05:07, Gavin Shan wrote:
>> Hi Steve,
>>
>> On 8/3/26 11:43 PM, Steven Price wrote:
>>> Introduce the skeleton functions for creating and destroying a realm.
>>> The IPA size requested is checked against what the RMM supports.
>>>
>>> The actual work of constructing the realm will be added in future
>>> patches.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v15:
>>>   * Remove realm->params and only temporarily allocate the page when the
>>>     realm is being created.
>>
>> [...]
>>
>>> ---
>>>   arch/arm64/include/asm/kvm_emulate.h | 24 +++++++++++
>>>   arch/arm64/include/asm/kvm_rmi.h     | 63 ++++++++++++++++++++++++++++
>>>   arch/arm64/kvm/arm.c                 | 12 ++++++
>>>   arch/arm64/kvm/mmu.c                 | 18 +++++++-
>>>   arch/arm64/kvm/rmi.c                 | 56 +++++++++++++++++++++++++
>>>   5 files changed, 171 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/ include/asm/kvm_emulate.h
>>> index 5bf3d7e1d92c..e26d6755279f 100644
>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>> @@ -688,4 +688,28 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>>>               vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>>>       }
>>>   }
>>> +
>>> +static inline bool kvm_is_realm(struct kvm *kvm)
>>> +{
>>> +    if (static_branch_unlikely(&kvm_rmi_is_available))
>>> +        return kvm->arch.is_realm;
>>> +    return false;
>>> +}
>>> +
>>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>>> +{
>>> +    return READ_ONCE(kvm->arch.realm.state);
>>> +}
>>> +
>>> +static inline void kvm_set_realm_state(struct kvm *kvm,
>>> +                       enum realm_state new_state)
>>> +{
>>> +    WRITE_ONCE(kvm->arch.realm.state, new_state);
>>> +}
>>> +
>>> +static inline bool kvm_realm_is_created(struct kvm *kvm)
>>> +{
>>> +    return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>>> +}
>>> +
>>>   #endif /* __ARM64_KVM_EMULATE_H__ */
>>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/ asm/kvm_rmi.h
>>> index 57d24b244c95..cefd00b76806 100644
>>> --- a/arch/arm64/include/asm/kvm_rmi.h
>>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>>> @@ -6,12 +6,75 @@
>>>   #ifndef __ASM_KVM_RMI_H
>>>   #define __ASM_KVM_RMI_H
>>> +#include <linux/arm-smccc-rmi.h>
>>> +
>>> +/**
>>> + * enum realm_state - State of a Realm
>>> + *
>>> + * Mirrors the RMM's Realm lifecycle states where they are meaningful to KVM,
>>> + * with REALM_STATE_DYING being a KVM-internal state used to prevent further
>>> + * requests while teardown is in progress. KVM does not track REALM_SYSTEM_OFF
>>> + * or REALM_ZOMBIE separately as they naturally lead to teardown.
>>> + */
>>> +enum realm_state {
>>> +    /**
>>> +     * @REALM_STATE_NONE:
>>> +     *      Realm has not yet been created. rmi_realm_create() has not
>>> +     *      yet been called.
>>> +     */
>>> +    REALM_STATE_NONE,
>>> +    /**
>>> +     * @REALM_STATE_NEW:
>>> +     *      Realm is under construction, rmi_realm_create() has been
>>> +     *      called, but it is not yet activated. Pages may be populated.
>>> +     */
>>> +    REALM_STATE_NEW,
>>> +    /**
>>> +     * @REALM_STATE_ACTIVE:
>>> +     *      Realm has been created and is eligible for execution with
>>> +     *      rmi_rec_enter(). Pages may no longer be populated with
>>> +     *      rmi_data_create().
>>> +     */
>>> +    REALM_STATE_ACTIVE,
>>> +    /**
>>> +     * @REALM_STATE_DYING:
>>> +     *      Realm is in the process of being destroyed or has already been
>>> +     *      destroyed.
>>> +     */
>>> +    REALM_STATE_DYING,
>>> +    /**
>>> +     * @REALM_STATE_DEAD:
>>> +     *      Realm has been destroyed.
>>> +     */
>>> +    REALM_STATE_DEAD
>>> +};
>>> +
>>>   /**
>>>    * struct realm - Additional per VM data for a Realm
>>> + *
>>> + * @rd: Kernel mapping of the RMM-managed Realm Descriptor (RD) granule
>>> + * @sro: Preallocated SRO state context for Realm MMU operations
>>> + * @state: The lifetime state machine for the realm
>>> + * @ia_bits: Number of valid Input Address bits in the IPA
>>>    */
>>>   struct realm {
>>> +    void *rd;
>>> +    /*
>>> +     * Reused by RTT map/unmap SRO commands. Those commands are only
>>> +     * issued from Realm stage-2 map/unmap paths while kvm->mmu_lock is
>>> +     * held for write, including Realm fault handling where
>>> +     * kvm_fault_lock() takes the write side, so concurrent use is
>>> +     * serialized.
>>> +     */
>>> +    struct rmi_sro_state *sro;
>>> +    enum realm_state state;
>>> +    unsigned int ia_bits;
>>>   };
>>>   void kvm_init_rmi(void);
>>> +u32 kvm_rmm_ipa_limit(void);
>>> +
>>> +int kvm_init_realm(struct kvm *kvm);
>>> +void kvm_destroy_realm(struct kvm *kvm);
>>>   #endif /* __ASM_KVM_RMI_H */
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index b961c22fce3d..c4d906861736 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -266,6 +266,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>>       bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>>> +    /* Initialise the realm bits after the generic bits are enabled */
>>> +    if (kvm_is_realm(kvm)) {
>>> +        ret = kvm_init_realm(kvm);
>>> +        if (ret)
>>> +            goto err_uninit_mmu;
>>> +    }
>>> +
>>>       return 0;
>>>   err_uninit_mmu:
>>> @@ -328,6 +335,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>>       kvm_unshare_hyp(kvm, kvm + 1);
>>>       kvm_arm_teardown_hypercalls(kvm);
>>> +    if (kvm_is_realm(kvm))
>>> +        kvm_destroy_realm(kvm);
>>>   }
>>>   static bool kvm_has_full_ptr_auth(void)
>>> @@ -488,6 +497,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>           else
>>>               r = kvm_supports_cacheable_pfnmap();
>>>           break;
>>> +    case KVM_CAP_ARM_RMI:
>>> +        r = static_key_enabled(&kvm_rmi_is_available);
>>> +        break;
>>>       default:
>>>           r = 0;
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 6c941aaa10c6..8b9efa8a3539 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -904,10 +904,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>>>   static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>>>   {
>>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>>       u32 kvm_ipa_limit = get_kvm_ipa_limit();
>>>       u64 mmfr0, mmfr1;
>>>       u32 phys_shift;
>>> +    if (kvm_is_realm(kvm))
>>> +        kvm_ipa_limit = kvm_rmm_ipa_limit();
>>> +
>>>       phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>>>       if (is_protected_kvm_enabled()) {
>>>           phys_shift = kvm_ipa_limit;
>>
>> get_kvm_ipa_limit() and variable 'kvm_ipa_limit' have been exposed through
>> KVM_CAP_ARM_VM_IPA_SIZE for both normal and realm VMs in this series. However,
>> the IPA limit determined by the feature-register-0 in TF-RMM, which is returned
>> by kvm_rmm_ipa_limit(), can be different from 'kvm_ipa_limit'.
>>
>> This brings confusion to VMM like qemu, where the request to create a realm VM is
>> rejected if the requested IPA size exceeds the limit, exposed by the host through
>> KVM_CAP_ARM_VM_IPA_SIZE. So the host needs to return correct IPA limit through
>> KVM_CAP_ARM_VM_IPA_SIZE for realm VM somewhere in this series?
> 
> You're right that the limit exposed by the KVM_CAP_ARM_VM_IPA_SIZE
> doesn't tell the VMM about the limit imposed by the RMM. The only way
> to expose this is via an ioctl() on the KVM VM fd. But the VM fd is
> created with an argument (type), which on arm64 unfortunately specifies
> the IPA Size. So, this is kind of a chicken and egg problem. Or the
> VMM can create a dummy Realm VM (with default IPA size of 0) and then
> run the cap.
> 
> On the other hand, given the Realm creation is measured, if the Realm
> can't be created with the "IPA Size" requested by the user, then there
> is no point in creating the Realm VM.
> 
> So, we decided that this failure condition was alright.
> 
> This was mentioned in one of the versions of the series, but got lost
> in the revisions.
> 
> If there is interest in getting this exposed, we could do something
> like the above. Or, the other option is limit the IPA size of the VM
> that can be created to RMM IPA limit, when we explicitly choose the
> KVM mode to be CCA (this is something that is coming in the next
> version)
> 

I was even wandering if KVM_CAP_ARM_RMI can be extended to return the limit.
For example, KVM_CAP_ARM_RMI is renamed to KVM_CAP_ARM_REALM_IPA_SIZE. 0 is
returned if Realm VM isn't supported. Otherwise, the IPA size enforced by
TF-RMM through the feature-register-0 is returned.

With above extension, the existing KVM_CAP_ARM_VM_IPA_SIZE is dedicated to
query the IPA size for the regular (or normal) VM, while KVM_CAP_ARM_REALM_IPA_SIZE
is used to get the IPA size for the Realm VM. VMM needs to decide which one
is to be used.

Another option could be splitting @arg in kvm_vm_ioctl_check_extension() into
two parts: (a) Indicator of the scope; (b) Specific capability. For (a), it
could be categorized into: (1) 0, global and not specific to any types of VMs;
(2) 1, indicating the capability is associated with a regular (normal) VM; (3)
2, indicating the capability is associated with a Realm VM. With this extension,
VMM uses ioctl(kvm_fd, KVM_CHECK_EXTENSION, (2UL << 48) | KVM_CAP_ARM_VM_IPA_SIZE)
to retrieve the IPA size of Realm VM that is enforced by TF-RMM. Besides, I'm not
sure if pKVM can be benefited from this splitting in long term.

Thanks,
Gavin
>>> @@ -957,9 +961,18 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
>>>   static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>>>   {
>>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>>>       unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
>>> -    stage2_destroy_range(pgt, 0, BIT(ia_bits));
>>> +    /*
>>> +     * Realm RTTs are inaccessible to the host and may contain stale data
>>> +     * after the RMM has released them. The non-root RTTs are explicitly
>>> +     * destroyed through RMI before the RD is destroyed; only the root PGD
>>> +     * pages remain to be freed here.
>>> +     */
>>> +    if (!kvm_is_realm(kvm))
>>> +        stage2_destroy_range(pgt, 0, BIT(ia_bits));
>>> +
>>>       KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>>>   }
>>> @@ -1001,6 +1014,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>>           return -EINVAL;
>>>       }
>>> +    mmu->arch = &kvm->arch;
>>> +
>>>       err = kvm_init_ipa_range(mmu, type);
>>>       if (err)
>>>           return err;
>>> @@ -1009,7 +1024,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>>       if (!pgt)
>>>           return -ENOMEM;
>>> -    mmu->arch = &kvm->arch;
>>>       err = KVM_PGT_FN(kvm_pgtable_stage2_init)(pgt, mmu, &kvm_s2_mm_ops);
>>>       if (err)
>>>           goto out_free_pgtable;
>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>> index 247c4f033945..528b01d5d71d 100644
>>> --- a/arch/arm64/kvm/rmi.c
>>> +++ b/arch/arm64/kvm/rmi.c
>>> @@ -5,6 +5,8 @@
>>>   #include <linux/kvm_host.h>
>>> +#include <asm/kvm_emulate.h>
>>> +#include <asm/kvm_mmu.h>
>>>   #include <asm/kvm_pgtable.h>
>>>   #include <asm/rmi_cmds.h>
>>>   #include <asm/virt.h>
>>> @@ -14,6 +16,60 @@ static bool rmi_has_feature(int reg, unsigned long feature)
>>>       return !!u64_get_bits(rmi_feat_reg(reg), feature);
>>>   }
>>> +u32 kvm_rmm_ipa_limit(void)
>>> +{
>>> +    return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>> +}
>>> +
>>> +void kvm_destroy_realm(struct kvm *kvm)
>>> +{
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +    size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>>> +
>>> +    if (!kvm_realm_is_created(kvm)) {
>>> +        kfree(realm->sro);
>>> +        realm->sro = NULL;
>>> +        return;
>>> +    }
>>> +
>>> +    kvm_set_realm_state(kvm, REALM_STATE_DYING);
>>> +
>>> +    if (realm->rd) {
>>> +        phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>> +
>>> +        if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>>> +            return;
>>> +
>>> +        if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>>> +            return;
>>> +        free_delegated_page(rd_phys);
>>> +        realm->rd = NULL;
>>> +    }
>>> +
>>> +    if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
>>> +                     pgd_size)))
>>> +        return;
>>> +
>>> +    kvm_set_realm_state(kvm, REALM_STATE_DEAD);
>>> +
>>> +    /* Now that the realm is destroyed, free the entry-level RTTs. */
>>> +    kvm_free_stage2_pgd(&kvm->arch.mmu);
>>> +
>>> +    kfree(realm->sro);
>>> +    realm->sro = NULL;
>>> +}
>>> +
>>> +int kvm_init_realm(struct kvm *kvm)
>>> +{
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +
>>> +    realm->sro = kmalloc_obj(*realm->sro);
>>> +    if (!realm->sro)
>>> +        return -ENOMEM;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   static int rmm_check_features(void)
>>>   {
>>>       if (kvm_lpa2_is_enabled() &&
>>
> 

