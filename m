Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795098463;
	b=0aGTBw3xvSNNJ0PP2aXVi6+vpblU35DKs07KvGUFwZP0Mj/8w2xYrHgybmD5VGlLAsTs
	 pZfCpPFI4orHZbgeof5RZ4bhAYGZfWKzU/Bme3sP22+wwqA605SDVyg8xhseqEP/DWkKD
	 wr13AyJc+kr/vKWM25imsQNlegoIq0ae6b0kB57t6hpX5B74OER4VWuvKTwWhK4sAxHPi
	 O4GPgXE83NiEQUILGuoh/HBq/wHl6krM5dagsIoRx4PoGO4/BxtuWk9SO6ExU0+FIwDbS
	 ReP+BCE4gEmmyQQPm7dbjlUDsTI2CxyjKxB9Y4M0uiBgr8FUO7QstIsHx3kC+SBLXwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098463;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=I7lrxp74JF6rLBz5kJks2GO3qiUA5k9sDt906Hjos7g=;
	b=nnCnv144C3Y6+UAYzVK+JWtnhuZeSHP1ZhxHn3HZH9oSyPX3AatGbIhmMlnyOuwIA6Aa
	 cYEiwvmlOzJs8vMTNGzgORlwYBzegeq1LJ8FwMCuRvFdUzNPFuEx/WhagXtZzI5H3zY+T
	 sfhHQGXQkjbfmFfyD0fLhojkEXsaKz+qyd1A5oDjHAeesa5uOKfGTlr8eeKALcuko3F/v
	 3lO0404+IiaPuL2orjhCe4vHtckAmuy5tFfXYY9XO0ZuBBfuIXje4pj3AscObCRC+y4JR
	 P5j9oTLkUhE7sCYN/9wrW5/iE1ZmaWdJfk3lWN/jRwkg7ZMU8o62Orh22R36sRyXUDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IiJEDUwp;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5500D606A325;
	Thu, 19 Nov 2026 14:27:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5500D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IiJEDUwp
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07DB01575;
	Thu, 19 Nov 2026 06:27:38 -0800 (PST)
Received: from [10.0.129.37] (e122027.cambridge.arm.com [10.0.129.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88C713F673;
	Thu, 19 Nov 2026 06:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795098460; bh=TPH+gGsCDlptdg7kFjkz3WGkd+BFmi72TWE+YB/dBuA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IiJEDUwp06Jg4RJQIwDNwU5oIfYuzAhSfy9B3SouH7nn1pSpvohYzq02irGG8KhGC
	 GmMcNuwqVX6NWogbnVwmRw2vevojx6QIgDgHcErE+hqhcotFo+VePsGio0uDiqMzso
	 /5pYF73aqo+SSnS7ug0S/oCJUykjDrNq6d8BRzlo=
Message-ID: <7871ecc1-277c-4231-8fa3-74c0085d01fb@arm.com>
Date: Thu, 19 Nov 2026 14:27:32 +0000
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
Subject: Re: [PATCH v3 05/11] KVM: arm64: CCA: Tear down RTTs
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
 <20261116164358.142785-6-steven.price@arm.com>
 <atrbfcxjasnyv2fx7gsy3cgrefvftsvq2h4ef6r7zmejmbwxjy@tofm65sb4frl>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <atrbfcxjasnyv2fx7gsy3cgrefvftsvq2h4ef6r7zmejmbwxjy@tofm65sb4frl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/11/2026 03:39, Wei-Lin Chang wrote:
> Hi Steven,
> 
> On Mon, Nov 16, 2026 at 04:43:51PM +0000, Steven Price wrote:
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
>> Tear down a created Realm whether it is still new or has been activated.
>> Unmap the Realm IPA space once during stage-2 teardown. Defer
>> destruction of non-root RTTs until final Realm destruction, after
>> REALM_TERMINATE and before destroying the RD; root RTTs remain until the
>> RD has gone away.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> ---
>> Changes since v2:
>> - Use the actual stage-2 start level and correct the RTT skip
>>   granularity. Free SRO state on final teardown errors.
>>
>> Changes since v1:
>> - Tear down created Realms in both NEW and ACTIVE states. Fix the
>>   RTT start level, page accounting on failed undelegation, and
>>   handling of RTT granules returned by RMI.
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |   9 ++
>>  arch/arm64/kvm/mmu.c             |  18 ++-
>>  arch/arm64/kvm/rmi.c             | 194 +++++++++++++++++++++++++++++++
>>  3 files changed, 220 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 6994756a14e6..dd16c004b831 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -57,6 +57,7 @@ enum realm_state {
>>   * @sro: Preallocated SRO state context for Realm MMU operations
>>   * @state: The lifetime state machine for the realm
>>   * @ia_bits: Number of valid Input Address bits in the IPA
>> + * @stage2_unmapped: The Realm stage-2 mappings have been removed
>>   */
>>  struct realm {
>>  	phys_addr_t rd_phys;
>> @@ -70,11 +71,19 @@ struct realm {
>>  	struct rmi_sro_state *sro;
>>  	enum realm_state state;
>>  	unsigned int ia_bits;
>> +	bool stage2_unmapped;
>>  };
>>  
>>  u32 kvm_rmm_ipa_limit(void);
>>  
>>  int kvm_init_realm(struct kvm *kvm);
>>  void kvm_destroy_realm(struct kvm *kvm);
>> +int kvm_realm_teardown_stage2(struct kvm *kvm);
>> +
>> +static inline bool kvm_realm_is_private_address(struct realm *realm,
>> +						unsigned long addr)
>> +{
>> +	return !(addr & BIT(realm->ia_bits - 1));
>> +}
> 
> Maybe move this to patch 9?

Yes that makes sense.

>>  
>>  #endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index ac72db3d4505..9baf2352d2a8 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1145,9 +1145,25 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>  	return err;
>>  }
>>  
>> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>> +{
>> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> +
>> +	mutex_lock(&kvm->arch.config_lock);
> 
> Use guard(mutex)(&kvm->arch.config_lock); here?

Ack.

>> +	if (kvm_realm_state(kvm) == REALM_STATE_NEW ||
>> +	    kvm_realm_state(kvm) == REALM_STATE_ACTIVE) {
>> +		kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +		WARN_ON(kvm_realm_teardown_stage2(kvm));
> 
> "teardown" here means unmap, but below like in
> realm_tear_down_rtt_level(), it means destroy.
> 
> This creates ambiguity and is confusing, can we avoid using "teardown"
> completely? Or at least make its meaning consistent.

There are two operations here:

 * Unmapping (e.g. RMI_RTT_DATA_UNMAP) where the VM's mapping is removed.

 * Destroying (e.g. RMI_RTT_DESTROY) where the VM's page tables are removed.

"Teardown" (or "tear down" - I seem to be inconsistent) really meant a
combination of the two - i.e. unmapping everything and destroying the
page tables.

But as you note the usage in the code isn't very consistent and it's
more confusing that helpful. So I'll reword things to avoid "teardown"
which will hopefully make things clearer.

>> +	}
>> +	mutex_unlock(&kvm->arch.config_lock);
>> +}
>> +
>>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>  {
>> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +	if (kvm_realm_is_created(kvm))
>> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
>> +	else
>> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>  }
>>  
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 57f59b618a96..74b89da4e801 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -16,22 +16,213 @@ u32 kvm_rmm_ipa_limit(void)
>>  	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>>  }
>>  
>> +static int get_start_level(struct realm *realm)
>> +{
>> +	/*
>> +	 * kvm_init_ipa_range() enforces a minimum of 32 IPA bits
>> +	 * (ARM64_MIN_PARANGE_BITS).
>> +	 */
>> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
>> +
>> +static void free_rtt(phys_addr_t phys)
>> +{
>> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
>> +	if (rmi_free_delegated_page(phys))
>> +		kvm_account_pgtable_pages(phys_to_virt(phys), 1);
>> +}
>> +
>> +/*
>> + * realm_rtt_destroy - Destroy an RTT at @level for @addr.
>> + *
>> + * Returns - Result of the RMI_RTT_DESTROY call, and:
>> + * @rtt_granule:	RTT granule, if the RTT was destroyed.
>> + * @next_addr:		IPA corresponding to the next possible valid entry we
>> + *			can target
>> + */
>> +static long realm_rtt_destroy(struct realm *realm, unsigned long addr,
>> +			      int level, phys_addr_t *rtt_granule,
>> +			      unsigned long *next_addr)
>> +{
>> +	unsigned long out_rtt;
>> +	long ret;
>> +
>> +	ret = rmi_rtt_destroy(realm->rd_phys, addr, level,
>> +			      &out_rtt, next_addr);
>> +
>> +	if (ret == RMI_SUCCESS)
>> +		*rtt_granule = out_rtt;
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
>> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +		return -EINVAL;
>> +
>> +	map_size = kvm_granule_size(level - 1);
>> +	if (WARN_ON(!IS_ALIGNED(start, map_size)))
>> +		return -EINVAL;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		phys_addr_t rtt_granule;
>> +		long ret;
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
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		switch (RMI_RESULT_STATUS(ret)) {
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
>> +			if (WARN_ON(RMI_RESULT_DATA_LEVEL(ret) != level))
>> +				return -EBUSY;
>> +			if (WARN_ON(level == KVM_PGTABLE_LAST_LEVEL))
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
>> +static int realm_destroy_rtts(struct kvm *kvm)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned int ia_bits = realm->ia_bits;
>> +
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	return realm_tear_down_rtt_range(realm, 0, (1UL << ia_bits));
>> +}
>> +
>> +static void realm_unmap_stage2(struct kvm *kvm)
> 
> Can we call this kvm_realm_unmap_stage2_all, expose this..
> 
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	if (realm->stage2_unmapped)
>> +		return;
>> +
>> +	write_lock(&kvm->mmu_lock);
>> +	kvm_stage2_unmap_range(&kvm->arch.mmu, 0,
>> +			       BIT(realm->ia_bits - 1), true);
>> +	write_unlock(&kvm->mmu_lock);
>> +
>> +	realm->stage2_unmapped = true;
>> +}
>> +
>> +int kvm_realm_teardown_stage2(struct kvm *kvm)
> 
> and remove this? I feel this function doesn't add much.

Yes kvm_realm_teardown_stage2() is a bit pointless now - I think I must
have refactored this over time down to nothing but not spotted that it's
now not needed. I've also got a WARN_ON() that the function returns 0
which seems somewhat pointless! I'll refactor some more ;)

Thanks for the review!

Steve

> Thanks,
> Wei-Lin Chang
> 
>> +{
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	realm_unmap_stage2(kvm);
>> +	return 0;
>> +}
>> +
>>  void kvm_destroy_realm(struct kvm *kvm)
>>  {
>>  	struct realm *realm = &kvm->arch.realm;
>>  	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>>  
>> +	/*
>> +	 * Serialize final RMM teardown with Realm creation and stage-2 teardown,
>> +	 * which also access Realm state under config_lock.
>> +	 */
>> +	guard(mutex)(&kvm->arch.config_lock);
>> +
>>  	if (!kvm_realm_is_created(kvm))
>>  		goto out_free_sro;
>>  
>>  	kvm_set_realm_state(kvm, REALM_STATE_DYING);
>>  
>> +	/*
>> +	 * REALM_DESTROY requires the realm to be non-live: all RECs must have
>> +	 * been destroyed and the root RTTs must be empty. Unmap the IPA space
>> +	 * and destroy any non-root RTTs before tearing down the RD. The root
>> +	 * RTT pages are still owned by the RMM at this point, so keep the KVM
>> +	 * pgtable alive until after REALM_DESTROY and undelegation.
>> +	 */
>> +	realm_unmap_stage2(kvm);
>> +
>>  	if (realm->rd_phys) {
>>  		phys_addr_t rd_phys = realm->rd_phys;
>>  
>>  		if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>>  			goto out_free_sro;
>>  
>> +		if (WARN_ON(realm_destroy_rtts(kvm)))
>> +			goto out_free_sro;
>> +
>>  		if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>>  			goto out_free_sro;
>>  		rmi_free_delegated_page(rd_phys);
>> @@ -44,6 +235,9 @@ void kvm_destroy_realm(struct kvm *kvm)
>>  
>>  	kvm_set_realm_state(kvm, REALM_STATE_DEAD);
>>  
>> +	/* Now that the realm is destroyed, free the entry-level RTTs. */
>> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +
>>  out_free_sro:
>>  	kfree(realm->sro);
>>  	realm->sro = NULL;
>> -- 
>> 2.43.0
>>

