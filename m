Return-Path: <SRS0=Oikv=H2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4EFC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 24 Feb 2021 17:21:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A1F164F0C
	for <kvmarm@archiver.kernel.org>; Wed, 24 Feb 2021 17:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A1F164F0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A15A04B292;
	Wed, 24 Feb 2021 12:21:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6b-iGWVRLlIo; Wed, 24 Feb 2021 12:21:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 494A64B269;
	Wed, 24 Feb 2021 12:21:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C6224B25F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 12:21:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m-hAJZv4oMKp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2021 12:21:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 107BE4B24D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2021 12:21:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4A1B101E;
 Wed, 24 Feb 2021 09:21:07 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC35F3F73B;
 Wed, 24 Feb 2021 09:21:05 -0800 (PST)
Subject: Re: [RFC PATCH 1/4] KVM: arm64: Move the clean of dcache to the map
 handler
To: Yanan Wang <wangyanan55@huawei.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Gavin Shan <gshan@redhat.com>,
 Quentin Perret <qperret@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20210208112250.163568-1-wangyanan55@huawei.com>
 <20210208112250.163568-2-wangyanan55@huawei.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <70b2d6c2-709b-d63b-1409-b16dad89b9b6@arm.com>
Date: Wed, 24 Feb 2021 17:21:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210208112250.163568-2-wangyanan55@huawei.com>
Content-Language: en-US
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hello,

On 2/8/21 11:22 AM, Yanan Wang wrote:
> We currently uniformly clean dcache in user_mem_abort() before calling the
> fault handlers, if we take a translation fault and the pfn is cacheable.
> But if there are concurrent translation faults on the same page or block,
> clean of dcache for the first time is necessary while the others are not.
>
> By moving clean of dcache to the map handler, we can easily identify the
> conditions where CMOs are really needed and avoid the unnecessary ones.
> As it's a time consuming process to perform CMOs especially when flushing
> a block range, so this solution reduces much load of kvm and improve the
> efficiency of creating mappings.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 16 --------------
>  arch/arm64/kvm/hyp/pgtable.c     | 38 ++++++++++++++++++++------------
>  arch/arm64/kvm/mmu.c             | 14 +++---------
>  3 files changed, 27 insertions(+), 41 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e52d82aeadca..4ec9879e82ed 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -204,22 +204,6 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>  	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>  }
>  
> -static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -{
> -	void *va = page_address(pfn_to_page(pfn));
> -
> -	/*
> -	 * With FWB, we ensure that the guest always accesses memory using
> -	 * cacheable attributes, and we don't have to clean to PoC when
> -	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
> -	 * PoU is not required either in this case.
> -	 */
> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> -		return;
> -
> -	kvm_flush_dcache_to_poc(va, size);
> -}
> -
>  static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
>  						  unsigned long size)
>  {
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 4d177ce1d536..2f4f87021980 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -464,6 +464,26 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>  	return 0;
>  }
>  
> +static bool stage2_pte_cacheable(kvm_pte_t pte)
> +{
> +	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> +	return memattr == PAGE_S2_MEMATTR(NORMAL);
> +}
> +
> +static void stage2_flush_dcache(void *addr, u64 size)
> +{
> +	/*
> +	 * With FWB, we ensure that the guest always accesses memory using
> +	 * cacheable attributes, and we don't have to clean to PoC when
> +	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
> +	 * PoU is not required either in this case.
> +	 */
> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> +		return;
> +
> +	__flush_dcache_area(addr, size);
> +}
> +
>  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  				      kvm_pte_t *ptep,
>  				      struct stage2_map_data *data)
> @@ -495,6 +515,10 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  		put_page(page);
>  	}
>  
> +	/* Flush data cache before installation of the new PTE */
> +	if (stage2_pte_cacheable(new))
> +		stage2_flush_dcache(__va(phys), granule);

This makes sense to me. kvm_pgtable_stage2_map() is protected against concurrent
calls by the kvm->mmu_lock, so only one VCPU can change the stage 2 translation
table at any given moment. In the case of concurrent translation faults on the
same IPA, the first VCPU that will take the lock will create the mapping and do
the dcache clean+invalidate. The other VCPUs will return -EAGAIN because the
mapping they are trying to install is almost identical* to the mapping created by
the first VCPU that took the lock.

I have a question. Why are you doing the cache maintenance *before* installing the
new mapping? This is what the kernel already does, so I'm not saying it's
incorrect, I'm just curious about the reason behind it.

*permissions might be different.

Thanks,

Alex

> +
>  	smp_store_release(ptep, new);
>  	get_page(page);
>  	data->phys += granule;
> @@ -651,20 +675,6 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	return ret;
>  }
>  
> -static void stage2_flush_dcache(void *addr, u64 size)
> -{
> -	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> -		return;
> -
> -	__flush_dcache_area(addr, size);
> -}
> -
> -static bool stage2_pte_cacheable(kvm_pte_t pte)
> -{
> -	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
> -	return memattr == PAGE_S2_MEMATTR(NORMAL);
> -}
> -
>  static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  			       enum kvm_pgtable_walk_flags flag,
>  			       void * const arg)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f2a4..d151927a7d62 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -609,11 +609,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
>  }
>  
> -static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -{
> -	__clean_dcache_guest_page(pfn, size);
> -}
> -
>  static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>  {
>  	__invalidate_icache_guest_page(pfn, size);
> @@ -882,9 +877,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (writable)
>  		prot |= KVM_PGTABLE_PROT_W;
>  
> -	if (fault_status != FSC_PERM && !device)
> -		clean_dcache_guest_page(pfn, vma_pagesize);
> -
>  	if (exec_fault) {
>  		prot |= KVM_PGTABLE_PROT_X;
>  		invalidate_icache_guest_page(pfn, vma_pagesize);
> @@ -1144,10 +1136,10 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  	trace_kvm_set_spte_hva(hva);
>  
>  	/*
> -	 * We've moved a page around, probably through CoW, so let's treat it
> -	 * just like a translation fault and clean the cache to the PoC.
> +	 * We've moved a page around, probably through CoW, so let's treat
> +	 * it just like a translation fault and the map handler will clean
> +	 * the cache to the PoC.
>  	 */
> -	clean_dcache_guest_page(pfn, PAGE_SIZE);
>  	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
>  	return 0;
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
