Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0FE32694E;
	Mon,  8 Jun 2026 10:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780916203; cv=none; b=Sy+Vyt1rxU47oyUC+TGJlEs+Wmdk18bXCa3ROIA4gqK7qkJxfBY/POrqHzIosIZel3TXlb8ozj2sMGciz8Mzof7RvGdapa2PBXxM2yZRfm6WxpofkJ3X9Pfqp2J+5U2tmTeYqw3pIr8E9Ysg75unIDiOP77d5V6UxciA3KvuXWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780916203; c=relaxed/simple;
	bh=3BsjGEV/zVg1r2FPoepEFV/lYqCNFcXTf/wKQVBDsp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hpYBZpzYAAg6A69ONeAPpunf7DByE3PcMjlFKNnbwjaTkRupgHthO/tzzz/+XSp3XqhCti7s2gHQ7U6MXF1/FJW7DgxRR0zS/karvif3u+2QfjKBZdY7gAt7lEneaM1b4DCXpaIwW6hv00SI5/hwbcsfEAOw6AkwGHwpk6SwBF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hqoMlR8u; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hqoMlR8u"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69DEF2403;
	Mon,  8 Jun 2026 03:56:36 -0700 (PDT)
Received: from [10.57.28.93] (unknown [10.57.28.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C82A13F62B;
	Mon,  8 Jun 2026 03:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780916201; bh=3BsjGEV/zVg1r2FPoepEFV/lYqCNFcXTf/wKQVBDsp0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hqoMlR8uEV7b745C1VkOn79UIulUNaWCmMMM0DnN/Ijpp9G6x9HQRx8JJG+Qi7u+B
	 K7vYaiVLgwC1XWknLZd4rOcFUR+6uIGGy9B/lC7a+j8j2gNOn7c7GBDPnvgAjjn9zo
	 hjzmL/ECH+fbvGNCQJCYelq5XGWF/bN5HfTVJbJI=
Message-ID: <04e7e38f-950c-4854-921b-79e06af29b5e@arm.com>
Date: Mon, 8 Jun 2026 11:56:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-30-steven.price@arm.com>
 <d08ca4d6-1e7c-473d-909e-89642bd8c4c2@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d08ca4d6-1e7c-473d-909e-89642bd8c4c2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 05/06/2026 12:20, Gavin Shan wrote:
> Hi Steve,
> 
> On 5/13/26 11:17 PM, Steven Price wrote:
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
>>
>> For memory in the lower (protected) region of IPA a fresh page is
>> provided to the RMM which will zero the contents. For memory in the
>> upper (shared) region of IPA, the memory from the memslot is mapped
>> into the realm VM non secure.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>   * Numerous changes due to rebasing.
>>   * Fix addr_range_desc() to encode the correct block size.
>> Changes since v12:
>>   * Switch to RMM v2.0 range based APIs.
>> Changes since v11:
>>   * Adapt to upstream changes.
>> Changes since v10:
>>   * RME->RMI renaming.
>>   * Adapt to upstream gmem changes.
>> Changes since v9:
>>   * Fix call to kvm_stage2_unmap_range() in kvm_free_stage2_pgd() to set
>>     may_block to avoid stall warnings.
>>   * Minor coding style fixes.
>> Changes since v8:
>>   * Propagate the may_block flag.
>>   * Minor comments and coding style changes.
>> Changes since v7:
>>   * Remove redundant WARN_ONs for realm_create_rtt_levels() - it will
>>     internally WARN when necessary.
>> Changes since v6:
>>   * Handle PAGE_SIZE being larger than RMM granule size.
>>   * Some minor renaming following review comments.
>> Changes since v5:
>>   * Reduce use of struct page in preparation for supporting the RMM
>>     having a different page size to the host.
>>   * Handle a race when delegating a page where another CPU has faulted on
>>     a the same page (and already delegated the physical page) but not yet
>>     mapped it. In this case simply return to the guest to either use the
>>     mapping from the other CPU (or refault if the race is lost).
>>   * The changes to populate_par_region() are moved into the previous
>>     patch where they belong.
>> Changes since v4:
>>   * Code cleanup following review feedback.
>>   * Drop the PTE_SHARED bit when creating unprotected page table entries.
>>     This is now set by the RMM and the host has no control of it and the
>>     spec requires the bit to be set to zero.
>> Changes since v2:
>>   * Avoid leaking memory if failing to map it in the realm.
>>   * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>>   * Adapt to changes in previous patches.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |   8 ++
>>   arch/arm64/include/asm/kvm_rmi.h     |  12 ++
>>   arch/arm64/kvm/mmu.c                 | 128 ++++++++++++++++----
>>   arch/arm64/kvm/rmi.c                 | 173 +++++++++++++++++++++++++++
>>   4 files changed, 301 insertions(+), 20 deletions(-)
>>
> 
> [...]
> 
>> @@ -1604,27 +1641,52 @@ static int gmem_abort(const struct
>> kvm_s2_fault_desc *s2fd)
>>       bool write_fault, exec_fault;
>>       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>>       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>> -    struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>> +    struct kvm_vcpu *vcpu = s2fd->vcpu;
>> +    struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
>> +    gpa_t gpa = kvm_gpa_from_fault(vcpu->kvm, s2fd->fault_ipa);
>>       unsigned long mmu_seq;
>>       struct page *page;
>> -    struct kvm *kvm = s2fd->vcpu->kvm;
>> +    struct kvm *kvm = vcpu->kvm;
>>       void *memcache;
>>       kvm_pfn_t pfn;
>>       gfn_t gfn;
>>       int ret;
>>   -    memcache = get_mmu_memcache(s2fd->vcpu);
>> -    ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>> +    if (kvm_is_realm(vcpu->kvm)) {
>> +        /* check for memory attribute mismatch */
>> +        bool is_priv_gfn = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
>> +        /*
>> +         * For Realms, the shared address is an alias of the private
>> +         * PA with the top bit set. Thus if the fault address matches
>> +         * the GPA then it is the private alias.
>> +         */
>> +        bool is_priv_fault = (gpa == s2fd->fault_ipa);
>> +
>> +        if (is_priv_gfn != is_priv_fault) {
>> +            kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>> +                              kvm_is_write_fault(vcpu),
>> +                              false,
>> +                              is_priv_fault);
>> +            /*
>> +             * KVM_EXIT_MEMORY_FAULT requires an return code of
>> +             * -EFAULT, see the API documentation
>> +             */
>> +            return -EFAULT;
>> +        }
>> +    }
>> +
> 
> For a Realm, gmem_abort() is called by kvm_handle_guest_abort() only when
> we're faulting in the private (protected) space.
> 
>     if (kvm_slot_has_gmem(memslot) && !shared_ipa_fault(vcpu->kvm,
> fault_ipa))
>         ret = gmem_abort(&s2fd);
>     else
>         ret = user_mem_abort(&s2fd);
> 
> With the condition, this block of code can be simplied to handle conversion
> (shared -> private) instead of both directions.
> 
>     /* Convert the shared address to the private adress for Realm */
>     if (kvm_is_realm(vcpu->kvm) &&
>         !kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT)) {
>         /*
>          * KVM_EXIT_MEMORY_FAULT requires an return code of
>          * -EFAULT, see the API documentation
>          */
>         kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
>                                       kvm_is_write_fault(vcpu),
>                                       false, true);
>         return -EFAULT;
>     }
> 
> 
> [...]
> 
>> @@ -2396,7 +2475,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>                   !write_fault &&
>>                   !kvm_vcpu_trap_is_exec_fault(vcpu));
>>   -        if (kvm_slot_has_gmem(memslot))
>> +        if (kvm_slot_has_gmem(memslot) && !shared_ipa_fault(vcpu-
>> >kvm, fault_ipa))
>>               ret = gmem_abort(&s2fd);
>>           else
>>               ret = user_mem_abort(&s2fd);
> gmem_abort() is only called for faults in the protected (private) space.

You're absolutely correct - that's a nice simplification!

Thanks,
Steve
