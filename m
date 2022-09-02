Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36F3ECAAD5
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 14:47:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 206D943C96;
	Fri,  2 Sep 2022 10:47:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uRnMHxKmnOmO; Fri,  2 Sep 2022 10:47:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5CF41175;
	Fri,  2 Sep 2022 10:47:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92372410DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QpwaxsZYxeW8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 10:47:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21FD841071
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1DAAED1;
 Fri,  2 Sep 2022 07:47:40 -0700 (PDT)
Received: from [10.57.45.3] (unknown [10.57.45.3])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DCF83F766;
 Fri,  2 Sep 2022 07:47:32 -0700 (PDT)
Message-ID: <54b979fc-5cb3-6eb4-47d4-e07e99359db9@arm.com>
Date: Fri, 2 Sep 2022 15:47:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 2/7] KVM: arm64: Simplify the sanitise_mte_tags() logic
Content-Language: en-GB
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-3-pcc@google.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20220810193033.1090251-3-pcc@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

On 10/08/2022 20:30, Peter Collingbourne wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Currently sanitise_mte_tags() checks if it's an online page before
> attempting to sanitise the tags. Such detection should be done in the
> caller via the VM_MTE_ALLOWED vma flag. Since kvm_set_spte_gfn() does
> not have the vma, leave the page unmapped if not already tagged. Tag
> initialisation will be done on a subsequent access fault in
> user_mem_abort().

Looks correct to me.

Reviewed-by: Steven Price <steven.price@arm.com>

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 40 +++++++++++++++-------------------------
>  1 file changed, 15 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c9012707f69c..1a3707aeb41f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1056,23 +1056,14 @@ static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
>   * - mmap_lock protects between a VM faulting a page in and the VMM performing
>   *   an mprotect() to add VM_MTE
>   */
> -static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> -			     unsigned long size)
> +static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> +			      unsigned long size)
>  {
>  	unsigned long i, nr_pages = size >> PAGE_SHIFT;
> -	struct page *page;
> +	struct page *page = pfn_to_page(pfn);
>  
>  	if (!kvm_has_mte(kvm))
> -		return 0;
> -
> -	/*
> -	 * pfn_to_online_page() is used to reject ZONE_DEVICE pages
> -	 * that may not support tags.
> -	 */
> -	page = pfn_to_online_page(pfn);
> -
> -	if (!page)
> -		return -EFAULT;
> +		return;
>  
>  	for (i = 0; i < nr_pages; i++, page++) {
>  		if (!page_mte_tagged(page)) {
> @@ -1080,8 +1071,6 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  			set_page_mte_tagged(page);
>  		}
>  	}
> -
> -	return 0;
>  }
>  
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> @@ -1092,7 +1081,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	bool write_fault, writable, force_pte = false;
>  	bool exec_fault;
>  	bool device = false;
> -	bool shared;
>  	unsigned long mmu_seq;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> @@ -1142,8 +1130,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		vma_shift = get_vma_page_shift(vma, hva);
>  	}
>  
> -	shared = (vma->vm_flags & VM_SHARED);
> -
>  	switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
>  	case PUD_SHIFT:
> @@ -1264,12 +1250,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
> -		if (!shared)
> -			ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
> -		else
> +		if ((vma->vm_flags & VM_MTE_ALLOWED) &&
> +		    !(vma->vm_flags & VM_SHARED)) {
> +			sanitise_mte_tags(kvm, pfn, vma_pagesize);
> +		} else {
>  			ret = -EFAULT;
> -		if (ret)
>  			goto out_unlock;
> +		}
>  	}
>  
>  	if (writable)
> @@ -1491,15 +1478,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	kvm_pfn_t pfn = pte_pfn(range->pte);
> -	int ret;
>  
>  	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
>  	WARN_ON(range->end - range->start != 1);
>  
> -	ret = sanitise_mte_tags(kvm, pfn, PAGE_SIZE);
> -	if (ret)
> +	/*
> +	 * If the page isn't tagged, defer to user_mem_abort() for sanitising
> +	 * the MTE tags. The S2 pte should have been unmapped by
> +	 * mmu_notifier_invalidate_range_end().
> +	 */
> +	if (kvm_has_mte(kvm) && !page_mte_tagged(pfn_to_page(pfn)))
>  		return false;
>  
>  	/*

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
