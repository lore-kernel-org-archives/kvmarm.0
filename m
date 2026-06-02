Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83ACF19D8AC;
	Tue,  2 Jun 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780411771; cv=none; b=WQMVTV0GRbR40j7lOTRRruytAVWVVpkeUCVED7A2QFBcgXIULHPHAWq05ZNwOOSnLtf7zquitKpHHnRVeV6TcKS7a/HtwluRI8w95lf3BpJ48THqeQOaHu5Jk4TaSZzJgMPiiCgE4VBuekKrJo4EYixBA7pKTO/CBNjqIWoibSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780411771; c=relaxed/simple;
	bh=ckmPbFrrlbBCsj+32r73hmSAIZ202Ey2IW5dvzKVFNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxiHvNWis2H3v5Q+uUdoMtN8t18/xeDfT2+OjOrLeVXp5tNMdNKlQ/GABk7qnQV5bp5KB874fEj/rj9bG6oTXHlD1HPfQAes0HoARIxRsmN5nQClUXgWfACKJe2/qPtUNVi/rbd3+QY73RkNZjp5wk7u3lbhF7jqhDzg25YxD4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZLqYKzIH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZLqYKzIH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1632C2B;
	Tue,  2 Jun 2026 07:49:22 -0700 (PDT)
Received: from [192.168.4.242] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C69B3F632;
	Tue,  2 Jun 2026 07:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780411767; bh=ckmPbFrrlbBCsj+32r73hmSAIZ202Ey2IW5dvzKVFNU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZLqYKzIHSP8HMndKGizl+Yq34Zk7NUVyl5P/3st9hoGmkaNtMqXgNlC/7ifQwz9Td
	 6Nu4pINiGvz5KAvzvKb8S70WXr7y9ekxRAVEbLDeBVY9OMsM42pSVPr4AZEVkdcKTP
	 wKov6Yaqztx4g0geip2EIfbYI0dAxwgYIY1JCkB8=
Message-ID: <1bb9da2a-bcc2-4232-944e-0730e9e1f45a@arm.com>
Date: Tue, 2 Jun 2026 15:49:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 14/44] arm64: RMI: Basic infrastructure for creating a
 realm.
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-15-steven.price@arm.com>
 <86ik88ui0g.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86ik88ui0g.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc

On 28/05/2026 08:10, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:22 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Introduce the skeleton functions for creating and destroying a realm.
>> The IPA size requested is checked against what the RMM supports.
>>
>> The actual work of constructing the realm will be added in future
>> patches.
> 
> Again, $SUBJECT doesn't reflect that this is purely a KVM patch.
> 
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Rebased and updated to RMM-v2.0-bet1.
>>   * Auxiliary granules have been removed in RMM-v2.0-bet1
>> Changes since v12:
>>   * Drop the RMM_PAGE_{SHIFT,SIZE} defines - the RMM is now configured to
>>     be the same as the host's page size.
>>   * Rework delegate/undelegate functions to use the new RMI range based
>>     operations.
>> Changes since v11:
>>   * Major rework to drop the realm configuration and make the
>>     construction of realms implicit rather than driven by the VMM
>>     directly.
>>   * The code to create RDs, handle VMIDs etc is moved to later patches.
>> Changes since v10:
>>   * Rename from RME to RMI.
>>   * Move the stage2 cleanup to a later patch.
>> Changes since v9:
>>   * Avoid walking the stage 2 page tables when destroying the realm -
>>     the real ones are not accessible to the non-secure world, and the RMM
>>     may leave junk in the physical pages when returning them.
>>   * Fix an error path in realm_create_rd() to actually return an error value.
>> Changes since v8:
>>   * Fix free_delegated_granule() to not call kvm_account_pgtable_pages();
>>     a separate wrapper will be introduced in a later patch to deal with
>>     RTTs.
>>   * Minor code cleanups following review.
>> Changes since v7:
>>   * Minor code cleanup following Gavin's review.
>> Changes since v6:
>>   * Separate RMM RTT calculations from host PAGE_SIZE. This allows the
>>     host page size to be larger than 4k while still communicating with an
>>     RMM which uses 4k granules.
>> Changes since v5:
>>   * Introduce free_delegated_granule() to replace many
>>     undelegate/free_page() instances and centralise the comment on
>>     leaking when the undelegate fails.
>>   * Several other minor improvements suggested by reviews - thanks for
>>     the feedback!
>> Changes since v2:
>>   * Improved commit description.
>>   * Improved return failures for rmi_check_version().
>>   * Clear contents of PGD after it has been undelegated in case the RMM
>>     left stale data.
>>   * Minor changes to reflect changes in previous patches.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h | 29 ++++++++++++++
>>   arch/arm64/include/asm/kvm_rmi.h     | 51 +++++++++++++++++++++++++
>>   arch/arm64/kvm/arm.c                 | 12 ++++++
>>   arch/arm64/kvm/mmu.c                 | 12 +++++-
>>   arch/arm64/kvm/rmi.c                 | 57 ++++++++++++++++++++++++++++
>>   5 files changed, 159 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 5bf3d7e1d92c..82fd777bd9bb 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -688,4 +688,33 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>>   			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>>   	}
>>   }
>> +
>> +static inline bool kvm_is_realm(struct kvm *kvm)
>> +{
>> +	if (static_branch_unlikely(&kvm_rmi_is_available))
>> +		return kvm->arch.is_realm;
>> +	return false;
>> +}
>> +
>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>> +{
>> +	return READ_ONCE(kvm->arch.realm.state);
>> +}
>> +
>> +static inline void kvm_set_realm_state(struct kvm *kvm,
>> +				       enum realm_state new_state)
>> +{
>> +	WRITE_ONCE(kvm->arch.realm.state, new_state);
>> +}
>> +
>> +static inline bool kvm_realm_is_created(struct kvm *kvm)
>> +{
>> +	return kvm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>> +}
>> +
>> +static inline bool vcpu_is_rec(const struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
>> +
>>   #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 4936007947fd..9de34983ee52 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -6,12 +6,63 @@
>>   #ifndef __ASM_KVM_RMI_H
>>   #define __ASM_KVM_RMI_H
>>   
>> +#include <asm/rmi_smc.h>
>> +
>> +/**
>> + * enum realm_state - State of a Realm
>> + */
>> +enum realm_state {
>> +	/**
>> +	 * @REALM_STATE_NONE:
>> +	 *      Realm has not yet been created. rmi_realm_create() has not
>> +	 *      yet been called.
>> +	 */
>> +	REALM_STATE_NONE,
>> +	/**
>> +	 * @REALM_STATE_NEW:
>> +	 *      Realm is under construction, rmi_realm_create() has been
>> +	 *      called, but it is not yet activated. Pages may be populated.
>> +	 */
>> +	REALM_STATE_NEW,
>> +	/**
>> +	 * @REALM_STATE_ACTIVE:
>> +	 *      Realm has been created and is eligible for execution with
>> +	 *      rmi_rec_enter(). Pages may no longer be populated with
>> +	 *      rmi_data_create().
>> +	 */
>> +	REALM_STATE_ACTIVE,
>> +	/**
>> +	 * @REALM_STATE_DYING:
>> +	 *      Realm is in the process of being destroyed or has already been
>> +	 *      destroyed.
>> +	 */
>> +	REALM_STATE_DYING,
>> +	/**
>> +	 * @REALM_STATE_DEAD:
>> +	 *      Realm has been destroyed.
>> +	 */
>> +	REALM_STATE_DEAD
>> +};
> 
> What is the ABI status of this state? Is it purely internal to KVM? Or
> is it something that the RMM actively tracks?

The states are in line with what the RMM maintains for the Realm state,
(Section A2.2.5 Realm Lifecycle)
except for :

1. REALM_STATE_DYING is really a KVM internal state to indicate, we
are in the process of destroying the Realm and no further requests
needs to be serviced

2. We don't track the REALM_SYSTEM_OFF, REALM_ZOMBIE states separately
as we :
  a) Always TERMINATE the Realm, just before the DESTROY
  b) SYSTEM_OFF is naturally triggering the tear down path, leading to 
DYING.




> 
>> +
>>   /**
>>    * struct realm - Additional per VM data for a Realm
>> + *
>> + * @state: The lifetime state machine for the realm
>> + * @rd: Kernel mapping of the Realm Descriptor (RD)
>> + * @params: Parameters for the RMI_REALM_CREATE command
>> + * @ia_bits: Number of valid Input Address bits in the IPA
>>    */
>>   struct realm {
>> +	enum realm_state state;
>> +	void *rd;
> 
> Why is this void? Doesn't it have a proper type?

Not really. This is an object that RMM manages (Realm Descriptor)
in the Realm world. We use it as a parameter to address the Realm.


> 
>> +	struct realm_params *params;
>> +	unsigned int ia_bits;
> 
> Consider reordering this structure to avoid holes.
> 
>>   };
>>   
>>   void kvm_init_rmi(void);
>> +u32 kvm_realm_ipa_limit(void);
> 
> The use of 'realm' is confusing. This is not a per-realm property, but
> something global. I'd rather reserve the term 'realm' for CCA VMs (cue
> the two prototypes below).

Agreed. Perhaps, kvm_rmm_ipa_limit() ?


> 
>> +
>> +int kvm_init_realm(struct kvm *kvm);
>> +void kvm_destroy_realm(struct kvm *kvm);
>>   
>>   #endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 247e03b33035..18251e561524 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -264,6 +264,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   
>>   	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>>   
>> +	/* Initialise the realm bits after the generic bits are enabled */
>> +	if (kvm_is_realm(kvm)) {
>> +		ret = kvm_init_realm(kvm);
>> +		if (ret)
>> +			goto err_uninit_mmu;
>> +	}
>> +
>>   	return 0;
>>   
>>   err_uninit_mmu:
>> @@ -326,6 +333,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>   	kvm_unshare_hyp(kvm, kvm + 1);
>>   
>>   	kvm_arm_teardown_hypercalls(kvm);
>> +	if (kvm_is_realm(kvm))
>> +		kvm_destroy_realm(kvm);
>>   }
>>   
>>   static bool kvm_has_full_ptr_auth(void)
>> @@ -486,6 +495,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   		else
>>   			r = kvm_supports_cacheable_pfnmap();
>>   		break;
>> +	case KVM_CAP_ARM_RMI:
>> +		r = static_key_enabled(&kvm_rmi_is_available);
>> +		break;
>>   
>>   	default:
>>   		r = 0;
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index d089c107d9b7..ba8286472286 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -877,10 +877,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>>   
>>   static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>>   {
>> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>   	u32 kvm_ipa_limit = get_kvm_ipa_limit();
>>   	u64 mmfr0, mmfr1;
>>   	u32 phys_shift;
>>   
>> +	if (kvm_is_realm(kvm))
>> +		kvm_ipa_limit = kvm_realm_ipa_limit();
>> +
>>   	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>>   	if (is_protected_kvm_enabled()) {
>>   		phys_shift = kvm_ipa_limit;
>> @@ -974,6 +978,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>   		return -EINVAL;
>>   	}
>>   
>> +	mmu->arch = &kvm->arch;
>> +
>>   	err = kvm_init_ipa_range(mmu, type);
>>   	if (err)
>>   		return err;
>> @@ -982,7 +988,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>   	if (!pgt)
>>   		return -ENOMEM;
>>   
>> -	mmu->arch = &kvm->arch;
> 
> Why moving this init?

Because, we need to know the "kvm" instance for kvm_init_ipa_range to
detect the limit that applies to Realms.

> 
>>   	err = KVM_PGT_FN(kvm_pgtable_stage2_init)(pgt, mmu, &kvm_s2_mm_ops);
>>   	if (err)
>>   		goto out_free_pgtable;
>> @@ -1114,7 +1119,10 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>   	write_unlock(&kvm->mmu_lock);
>>   
>>   	if (pgt) {
>> -		kvm_stage2_destroy(pgt);
>> +		if (!kvm_is_realm(kvm))
>> +			kvm_stage2_destroy(pgt);
>> +		else
>> +			kvm_pgtable_stage2_destroy_pgd(pgt);
> 
> Why can't you make kvm_stage2_destroy() do the right thing? Surely the
> PTs have to be reclaimed one way or another.

Actually yes, we could make it work. We need to skip walking the page
table for Realms. We may be able to do the checks via 
pgt->mmu->arch->kvm and skip the walking for Realms. ( The S2 is 
unmapped and torn
down before the RD is destroyed in kvm_destroy_realm(). We can't
rely on the contents of the PGDs to be zero - e.g., with MEC.)



> 
>>   		kfree(pgt);
>>   	}
>>   }
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 6e28b669ded2..f51ec667445e 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -5,6 +5,8 @@
>>   
>>   #include <linux/kvm_host.h>
>>   
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_mmu.h>
>>   #include <asm/kvm_pgtable.h>
>>   #include <asm/rmi_cmds.h>
>>   #include <asm/virt.h>
>> @@ -14,6 +16,61 @@ static bool rmi_has_feature(unsigned long feature)
>>   	return !!u64_get_bits(rmm_feat_reg0, feature);
>>   }
>>   
>> +u32 kvm_realm_ipa_limit(void)
>> +{
>> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>> +}
>> +
>> +void kvm_destroy_realm(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>> +
>> +	if (realm->params) {
>> +		free_page((unsigned long)realm->params);
>> +		realm->params = NULL;
>> +	}
>> +
>> +	if (!kvm_realm_is_created(kvm))
>> +		return;
>> +
>> +	kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +
>> +	write_lock(&kvm->mmu_lock);
>> +	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
>> +			       BIT(realm->ia_bits - 1), true);
>> +	write_unlock(&kvm->mmu_lock);
>> +
>> +	if (realm->rd) {
>> +		phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +
>> +		if (WARN_ON(rmi_realm_terminate(rd_phys)))
>> +			return;
>> +
>> +		if (WARN_ON(rmi_realm_destroy(rd_phys)))
>> +			return;
>> +		free_delegated_page(rd_phys);
>> +		realm->rd = NULL;
>> +	}
>> +
>> +	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys, pgd_size)))
>> +		return;
>> +
>> +	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
>> +
>> +	/* Now that the Realm is destroyed, free the entry level RTTs */
>> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +}
> 
> This really needs documentation: what happens at each stage? What
> memory is reclaimed when?

Agreed.

> 
> But even more importantly, why is this built in a completely parallel
> way, potentially deviating from the existing KVM S2 management?


RMM requires a Realm is not live at the time of REALM_DESTROY.
(See section A2.2.4 Realm Liveness).
i.e., All RECs are destroyed, Root RTTs wiped clean (no live mappings)
before the RD is destroyed. So, we need to make sure all of this is
done at Realm Destroy. Hence we delay the kvm_free_stage2_pgd() until
we destroy the RD.

Does that help? May be we could improve the comments around it.


Suzuki



 > Thanks,>
> 	M.
> 

