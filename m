Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965549;
	b=F6U6kypKzAAKMzJHrZkzJPqpMpKhWTp0tz0yBBjTiHj8zFHWS/UULxQZUvcS5mFQez8s
	 rNumuoDIiYAi/FQ6BZXZtVw4Hv9pSa4U64TT/ClGrIoS7KfoqHA0QzmiVf7wP6UHN0t3O
	 dNJn8Hfc0FNI3xD/kGc5kWEoQZ+x0swjdOjG5mS01z5y49izf0B8RXH2mGM6tCRP1Uhzr
	 bkKQ/JYjiDUYCF5TTtrE9ZQ4RGFc8OvW0TwvBsomz0r6A+YTsM4HlB3YHR9a0Y6RNdXoE
	 7o31ytV7itQZw8tMrdiRZsrbro5wmnNA4+XXVtRDRxiMzHR/8B0mvBPuQthfYKQTu/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965549;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=W4fidkDYHWE9+QINyOADU1Ue+HeYC3+/Rrlw2BZZSSU=;
	b=dRXlO9Lzw6fmKKUNzpVRBaWCpjJQZTrhlu2D7iNDkcO6kTlTVRfORMGU7j9gu1lN6kTS
	 MZPYhtsmYju8hH9jJDpYJ7sILOqG/R5CSpk0hd/f+ZY4D86FF+ui279NG/F4AiiYyVH/X
	 DhLiNF7ppSZHaFolfhHsjQtiJoEATpzF2qlAWF2o2vcFQPHD/cTWe3CcLvFu9d4mZ3hJk
	 4kHKnIOJ6NHKTp13TppoKqDdBR0gsu13lc8etawYk6ikeprUFuGVG8lK0EnDuOxUN+NuL
	 OaqPlSs647K1IX2SBgYIzY26iLE76u9Ds84KCx2D0gNAWIsnL8iWqJ2DImL/M35M+4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=juvt8uiJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800F1606BD7D;
	Fri,  6 Nov 2026 11:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 800F1606BD7D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=juvt8uiJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FA1A1650;
	Fri,  6 Nov 2026 03:45:43 -0800 (PST)
Received: from [10.0.128.250] (e122027.cambridge.arm.com [10.0.128.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E2523F628;
	Fri,  6 Nov 2026 03:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793965546; bh=M73W2N5yJyp2P30rzOMISScbNOi08NBkAWzkEmEjo1k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=juvt8uiJPB9gHD9SyKoS2Xhw1TtdR2eIMvpNEVhY00IEIOBqM7HGpJj0HmJVwk0L3
	 /ZtrJGIG1+TT2q7q2O32zLYOgiCV7z2oiFvdixwk6qVmjpn3aVi9KINrQ9MFp2eRH3
	 2bjmOkCT46MLPAP6Yu08w0aRzUAhjy6F7goffizs=
Message-ID: <31ef9077-0d88-401d-b6aa-78b9d9f496bc@arm.com>
Date: Fri, 6 Nov 2026 11:45:40 +0000
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
Subject: Re: [PATCH 10/11] KVM: arm64: CCA: Support runtime faulting of memory
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-11-steven.price@arm.com>
 <fa0ee5a1-4c49-4c1f-bfbb-c270dc4b6301@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <fa0ee5a1-4c49-4c1f-bfbb-c270dc4b6301@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 05/11/2026 17:30, Suzuki K Poulose wrote:
> On 02/11/2026 14:13, Steven Price wrote:
>> At runtime if the realm guest accesses memory which hasn't yet been
>> mapped then KVM needs to either populate the region or fault the guest.
> 
> minor nit: "populate" could be confusing here in the CCA context
> Could we just say:
> 
> If the realm guest accesses memory which hasn't yet been
> mapped at stage2, KVM needs to fixup the stage2 mapping.
> (The only other option is to inject an Synchronous External Abort
> to back to the Guest if the fault is at an unprotected IPA)

Sure I'll avoid "populate" since it has another meaning in CCA.

> 
>>
>> For memory in the lower (protected) region of IPA, verify that the
>> corresponding guest_memfd page is private before delegating to the RMM.
>> The RMM then maps the page into the realm and initializes its contents
>> to zero.
>>
>> For memory in the upper (shared) IPA region, map the backing page as
>> non-secure memory. Check that a guest_memfd page is shared when the
>> fault uses guest_memfd; ordinary userspace-backed memslots follow the
>> normal user memory fault path.
> 
> Should we make it explicit that the ordinary userspace-backed memslots
> can only be mapped at the shared ipa ?

Sure

>>
>> If the fault IPA and guest_memfd attributes disagree then exit to
>> userspace with KVM_EXIT_MEMORY_FAULT so the VMM can perform the required
>> conversion.
> 
> Or alternately, the host can inject an SEA on a fault at unprotected
> fault.

Indeed - I'll add that.

>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |  13 ++
>>   arch/arm64/include/asm/kvm_rmi.h     |   7 +-
>>   arch/arm64/kvm/mmu.c                 | 115 +++++++++++---
>>   arch/arm64/kvm/rmi.c                 | 228 ++++++++++++++++++++++++++-
>>   4 files changed, 336 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/
>> include/asm/kvm_emulate.h
>> index 32021bdf2610..8a71fddfdb85 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -847,4 +847,17 @@ static inline bool kvm_realm_is_created(struct
>> kvm *kvm)
>>       return kvm_vm_is_realm(kvm) && kvm_realm_state(kvm) !=
>> REALM_STATE_NONE;
>>   }
>>   +static inline gpa_t kvm_gpa_from_fault(struct kvm *kvm, phys_addr_t
>> ipa)
>> +{
>> +    if (!kvm_vm_is_realm(kvm))
>> +        return ipa;
>> +
>> +    return ipa & ~BIT(kvm->arch.realm.ia_bits - 1);
>> +}
>> +
>> +static inline gfn_t kvm_gfn_from_fault(struct kvm *kvm, phys_addr_t ipa)
>> +{
>> +    return gpa_to_gfn(kvm_gpa_from_fault(kvm, ipa));
>> +}
>> +
>>   #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index 72a9449f00d7..105660d4d56a 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -6,6 +6,7 @@
>>   #ifndef __ASM_KVM_RMI_H
>>   #define __ASM_KVM_RMI_H
>>   +#include <asm/kvm_pgtable.h>
>>   #include <linux/arm-smccc-rmi.h>
>>   #include <linux/kvm.h>
>>   @@ -92,9 +93,13 @@ void kvm_realm_unmap_range_filter(struct kvm *kvm,
>>   void kvm_realm_unmap_range(struct kvm *kvm,
>>                  unsigned long ipa,
>>                  unsigned long size,
>> -               bool unmap_private,
>>                  bool may_block);
> 
> The above function is not need as discussed in the previous patch.
>>   +int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>> +          kvm_pfn_t pfn, unsigned long map_size,
>> +          enum kvm_pgtable_prot prot,
>> +          struct kvm_mmu_memory_cache *memcache);
>> +
>>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>>                           unsigned long addr)
>>   {
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index eb8c5f9e9791..20aedbe6ec07 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -434,7 +434,11 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>       phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>>       phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
>>   -    kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>> +    if (kvm_vm_is_realm(kvm))
>> +        kvm_realm_unmap_range_filter(kvm, addr, end - addr, true,
>> +                         KVM_FILTER_SHARED);
> 
> Actually, we should simply do nothing for Realm. Here, we are t rying
> unmap the memslot, while we are supposed to make sure the flush the
> dcache to poc for cacheable mappings. Given that RMM mandates FWB for
> stage2, this is NOP for a Realm, which also solves the sashiko report
> on memslot deletion for guest_memfd. Also, another candidate for
> vm_s2_ops ;-)

Probably better is to early out in stage2_flush_vm() such that this
function is never called.

>> +    else
>> +        kvm_stage2_flush_range(&kvm->arch.mmu, addr, end);
>>   }
>>     /**
>> @@ -1221,6 +1225,10 @@ void stage2_unmap_vm(struct kvm *kvm)
>>       struct kvm_memory_slot *memslot;
>>       int idx, bkt;
>>   +    /* For realms this is handled by the RMM so nothing to do here */
>> +    if (kvm_vm_is_realm(kvm))
>> +        return;
>> +
>>       idx = srcu_read_lock(&kvm->srcu);
>>       mmap_read_lock(current->mm);
>>       write_lock(&kvm->mmu_lock);
>> @@ -1790,6 +1798,10 @@ static int gmem_abort(const struct
>> kvm_s2_fault_desc *s2fd,
>>       void *memcache = NULL;
>>       gfn_t canonical_gfn;
>>       int ret;
>> +    bool is_realm_private = false;
>> +
>> +    if (KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
>> +        return -EINVAL;
>>         if (!perm_fault) {
>>           memcache = get_mmu_memcache(s2fd->vcpu);
>> @@ -1804,7 +1816,7 @@ static int gmem_abort(const struct
>> kvm_s2_fault_desc *s2fd,
>>       }
>>         s2vi.vma_pagesize = PAGE_SIZE;
>> -    s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >>
>> PAGE_SHIFT;
>> +    s2vi.gfn = gpa_to_gfn(kvm_gpa_from_fault(kvm, s2fd->fault_ipa));
>>       canonical_gfn = get_canonical_gfn(s2fd, &s2vi);
>>         write_fault = kvm_s2_fault_is_write(s2fd);
>> @@ -1816,13 +1828,28 @@ static int gmem_abort(const struct
>> kvm_s2_fault_desc *s2fd,
>>       /* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>>       smp_rmb();
>>   +    if (kvm_vm_is_realm(kvm)) {
>> +        is_realm_private = kvm_realm_is_private_address(&kvm-
>> >arch.realm,
>> +                                s2fd->fault_ipa);
>> +
>> +        if (is_realm_private != kvm_gmem_is_private_gfn(kvm,
>> canonical_gfn)) {
>> +            kvm_prepare_memory_fault_exit(s2fd->vcpu,
>> +                              gfn_to_gpa(canonical_gfn),
>> +                              PAGE_SIZE,
>> +                              write_fault, exec_fault,
>> +                              is_realm_private);
>> +            kfree(mapping);
>> +            return -EFAULT;
>> +        }
>> +    }
>> +
> 
> I am wondering there is a way to make it a bit more generic. The issue
> is, only Realm has private memory with guest_memfd for now. Don't know
> the pKVM plans for it.
> 
> 
>>       ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn,
>> &s2vi.pfn, NULL);
>>       if (ret) {
>>           /* If result is non-NULL this is a synthetic fault. */
>>           if (!result)
>>               kvm_prepare_memory_fault_exit(s2fd->vcpu,
>> gfn_to_gpa(canonical_gfn),
>>                                 s2vi.vma_pagesize, write_fault,
>> exec_fault,
>> -                              false);
>> +                              is_realm_private);
>>           kfree(mapping);
>>           return ret;
>>       }
>> @@ -1845,6 +1872,13 @@ static int gmem_abort(const struct
>> kvm_s2_fault_desc *s2fd,
>>           goto out_unlock;
>>       }
>>   +    if (kvm_vm_is_realm(kvm)) {
>> +        prot &= ~KVM_PGTABLE_PROT_X;
>> +        ret = realm_map_ipa(kvm, s2fd->fault_ipa, s2vi.pfn,
>> +                    PAGE_SIZE, prot, memcache);
> 
> I wonder if we need to treat the perm_faults (in the shared IPA)
> differently and explicitly make a helper for that. We do handle
> them in realm_map_unprotected() now, but it is rather a little
> unclear.
> 
>> +        goto out_unlock;
>> +    }
>> +
>>       if (perm_fault) {
>>           /*
>>            * Drop the SW bits in favour of those stored in the
>> @@ -2046,7 +2080,8 @@ static int kvm_s2_fault_get_vma_info(const
>> struct kvm_s2_fault_desc *s2fd,
>>        * mapping size to ensure we find the right PFN and lay down the
>>        * mapping in the right place.
>>        */
>> -    s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >>
>> PAGE_SHIFT;
>> +    s2vi->gfn = kvm_gfn_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa,
>> +                               s2vi->vma_pagesize));
>>         s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
>>   @@ -2241,12 +2276,15 @@ static int kvm_s2_fault_map(const struct
>> kvm_s2_fault_desc *s2fd,
>>       if (!perm_fault_granule && !s2vi->map_non_cacheable &&
>> kvm_has_mte(kvm))
>>           sanitise_mte_tags(kvm, pfn, mapping_size);
>>   -    /*
>> -     * Under the premise of getting a FSC_PERM fault, we just need to
>> relax
>> -     * permissions only if mapping_size equals perm_fault_granule.
>> Otherwise,
>> -     * kvm_pgtable_stage2_map() should be called to change block size.
>> -     */
>> -    if (mapping_size == perm_fault_granule) {
>> +    if (kvm_vm_is_realm(kvm)) {
>> +        ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
>> +                    prot, memcache);
>> +    } else if (mapping_size == perm_fault_granule) {
>> +        /*
>> +         * Under the premise of getting a FSC_PERM fault, we just
>> need to relax
>> +         * permissions only if mapping_size equals
>> perm_fault_granule. Otherwise,
>> +         * kvm_pgtable_stage2_map() should be called to change block
>> size.
>> +         */
>>           /*
>>            * Drop the SW bits in favour of those stored in the
>>            * PTE, which will be preserved.
>> @@ -2339,18 +2377,43 @@ static int user_mem_abort(const struct
>> kvm_s2_fault_desc *s2fd,
>>       return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
>>   }
>>   +static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa);
>> +static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>> +                    const struct kvm_s2_fault_desc *s2fd);
>> +
> 
> minor nit: Both those could be dropped by moving the definitons up ?

Ack

>>   static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>>   {
>>       VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(s2fd) &&
>>               !esr_abt_is_write_fault(s2fd->esr) &&
>>               !kvm_s2_fault_is_exec(s2fd));
>>   -    if (kvm_slot_has_gmem(s2fd->memslot))
>> +    if (private_ipa_fault(s2fd->vcpu->kvm, s2fd->fault_ipa) &&
>> +        !kvm_slot_has_gmem(s2fd->memslot))
>> +        return -EINVAL;
>> +
>> +    if (kvm_fault_is_gmem_abort(s2fd->vcpu->kvm, s2fd))
>>           return gmem_abort(s2fd, NULL);
>>       else
>>           return user_mem_abort(s2fd, NULL);
>>   }
>>   +/* Decide if an abort should be handled by the gmem */
>> +static bool kvm_fault_is_gmem_abort(struct kvm *kvm,
>> +                    const struct kvm_s2_fault_desc *s2fd)
>> +{
>> +    if (!kvm_slot_has_gmem(s2fd->memslot))
>> +        return false;
>> +    if (kvm_memslot_is_gmem_only(s2fd->memslot))
>> +        return true;
>> +    /*
>> +     * For Realms, all private faults must be backed by GMEM.
>> +     * TODO: Handle Trusted device private memory mappings.
>> +     */
>> +    if (private_ipa_fault(kvm, s2fd->fault_ipa))
>> +        return true;
>> +    return false;
>> +}
>> +
>>   /* Resolve the access fault by making the page young again. */
>>   static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t
>> fault_ipa)
>>   {
>> @@ -2444,6 +2507,12 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>>       return 0;
>>   }
>>   +static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
>> +{
>> +    return kvm_vm_is_realm(kvm) &&
>> +        kvm_realm_is_private_address(&kvm->arch.realm, fault_ipa);
>> +}
>> +
>>   /**
>>    * kvm_handle_guest_abort - handles all 2nd stage aborts
>>    * @vcpu:    the VCPU pointer
>> @@ -2457,10 +2526,10 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>>    */
>>   int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>   {
>> +    struct kvm *kvm = vcpu->kvm;
>>       struct kvm_s2_trans nested_trans, *nested = NULL;
>>       unsigned long esr = kvm_vcpu_get_esr(vcpu);
>>       struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
>> -    struct kvm *kvm = vcpu->kvm;
>>       phys_addr_t fault_ipa; /* The address we faulted on */
>>       phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
>>       struct kvm_memory_slot *memslot;
>> @@ -2553,8 +2622,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>           nested = &nested_trans;
>>       }
>>   -    gfn = ipa >> PAGE_SHIFT;
>> +    gfn = kvm_gfn_from_fault(kvm, ipa);
>>       memslot = gfn_to_memslot(kvm, gfn);
>> +
>>       hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>>       write_fault = esr_abt_is_write_fault(esr);
>>       if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>> @@ -2597,7 +2667,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>            * of the page size.
>>            */
>>           ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
>> -        ret = io_mem_abort(vcpu, ipa);
>> +        ret = io_mem_abort(vcpu, kvm_gpa_from_fault(kvm, ipa));
>>           goto out_unlock;
>>       }
>>   @@ -2856,6 +2926,7 @@ int kvm_arch_prepare_memory_region(struct kvm
>> *kvm,
>>                      enum kvm_mr_change change)
>>   {
>>       hva_t hva, reg_end;
>> +    gfn_t ipa_limit;
>>       int ret = 0;
>>         if (kvm_vm_is_protected(kvm) && new &&
>> @@ -2891,17 +2962,21 @@ int kvm_arch_prepare_memory_region(struct kvm
>> *kvm,
>>           return 0;
>>         /*
>> -     * Prevent userspace from creating a memory region outside of the
>> IPA
>> -     * space addressable by the KVM guest IPA space.
>> +     * Realm shared IPAs alias the corresponding private IPAs, so
>> memslots
>> +     * must reside entirely in the canonical lower half of the IPA
>> space.
>>        */
>> -    if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm-
>> >arch.mmu) >> PAGE_SHIFT))
>> +    ipa_limit = kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT;
>> +    if (kvm_vm_is_realm(kvm))
>> +        ipa_limit >>= 1;
>> +    if (new->base_gfn + new->npages > ipa_limit)
>>           return -EFAULT;
> 
> Please could we move this change to the patch where we deal with
> memslots for Realms ?>

Will do

>>       /*
>> -     * Only support guest_memfd backed memslots with mappable memory,
>> since
>> -     * there aren't any CoCo VMs that support only private memory on
>> arm64.
>> +     * Only support guest_memfd backed memslots with mappable memory,
>> +     * unless the guest is a CCA realm guest.
>>        */
>> -    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>> +    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new) &&
>> +        !kvm_vm_is_realm(kvm))
>>           return -EINVAL;
> 
> This looks like a left over from the original support without in-place
> conversion support.  This hunk should be dropped ?

Good point - yes we should be requiring the VMM specifies the MMAP flag.

>>         /* guest_memfd is incompatible with MTE. */
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 1066f767f85d..f89460d8adcb 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -531,15 +531,231 @@ void kvm_realm_unmap_range_filter(struct kvm
>> *kvm, unsigned long start,
>>   }
>>     void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>> -               unsigned long size, bool unmap_private,
>> -               bool may_block)
>> +               unsigned long size, bool may_block)
>>   {
>> -    enum kvm_gfn_range_filter attr_filter = KVM_FILTER_SHARED;
>> +    kvm_realm_unmap_range_filter(kvm, start, size, may_block,
>> +                     KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
>> +}
> 
> 
> 
>> +
>> +static unsigned long addr_range_desc(unsigned long phys, unsigned
>> long size,
>> +                     unsigned long state)
>> +{
>> +    unsigned long count = 1;
>> +    unsigned long out;
>> +    int rmi_size;
>> +
>> +    for (rmi_size = KVM_PGTABLE_LAST_LEVEL; rmi_size >= 0; rmi_size--) {
>> +        unsigned long entry_size = rmi_range_entry_size(rmi_size);
>> +
>> +        if (size == entry_size)
>> +            break;
>> +        if (size > entry_size) {
>> +            rmi_size = -1;
>> +            break;
>> +        }
>> +    }
>> +
>> +    if (rmi_size < 0) {
>> +        /*
>> +         * Only support mapping at the page level granularity when
>> +         * it's an unusual length. This should get us back onto a larger
>> +         * block size for the subsequent mappings.
> 
> Is the second part really valid ?

Well the idea here is that after a number of PAGE_SIZEd mappings we
should be sufficiently aligned that we can move back to the larger block
size.

I've reworked this function locally and hopefully made things clearer.

>> +         */
>> +        rmi_size = 0;
>> +        count = MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1);
>> +    }
>> +
>> +    WARN_ON(phys & ~PAGE_MASK);
>> +
>> +    out = FIELD_PREP(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, rmi_size) |
>> +          FIELD_PREP(RMI_ADDR_RANGE_COUNT_MASK, count) |
>> +          FIELD_PREP(RMI_ADDR_RANGE_STATE_MASK, state);
>> +    out |= phys & PAGE_MASK;
>> +
>> +    return out;
>> +}
>> +
>> +static int realm_map_protected(struct kvm *kvm,
>> +                   unsigned long ipa,
>> +                   kvm_pfn_t pfn,
>> +                   unsigned long map_size,
>> +                   struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    phys_addr_t base_phys = phys;
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    phys_addr_t delegated_phys;
>> +    unsigned long base_ipa = ipa;
>> +    unsigned long ipa_top;
>> +    long ret = 0;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(map_size, PAGE_SIZE) ||
>> +            !IS_ALIGNED(ipa, map_size)))
>> +        return -EINVAL;
>> +
>> +    if (rmi_delegate_range(phys, map_size, &delegated_phys)) {
>> +        if (delegated_phys == phys) {
>> +            /*
>> +             * It's likely we raced with another VCPU on the same
>> +             * fault. Assume the other VCPU has handled the fault
>> +             * and return to the guest.
>> +             */
>> +            return 0;
>> +        }
>> +        /* Partial delegation - map as much as we can */
>> +        map_size = delegated_phys - phys;
>> +    }
>> +
>> +    ipa_top = ipa + map_size;
>> +
>> +    while (ipa < ipa_top) {
>> +        unsigned long flags = RMI_ADDR_TYPE_SINGLE;
>> +        unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa,
>> +                               RMI_OP_MEM_DELEGATED);
>> +        unsigned long out_top;
>> +
>> +        ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
>> +                       &out_top);
>> +        if (ret < 0)
>> +            goto err_undelegate;
>> +
>> +        if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RESULT_DATA_LEVEL(ret);
>> +
>> +            if (WARN_ON(level >= KVM_PGTABLE_LAST_LEVEL))
>> +                goto err_undelegate;
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              level + 1,
>> +                              memcache);
>> +            if (ret)
>> +                goto err_undelegate;
>>   -    if (unmap_private)
>> -        attr_filter |= KVM_FILTER_PRIVATE;
>> +            continue;
>> +        }
>> +
>> +        if (WARN_ON(ret))
>> +            goto err_undelegate;
>> +
>> +        phys += out_top - ipa;
>> +        ipa = out_top;
>> +    }
>> +
>> +    return 0;
>> +
>> +err_undelegate:
>> +    realm_unmap_private_range(kvm, base_ipa, ipa, true);
>> +    /* A range which cannot be undelegated remains owned by the RMM. */
>> +    WARN_ON(rmi_undelegate_range(base_phys, map_size));
>> +    return ret < 0 ? ret : -ENXIO;
>> +}
>> +
>> +static int realm_map_non_secure(struct kvm *kvm,
> 
> realm_map_unprotected() to pair with realm_map_protected() ?

Yes that's probably better - "secure" is always a problematic term ;)

>> +                unsigned long ipa,
>> +                kvm_pfn_t pfn,
>> +                unsigned long size,
>> +                enum kvm_pgtable_prot prot,
>> +                struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    unsigned long attr, flags = 0;
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    unsigned long ipa_top = ipa + size;
>> +    long ret;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(size, PAGE_SIZE)))
>> +        return -EINVAL;
>> +
>> +    switch (prot & (KVM_PGTABLE_PROT_DEVICE |
>> KVM_PGTABLE_PROT_NORMAL_NC)) {
>> +    case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
>> +        return -EINVAL;
>> +    case KVM_PGTABLE_PROT_DEVICE:
>> +        attr = MT_S2_FWB_DEVICE_nGnRE;
>> +        break;
>> +    case KVM_PGTABLE_PROT_NORMAL_NC:
>> +        attr = MT_S2_FWB_NORMAL_NC;
>> +        break;
>> +    default:
>> +        attr = MT_S2_FWB_NORMAL;
>> +    }
>> +
>> +    flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR_MASK, attr);
>> +
>> +    if (prot & KVM_PGTABLE_PROT_R)
>> +        flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP_MASK,
>> RMI_S2AP_DIRECT_READ);
>> +    if (prot & KVM_PGTABLE_PROT_W)
>> +        flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP_MASK,
>> RMI_S2AP_DIRECT_WRITE);
>> +
>> +    flags |= RMI_ADDR_TYPE_SINGLE;
> 
> May be add a TODO: comment, explaining we plan to add multi-list mapping
> later ?

Ack.

>> +
>> +    while (ipa < ipa_top) {
>> +        unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa,
>> +                               RMI_OP_MEM_UNDELEGATED);
>> +        unsigned long out_top;
>> +
>> +        ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags, range_desc,
>> +                     &out_top);
> 
> Do we get an RMI_ERROR_INPUT, if the range_desc doesn't cover the
> ipa_top, if we truncated the range_desc in addr_range_desc() due
> to alignment ?

It doesn't appear to be listed as a failure condition in the spec from
what I can see. I have to admit the spec isn't entirely clear on this
though.

I'll update the code to cap the top value in this case.

Thanks,
Steve

>> +        if (ret < 0)
>> +            return ret;
>> +
>> +        if (RMI_RESULT_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RESULT_DATA_LEVEL(ret);
>> +            int req_level = find_map_level(realm, ipa, ipa_top);
>> +
>> +            /*
>> +             * There already exists a mapping at the level. May be
>> +             * we are relaxing a permission for the given range ?
>> +             */
>> +            if (level >= req_level) {
>> +                realm_unmap_shared_range(kvm, ipa, ipa_top, true);
>> +                continue;
>> +            }
>> +
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              req_level,
>> +                              memcache);
>> +            if (ret)
>> +                return ret;
>> +
>> +            ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
>> +                         range_desc, &out_top);
>> +            if (ret < 0)
>> +                return ret;
>> +        }
>> +
>> +        if (ret && RMI_RESULT_STATUS(ret) != RMI_ERROR_RTT)
>> +            return ret;
>> +
>> +        phys += out_top - ipa;
>> +        ipa = out_top;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
>> +          kvm_pfn_t pfn, unsigned long map_size,
>> +          enum kvm_pgtable_prot prot,
>> +          struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    if (kvm_realm_state(kvm) != REALM_STATE_ACTIVE)
>> +        return -EBUSY;
>> +
>> +    ipa = ALIGN_DOWN(ipa, map_size);
>> +    if (!kvm_realm_is_private_address(realm, ipa)) {
>> +        return realm_map_non_secure(kvm, ipa, pfn, map_size, prot,
>> +                        memcache);
>> +    }
>>   -    kvm_realm_unmap_range_filter(kvm, start, size, may_block,
>> attr_filter);
>> +    /* It's impossible to map protected pages read-only. */
>> +    if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
>> +        return -EFAULT;
>> +    return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
>>   }
>>     void kvm_destroy_realm(struct kvm *kvm)
> 

