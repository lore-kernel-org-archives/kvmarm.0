Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937793CE48F;
	Fri, 10 Apr 2026 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775833916; cv=none; b=u9cPLo8Ec1QVooOcRBSE6sLzIrd9KER2kSUcubeydpJa36OrCoH357peqjFADXtPuHoYHV1QU26IJav+3YaUNrZbr7LBnKubpgIWYS2ACVZj5P6A9LOyRWhXEnTgJbvrD/SZ7IRcAitPk/bY7xFG7khAqEluXaE3sXR1+OT65rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775833916; c=relaxed/simple;
	bh=E99sP2/l4L5lvxnw08AtVWLovpakAPKrpGL1rB4Sp50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kCRlyCsp7XNblozwd4EoO2RVZzlVhgyNIOqDrpDGMYUvUI4fMhpywAN5PiwUTJer+eoGC1kOzfHHPH2mxuk0DB3iMJEA/m5t8gM0UWwDkcu1G+LTWFsQVrUcOp0bLKjgW+GkacJQ7hXj8Zfb4/NpY6b75jeK/BHtQnOMYCrR5zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CrmU8kkA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CrmU8kkA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1675C1CE2;
	Fri, 10 Apr 2026 08:11:46 -0700 (PDT)
Received: from [10.1.29.18] (e122027.cambridge.arm.com [10.1.29.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8C5E3FAA1;
	Fri, 10 Apr 2026 08:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775833911; bh=E99sP2/l4L5lvxnw08AtVWLovpakAPKrpGL1rB4Sp50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CrmU8kkAeCl1T9/hmXUaLRliTr0TNVc9sV4DJWOLfxYL/aUmKlbSXPegSJZ7pL/9s
	 xjsl0yUu6nwA16fsWB7zsWmxwhi99CPbGi5ATNyYOBdphSX4sLrK3PVvamQUdYnIzo
	 qqAtvqp+s3ylu2oMLMmGk5c90etdx5Kcz6XdbI+E=
Message-ID: <7f01c643-ccd6-4d8d-ae79-9eb3584e433f@arm.com>
Date: Fri, 10 Apr 2026 16:11:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 15/48] arm64: RMI: RTT tear down
To: Wei-Lin Chang <weilin.chang@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-16-steven.price@arm.com>
 <knluksqra3k56kjisorhids7lm6hzqqqp7s4kq47cribh66hos@ctatngbv263v>
 <ef49030f-1ee7-4473-acc7-c8900acb977d@arm.com>
 <5chegrtlkmet4n5u53wmjbpyflul2dy5o6lpevvxo3hycvyszx@3ogzwuvsbvr3>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <5chegrtlkmet4n5u53wmjbpyflul2dy5o6lpevvxo3hycvyszx@3ogzwuvsbvr3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/03/2026 13:04, Wei-Lin Chang wrote:
> On Fri, Mar 20, 2026 at 04:12:48PM +0000, Steven Price wrote:
>> On 19/03/2026 17:35, Wei-Lin Chang wrote:
>>> On Wed, Mar 18, 2026 at 03:53:39PM +0000, Steven Price wrote:
>>>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>>>> that the RMM creates/destroys entries as necessary. The physical pages
>>>> to store the page tables are delegated to the realm as required, and can
>>>> be undelegated when no longer used.
>>>>
>>>> Creating new RTTs is the easy part, tearing down is a little more
>>>> tricky. The result of realm_rtt_destroy() can be used to effectively
>>>> walk the tree and destroy the entries (undelegating pages that were
>>>> given to the realm).
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> Changes since v12:
>>>>  * Simplify some functions now we know RMM page size is the same as the
>>>>    host's.
>>>> Changes since v11:
>>>>  * Moved some code from earlier in the series to this one so that it's
>>>>    added when it's first used.
>>>> Changes since v10:
>>>>  * RME->RMI rename.
>>>>  * Some code to handle freeing stage 2 PGD moved into this patch where
>>>>    it belongs.
>>>> Changes since v9:
>>>>  * Add a comment clarifying that root level RTTs are not destroyed until
>>>>    after the RD is destroyed.
>>>> Changes since v8:
>>>>  * Introduce free_rtt() wrapper which calls free_delegated_granule()
>>>>    followed by kvm_account_pgtable_pages(). This makes it clear where an
>>>>    RTT is being freed rather than just a delegated granule.
>>>> Changes since v6:
>>>>  * Move rme_rtt_level_mapsize() and supporting defines from kvm_rme.h
>>>>    into rme.c as they are only used in that file.
>>>> Changes since v5:
>>>>  * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
>>>>    a property of the RMM specification not the RME architecture.
>>>> Changes since v2:
>>>>  * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>>>>    later patch when they are actually used.
>>>>  * Some simplifications now rmi_xxx() functions allow NULL as an output
>>>>    parameter.
>>>>  * Improved comments and code layout.
>>>> ---
>>>>  arch/arm64/include/asm/kvm_rmi.h |   7 ++
>>>>  arch/arm64/kvm/mmu.c             |  15 +++-
>>>>  arch/arm64/kvm/rmi.c             | 145 +++++++++++++++++++++++++++++++
>>>>  3 files changed, 166 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>>>> index 0ada525af18f..16a297f3091a 100644
>>>> --- a/arch/arm64/include/asm/kvm_rmi.h
>>>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>>>> @@ -68,5 +68,12 @@ u32 kvm_realm_ipa_limit(void);
>>>>  
>>>>  int kvm_init_realm_vm(struct kvm *kvm);
>>>>  void kvm_destroy_realm(struct kvm *kvm);
>>>> +void kvm_realm_destroy_rtts(struct kvm *kvm);
>>>> +
>>>> +static inline bool kvm_realm_is_private_address(struct realm *realm,
>>>> +						unsigned long addr)
>>>> +{
>>>> +	return !(addr & BIT(realm->ia_bits - 1));
>>>> +}
>>>>  
>>>>  #endif /* __ASM_KVM_RMI_H */
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 9dc242c3b9c8..41152abf55b2 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -1098,10 +1098,23 @@ void stage2_unmap_vm(struct kvm *kvm)
>>>>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>>>  {
>>>>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>>> -	struct kvm_pgtable *pgt = NULL;
>>>> +	struct kvm_pgtable *pgt;
>>>>  
>>>>  	write_lock(&kvm->mmu_lock);
>>>>  	pgt = mmu->pgt;
>>>> +	if (kvm_is_realm(kvm) &&
>>>> +	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>>>> +	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>>>> +		write_unlock(&kvm->mmu_lock);
>>>> +		kvm_realm_destroy_rtts(kvm);
>>>> +
>>>> +		/*
>>>> +		 * The PGD pages can be reclaimed only after the realm (RD) is
>>>> +		 * destroyed. We call this again from kvm_destroy_realm() after
>>>> +		 * the RD is destroyed.
>>>> +		 */
>>>> +		return;
>>>> +	}
>>>
>>> Hi,
>>>
>>> I see that kvm_free_stage2_pgd() will be called twice:
>>>
>>> kvm_destroy_vm()
>>>   mmu_notifier_unregister()
>>>     kvm_mmu_notifier_release()
>>>       kvm_flush_shadow_all()
>>>         kvm_arch_flush_shadow_all()
>>>           kvm_uninit_stage2_mmu()
>>>             kvm_free_stage2_pgd()
>>>   kvm_arch_destroy_vm()
>>>     kvm_destroy_realm()
>>>       kvm_free_stage2_pgd()
>>>
>>> At the first call the realm state is REALM_STATE_ACTIVE, at the second
>>> it is REALM_STATE_DEAD. Reading the comment added to
>>> kvm_free_stage2_pgd() here, does it mean this function is called twice
>>> on purpose? If so do you think it's better to extract this and create
>>> another function instead, then use kvm_is_realm() to choose which to
>>> run? I think it is confusing to have this function run twice for a
>>> realm.
>>
>> So the issue here is that the RMM requires we do things in a different
>> order to a normal VM. For a realm the PGD cannot be destroyed until the
>> realm itself is destroyed - the RMM revent the host undelegating them.
>>
>> So the first call cannot actually do the free - this is the
>> REALM_STATE_ACTIVE case.
>>
>> In kvm_destroy_realm() we tear down the actual realm and undelegate the
>> granules. We then need to actually free the PGD - the "obvious" way of
>> doing that is calling kvm_free_stage2_pgd() as that handles the KVM
>> intricacies - e.g. updating the mmu object.
>>
>> I'm not sure how to structure the code better without causing
>> duplication - I don't want another copy of the cleanup from
>> kvm_free_stage2_pgd() in a CCA specific file because it will most likely
>> get out of sync with the normal VM case. There is a comment added
>> explaining "we call this again" which I hoped would make it less confusing.
>>
> 
> Oh, I see, thanks for letting me know!
> 
> During this I found in the first call of kvm_free_stage2_pgd() it's doing
> kvm_stage2_unmap_range() and kvm_realm_destroy_rtts(), but they are also
> called in kvm_destroy_realm(), is that intentional?
> If they can be called at kvm_destroy_realm() time, could we just not do
> kvm_free_stage2_pgd() in kvm_uninit_stage2_mmu() for realms?
> And if they should be called in kvm_free_stage2_pgd(), could we refactor
> it to something like:
> (just showing the idea, didn't try compiling or anything)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7d7caab8f573..280d2bef8492 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1030,9 +1030,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>  	return err;
>  }
>  
> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
> +{
> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	WARN_ON(kvm_realm_state(kvm) != REALM_STATE_ACTIVE);
> +	write_lock(&kvm->mmu_lock);
> +	kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), true);
> +	write_unlock(&kvm->mmu_lock);
> +	kvm_realm_destroy_rtts(kvm);
> +}
> +
>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>  {
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	if (kvm_is_realm(kvm))
> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
> +	else
> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
> +
>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>  }
>  
> @@ -1117,22 +1133,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>  
>  	write_lock(&kvm->mmu_lock);
>  	pgt = mmu->pgt;
> -	if (kvm_is_realm(kvm) &&
> -	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
> -	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> -		struct realm *realm = &kvm->arch.realm;
> -
> -		kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), true);
> -		write_unlock(&kvm->mmu_lock);
> -		kvm_realm_destroy_rtts(kvm);
>  
> -		/*
> -		 * The PGD pages can be reclaimed only after the realm (RD) is
> -		 * destroyed. We call this again from kvm_destroy_realm() after
> -		 * the RD is destroyed.
> -		 */
> -		return;
> -	}
>  	if (pgt) {
>  		mmu->pgd_phys = 0;
>  		mmu->pgt = NULL;
> 
> Sorry if I missed anything!

No I don't think you've missed anything, that actually does look nicer.
Thanks for the suggestion.

Thanks,
Steve
