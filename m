Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034CDC2BBD0
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 15:36:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69F0920678
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 15:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69F0920678
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2AE44B0E5;
	Wed,  2 Sep 2020 11:36:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zpmqVGN+hF14; Wed,  2 Sep 2020 11:36:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A614B0F0;
	Wed,  2 Sep 2020 11:36:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 827284B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 11:36:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hiLdxRFSglHm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 11:36:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF864B0D1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 11:36:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2F36101E;
 Wed,  2 Sep 2020 08:36:16 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEBFD3F71F;
 Wed,  2 Sep 2020 08:36:15 -0700 (PDT)
Subject: Re: [PATCH v3 08/21] KVM: arm64: Convert kvm_set_spte_hva() to
 generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-9-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <86bb295c-64d8-51a1-25f4-32a5a1bb2172@arm.com>
Date: Wed, 2 Sep 2020 16:37:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-9-will@kernel.org>
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

There are still a few comments and code paths in stage2_set_pte referring to
kvm_set_spte_hva.

On 8/25/20 10:39 AM, Will Deacon wrote:
> Convert kvm_set_spte_hva() to use kvm_pgtable_stage2_map() instead
> of stage2_set_pte().
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 33146d3dc93a..704b471a48ce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1911,28 +1911,27 @@ int kvm_unmap_hva_range(struct kvm *kvm,
>  
>  static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>  {
> -	pte_t *pte = (pte_t *)data;
> +	kvm_pfn_t *pfn = (kvm_pfn_t *)data;
>  
>  	WARN_ON(size != PAGE_SIZE);
> +
>  	/*
> -	 * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
> -	 * flag clear because MMU notifiers will have unmapped a huge PMD before
> -	 * calling ->change_pte() (which in turn calls kvm_set_spte_hva()) and
> -	 * therefore stage2_set_pte() never needs to clear out a huge PMD
> -	 * through this calling path.
> +	 * The MMU notifiers will have unmapped a huge PMD before calling
> +	 * ->change_pte() (which in turn calls kvm_set_spte_hva()) and
> +	 * therefore we never need to clear out a huge PMD through this
> +	 * calling path and a memcache is not required.
>  	 */
> -	stage2_set_pte(&kvm->arch.mmu, NULL, gpa, pte, 0);
> +	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, gpa, PAGE_SIZE,
> +			       __pfn_to_phys(*pfn), KVM_PGTABLE_PROT_R, NULL);

I have to admit that I managed to confuse myself.

According to the comment, this is called after unmapping a huge PMD.
__unmap_stage2_range() -> .. -> unmap_stage2_pmd() calls pmd_clear(), which means
the PMD entry is now 0.

In __kvm_pgtable_visit(), kvm_pte_table() returns false, because the entry is
invalid, and so we call stage2_map_walk_leaf(). Here, stage2_map_walker_try_leaf()
will return false, because kvm_block_mapping_supported() returns false (PMD
granule is larger than PAGE_SIZE), and then we end up allocating a table from the
memcache. memcache which will NULL, and kvm_mmu_memory_cache_alloc() will
dereference the NULL pointer.

I'm pretty sure there's something that I'm missing here, I would really appreciate
someone pointing out where I'm making a mistake.

Thanks,

Alex

>  	return 0;
>  }
>  
> -
>  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  {
>  	unsigned long end = hva + PAGE_SIZE;
>  	kvm_pfn_t pfn = pte_pfn(pte);
> -	pte_t stage2_pte;
>  
> -	if (!kvm->arch.mmu.pgd)
> +	if (!kvm->arch.mmu.pgt)
>  		return 0;
>  
>  	trace_kvm_set_spte_hva(hva);
> @@ -1942,9 +1941,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  	 * just like a translation fault and clean the cache to the PoC.
>  	 */
>  	clean_dcache_guest_page(pfn, PAGE_SIZE);
> -	stage2_pte = kvm_pfn_pte(pfn, PAGE_S2);
> -	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
> -
> +	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
>  	return 0;
>  }
>  
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
