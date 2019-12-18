Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E2FC2D0CD
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 15:39:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2546224650
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 15:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2546224650
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC4294A541;
	Wed, 18 Dec 2019 10:39:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SCmFinETcHR2; Wed, 18 Dec 2019 10:39:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B1E4A536;
	Wed, 18 Dec 2019 10:39:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 888C04A542
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 10:39:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fwxiK71ahWbV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 10:39:01 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D2FA4A49F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 10:39:01 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DECE430E;
 Wed, 18 Dec 2019 07:39:00 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 732DD3F719;
 Wed, 18 Dec 2019 07:39:00 -0800 (PST)
Date: Wed, 18 Dec 2019 16:38:59 +0100
From: Christoffer Dall <christoffer.dall@arm.com>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Re-check VMA on detecting a poisoned
 page
Message-ID: <20191218153859.GB25857@e113682-lin.lund.arm.com>
References: <20191217123809.197392-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191217123809.197392-1-james.morse@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Dec 17, 2019 at 12:38:09PM +0000, James Morse wrote:
> When we check for a poisoned page, we use the VMA to tell userspace
> about the looming disaster. But we pass a pointer to this VMA
> after having released the mmap_sem, which isn't a good idea.
> 
> Instead, stash the shift value that goes with this pfn while
> we are holding the mmap_sem.
> 
> Reported-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
> 
> Based on Marc's patch:
> Link: lore.kernel.org/r/20191211165651.7889-3-maz@kernel.org
> 
>  virt/kvm/arm/mmu.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..bb0f8d648678 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1591,16 +1591,8 @@ static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
>  	__invalidate_icache_guest_page(pfn, size);
>  }
>  
> -static void kvm_send_hwpoison_signal(unsigned long address,
> -				     struct vm_area_struct *vma)
> +static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
>  {
> -	short lsb;
> -
> -	if (is_vm_hugetlb_page(vma))
> -		lsb = huge_page_shift(hstate_vma(vma));
> -	else
> -		lsb = PAGE_SHIFT;
> -
>  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
>  }
>  
> @@ -1673,6 +1665,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>  	struct vm_area_struct *vma;
> +	short vma_shift;
>  	kvm_pfn_t pfn;
>  	pgprot_t mem_type = PAGE_S2;
>  	bool logging_active = memslot_is_logging(memslot);
> @@ -1696,7 +1689,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		return -EFAULT;
>  	}
>  
> -	vma_pagesize = vma_kernel_pagesize(vma);
> +	if (is_vm_hugetlb_page(vma))
> +		vma_shift = huge_page_shift(hstate_vma(vma));
> +	else
> +		vma_shift = PAGE_SHIFT;
> +
> +	vma_pagesize = 1ULL << vma_shift;
>  	if (logging_active ||
>  	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
>  		force_pte = true;
> @@ -1735,7 +1733,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writable);
>  	if (pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(hva, vma);
> +		kvm_send_hwpoison_signal(hva, vma_shift);
>  		return 0;
>  	}
>  	if (is_error_noslot_pfn(pfn))
> -- 
> 2.24.0
> 
> 
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
