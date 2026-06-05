Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506533FF1B8;
	Fri,  5 Jun 2026 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780671696; cv=none; b=VV3bZX3k/pQlgsVZr9qbZfqxahgrvSjAUqMKpPaenv+sx+obi/+b8t8PiO4atTc2lWapweM5kZ73N+R0iiIyPKlf35PVOwfYi+NThJul1xZAD65AHi0NJioR5OCE6QFeBA3ANi4G3AFsOU5xWEowF4sBR3tibfgo1mvNrxQYK1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780671696; c=relaxed/simple;
	bh=Kw74Th8uleLKaO5LRkIELng/AmZEGicEGgtYZsuXiDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BDSQJB1uhZJGWvdyBHT1P2l6hbcb8SHWyq+veSlMQ51+RmWMGSIoHZcISRraCFEuq+Gw88+Nz/DIxtZ+Dt0RvZGw8C3hwPCiAnx0TxR2sc05B/3goQQkz2ii9WgYuCqxQnY5GEDMSnljvemU8Cv8TeY4gE6f17mc/eTvdG84Ir8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sLZaoukS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sLZaoukS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85EC52E9D;
	Fri,  5 Jun 2026 08:01:29 -0700 (PDT)
Received: from [10.1.31.21] (e122027.cambridge.arm.com [10.1.31.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8439D3F7D8;
	Fri,  5 Jun 2026 08:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780671694; bh=Kw74Th8uleLKaO5LRkIELng/AmZEGicEGgtYZsuXiDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sLZaoukSK9cGr5r3sxgKk4y8LVhQ2VNs87ssT11w2vqpCTeDhdMGx7YhaLota1S9g
	 HxctiV8g1p0inhSdwHiGjI74yZN7JqyEEpvbK0/HBHOeKScXTHiB5scv59+MUAkrw4
	 r10HFA1sjZsLx+2KXQ6bQKfL6JK0Db9ua3edkUeY=
Message-ID: <c6a474b3-225d-42b9-9b64-2f80683ebe9c@arm.com>
Date: Fri, 5 Jun 2026 16:01:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 17/44] arm64: RMI: RTT tear down
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
 Vishal Annapurve <vannapurve@google.com>, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-18-steven.price@arm.com>
 <mpesc2j3czpunbg3pvgwbotvfn7vahaabvoiu77vd2g5uervho@255lwycekmxh>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <mpesc2j3czpunbg3pvgwbotvfn7vahaabvoiu77vd2g5uervho@255lwycekmxh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/05/2026 23:32, Wei-Lin Chang wrote:
> Hi,
> 
> On Wed, May 13, 2026 at 02:17:25PM +0100, Steven Price wrote:
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
>> Changes since v13:
>>  * Avoid the double call of kvm_free_stage2_pgd() by splitting the work
>>    across that and a new function kvm_realm_uninit_stage2() which is
>>    only called for realm guests.
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
>>  arch/arm64/kvm/mmu.c             |  21 ++++-
>>  arch/arm64/kvm/rmi.c             | 148 +++++++++++++++++++++++++++++++
>>  3 files changed, 174 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 9de34983ee52..06ba0d4745c6 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -64,5 +64,12 @@ u32 kvm_realm_ipa_limit(void);
>>  
>>  int kvm_init_realm(struct kvm *kvm);
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
>> index ba8286472286..eb56d4e7f21a 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1024,9 +1024,26 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>  	return err;
>>  }
>>  
>> +static void kvm_realm_uninit_stage2(struct kvm_s2_mmu *mmu)
>> +{
>> +	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> +	struct realm *realm = &kvm->arch.realm;
>> +
>> +	if (kvm_realm_state(kvm) != REALM_STATE_ACTIVE)
>> +		return;
>> +
>> +	write_lock(&kvm->mmu_lock);
>> +	kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), true);
>> +	write_unlock(&kvm->mmu_lock);
>> +	kvm_realm_destroy_rtts(kvm);
>> +}
>> +
>>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>>  {
>> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
>> +	if (kvm_is_realm(kvm))
>> +		kvm_realm_uninit_stage2(&kvm->arch.mmu);
>> +	else
>> +		kvm_free_stage2_pgd(&kvm->arch.mmu);
>>  	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>>  }
>>  
>> @@ -1103,7 +1120,7 @@ void stage2_unmap_vm(struct kvm *kvm)
>>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>  {
>>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>> -	struct kvm_pgtable *pgt = NULL;
>> +	struct kvm_pgtable *pgt;
>>  
>>  	write_lock(&kvm->mmu_lock);
>>  	pgt = mmu->pgt;
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index f51ec667445e..5b00ccca4af3 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -11,6 +11,14 @@
>>  #include <asm/rmi_cmds.h>
>>  #include <asm/virt.h>
>>  
>> +static inline unsigned long rmi_rtt_level_mapsize(int level)
>> +{
>> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
>> +		return PAGE_SIZE;
>> +
>> +	return (1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>> +}
>> +
>>  static bool rmi_has_feature(unsigned long feature)
>>  {
>>  	return !!u64_get_bits(rmm_feat_reg0, feature);
>> @@ -21,6 +29,144 @@ u32 kvm_realm_ipa_limit(void)
>>  	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>>  }
>>  
>> +static int get_start_level(struct realm *realm)
>> +{
>> +	return 4 - stage2_pgtable_levels(realm->ia_bits);
>> +}
>> +
>> +static void free_rtt(phys_addr_t phys)
>> +{
>> +	if (free_delegated_page(phys))
>> +		return;
>> +
>> +	kvm_account_pgtable_pages(phys_to_virt(phys), -1);
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
> 
> Looks like out_rtt can be simplified out.

The issue here is there's a type conversion going on. rmi_rtt_destroy()
takes an "unsigned long *" to match the general approach of using
"unsigned long" for the inputs/outputs of SMCCC calls. But rtt_granule
is a "phys_addr_t". While we know these are (currently) the same size,
they are not the same type according to the compiler - phys_addr_t is
"long long unsigned int".

Thanks,
Steve

> [...]
> 
> Thanks,
> Wei-Lin Chang

