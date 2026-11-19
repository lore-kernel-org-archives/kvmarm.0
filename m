Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107678;
	b=zeFS1GIgFeXS+DkqynaUxzJperXe0lyAKbiBqglM6f3OYtPyZ6Av6Sv/fFU7x0fidzFQ
	 kJy4wJZN3NLdPxh7F8Voo6V0UbvO/7Ad6s87xdBTe2KVj9yxWETPQweCO/xBWqxFXhI91
	 5JhVcaDAoc+FKthEJnl4rU1HoSGJ8m5cr+wJjZXB6gAVnxntuXOEsQiyzGMEEpnEivVOY
	 cCzQPs8xns1un1o7qZvecetxZdC2J23r3jKHaXBLVQyvVFIrl8W/h2/kklXjx+IMMCtUM
	 t9xLw5jwySaoR8wa3K/SV5hHXdAagfOo3GKAyKf3vl2TwAVoqrwkWbKZvALHINFMLyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107678;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HuvbqePajCm3jKp9iOjUnXA/SrQymMd79cA69qsQnQI=;
	b=GRSsNs8ewjGuh7nkBnLIx9nGHcSiIkfCVE5bkNUfzCl/CUf0cugxxzQ+l20xddqVqIPj
	 zS5c86nwACyoVEWWKqtdyMpuSSxyCSSh1TmMzsBzJBkinstGksRT4b0XzoVgBBFNMlRKl
	 pyusiD7wjdkNrIZM46CbrtrHJTeT81C8RwcsSjKD+zj5nalXng7PP4Rr6pwyhugdqThUC
	 CHCDBCCacOURUDfME5qE0adZzInb4nVo9PqxuOExLGyuy5g+yX9n2cncrmSXzqHahgZM7
	 iYjyZmBrAihCWpZ9GvQunzR3+3x5QreVW3DkToAhcZJI2FCM5hn3JamD4XeH1NURWYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="Ow/Bbh3a";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED41E606A324;
	Thu, 19 Nov 2026 17:01:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED41E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Ow/Bbh3a
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 548EC1575;
	Thu, 19 Nov 2026 09:01:14 -0800 (PST)
Received: from [10.0.129.37] (e122027.cambridge.arm.com [10.0.129.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A32483F673;
	Thu, 19 Nov 2026 09:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795107677; bh=Yb/X4lEMD/TYhBRp9Ovm5Bp1Hk6z6MRsu5RbwGNenBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ow/Bbh3agrnb3+CsDs6QKApKERkYiMWf301VWP/bOwjWZBQEkVRYePRhAC2T3DmGN
	 awlzauDaMWP4kiGf8To7uBXM8+Ku4XjJ3N5kxbs/QsbCuq/n1q/dSTa+itAP4L8Gh3
	 +odwVNoQgClJtQNTEd4R04QKcKENjcXPEx/y6dp0=
Message-ID: <bf4da8b7-0714-4253-9841-cf83cb65b92d@arm.com>
Date: Thu, 19 Nov 2026 17:01:10 +0000
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
Subject: Re: [PATCH v3 09/11] KVM: arm64: CCA: Support runtime faulting of
 memory
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
 Vishal Annapurve <vannapurve@google.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-10-steven.price@arm.com>
 <hwmtiumovuqyu7js5eqd4xt3h2zsuhjwkcygnw62hp5rrar5ph@5fhmv46iio2r>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <hwmtiumovuqyu7js5eqd4xt3h2zsuhjwkcygnw62hp5rrar5ph@5fhmv46iio2r>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/11/2026 07:48, Wei-Lin Chang wrote:
> Hi Steven,
> 
> On Mon, Nov 16, 2026 at 04:43:55PM +0000, Steven Price wrote:
> 
> [...]
> 
>> @@ -1791,12 +1799,18 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	void *memcache = NULL;
>>  	gfn_t canonical_gfn;
>>  	int ret;
>> +	bool is_private = false;
>>  
>> -	if (!perm_fault) {
>> +	if (KVM_BUG_ON(!kvm_slot_has_gmem(s2fd->memslot), kvm))
>> +		return -EINVAL;
> 
> I feel this is being too cautious, gmem_abort is always run after a
> kvm_slot_has_gmem() check.

Fair point - I'll drop that.

>> +
>> +	if (!perm_fault || kvm_arch_has_private_mem(kvm)) {
>>  		memcache = get_mmu_memcache(s2fd->vcpu);
>>  		ret = topup_mmu_memcache(s2fd->mmu, memcache);
>>  		if (ret)
>>  			return ret;
>> +	}
>> +	if (!perm_fault) {
>>  		if (kvm_is_nested_s2_mmu(kvm, pgt->mmu)) {
>>  			mapping = kmalloc_obj(struct kvm_guest_s2_mapping, GFP_KERNEL_ACCOUNT);
>>  			if (!mapping)
>> @@ -1805,7 +1819,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	}
>>  
>>  	s2vi.vma_pagesize = PAGE_SIZE;
>> -	s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >> PAGE_SHIFT;
>> +	s2vi.gfn = gpa_to_gfn(kvm_gpa_from_fault(kvm, s2fd->fault_ipa));
>>  	canonical_gfn = get_canonical_gfn(s2fd, &s2vi);
>>  
>>  	write_fault = kvm_s2_fault_is_write(s2fd);
>> @@ -1817,13 +1831,35 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>>  	smp_rmb();
>>  
>> +	if (kvm_arch_has_private_mem(kvm)) {
>> +		switch (kvm->arch.vm_flavor) {
>> +		case VM_REALM:
>> +			is_private = kvm_realm_is_private_address(&kvm->arch.realm,
>> +								  s2fd->fault_ipa);
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +
>> +		if (is_private != kvm_gmem_is_private_gfn(kvm, canonical_gfn)) {
>> +			if (!result)
>> +				kvm_prepare_memory_fault_exit(s2fd->vcpu,
>> +							      gfn_to_gpa(canonical_gfn),
>> +							      PAGE_SIZE,
>> +							      write_fault, exec_fault,
>> +							      is_private);
>> +			kfree(mapping);
>> +			return -EFAULT;
>> +		}
>> +	}
>> +
>>  	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, NULL);
>>  	if (ret) {
>>  		/* If result is non-NULL this is a synthetic fault. */
>>  		if (!result)
>>  			kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
>>  						      s2vi.vma_pagesize, write_fault, exec_fault,
>> -						      false);
>> +						      is_private);
>>  		kfree(mapping);
>>  		return ret;
>>  	}
>> @@ -1846,6 +1882,16 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  		goto out_unlock;
>>  	}
>>  
>> +	switch (kvm->arch.vm_flavor) {
>> +	case VM_REALM:
>> +		prot &= ~KVM_PGTABLE_PROT_X;
>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, s2vi.pfn,
>> +				    PAGE_SIZE, prot, memcache);
>> +		goto out_unlock;
>> +	default:
>> +		break;
>> +	}
>> +
>>  	if (perm_fault) {
>>  		/*
>>  		 * Drop the SW bits in favour of those stored in the
>> @@ -2047,7 +2093,8 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>>  	 * mapping size to ensure we find the right PFN and lay down the
>>  	 * mapping in the right place.
>>  	 */
>> -	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
>> +	s2vi->gfn = kvm_gfn_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa,
>> +						       s2vi->vma_pagesize));
>>  
>>  	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
>>  
>> @@ -2227,7 +2274,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>  	 * possible.
>>  	 */
>>  	if (mapping_size == PAGE_SIZE && s2vi->max_map_size != PAGE_SIZE) {
>> -		if (perm_fault_granule > PAGE_SIZE) {
>> +		if (perm_fault_granule > PAGE_SIZE && !kvm_vm_is_realm(kvm)) {
>>  			mapping_size = perm_fault_granule;
>>  		} else {
>>  			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
>> @@ -2242,12 +2289,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>>  	if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(kvm))
>>  		sanitise_mte_tags(kvm, pfn, mapping_size);
>>  
>> -	/*
>> -	 * Under the premise of getting a FSC_PERM fault, we just need to relax
>> -	 * permissions only if mapping_size equals perm_fault_granule. Otherwise,
>> -	 * kvm_pgtable_stage2_map() should be called to change block size.
>> -	 */
>> -	if (mapping_size == perm_fault_granule) {
>> +	if (kvm_vm_is_realm(kvm)) {
>> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
>> +				    prot, memcache);
>> +	} else if (mapping_size == perm_fault_granule) {
>> +		/*
>> +		 * Under the premise of getting a FSC_PERM fault, we just need to relax
>> +		 * permissions only if mapping_size equals perm_fault_granule. Otherwise,
>> +		 * kvm_pgtable_stage2_map() should be called to change block size.
>> +		 */
>>  		/*
>>  		 * Drop the SW bits in favour of those stored in the
>>  		 * PTE, which will be preserved.
>> @@ -2306,15 +2356,16 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	/*
>>  	 * Permission faults just need to update the existing leaf entry,
>>  	 * and so normally don't require allocations from the memcache. The
>> -	 * only exception to this is when dirty logging is enabled at runtime
>> +	 * exceptions are when dirty logging is enabled at runtime
>>  	 * and a fault needs to collapse a block entry into a table.
>> +	 * Realms can also require new RTT levels when replacing a mapping.
>>  	 * Under pKVM a permission fault can also collapse pages into a block,
>>  	 * which needs a fresh mapping object, and the hypervisor requires the
>>  	 * min-pages memcache even when the install allocates nothing.
>>  	 */
>>  	memcache = get_mmu_memcache(s2fd->vcpu);
>>  	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
>> -	    is_protected_kvm_enabled()) {
>> +	    is_protected_kvm_enabled() || kvm_vm_is_realm(s2fd->vcpu->kvm)) {
>>  		ret = topup_mmu_memcache(s2fd->mmu, memcache);
>>  		if (ret)
>>  			return ret;
>> @@ -2340,12 +2391,22 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
>>  	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
>>  }
> 
> I see that the changes to gmem_abort() and kvm_s2_fault_map() are more
> significant, and can possibly be turned into its realm version leaving
> the original unchanged. With this can we give realm_vm_s2_ops its own
> .vm_mem_abort? Something like:
> 
> First, make user_mem_abort() take a function pointer, call it at the
> current kvm_s2_fault_map() place.
> 
> Then realm_vm_s2_ops.vm_mem_abort = realm_mem_abort()
> 
> And in realm_mem_abort() do:
> 
> realm_mem_abort()
>   if gmem slot:    realm_gmem_abort()
>   if regular slot: user_mem_abort(kvm_realm_fault_map)
> 
> realm_gmem_abort() and kvm_realm_fault_map() are just the realm version
> of gmem_abort() and kvm_s2_fault_map(). For example they won't need NV
> related code, and vm_flavor switch case.
> 
> Proposing this because I think we would like the CCA changes more
> self-contained.

It's a little marginal - there's quite a bit of common code between the
realm path and the normal path. But it does have the advantage that you
mention of making CCA more self contained. So it's probably worth it.

Thanks,
Steve

> Thanks,
> Wei-Lin Chang
> 
>>  
>> +static bool private_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
>> +{
>> +	return kvm_vm_is_realm(kvm) &&
>> +		kvm_realm_is_private_address(&kvm->arch.realm, fault_ipa);
>> +}
>> +
>>  static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>>  {
>>  	VM_WARN_ON_ONCE(kvm_s2_fault_is_perm(s2fd) &&
>>  			!esr_abt_is_write_fault(s2fd->esr) &&
>>  			!kvm_s2_fault_is_exec(s2fd));
>>  
>> +	if (private_ipa_fault(s2fd->vcpu->kvm, s2fd->fault_ipa) &&
>> +	    !kvm_slot_has_gmem(s2fd->memslot))
>> +		return -EINVAL;
>> +
>>  	if (kvm_slot_has_gmem(s2fd->memslot))
>>  		return gmem_abort(s2fd, NULL);
>>  	else
>> @@ -2458,10 +2519,10 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>>   */
>>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  {
>> +	struct kvm *kvm = vcpu->kvm;
>>  	struct kvm_s2_trans nested_trans, *nested = NULL;
>>  	unsigned long esr = kvm_vcpu_get_esr(vcpu);
>>  	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
>> -	struct kvm *kvm = vcpu->kvm;
>>  	phys_addr_t fault_ipa; /* The address we faulted on */
>>  	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
>>  	struct kvm_memory_slot *memslot;
>> @@ -2554,8 +2615,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  		nested = &nested_trans;
>>  	}
>>  
>> -	gfn = ipa >> PAGE_SHIFT;
>> +	gfn = kvm_gfn_from_fault(kvm, ipa);
>>  	memslot = gfn_to_memslot(kvm, gfn);
>> +
>>  	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>>  	write_fault = esr_abt_is_write_fault(esr);
>>  	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
>> @@ -2598,7 +2660,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>>  		 * of the page size.
>>  		 */
>>  		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
>> -		ret = io_mem_abort(vcpu, ipa);
>> +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(kvm, ipa));
>>  		goto out_unlock;
>>  	}
>>  
> 
> [...]

