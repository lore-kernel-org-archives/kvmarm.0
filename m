Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794588022;
	b=imUajuqOUVxOvXhQPc7ER2mSOJvPd2oxuNGYcGtfjIhvLbsLXKrw5j+fMBYqG/acIYQZ
	 hE2D3t4E/X7U1Rr91UvSZKAqM+62tA/mRd62TQwyDNK5RXxxBzpdqxEAfFZWSm1kI0ap4
	 hLULQ8Sh9CSSbWsRvs7OmcAV79awp9zWXcFTlStOI92o9iwofT6e2EgRUHJvz14wDblh9
	 b1buVfjmw6yLQXICtn0hVHShaL4DBgCTgRbBWg8jhjGaLdhdBD+GnwQCSQOf28F5/mOf/
	 cTgITqwVctWFnsFhPOXFJ3f/jBrIqQjXI3fpHttfHSE1QCvk8TM2++MawOB6wRnc2lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794588022;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=4hrO+e6psKT0G9cQKzDJd2tFoUjCcpj/bUYIzTJU/8M=;
	b=tMmWl1j4q7UhNjoECwjDW7R3c8xfXP0Zl3Aqxyr4TNl5LSAbbtcf3OudJ2yYZekW0cJF
	 94pBk16K4otZiYF13yfc/MvjLrwZ7cc3wCwZobgFBI2CIX5VjIH6pky6Hy6yyIvp+XrQv
	 4w5xTphRrsRcys3A08MxJaUvG1sn4aMYR00y3OAfOy0nd9U7nbQ1mABeYkLqmpDjRTqqz
	 1G1Bk+FXovddhTukjTz9TF7BmA3aNZKeXh4Z6awCwKW+62u8r49/w47hvmvqVTXK/oByf
	 84CJ37XzZEPlmxzfKlReyid3Ow/0H/lODUo6aEwMZCJ+CNWzSMj3l2sM4ITV0PM3x6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XPh8lR4z;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F98D60A263C;
	Fri, 13 Nov 2026 16:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F98D60A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XPh8lR4z
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2191143D;
	Fri, 13 Nov 2026 08:40:16 -0800 (PST)
Received: from [10.0.129.47] (e122027.cambridge.arm.com [10.0.129.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 781C93F673;
	Fri, 13 Nov 2026 08:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794588019; bh=1zidGf96h2mILbQOIPvQvH9eE0PFWLwBTyMugXxtTL4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XPh8lR4z4sGOr6mc4nQmdxCkus7p7kE/+H+/rLmcfw3HxIpswM+njx6Syluzaz/ze
	 05XTW09R9RvMuuTRSunsyOCczODX5k9giTJzyZxEZLII0ZN+dyCy/UIr/JAQ0N/IVq
	 kdwS1SAyCKpQDILcvHcFg8Q5vEdb44ljRsxG/D8k=
Message-ID: <adc28bdc-ced8-4627-8ec7-23b767e7d445@arm.com>
Date: Fri, 13 Nov 2026 16:40:12 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/12] KVM: arm64: CCA: Tear down RTTs
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-8-steven.price@arm.com>
 <e1690e53-70fb-47fe-bd06-4758b1e196d2@arm.com>
 <6c362b9e-6ac3-4cbb-8e9d-d666f87ef8c2@arm.com>
 <020d220a-6f21-46a9-a0d6-51e56a7b3a5a@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <020d220a-6f21-46a9-a0d6-51e56a7b3a5a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 13/11/2026 16:26, Suzuki K Poulose wrote:
> On 13/11/2026 15:05, Steven Price wrote:
>> On 13/11/2026 01:04, Suzuki K Poulose wrote:
>>> On 11/11/2026 14:57, Steven Price wrote:
>>>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>>>> that the RMM creates/destroys entries as necessary. The physical pages
>>>> to store the page tables are delegated to the realm as required, and
>>>> can
>>>> be undelegated when no longer used.
>>>>
>>>> Creating new RTTs is the easy part, tearing down is a little more
>>>> tricky. The result of realm_rtt_destroy() can be used to effectively
>>>> walk the tree and destroy the entries (undelegating pages that were
>>>> given to the realm).
>>>>
>>>> Tear down a created Realm whether it is still new or has been
>>>> activated.
>>>> Unmap the Realm IPA space once during stage-2 teardown. Defer
>>>> destruction of non-root RTTs until final Realm destruction, after
>>>> REALM_TERMINATE and before destroying the RD; root RTTs remain until
>>>> the
>>>> RD has gone away.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>
> 
> ...
> 
>>>>      #endif /* __ASM_KVM_RMI_H */
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index 9df3f8d5b4ef..be014f6c00e7 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -1145,9 +1145,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct
>>>> kvm_s2_mmu *mmu, unsigned long t
>>>>        return err;
>>>>    }
> 
> ...
> 
>>>>    void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>>>    {
>>>> -    kvm_free_stage2_pgd(&kvm->arch.mmu);
>>>> +    if (kvm_realm_is_created(kvm))
>>>> +        kvm_realm_uninit_stage2(&kvm->arch.mmu);
>>>> +    else
>>>> +        kvm_free_stage2_pgd(&kvm->arch.mmu);
>>>
>>> We added kvm_free_stage2_pgd() from kvm_destroy_realm() for Realms in
>>> the previous patch. Should we move that here since, this is where we
>>>
>>> 1. Deal with tearing down stage2
>>> 2. And more importantly we are skipping it for Realms.
>>
>> I'm not quite sure what you're asking for here. We can't free the stage2
>> PGD while the realm is existing (because the RMM has the pages) - so we
>> defer it.
> 
> I understand. My point is, we are deferring the stage2 free for Realm
> in this patch, without explicitly showing where it is done. We have
> introduced that as part of kvm_destroy_realm() in Patch 6.
> 
> My recommendation is to add kvm_free_stage2_pgd() to kvm_destroy_realm()
> in this patch, where we are showing when this is deferred to. e.g.,
> this patch functionally leaves the reader with no clue when this is
> actually freed.
> 
> Does that make sense ?

Ah, yes move the code between patches - I thought you were suggesting
somehow moving the code between functions (hence I was very confused).

Yes, I can move the kvm_destroy_realm() code changes into this patch.

Thanks,
Steve

> 
>>
>>>>        kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>>>    }
>>>>    diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>>> index 69c628cfb6c7..b904e6541fb0 100644
>>>> --- a/arch/arm64/kvm/rmi.c
>>>> +++ b/arch/arm64/kvm/rmi.c
>>>> @@ -11,16 +11,193 @@
>>>>    #include <asm/kvm_pgtable.h>
>>>>    #include <asm/virt.h>
>>>>    +static inline unsigned long rmi_rtt_level_mapsize(int level)
>>>> +{
>>>> +    if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>>>> +        return PAGE_SIZE;
>>>> +
>>>> +    return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>>>> +}
>>>> +
>>>
>>> We agreed to use kvm_granule_size() instead of this ?
>>>
>>> https://lore.kernel.org/all/cb183290-3fee-4535-aa3e-5cc172c2323a@arm.com
>>
>> That was a screw-up when I was squashing fixes back in - the next patch
>> removes the code. I'll fix this up in the next version so it never
>> appears. Thanks for pointing it out.
>>
>>>>    u32 kvm_rmm_ipa_limit(void)
>>>>    {
>>>>        return u64_get_bits(rmi_feat_reg(0),
>>>> RMI_FEATURE_REGISTER_0_S2SZ);
>>>>    }
>>>>    +static int get_start_level(struct realm *realm)
>>>> +{
>>>> +    return 4 - max(2, stage2_pgtable_levels(realm->ia_bits));
>>>
>>> I don't think we need this "max()". ia_bits is guaranteed to be
>>>> = 32bit (ARM64_MIN_PARANGE_BITS, see kvm_init_ipa_range()), implying
>>> that we have at least 2 levels on all page sizes.
>>
>> Ah, very true - Sashiko complained, but I hadn't noticed
>> ARM64_MIN_PARANGE_BITS provided an effective minimum. I'll remove the
>> max() and add a comment.
>>
>>>> +}
>>>> +
>>>> +static void free_rtt(phys_addr_t phys)
>>>> +{
>>>> +    kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>>>> +    if (rmi_free_delegated_page(phys))
>>>> +        kvm_account_pgtable_pages(phys_to_virt(phys), 1);
>>>
>>> Is there a reason why remove the account before freeing ? Could we do
>>> this after we have reclaimed it ?
>>
>> Sashiko again:
>>
>>> Does calling kvm_account_pgtable_pages() after rmi_free_delegated_page()
>>> access the page after it has already been freed and uncharged from its
>>> memcg?
>>
>> Basically the problem is that rmi_free_delegated_page() frees the page
>> back to the allocator. So doing the account after freeing means that
>> technically the page could have been reused.
> 
> Thanks, for the explanation, that makes sense.
> 
> Cheers
> Suzuki
> 

