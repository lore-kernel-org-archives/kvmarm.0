Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C4D3B3898;
	Fri, 20 Mar 2026 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774023176; cv=none; b=op8I05CWjUKneLumAZNxqJon5pwjhoOuS/lBmSVlIyPG7VWsgIsFOI0Vc5KbHZctHsqEEUB8wd3WOpayDHR4eTlGLo81wQoxGjam+gmtpj4Ja8JZJ8yTO05Ro+1jTQ21vUebjvD1ZPIZp0O6hvIxy+eC/eHVVK9+/OVNVlpbInA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774023176; c=relaxed/simple;
	bh=pK2xsCGRMMU1E7w48dNyoO2C+Zvbqoic8EPlky0xXaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpE8lsjaXI7kJ6Aop92HvieQiDJPyNMOtj8oLpMATX6bZ15G3i45EPSJ0KGm55P3eAql/4DXSCqECZ/mh75iZwrYdZ8jYIUetATSOasF03DmUaItk+5uyiFsH/k56UxXUXtmv5KKm67jPg+uA/+ozCy+COQcDNe/ocWvvTysbx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22538165C;
	Fri, 20 Mar 2026 09:12:48 -0700 (PDT)
Received: from [10.1.29.20] (e122027.cambridge.arm.com [10.1.29.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E60EC3F7BD;
	Fri, 20 Mar 2026 09:12:49 -0700 (PDT)
Message-ID: <ef49030f-1ee7-4473-acc7-c8900acb977d@arm.com>
Date: Fri, 20 Mar 2026 16:12:48 +0000
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
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <knluksqra3k56kjisorhids7lm6hzqqqp7s4kq47cribh66hos@ctatngbv263v>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 17:35, Wei-Lin Chang wrote:
> On Wed, Mar 18, 2026 at 03:53:39PM +0000, Steven Price wrote:
>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>> that the RMM creates/destroys entries as necessary. The physical pages
>> to store the page tables are delegated to the realm as required, and can
>> be undelegated when no longer used.
>>
>> Creating new RTTs is the easy part, tearing down is a little more
>> tricky. The result of realm_rtt_destroy() can be used to effectively
>> walk the tree and destroy the entries (undelegating pages that were
>> given to the realm).
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v12:
>>  * Simplify some functions now we know RMM page size is the same as the
>>    host's.
>> Changes since v11:
>>  * Moved some code from earlier in the series to this one so that it's
>>    added when it's first used.
>> Changes since v10:
>>  * RME->RMI rename.
>>  * Some code to handle freeing stage 2 PGD moved into this patch where
>>    it belongs.
>> Changes since v9:
>>  * Add a comment clarifying that root level RTTs are not destroyed until
>>    after the RD is destroyed.
>> Changes since v8:
>>  * Introduce free_rtt() wrapper which calls free_delegated_granule()
>>    followed by kvm_account_pgtable_pages(). This makes it clear where an
>>    RTT is being freed rather than just a delegated granule.
>> Changes since v6:
>>  * Move rme_rtt_level_mapsize() and supporting defines from kvm_rme.h
>>    into rme.c as they are only used in that file.
>> Changes since v5:
>>  * Rename some RME_xxx defines to do with page sizes as RMM_xxx - they are
>>    a property of the RMM specification not the RME architecture.
>> Changes since v2:
>>  * Moved {alloc,free}_delegated_page() and ensure_spare_page() to a
>>    later patch when they are actually used.
>>  * Some simplifications now rmi_xxx() functions allow NULL as an output
>>    parameter.
>>  * Improved comments and code layout.
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |   7 ++
>>  arch/arm64/kvm/mmu.c             |  15 +++-
>>  arch/arm64/kvm/rmi.c             | 145 +++++++++++++++++++++++++++++++
>>  3 files changed, 166 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 0ada525af18f..16a297f3091a 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -68,5 +68,12 @@ u32 kvm_realm_ipa_limit(void);
>>  
>>  int kvm_init_realm_vm(struct kvm *kvm);
>>  void kvm_destroy_realm(struct kvm *kvm);
>> +void kvm_realm_destroy_rtts(struct kvm *kvm);
>> +
>> +static inline bool kvm_realm_is_private_address(struct realm *realm,
>> +						unsigned long addr)
>> +{
>> +	return !(addr & BIT(realm->ia_bits - 1));
>> +}
>>  
>>  #endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 9dc242c3b9c8..41152abf55b2 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1098,10 +1098,23 @@ void stage2_unmap_vm(struct kvm *kvm)
>>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>  {
>>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> -	struct kvm_pgtable *pgt = NULL;
>> +	struct kvm_pgtable *pgt;
>>  
>>  	write_lock(&kvm->mmu_lock);
>>  	pgt = mmu->pgt;
>> +	if (kvm_is_realm(kvm) &&
>> +	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>> +	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
>> +		write_unlock(&kvm->mmu_lock);
>> +		kvm_realm_destroy_rtts(kvm);
>> +
>> +		/*
>> +		 * The PGD pages can be reclaimed only after the realm (RD) is
>> +		 * destroyed. We call this again from kvm_destroy_realm() after
>> +		 * the RD is destroyed.
>> +		 */
>> +		return;
>> +	}
> 
> Hi,
> 
> I see that kvm_free_stage2_pgd() will be called twice:
> 
> kvm_destroy_vm()
>   mmu_notifier_unregister()
>     kvm_mmu_notifier_release()
>       kvm_flush_shadow_all()
>         kvm_arch_flush_shadow_all()
>           kvm_uninit_stage2_mmu()
>             kvm_free_stage2_pgd()
>   kvm_arch_destroy_vm()
>     kvm_destroy_realm()
>       kvm_free_stage2_pgd()
> 
> At the first call the realm state is REALM_STATE_ACTIVE, at the second
> it is REALM_STATE_DEAD. Reading the comment added to
> kvm_free_stage2_pgd() here, does it mean this function is called twice
> on purpose? If so do you think it's better to extract this and create
> another function instead, then use kvm_is_realm() to choose which to
> run? I think it is confusing to have this function run twice for a
> realm.

So the issue here is that the RMM requires we do things in a different
order to a normal VM. For a realm the PGD cannot be destroyed until the
realm itself is destroyed - the RMM revent the host undelegating them.

So the first call cannot actually do the free - this is the
REALM_STATE_ACTIVE case.

In kvm_destroy_realm() we tear down the actual realm and undelegate the
granules. We then need to actually free the PGD - the "obvious" way of
doing that is calling kvm_free_stage2_pgd() as that handles the KVM
intricacies - e.g. updating the mmu object.

I'm not sure how to structure the code better without causing
duplication - I don't want another copy of the cleanup from
kvm_free_stage2_pgd() in a CCA specific file because it will most likely
get out of sync with the normal VM case. There is a comment added
explaining "we call this again" which I hoped would make it less confusing.

Thanks,
Steve

> Thanks,
> Wei-Lin Chang
> 
>>  	if (pgt) {
>>  		mmu->pgd_phys = 0;
>>  		mmu->pgt = NULL;
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 700b8c935d29..1fd2c18f7381 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -15,6 +15,19 @@
>>  static unsigned long rmm_feat_reg0;
>>  static unsigned long rmm_feat_reg1;
>>  
>> +#define RMM_RTT_BLOCK_LEVEL	2
>> +#define RMM_RTT_MAX_LEVEL	3
>> +
>> +#define RMM_L2_BLOCK_SIZE	PMD_SIZE
>> +
>> +static inline unsigned long rmi_rtt_level_mapsize(int level)
>> +{
>> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
>> +		return PAGE_SIZE;
>> +
>> +	return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>> +}
>> +
>>  static bool rmi_has_feature(unsigned long feature)
>>  {
>>  	return !!u64_get_bits(rmm_feat_reg0, feature);
>> @@ -189,6 +202,11 @@ u32 kvm_realm_ipa_limit(void)
>>  	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>>  }
>>  
>> +static int get_start_level(struct realm *realm)
>> +{
>> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
>> +
>>  static int undelegate_range(phys_addr_t phys, unsigned long size)
>>  {
>>  	unsigned long ret;
>> @@ -223,6 +241,131 @@ static int free_delegated_page(phys_addr_t phys)
>>  	return 0;
>>  }
>>  
>> +static void free_rtt(phys_addr_t phys)
>> +{
>> +	if (free_delegated_page(phys))
>> +		return;
>> +
>> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>> +}
>> +
>> +static int realm_rtt_destroy(struct realm *realm, unsigned long addr,
>> +			     int level, phys_addr_t *rtt_granule,
>> +			     unsigned long *next_addr)
>> +{
>> +	unsigned long out_rtt;
>> +	int ret;
>> +
>> +	ret = rmi_rtt_destroy(virt_to_phys(realm->rd), addr, level,
>> +			      &out_rtt, next_addr);
>> +
>> +	*rtt_granule = out_rtt;
>> +
>> +	return ret;
>> +}
>> +
>> +static int realm_tear_down_rtt_level(struct realm *realm, int level,
>> +				     unsigned long start, unsigned long end)
>> +{
>> +	ssize_t map_size;
>> +	unsigned long addr, next_addr;
>> +
>> +	if (WARN_ON(level > RMM_RTT_MAX_LEVEL))
>> +		return -EINVAL;
>> +
>> +	map_size = rmi_rtt_level_mapsize(level - 1);
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		phys_addr_t rtt_granule;
>> +		int ret;
>> +		unsigned long align_addr = ALIGN(addr, map_size);
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		if (next_addr > end || align_addr != addr) {
>> +			/*
>> +			 * The target range is smaller than what this level
>> +			 * covers, recurse deeper.
>> +			 */
>> +			ret = realm_tear_down_rtt_level(realm,
>> +							level + 1,
>> +							addr,
>> +							min(next_addr, end));
>> +			if (ret)
>> +				return ret;
>> +			continue;
>> +		}
>> +
>> +		ret = realm_rtt_destroy(realm, addr, level,
>> +					&rtt_granule, &next_addr);
>> +
>> +		switch (RMI_RETURN_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			free_rtt(rtt_granule);
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			if (next_addr > addr) {
>> +				/* Missing RTT, skip */
>> +				break;
>> +			}
>> +			/*
>> +			 * We tear down the RTT range for the full IPA
>> +			 * space, after everything is unmapped. Also we
>> +			 * descend down only if we cannot tear down a
>> +			 * top level RTT. Thus RMM must be able to walk
>> +			 * to the requested level. e.g., a block mapping
>> +			 * exists at L1 or L2.
>> +			 */
>> +			if (WARN_ON(RMI_RETURN_INDEX(ret) != level))
>> +				return -EBUSY;
>> +			if (WARN_ON(level == RMM_RTT_MAX_LEVEL))
>> +				return -EBUSY;
>> +
>> +			/*
>> +			 * The table has active entries in it, recurse deeper
>> +			 * and tear down the RTTs.
>> +			 */
>> +			next_addr = ALIGN(addr + 1, map_size);
>> +			ret = realm_tear_down_rtt_level(realm,
>> +							level + 1,
>> +							addr,
>> +							next_addr);
>> +			if (ret)
>> +				return ret;
>> +			/*
>> +			 * Now that the child RTTs are destroyed,
>> +			 * retry at this level.
>> +			 */
>> +			next_addr = addr;
>> +			break;
>> +		default:
>> +			WARN_ON(1);
>> +			return -ENXIO;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int realm_tear_down_rtt_range(struct realm *realm,
>> +				     unsigned long start, unsigned long end)
>> +{
>> +	/*
>> +	 * Root level RTTs can only be destroyed after the RD is destroyed. So
>> +	 * tear down everything below the root level
>> +	 */
>> +	return realm_tear_down_rtt_level(realm, get_start_level(realm) + 1,
>> +					 start, end);
>> +}
>> +
>> +void kvm_realm_destroy_rtts(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned int ia_bits = realm->ia_bits;
>> +
>> +	WARN_ON(realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits)));
>> +}
>> +
>>  void kvm_destroy_realm(struct kvm *kvm)
>>  {
>>  	struct realm *realm = &kvm->arch.realm;
>> @@ -246,6 +389,8 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  	if (realm->rd) {
>>  		phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>  
>> +		kvm_realm_destroy_rtts(kvm);
>> +
>>  		if (WARN_ON(rmi_realm_destroy(rd_phys)))
>>  			return;
>>  		free_delegated_page(rd_phys);
>> -- 
>> 2.43.0
>>

