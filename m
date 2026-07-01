Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5EC343893
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.167.222.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782924059; cv=none; b=o5gREx19+l5MMxXwN5anxDUok3Des6Ypum3L7yuozmscJTUi8epMfU9IxoqTsNEzgeR3MBTNB3N7dG49NEDc8WvOI1NkbN9zd7PxtaaVjfgR9yNYzg2ukrJ/idJkvuOaWM+z8YKqPtwdjdOSewj8onienhUPeGLsJjbSNki8egU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782924059; c=relaxed/simple;
	bh=knJsmh4AKT/JokA4ZXeYcLHQpmKnyw0h7iRQ2j8y538=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=lNPNsMoJODUqvh7SLJ/PdO/xI9N5c470tD+QlNyLOWuwDPqU/CjA30LfrLZPdFvzWTeScGSPPAYPTdJyiXb03ciDCuDwV+gdJb35EIuEltIzLRPVWMqnxjAQekpIWBNENcN/gwn4Uw+pBHZjfqp0wfAtjH5xWlOEDZTGzCp8XW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=Qbik0ukN; arc=none smtp.client-ip=198.167.222.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="Qbik0ukN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782924046;
	bh=IcvXr+XpwcXIl5fM8xKi3PUr+V6+uleNHzT41cgqWTE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Qbik0ukNjGB++p4equLZMSRRUn+XKS96t0Di/dLpuQMEzCIvVMlr8z9HO0d/e8MId
	 wY1AsOv2KhBBpfs88sRmRKEXBFlMlY4z2xDPYfE88rS+8Dy1dEb2o6ZkpcOP640uIQ
	 3yNZ8UJRuJham46lCOuXoN9H4OX+VtKcsZMZi73g=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4gr5Nt5xJcz6vZ9;
	Wed, 01 Jul 2026 16:40:46 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4gr5Nt2BPnz4y2q;
	Wed, 01 Jul 2026 16:40:46 +0000 (UTC)
Date: Wed, 01 Jul 2026 17:40:46 +0100
From: Bradley Morgan <include@grrlz.net>
To: Leonardo Bras <leo.bras@arm.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>,
 Vincent Donnefort <vdonnefort@google.com>, Gavin Shan <gshan@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_1/3=5D_KVM=3A_arm64=3A_skip_pKVM?=
 =?US-ASCII?Q?_cache_flushes_for_non_cacheable_mappings?=
In-Reply-To: <akU64YK5dqcWGdCD@LeoBrasDK>
References: <20260624160028.15591-1-include@grrlz.net> <20260624160028.15591-2-include@grrlz.net> <akU64YK5dqcWGdCD@LeoBrasDK>
Message-ID: <5105C9D2-C708-452E-BA61-F22083A33C74@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 1, 2026 5:05:53 PM GMT+01:00, Leonardo Bras <leo.bras@arm.com>
wrote:
>On Wed, Jun 24, 2026 at 04:00:26PM +0000, Bradley Morgan wrote:
>> pKVM keeps its own mapping list for stage 2 operations. Its flush path
>> uses that list directly, so it lost the PTE attribute check done by the
>> generic stage 2 walker.
>> 
>> Record whether a mapping is cacheable and skip cache maintenance for
>> mappings that are not cacheable.
>> 
>> Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
>> Signed-off-by: Bradley Morgan <include@grrlz.net>
>> ---
>>  arch/arm64/kvm/pkvm.c | 51 ++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 41 insertions(+), 10 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
>> index 428723b1b0f5..ca6e823028c2 100644
>> --- a/arch/arm64/kvm/pkvm.c
>> +++ b/arch/arm64/kvm/pkvm.c
>> @@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping
>*m)
>>  	return m->gfn * PAGE_SIZE;
>>  }
>>  
>> +#define PKVM_MAPPING_NR_PAGES_MASK	GENMASK_ULL(47, 0)
>> +#define PKVM_MAPPING_CACHEABLE		BIT_ULL(48)
>
>Out of curiosity here, why do you choose to use bit 48 here instead of, 
>let's say, bit 63?
>
>(I know it makes absolutely no difference to inner working here, as there 
>should probably not be 2^48 pages in one mapping.)
>
>Thanks!
>Leo


sup Leo, here's a quote from maz 

"This thing is already big enough, let's not add a bool right in the
middle (use pahole to find out why this is bad). Given that nr_pages
is for a range, and that the minimum page size uses 12 bits, the
largest number of pages you can have here is 56-12=48 bit wide. That's
another 16 bits worth of flags you can use."

this should just clarify things, any questions, feel more than free to ask!

(btw V4 is coming soon)

>> +
>> +static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
>> +{
>> +	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
>> +}
>> +
>> +static bool pkvm_mapping_is_cacheable(struct pkvm_mapping *m)
>> +{
>> +	return m->nr_pages & PKVM_MAPPING_CACHEABLE;
>> +}
>> +
>> +static void pkvm_mapping_set_nr_pages(struct pkvm_mapping *m, u64
>nr_pages,
>> +				      bool cacheable)
>> +{
>> +	WARN_ON_ONCE(nr_pages & ~PKVM_MAPPING_NR_PAGES_MASK);
>> +
>> +	m->nr_pages = nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
>> +	if (cacheable)
>> +		m->nr_pages |= PKVM_MAPPING_CACHEABLE;
>> +}
>> +
>>  static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
>>  {
>> -	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
>> +	return (m->gfn + pkvm_mapping_nr_pages(m)) * PAGE_SIZE - 1;
>>  }
>>  
>>  INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
>> @@ -350,7 +373,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct
>kvm_pgtable *pgt, u64 start, u64
>>  			continue;
>>  
>>  		page = pfn_to_page(mapping->pfn);
>> -		WARN_ON_ONCE(mapping->nr_pages != 1);
>> +		WARN_ON_ONCE(pkvm_mapping_nr_pages(mapping) != 1);
>>  		unpin_user_pages_dirty_lock(&page, 1, true);
>>  		account_locked_vm(kvm->mm, 1, false);
>>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
>> @@ -369,7 +392,7 @@ static int __pkvm_pgtable_stage2_unshare(struct
>kvm_pgtable *pgt, u64 start, u64
>>  
>>  	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
>>  		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
>> -					mapping->nr_pages);
>> +					pkvm_mapping_nr_pages(mapping));
>>  		if (WARN_ON(ret))
>>  			return ret;
>>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
>> @@ -448,7 +471,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt,
>u64 addr, u64 size,
>>  		 * permission faults are handled in the relax_perms() path.
>>  		 */
>>  		if (mapping) {
>> -			if (size == (mapping->nr_pages * PAGE_SIZE))
>> +			if (size == (pkvm_mapping_nr_pages(mapping) * PAGE_SIZE))
>>  				return -EAGAIN;
>>  
>>  			/*
>> @@ -472,7 +495,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt,
>u64 addr, u64 size,
>>  	swap(mapping, cache->mapping);
>>  	mapping->gfn = gfn;
>>  	mapping->pfn = pfn;
>> -	mapping->nr_pages = size / PAGE_SIZE;
>> +	pkvm_mapping_set_nr_pages(mapping, size / PAGE_SIZE,
>> +				  !(prot & (KVM_PGTABLE_PROT_DEVICE |
>> +					    KVM_PGTABLE_PROT_NORMAL_NC)));
>>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
>>  
>>  	return ret;
>> @@ -503,7 +528,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable
>*pgt, u64 addr, u64 size)
>>  	lockdep_assert_held(&kvm->mmu_lock);
>>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>>  		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
>> -					mapping->nr_pages);
>> +					pkvm_mapping_nr_pages(mapping));
>>  		if (WARN_ON(ret))
>>  			break;
>>  	}
>> @@ -517,9 +542,13 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable
>*pgt, u64 addr, u64 size)
>>  	struct pkvm_mapping *mapping;
>>  
>>  	lockdep_assert_held(&kvm->mmu_lock);
>> -	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
>> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>> +		if (!pkvm_mapping_is_cacheable(mapping))
>> +			continue;
>> +
>>  		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
>> -					  PAGE_SIZE * mapping->nr_pages);
>> +					  PAGE_SIZE * pkvm_mapping_nr_pages(mapping));
>> +	}
>>  
>>  	return 0;
>>  }
>> @@ -536,8 +565,10 @@ bool pkvm_pgtable_stage2_test_clear_young(struct
>kvm_pgtable *pgt, u64 addr, u64
>>  
>>  	lockdep_assert_held(&kvm->mmu_lock);
>>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
>> -		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
>> -					   mapping->nr_pages, mkold);
>> +		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest,
>> +					   handle, mapping->gfn,
>> +					   pkvm_mapping_nr_pages(mapping),
>> +					   mkold);
>>  
>>  	return young;
>>  }
>> -- 
>> 2.53.0
>> 
>

Thanks!
