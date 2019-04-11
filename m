Return-Path: <SRS0=Fx/F=SN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B05C10F14
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 02:00:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D5F820873
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 02:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D5F820873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A114A47E;
	Wed, 10 Apr 2019 22:00:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gcDkKqHfHzBn; Wed, 10 Apr 2019 22:00:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF7A4A477;
	Wed, 10 Apr 2019 22:00:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53FF44A475
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 22:00:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gkkt4igc41y3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 22:00:39 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EA954A472
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 22:00:39 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 6B8E4EB095994463CA7C;
 Thu, 11 Apr 2019 10:00:36 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Thu, 11 Apr 2019
 10:00:28 +0800
Subject: Re: [PATCH 2/2] kvm: arm: Unify handling THP backed host memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-3-git-send-email-suzuki.poulose@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c48b2bd4-68e6-dbc0-b010-78a23a889196@huawei.com>
Date: Thu, 11 Apr 2019 09:59:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <1554909832-7169-3-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190411015906.Z0bBIHBSsSX6xbx4Lrn8ddh2wLlqKdPYI-34rc01ARM@z>

Hi Suzuki,

On 2019/4/10 23:23, Suzuki K Poulose wrote:
> We support mapping host memory backed by PMD transparent hugepages
> at stage2 as huge pages. However the checks are now spread across
> two different places. Let us unify the handling of the THPs to
> keep the code cleaner (and future proof for PUD THP support).
> This patch moves transparent_hugepage_adjust() closer to the caller
> to avoid a forward declaration for fault_supports_stage2_huge_mappings().
> 
> Also, since we already handle the case where the host VA and the guest
> PA may not be aligned, the explicit VM_BUG_ON() is not required.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Zneghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   virt/kvm/arm/mmu.c | 123 +++++++++++++++++++++++++++--------------------------
>   1 file changed, 62 insertions(+), 61 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 6d73322..714eec2 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1380,53 +1380,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   	return ret;
>   }
>   
> -static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
> -{
> -	kvm_pfn_t pfn = *pfnp;
> -	gfn_t gfn = *ipap >> PAGE_SHIFT;
> -	struct page *page = pfn_to_page(pfn);
> -
> -	/*
> -	 * PageTransCompoundMap() returns true for THP and
> -	 * hugetlbfs. Make sure the adjustment is done only for THP
> -	 * pages.
> -	 */
> -	if (!PageHuge(page) && PageTransCompoundMap(page)) {
> -		unsigned long mask;
> -		/*
> -		 * The address we faulted on is backed by a transparent huge
> -		 * page.  However, because we map the compound huge page and
> -		 * not the individual tail page, we need to transfer the
> -		 * refcount to the head page.  We have to be careful that the
> -		 * THP doesn't start to split while we are adjusting the
> -		 * refcounts.
> -		 *
> -		 * We are sure this doesn't happen, because mmu_notifier_retry
> -		 * was successful and we are holding the mmu_lock, so if this
> -		 * THP is trying to split, it will be blocked in the mmu
> -		 * notifier before touching any of the pages, specifically
> -		 * before being able to call __split_huge_page_refcount().
> -		 *
> -		 * We can therefore safely transfer the refcount from PG_tail
> -		 * to PG_head and switch the pfn from a tail page to the head
> -		 * page accordingly.
> -		 */
> -		mask = PTRS_PER_PMD - 1;
> -		VM_BUG_ON((gfn & mask) != (pfn & mask));
> -		if (pfn & mask) {
> -			*ipap &= PMD_MASK;
> -			kvm_release_pfn_clean(pfn);
> -			pfn &= ~mask;
> -			kvm_get_pfn(pfn);
> -			*pfnp = pfn;
> -		}
> -
> -		return true;
> -	}
> -
> -	return false;
> -}
> -
>   /**
>    * stage2_wp_ptes - write protect PMD range
>    * @pmd:	pointer to pmd entry
> @@ -1677,6 +1630,61 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
>   }
>   
> +/*
> + * Check if the given hva is backed by a transparent huge page (THP)
> + * and whether it can be mapped using block mapping in stage2. If so, adjust
> + * the stage2 PFN and IPA accordingly. Only PMD_SIZE THPs are currently
> + * supported. This will need to be updated to support other THP sizes.
> + *
> + * Returns the size of the mapping.
> + */
> +static unsigned long
> +transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
> +			    unsigned long hva, kvm_pfn_t *pfnp,
> +			    phys_addr_t *ipap)
> +{
> +	kvm_pfn_t pfn = *pfnp;
> +	struct page *page = pfn_to_page(pfn);
> +
> +	/*
> +	 * PageTransCompoundMap() returns true for THP and
> +	 * hugetlbfs. Make sure the adjustment is done only for THP
> +	 * pages. Also make sure that the HVA and IPA are sufficiently
> +	 * aligned and that the  block map is contained within the memslot.
> +	 */
> +	if (!PageHuge(page) && PageTransCompoundMap(page) &&

We managed to get here, ensure that we only play with normal size pages
and no hugetlbfs pages will be involved.  "!PageHuge(page)" will always
return true and we can let it go.

> +	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +		/*
> +		 * The address we faulted on is backed by a transparent huge
> +		 * page.  However, because we map the compound huge page and
> +		 * not the individual tail page, we need to transfer the
> +		 * refcount to the head page.  We have to be careful that the
> +		 * THP doesn't start to split while we are adjusting the
> +		 * refcounts.
> +		 *
> +		 * We are sure this doesn't happen, because mmu_notifier_retry
> +		 * was successful and we are holding the mmu_lock, so if this
> +		 * THP is trying to split, it will be blocked in the mmu
> +		 * notifier before touching any of the pages, specifically
> +		 * before being able to call __split_huge_page_refcount().
> +		 *
> +		 * We can therefore safely transfer the refcount from PG_tail
> +		 * to PG_head and switch the pfn from a tail page to the head
> +		 * page accordingly.
> +		 */
> +		*ipap &= PMD_MASK;
> +		kvm_release_pfn_clean(pfn);
> +		pfn &= ~(PTRS_PER_PMD - 1);
> +		kvm_get_pfn(pfn);
> +		*pfnp = pfn;
> +
> +		return PMD_SIZE;
> +	}
> +
> +	/* Use page mapping if we cannot use block mapping */
> +	return PAGE_SIZE;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
>   			  unsigned long fault_status)
> @@ -1780,20 +1788,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (mmu_notifier_retry(kvm, mmu_seq))
>   		goto out_unlock;
>   
> -	if (vma_pagesize == PAGE_SIZE && !force_pte) {
> -		/*
> -		 * Only PMD_SIZE transparent hugepages(THP) are
> -		 * currently supported. This code will need to be
> -		 * updated to support other THP sizes.
> -		 *
> -		 * Make sure the host VA and the guest IPA are sufficiently
> -		 * aligned and that the block is contained within the memslot.
> -		 */
> -		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
> -		    transparent_hugepage_adjust(&pfn, &fault_ipa))
> -			vma_pagesize = PMD_SIZE;
> -	}
> -
> +	/*
> +	 * If we are not forced to use page mapping, check if we are
> +	 * backed by a THP and thus use block mapping if possible.
> +	 */
> +	if (vma_pagesize == PAGE_SIZE && !force_pte)
> +		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> +							   &pfn, &fault_ipa);
>   	if (writable)
>   		kvm_set_pfn_dirty(pfn);
>   
thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
