Return-Path: <SRS0=zihn=CK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F57C433E6
	for <kvmarm@archiver.kernel.org>; Tue,  1 Sep 2020 17:07:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AFD42071B
	for <kvmarm@archiver.kernel.org>; Tue,  1 Sep 2020 17:07:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AFD42071B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8594C4B1A5;
	Tue,  1 Sep 2020 13:07:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lWqQIfCn8-3i; Tue,  1 Sep 2020 13:07:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 406364B190;
	Tue,  1 Sep 2020 13:07:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A26A04B186
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 13:07:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FFau17zMS+A5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2020 13:07:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 356A14B184
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 13:07:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7B9E1FB;
 Tue,  1 Sep 2020 10:07:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 131503F71F;
 Tue,  1 Sep 2020 10:07:02 -0700 (PDT)
Subject: Re: [PATCH v3 07/21] KVM: arm64: Convert kvm_phys_addr_ioremap() to
 generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-8-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a25db0df-0238-4f81-b0ab-27a55e1de932@arm.com>
Date: Tue, 1 Sep 2020 18:08:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-8-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

Hi Will,

The patch looks correct to me. I also had another look at the pre-order visitor
for kvm_pgtable_stage2_map, and it will not try to map the address range using a
block mapping (kvm_block_mapping_supported returns false).

One nitpick below.

On 8/25/20 10:39 AM, Will Deacon wrote:
> Convert kvm_phys_addr_ioremap() to use kvm_pgtable_stage2_map() instead
> of stage2_set_pte().
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 14 +-------------
>  arch/arm64/kvm/mmu.c         | 29 ++++++++++++-----------------
>  2 files changed, 13 insertions(+), 30 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 41ee8f3c0369..6f65d3841ec9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -439,18 +439,6 @@ struct stage2_map_data {
>  	struct kvm_mmu_memory_cache	*memcache;
>  };
>  
> -static kvm_pte_t *stage2_memcache_alloc_page(struct stage2_map_data *data)
> -{
> -	kvm_pte_t *ptep = NULL;
> -	struct kvm_mmu_memory_cache *mc = data->memcache;
> -
> -	/* Allocated with GFP_PGTABLE_USER, so no need to zero */
> -	if (mc && mc->nobjs)
> -		ptep = mc->objects[--mc->nobjs];
> -
> -	return ptep;
> -}
> -
>  static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
>  				    struct stage2_map_data *data)
>  {
> @@ -531,7 +519,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>  		return -EINVAL;
>  
> -	childp = stage2_memcache_alloc_page(data);
> +	childp = kvm_mmu_memory_cache_alloc(data->memcache);

I think this hunk and the above could have been squashed in the previous patch, I
think we could have used kvm_mmu_memory_cache_alloc directly from the start.

Thanks,

Alex

>  	if (!childp)
>  		return -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4607e9ca60a2..33146d3dc93a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1154,35 +1154,30 @@ static int stage2_pudp_test_and_clear_young(pud_t *pud)
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable)
>  {
> -	phys_addr_t addr, end;
> +	phys_addr_t addr;
>  	int ret = 0;
> -	unsigned long pfn;
>  	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> +				     KVM_PGTABLE_PROT_R |
> +				     (writable ? KVM_PGTABLE_PROT_W : 0);
>  
> -	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
> -	pfn = __phys_to_pfn(pa);
> -
> -	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> -		pte_t pte = kvm_pfn_pte(pfn, PAGE_S2_DEVICE);
> -
> -		if (writable)
> -			pte = kvm_s2pte_mkwrite(pte);
> -
> +	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
>  		ret = kvm_mmu_topup_memory_cache(&cache,
>  						 kvm_mmu_cache_min_pages(kvm));
>  		if (ret)
> -			goto out;
> +			break;
> +
>  		spin_lock(&kvm->mmu_lock);
> -		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
> -				     KVM_S2PTE_FLAG_IS_IOMAP);
> +		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> +					     &cache);
>  		spin_unlock(&kvm->mmu_lock);
>  		if (ret)
> -			goto out;
> +			break;
>  
> -		pfn++;
> +		pa += PAGE_SIZE;
>  	}
>  
> -out:
>  	kvm_mmu_free_memory_cache(&cache);
>  	return ret;
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
